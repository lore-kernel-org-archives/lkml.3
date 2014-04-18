Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaDRAhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:37:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34270 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDRAhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:37:32 -0400
Date: Fri, 18 Apr 2014 01:37:26 +0100
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
Message-ID: <20140418003725.GE18016@ZenIV.linux.org.uk>
References: <20140413053956.GM18016@ZenIV.linux.org.uk>
 <87zjjp3e7w.fsf@x220.int.ebiederm.org>
 <87ppkl1xb7.fsf@x220.int.ebiederm.org>
 <20140413215242.GP18016@ZenIV.linux.org.uk>
 <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
 <87ppkhc4pp.fsf@x220.int.ebiederm.org>
 <87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
 <20140417202237.GA18016@ZenIV.linux.org.uk>
 <87tx9rwsz4.fsf@x220.int.ebiederm.org>
 <20140417221203.GC18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417221203.GC18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:12:03PM +0100, Al Viro wrote:

> That's all.  And yes, I believe that such series would make sense on its
> own and once it survives beating (see above about docker - that bastard has
> surprised me quite a bit re stressing namespace-related codepaths), I would
> be quite willing to help with getting it merged.

FWIW, the tricky part around auto-close of acct is that we really want to
preserve the following property:

	In usual setups, umount(2) will not return until fs has been
shut down.

fput() being async is not a problem - it will be processed before we
return to userland.  I agree that we don't need the loop anymore (it's
basically a stack depth reduction measure that was needed with sync
fput() - without "add one more and deal with it when we return" we
would be getting mntput_no_expire -> fput -> mntput -> fs shutdown
back then).  But offloading that fput() to workqueue makes it really
possible to have actual fs shutdown happen after umount(2) returns,
without any extra mounts of the same fs, etc.  And since that shutdown
*can* take a long time (lots of dirty pages around, slow device or
slow network, etc.), we really might be talking about e.g. umount(8)
being finished before fs shutdown finishes.  It's an expected situation
when we have the same thing still mounted elsewhere or lazy-umounted
and busy, but this changes behaviour on setups where we had been
guaranteed that umount -a *will* wait until all filesystems except
root are shut down and root is remounted r/o.  So this change really
can cause data loss on reboot(8)/halt(8) on existing boxen...

IOW, workqueue is not the right tool here.  OTOH, it looks like we do have
a problem with kernel/acct.c vs. umount; it just requires a race between
auto-closing and acct_process_in_ns().  It's narrow, so it doesn't bite
us all the time, but it's there...  Damn, it had been a long time since
I really looked at that code ;-/

Actually, there's another reason why workqueue is bogus - we call
do_acct_process(), same as we do on acct(NULL) (which might or might
not be a good idea), but at least with do that from the context of
real process doing umount(2).  Doing that from workqueue is going to
produce a really bogus record...
