Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaDSCQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 22:16:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38077 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaDSCQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 22:16:51 -0400
Date: Sat, 19 Apr 2014 03:16:46 +0100
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
Message-ID: <20140419021646.GO18016@ZenIV.linux.org.uk>
References: <87ppkl1xb7.fsf@x220.int.ebiederm.org>
 <20140413215242.GP18016@ZenIV.linux.org.uk>
 <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
 <87ppkhc4pp.fsf@x220.int.ebiederm.org>
 <87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
 <20140417202237.GA18016@ZenIV.linux.org.uk>
 <87tx9rwsz4.fsf@x220.int.ebiederm.org>
 <20140417221203.GC18016@ZenIV.linux.org.uk>
 <20140418003725.GE18016@ZenIV.linux.org.uk>
 <20140419013526.GN18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140419013526.GN18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 02:35:26AM +0100, Al Viro wrote:

> My apologies for confusion - I have not looked at your last commit.
> I *really* don't like that solution, but it probably does close that
> particular problem.  Consider that objection withdrawn (modulo "you
> have created a bisect hazard here, that part of series needs to be
> reordered").
> 
> I still don't think that this is the right approach.  Hell knows ;-/
> Maybe you are right about offloading auto-close to a wq...  The whole
> mnt_pin/mnt_unpin is bloody ugly, especially with multiple references
> held by kernel/acct.c-opened files ;-/

Actually, it's worse than ugly.  Consider the following race:
* umount(2) decides that victim isn't busy and does everything up to
the final mntput_no_expire().
* acct(NULL) is called, and gets to
        if (old_acct) {
                mnt_unpin(old_acct->f_path.mnt);
                spin_unlock(&acct_lock);   
                do_acct_process(acct, old_ns, old_acct);
                filp_close(old_acct, NULL);
                spin_lock(&acct_lock);
        }
It starts writing and blocks.  Now mnt_pinned is 0 and refcount is 1, so
mntput_no_expire() from umount(2) does not see anything untowards and just
returns.  Eventually, write finishes and acct(2) does filp_close().  Fine,
but by that point umount(2) has already returned to userland and we have
the problem I'd been complaining about in your solution.  And your patches
won't go anywhere near wait_for_completion() in that case, so they don't
close that hole either...

Not your fault, and not that scary wrt dirty shutdown, but it still needs
fixing.  While we are at it, consider what happens if something is busy
in acct_process() while we are hitting that race.  This filp_close()
will happen before the final fput(), so the actual fs shutdown is moved
to whatever exiting process that was in acct_process() at that point.
Might be more than one of those, even - then the last one to finish
writing will end up carrying the bucket.

Actually, even without umount(2) in the mix (just acct(NULL) vs. exiting
processes) it's somewhat fishy - we are, after all, calling ->flush()
before the final entries are written.

That, BTW, is another reason why "let's write one last entry on acct(NULL)"
is bogus - userland tools might hope to use that to get information about the
command that has stopped logging, but it is not guaranteed to be the last
one.
