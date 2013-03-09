Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab3CII2i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 03:28:38 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:55215 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab3CII2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 03:28:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130309003617.GB6743@redhat.com>
	<CA+55aFzS0MpqRNM_HmJq6GKiuBncieA6LysNjSM1qSmETitkGw@mail.gmail.com>
	<20130309020318.GA11449@redhat.com>
	<CA+55aFwoqQUgS3ou4oqA-G7-cQzU-pwq7aSJ9vA5oyWCshhDkw@mail.gmail.com>
	<20130309022623.GB11449@redhat.com>
	<20130309025631.GA13188@redhat.com>
	<20130309025752.GA13913@redhat.com>
	<CA+55aFxyOYXnzDoWr7Utr1QLjjMUCON5EGH3FMvGBHxnxMJmQQ@mail.gmail.com>
	<20130309032530.GA19839@redhat.com> <87wqthmedi.fsf@xmission.com>
	<20130309042658.GB1396@redhat.com>
Date: Sat, 09 Mar 2013 00:28:27 -0800
In-Reply-To: <20130309042658.GB1396@redhat.com> (Dave Jones's message of "Fri,
	8 Mar 2013 23:26:58 -0500")
Message-ID: <87haklkmdw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19H6jQ5W4PsJqvKtPwePvarQy4DjGLENG4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dave Jones <davej@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> On Fri, Mar 08, 2013 at 07:38:33PM -0800, Eric W. Biederman wrote:
>  > Dave Jones <davej@redhat.com> writes:
>  > 
>  > > On Fri, Mar 08, 2013 at 07:16:09PM -0800, Linus Torvalds wrote:
>  > >  > Goodie. Your bug reports gave me heartburn. But it sounds like we have an
>  > >  > angle on all of the ones you've seen now?
>  > >  > 
>  > >  > Or have I forgotten about some case?
>  > >  
>  > > To be honest I've lost track of the whole collection.
>  > > Let me repull your latest tree, and see what falls out.
>  > > (I'll turn off CONFIG_USER_NS for now too until that gets fixed)
>  > 
>  > It was CONFIG_UTS_NS that tripped you.  
>  > 
>  > Since I can trigger this with /proc/self/ns/mnt/a you are going to be
>  > able to compile this one out.
>
> fwiw, the other namespace procfs files look like they have the same bug
>
> I just triggered it again on /proc/571/task/571/ns/net

Yep same code.

I will do a proper submission of this after I have slept.  But
here is the fix.

From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat, 9 Mar 2013 00:14:45 -0800
Subject: [PATCH] proc: Use nd_jump_link in proc_ns_follow_link

Update proc_ns_follow_link to use nd_jump_link instead of just
manually updating nd.path.dentry.

This fixes the BUG_ON(nd->inode != parent->d_inode) reported by Dave
Jones and reproduced trivially with mkdir /proc/self/ns/uts/a.

Sigh it looks like the VFS change to require use of nd_jump_link
happend while proc_ns_follow_link was baking and since the common case
of proc_ns_follow_link continued to work without problems the need for
making this change was overlooked.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/namespaces.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index b7a4719..66b51c0 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -118,7 +118,7 @@ static void *proc_ns_follow_link(struct dentry *dentry, struct nameidata *nd)
 	struct super_block *sb = inode->i_sb;
 	struct proc_inode *ei = PROC_I(inode);
 	struct task_struct *task;
-	struct dentry *ns_dentry;
+	struct path ns_path;
 	void *error = ERR_PTR(-EACCES);
 
 	task = get_proc_task(inode);
@@ -128,14 +128,14 @@ static void *proc_ns_follow_link(struct dentry *dentry, struct nameidata *nd)
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto out_put_task;
 
-	ns_dentry = proc_ns_get_dentry(sb, task, ei->ns_ops);
-	if (IS_ERR(ns_dentry)) {
-		error = ERR_CAST(ns_dentry);
+	ns_path.dentry = proc_ns_get_dentry(sb, task, ei->ns_ops);
+	if (IS_ERR(ns_path.dentry)) {
+		error = ERR_CAST(ns_path.dentry);
 		goto out_put_task;
 	}
 
-	dput(nd->path.dentry);
-	nd->path.dentry = ns_dentry;
+	ns_path.mnt = mntget(nd->path.mnt);
+	nd_jump_link(nd, &ns_path);
 	error = NULL;
 
 out_put_task:
-- 
1.7.5.4

