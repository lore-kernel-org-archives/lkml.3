Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaDSBfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 21:35:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38042 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaDSBfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 21:35:33 -0400
Date: Sat, 19 Apr 2014 02:35:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>, tytso@mit.edu
Subject: Re: [GIT PULL] Detaching mounts on unlink for 3.15
Message-ID: <20140419013526.GN18016@ZenIV.linux.org.uk>
References: <87zjjp3e7w.fsf@x220.int.ebiederm.org>
 <87ppkl1xb7.fsf@x220.int.ebiederm.org>
 <20140413215242.GP18016@ZenIV.linux.org.uk>
 <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
 <87ppkhc4pp.fsf@x220.int.ebiederm.org>
 <87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
 <20140417202237.GA18016@ZenIV.linux.org.uk>
 <87tx9rwsz4.fsf@x220.int.ebiederm.org>
 <20140417221203.GC18016@ZenIV.linux.org.uk>
 <20140418003725.GE18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418003725.GE18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 01:37:26AM +0100, Al Viro wrote:
> FWIW, the tricky part around auto-close of acct is that we really want to
> preserve the following property:
> 
> 	In usual setups, umount(2) will not return until fs has been
> shut down.
> 
> fput() being async is not a problem - it will be processed before we
> return to userland.  I agree that we don't need the loop anymore (it's
> basically a stack depth reduction measure that was needed with sync
> fput() - without "add one more and deal with it when we return" we
> would be getting mntput_no_expire -> fput -> mntput -> fs shutdown
> back then).  But offloading that fput() to workqueue makes it really
> possible to have actual fs shutdown happen after umount(2) returns,
> without any extra mounts of the same fs, etc.  And since that shutdown
> *can* take a long time (lots of dirty pages around, slow device or
> slow network, etc.), we really might be talking about e.g. umount(8)
> being finished before fs shutdown finishes.  It's an expected situation
> when we have the same thing still mounted elsewhere or lazy-umounted
> and busy, but this changes behaviour on setups where we had been
> guaranteed that umount -a *will* wait until all filesystems except
> root are shut down and root is remounted r/o.  So this change really
> can cause data loss on reboot(8)/halt(8) on existing boxen...

My apologies for confusion - I have not looked at your last commit.
I *really* don't like that solution, but it probably does close that
particular problem.  Consider that objection withdrawn (modulo "you
have created a bisect hazard here, that part of series needs to be
reordered").

I still don't think that this is the right approach.  Hell knows ;-/
Maybe you are right about offloading auto-close to a wq...  The whole
mnt_pin/mnt_unpin is bloody ugly, especially with multiple references
held by kernel/acct.c-opened files ;-/  And yes, this horror is originally
mine; the only excuse I have is that previous variant had been even more
kludgy.

_If_ we push it to wq, we really want to stop calling do_process_acct()
on auto-close.  With umount(8) it's borderline defensible, but with
workqueue it makes no sense whatsoever.  Moreover, it makes no sense
on acct_exit_ns() - it's done when PID 1 of that pidns dies, after having
called acct_process().  What's the point of having accounting in
non-root pidns spew two entries for its init?

Assuming we can stop generating records on auto-close, do we need
the wq thing at all?  After all, we could rip the affected acct->file
out, then flush and fput them all right there.  The usual logics for fput()
will make sure that they (and all of them will be final) will be
processed before we leave umount(2).  And let the last one trigger the
final mntput, now that mnt_pinned is zero...

PS: AFAICT, *BSD do not spew that even on explicit acct(NULL).  4.3 variants
found on PUPS do not, ditto for 4.4BSD-Alpha2 there; in Net2 kern_acct.c
is one of the castration victims, so it doesn't do anything at all and in
current {Free,Net,Open}BSD kernels it also doesn't happen.

Why do we bother with that at all?  It had been that way all way back to
2.1.68pre1 when kernel/acct.c had been merged, and it's probably too
late by now to try and ask the author about the reasons...
