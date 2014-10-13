Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaJMWnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 18:43:14 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51342 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaJMWnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 18:43:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20141013062945.GX7996@ZenIV.linux.org.uk>
Date: Mon, 13 Oct 2014 15:42:28 -0700
In-Reply-To: <20141013062945.GX7996@ZenIV.linux.org.uk> (Al Viro's message of
	"Mon, 13 Oct 2014 07:29:45 +0100")
Message-ID: <87r3ybwq0b.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18XsMsbnkqhX0i0dKALAJnSnS6ouBWWH9c=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1038 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 4 (0.4%), parse: 1.49 (0.1%), extract_message_metadata:
	13 (1.3%), get_uri_detail_list: 7 (0.7%), tests_pri_-1000: 7 (0.7%),
	tests_pri_-950: 2 (0.2%), tests_pri_-900: 1.54 (0.1%), tests_pri_-400: 54
	(5.2%), check_bayes: 52 (5.0%), tests_pri_0: 942 (90.8%), tests_pri_500: 7
	(0.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC] dealing with proc_ns_follow_link() and "namespace" dentries
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> But more fundamentally, this stuff has no business being in procfs.  The
> *only* reason why we are putting them there (and get those inodes and
> dentries duplicated for different procfs instances) is this in
> do_loopback():
>         if (!check_mnt(parent) || !check_mnt(old))
>                 goto out2;
> You want to be able to bind those suckers by mount --bind.  Which is an
> odd API design (and it gives you another headache from hell with mnt_ns_loop())
> but it's too late to change, sadly ;-/  So you want ->follow_link() to
> yield dentries matching some vfsmount in our namespace.  The things would be
> much simpler if we didn't try that.
>
> Look: do_loopback() is *already* aware of those suckers.  Has to be, due to
> aforementioned mnt_ns_loop().  So we might as well weaken the constraints on
> old - check_mnt(old) || proc_ns_inode(old_path.dentry->d_inode) would do.
> The thing is, we calculate that proc_ns_inode() anyway.

Truthfully mnt_ns_loop only exists for because we have these for the
mount namespace.  But I take your point.

Your proposal sounds like it should work.  After the bind mount is
created we have a new struct mount so the existing chk_mnt checks won't
get us into trouble.

At some point we may need to allow multiple internal superblocks to
allow having a preset inode number for the purposes of
checkpoint/restart but I don't see that being a bottleneck to process
migration anytime in the near future, and your design does not preclude
that possibility.

There was a potential issue with your earlier suggestion to modify
check_mnt to only include mounted filesystems as otherwise there is an
issue with references to filesystems unmounted with MNT_DETACH being
able to be bind mounted.  Having an explicit proc_ns_inode test avoids
those issues.


> Now, suppose we'd done that.  In principle, it allows some things that are
> not allowed right now - you could open such file and pass it (via SCM_RIGHTS)
> to a process in another namespace.  With the current tree you can't bind
> that bugger via /proc/self/fd/<n> - it will have alien vfsmount.  After such
> change it will become allowed.  Is there any problem with that?  I don't see
> any (after all, recepient might have held it open and anyone who could
> get to that sucker via /proc/<pid>/fd/<n> could've simply stopped the recepient
> and made it pass the damn thing to them - being able to ptrace is enough
> for that).  Am I missing anything?

The only thing you can't do with a passed file descriptor today is to
mount it.  Everything else is already doable in any context, and all
mounting does is give you the ability to keep the namespace alive.
Something you can already do by just keeping the file descriptor open.

These filedescriptors are guarded by directory permissions so if
/proc/<pid>/fd had more open permissions I might be concerned, but
as it stands only the user of the process possesors of the appropriate
capability can access that directory.

So I really think we are good.  Thank you for making such a careful
analysis.

> *IF* we can get away with such change, everything becomes much easier.  We
> can add a filesystem just for those guys - one for the entire system.  And
> kern_mount() it.  Don't bother with register_filesystem() - no point showing
> it in the /proc/filesystems, etc.  No need to abuse procfs inodes either.
> Or procfs icache, for that matter.  All we need is a small standard piece
> embedded into each {mnt,net,pid,user,...}ns.
>
> Namely, let's stash a pointer to such dentry (if any) into that standard piece.
> Not a counting reference, of course, and used in a very limited way.
> 	* have ->d_prune() for those guys replace the stashed pointer with NULL.
> 	* on the "get dentry for ns" side,
> 	again:
> 		rcu_read_lock()
> 		d = atomic_long_read(stashed pointer)
> 		if (!d)
> 			goto slow;
> 		if (!lockref_get_not_dead(&d->d_lockref))
> 			goto slow;
> 		rcu_read_unlock();
> 		return d;
> 	slow:
> 		rcu_read_unlock();
> 		allocate new inode
> 		allocate new dentry
> 		d_instantiate()
> 		d = atomic_long_cmpxchg(stashed pointer, NULL, new dentry);
> 		if (d) {
> 			dput(new dentry);
> 			cpu_relax();	// might not be needed
> 			goto again;
> 		}
> 		return new dentry;
> I'd suggest having ->i_private point to that standard piece and storing
> ns_ops and proc_inum in there.

I think it is a shame that we don't have an equivalent of
d_materialise_unique that does thoe whole d_find_alias logic
non-directories.  Sigh.  But what should drive which functions to keep
are the real and needs of filesystems not my weird namespace case.

>From looking at your proposed code that doesn't look like it will be
any more difficult to maintain from the namespace side.  So I have no
objects with moving the code in that direction. 

> 	It's obviously a project for the next cycle and it'll require
> some cooperation between vfs and userns trees, but not too much of it -
> all we really need is a never-changed commit embedding that structure into
> all ...ns and passing _that_ to proc_{alloc,free}_inum() replacements
> Merged both into vfs.git #for-next and usern one.  We can do that right
> after -rc1.  Incidentally, it might make sense to move refcount into that
> common piece as well, but that's independent from the stuff above.

That sounds like a reasonable direction to go.  I think your schedule
may be a tad optimistic time-wise, if for no other reason that code
reviews take time, but that plan should work.

Eric
