Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786Ab3CHQBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:01:25 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:50574 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab3CHQBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:01:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
References: <20130307132819.GA31162@localhost> <87sj47t97s.fsf@xmission.com>
	<CADZ9YHhbvu8WYUMdDtpvkrZmLCD87fQ0Y0AcXdBaQB53=uPYYw@mail.gmail.com>
Date: Fri, 08 Mar 2013 08:01:15 -0800
In-Reply-To: <CADZ9YHhbvu8WYUMdDtpvkrZmLCD87fQ0Y0AcXdBaQB53=uPYYw@mail.gmail.com>
	(Rakib Mullick's message of "Fri, 8 Mar 2013 17:38:52 +0600")
Message-ID: <87d2v9q3sk.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18MZ104h7wXEufVOYeJNzyHg+yqeYh5nEs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rakib Mullick <rakib.mullick@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [nsproxy] BUG: unable to handle kernel NULL pointer dereference at 0000000000000024
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rakib Mullick <rakib.mullick@gmail.com> writes:

> On 3/7/13, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Fengguang Wu <fengguang.wu@intel.com> writes:
>>
>>> Greetings,
>>>
>>> I got the below oops and the first bad commit is
>>
>> Doh!  On a second look that change is totally wrong.  Of course we need
>> to up the ref-count every time we create a new process.  Especially if
>> we don't do anything with namespaces.
>>
>> I was looking at it from the wrong angle last night.  I should have
>> known better.
>>
>> Patch dropped.
>>
>
> Sad to know :( . From the debug messages, it's kmemcheck report. I
> can't related the problem specified with the patch I've proposed.
>
> It seems at task exit path, at switch_task_namespaces() - after my
> patch atomic_dec_and_test(&ns->count) becomes true (-1), thus
> free_nsproxy() gets called. But, free_nsproxy() shouldn't get called
> here.
>
> Am I right? Or there's something else?

When a new task is created one of two things needs to happen.
A) A reference count needs to be added to the current nsproxy.
B) B a new nsproxy needs to be created.

The way that code works today is far from a shiny example of totally
clear code but it is not incorrect.

By moving get_nsproxy down below the first return 0, you removed taking
the reference count in the one case it is important.

Arguably we should apply the patch below for clarity, and I just might
queue it up for 3.10.

Eric

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index afc0456..11b8b3f 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -125,22 +125,16 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 	struct nsproxy *old_ns = tsk->nsproxy;
 	struct user_namespace *user_ns = task_cred_xxx(tsk, user_ns);
 	struct nsproxy *new_ns;
-	int err = 0;
-
-	if (!old_ns)
-		return 0;
-
-	get_nsproxy(old_ns);
 
 	if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-				CLONE_NEWPID | CLONE_NEWNET)))
+		       CLONE_NEWPID | CLONE_NEWNET))) {
+		get_nsproxy(old_ns);
 		return 0;
-
-	if (!ns_capable(user_ns, CAP_SYS_ADMIN)) {
-		err = -EPERM;
-		goto out;
 	}
 
+	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
 	/*
 	 * CLONE_NEWIPC must detach from the undolist: after switching
 	 * to a new ipc namespace, the semaphore arrays from the old
@@ -148,22 +142,15 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 	 * means share undolist with parent, so we must forbid using
 	 * it along with CLONE_NEWIPC.
 	 */
-	if ((flags & CLONE_NEWIPC) && (flags & CLONE_SYSVSEM)) {
-		err = -EINVAL;
-		goto out;
-	}
+	if ((flags & CLONE_NEWIPC) && (flags & CLONE_SYSVSEM))
+		return -EINVAL;
 
 	new_ns = create_new_namespaces(flags, tsk, user_ns, tsk->fs);
-	if (IS_ERR(new_ns)) {
-		err = PTR_ERR(new_ns);
-		goto out;
-	}
+	if (IS_ERR(new_ns))
+		return PTR_ERR(new_ns);
 
 	tsk->nsproxy = new_ns;
-
-out:
-	put_nsproxy(old_ns);
-	return err;
+	return 0;
 }
 
 void free_nsproxy(struct nsproxy *ns)

