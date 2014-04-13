Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaDMHBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 03:01:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44931 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaDMHBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 03:01:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
References: <87wqezl5df.fsf_-_@x220.int.ebiederm.org>
	<20140409023027.GX18016@ZenIV.linux.org.uk>
	<20140409023947.GY18016@ZenIV.linux.org.uk>
	<87sipmbe8x.fsf@x220.int.ebiederm.org>
	<20140409175322.GZ18016@ZenIV.linux.org.uk>
	<20140409182830.GA18016@ZenIV.linux.org.uk>
	<87txa286fu.fsf@x220.int.ebiederm.org>
	<87fvlm860e.fsf_-_@x220.int.ebiederm.org>
	<20140409232423.GB18016@ZenIV.linux.org.uk>
	<87lhva5h4k.fsf@x220.int.ebiederm.org>
	<20140413053956.GM18016@ZenIV.linux.org.uk>
Date: Sun, 13 Apr 2014 00:01:23 -0700
In-Reply-To: <20140413053956.GM18016@ZenIV.linux.org.uk> (Al Viro's message of
	"Sun, 13 Apr 2014 06:39:56 +0100")
Message-ID: <87zjjp3e7w.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19m6b2U6xIUJ+g041mP2bqql1hNs8Ex3rg=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1901]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] vfs: In mntput run deactivate_super on a shallow stack.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Sat, Apr 12, 2014 at 03:15:39PM -0700, Eric W. Biederman wrote:
>
>> Can you explain which scenario you are thinking about with respect to a
>> failed modprobe?
>
> Completely made up example:
>
> static struct file_system_type foofs = {
> 	.mount = mount_foo,
> 	.kill_sb = kill_foo,
> };
>
> static struct vfsmount *mnt;
>
> static __init int foo_init(void)
> {
> 	int err;
> 	err = init_some();
> 	if (err < 0)
> 		return err;
> 	mnt = kern_mount(&foofs);
> 	if (IS_ERR(mnt)) {
> 		uninit_some();
> 		return PTR_ERR(mnt);
> 	}
> 	err = init_some_more();
> 	if (err < 0) {
> 		kern_umount(mnt);
> 		uninit_some();
> 		return err;
> 	}
> 	printk(KERN_INFO "loaded foo");
> 	return 0;
> }
>
> Now, think what happens if init_some_more() in the above fails.  With the
> current mntput() semantics, everything works.  After making mntput() (from
> kern_umount()) delayed until the return to userland, we end up with attempt
> to call kill_foo() after the memory where it code sits gets freed.  For that
> matter, by that point we are not even guaranteed to reach it, since it
> comes as mnt->mnt_sb->s_type->kill_sb() and s_type points to freed memory.
>
> I'm not saying that we have something that would closely resemble this
> example, but it's not hard to vary it in a lot of ways, keeping the same
> problem.  Basically, you need to audit all paths leading from failure
> exits in some module_init() to mntput() and figure out if delaying the
> effect of that mntput() would be safe there (== doesn't get delayed past
> the point where we destroy something needed for that fs shutdown).
>
> It's not *that* horrible, since not too many modules out there are
> declaring any fs types, but it needs to be done.  In theory, you could
> also fall prey to something like this:
> 	type = get_fs_type("proc");
> 	ns = kmalloc(...);
> 	/* fill *ns */
> 	mnt = kern_mount_data(type, p);
> 	...
> 	if (error) {
> 		kern_unmount(mnt);
> 		kfree(p);
> 		put_filesystem(type);
> 	}
> possibly with get_fs_type() replaced with some other way to get that
> pointer to fs type (defined elsewhere).  E.g. for procfs it could
> be, say, task_active_pid_ns(current)->proc_mnt->mnt_sb->s_type, etc.
>
> Again, it's not impossible to audit (there's not a lot of places where
> struct file_system_type * is ever stored, there are few instances of
> struct file_system_type, all statically allocated, etc.), but it's
> a non-trivial amount of work.  And I honestly don't know if we have
> any such places right now.  Moreover, unless you feel like repeating
> that kind of audit every merge window, we'll need a some way of dealing
> with such situations.  Something like flush_pending_mntput(fs_type), for
> example, documented as barrier to be used in such places might do, but
> if you can think of something more fool-proof...

I performed a quick audit and I don't see that case happening in the
current code.  

Further I believe we already have a pretty good protection against the
class of bug you are talking about.

deactivate_locked_super calls put_filesystem which calls module_put.  So
we have a reference to the module the filesystem was loaded in so the
code and static data is not going away until the we free the super block
and decrement the module reference count.

So while I think it is possible for kill_sb, or put_super to reference
so global module data that we have cleaned up I think it is a pretty
unlikely situation.

kern_mount or kern_mount_data seems to be the very last thing modules
that reference it perform.  I will take a closer look before I send the
final version of this but I think you are worrying about something that
just doesn't happen in practice and isn't likely too.

Eric

