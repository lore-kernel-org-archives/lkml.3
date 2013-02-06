Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab3BFQbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:31:53 -0500
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:56697 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757568Ab3BFQbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:31:49 -0500
X-TM-IMSS-Message-ID: <33938ac200052ebd@nsa.gov>
Message-ID: <511284B2.2070402@tycho.nsa.gov>
Date: Wed, 06 Feb 2013 11:28:34 -0500
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tommi Rantala <tt.rantala@gmail.com>
CC: James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: Re: selinux_msg_queue_msgrcv() oops
References: <CA+ydwtqgnMGuuHHWwj7jZh14WNdCFW_KA_APH-XZYX+RA-Ls1Q@mail.gmail.com> <5112662D.1010406@tycho.nsa.gov> <CA+ydwtpBNinVYa3zxoGVWjQLemxTyqTCm=o8mPut-F-DZx1xVg@mail.gmail.com>
In-Reply-To: <CA+ydwtpBNinVYa3zxoGVWjQLemxTyqTCm=o8mPut-F-DZx1xVg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050308000306020901090205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050308000306020901090205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 02/06/2013 10:21 AM, Tommi Rantala wrote:
> 2013/2/6 Stephen Smalley <sds@tycho.nsa.gov>:
>> On 02/06/2013 07:56 AM, Tommi Rantala wrote:
>>>
>>> Hello,
>>>
>>> I'm hitting an oops in selinux_msg_queue_msgrcv() when fuzzing with
>>> Trinity as the root user (in a qemu VM):
>>
>>
>> NULL msg->security at that point is a bug in the ipc subsystem; SELinux is
>> just the messenger.  Normally msg->security is set for every allocated msg
>> by load_msg() -> security_msg_msg_alloc() ->
>> selinux_msg_msg_alloc_security(), and freed/cleared upon free_msg() ->
>> security_msg_msg_free() -> selinux_msg_msg_free_security().  Looking around,
>> I see copy_msg() introduced for checkpoint-restore initializes dst->security
>> to NULL but never sets it properly?
>
> I am indeed building with CONFIG_CHECKPOINT_RESTORE=y, so your
> analysis seems to be correct.

(cc originator of the bug)

If I am reading this correctly, then when the copy msg was created, a 
msg security struct was already allocated 
(prepare_copy->load_msg->security_msg_msg_alloc).  So having copy_msg() 
clear dst->security is also a memory leak in addition to leading to this 
oops.  Attached is a possible, un-tested fix.

>
>>>
>>> [12578.053111] BUG: unable to handle kernel NULL pointer dereference
>>> at           (null)
>>> [12578.054025] IP: [<ffffffff8131e1da>]
>>> selinux_msg_queue_msgrcv+0xda/0x1e0
>>> [12578.054025] PGD 29961067 PUD 34dc5067 PMD 0
>>> [12578.054025] Oops: 0000 [#2] SMP
>>> [12578.054025] CPU 1
>>> [12578.054025] Pid: 23453, comm: trinity-child23 Tainted: G      D W
>>>    3.8.0-rc6+ #31 Bochs Bochs
>>> [12578.054025] RIP: 0010:[<ffffffff8131e1da>]  [<ffffffff8131e1da>]
>>> selinux_msg_queue_msgrcv+0xda/0x1e0
>>> [12578.054025] RSP: 0018:ffff88002b6b5e18  EFLAGS: 00010246
>>> [12578.054025] RAX: 0000000000000000 RBX: ffff88003132d410 RCX:
>>> 0000000000000001
>>> [12578.054025] RDX: ffff88000e8bc560 RSI: 0000000000000001 RDI:
>>> 0000000000000246
>>> [12578.054025] RBP: ffff88002b6b5e68 R08: 0000000000000000 R09:
>>> 0000000000000000
>>> [12578.054025] R10: ffff88000e8bc560 R11: 0000000000000000 R12:
>>> 0000000000000001
>>> [12578.054025] R13: 0000000000000000 R14: ffff880006449500 R15:
>>> ffff88003132d410
>>> [12578.054025] FS:  00007f7385059700(0000) GS:ffff88003e200000(0000)
>>> knlGS:0000000000000000
>>> [12578.054025] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [12578.054025] CR2: 0000000000000000 CR3: 00000000303a2000 CR4:
>>> 00000000000006e0
>>> [12578.054025] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>> 0000000000000000
>>> [12578.054025] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>>> 0000000000000400
>>> [12578.054025] Process trinity-child23 (pid: 23453, threadinfo
>>> ffff88002b6b4000, task ffff88000e8bc560)
>>> [12578.054025] Stack:
>>> [12578.054025]  ffffffff8131e105 ffffffff81313f69 ffff88002b6b5e04
>>> ffffffff00000000
>>> [12578.054025]  ffffffff812fd6f5 ffff88003a89c1c0 0000000000000000
>>> 0000000000000001
>>> [12578.054025]  0000000000000000 ffff88003132d4c0 ffff88002b6b5e78
>>> ffffffff81314086
>>> [12578.054025] Call Trace:
>>> [12578.054025]  [<ffffffff8131e105>] ? selinux_msg_queue_msgrcv+0x5/0x1e0
>>> [12578.054025]  [<ffffffff81313f69>] ? security_ipc_permission+0x19/0x20
>>> [12578.054025]  [<ffffffff812fd6f5>] ? ipc_lock+0x5/0x1c0
>>> [12578.054025]  [<ffffffff81314086>] security_msg_queue_msgrcv+0x16/0x20
>>> [12578.054025]  [<ffffffff812ff93f>] do_msgrcv+0x1ef/0x6e0
>>> [12578.054025]  [<ffffffff812fe340>] ? load_msg+0x180/0x180
>>> [12578.054025]  [<ffffffff81373184>] ? lockdep_sys_exit_thunk+0x35/0x67
>>> [12578.054025]  [<ffffffff810fb236>] ? trace_hardirqs_on_caller+0x16/0x1a0
>>> [12578.054025]  [<ffffffff8137310e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>> [12578.054025]  [<ffffffff812ffe45>] sys_msgrcv+0x15/0x20
>>> [12578.054025]  [<ffffffff81cfe9d9>] system_call_fastpath+0x16/0x1b
>>> [12578.054025] Code: 4c 8d 45 c0 45 31 c9 b9 10 00 00 00 44 89 e7 4d
>>> 8b 6d 28 c6 45 c0 04 89 55 c8 8b 70 04 ba 1b 00 00 00 e8 fa 7a ff ff
>>> 85 c0 75 1d <41> 8b 75 00 4c 8d 45 c0 45 31 c9 b9 02 00 00 00 ba 1a 00
>>> 00 00
>>> [12578.054025] RIP  [<ffffffff8131e1da>]
>>> selinux_msg_queue_msgrcv+0xda/0x1e0
>>> [12578.054025]  RSP <ffff88002b6b5e18>
>>> [12578.054025] CR2: 0000000000000000
>>> [12578.142292] ---[ end trace 36aee1c7bfea7f83 ]---
>>>
>>>
>>> After adding:
>>>
>>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>>> index 54aaa72..20cec57 100644
>>> --- a/security/selinux/hooks.c
>>> +++ b/security/selinux/hooks.c
>>> @@ -4982,9 +4982,12 @@ static int selinux_msg_queue_msgrcv(struct
>>> msg_queue *msq, struct msg_msg *msg,
>>>
>>>           rc = avc_has_perm(sid, isec->sid,
>>>                             SECCLASS_MSGQ, MSGQ__READ, &ad);
>>> -       if (!rc)
>>> +       if (!rc) {
>>> +               WARN(msec == NULL, "msec is NULL!");
>>> +
>>>                   rc = avc_has_perm(sid, msec->sid,
>>>                                     SECCLASS_MSG, MSG__RECEIVE, &ad);
>>> +       }
>>>           return rc;
>>>    }
>>>
>>>
>>> I see:
>>>
>>> [   43.103283] ------------[ cut here ]------------
>>> [   43.104236] WARNING: at
>>> /home/ttrantal/git/linux-2.6/security/selinux/hooks.c:4986
>>> selinux_msg_queue_msgrcv+0x1ff/0x210()
>>> [   43.106088] Hardware name: Bochs
>>> [   43.106640] msec is NULL!Pid: 2387, comm: trinity-child9 Not
>>> tainted 3.8.0-rc6+ #37
>>> [   43.107950] Call Trace:
>>> [   43.108393]  [<ffffffff8131e12f>] ?
>>> selinux_msg_queue_msgrcv+0x1ff/0x210
>>> [   43.109534]  [<ffffffff8109ac1a>] warn_slowpath_common+0x7a/0xb0
>>> [   43.110565]  [<ffffffff8109acc6>] warn_slowpath_fmt+0x46/0x50
>>> [   43.111561]  [<ffffffff8131e12f>] selinux_msg_queue_msgrcv+0x1ff/0x210
>>> [   43.112677]  [<ffffffff8131df35>] ? selinux_msg_queue_msgrcv+0x5/0x210
>>> [   43.113808]  [<ffffffff81313f99>] ? security_ipc_permission+0x19/0x20
>>> [   43.114919]  [<ffffffff812fd725>] ? ipc_lock+0x5/0x1c0
>>> [   43.115817]  [<ffffffff813140b6>] security_msg_queue_msgrcv+0x16/0x20
>>> [   43.116929]  [<ffffffff812ff96f>] do_msgrcv+0x1ef/0x6e0
>>> [   43.117909]  [<ffffffff812fe370>] ? load_msg+0x180/0x180
>>> [   43.118850]  [<ffffffff810fb35d>] ?
>>> trace_hardirqs_on_caller+0x10d/0x1a0
>>> [   43.120019]  [<ffffffff8137315e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>> [   43.121126]  [<ffffffff812ffe75>] sys_msgrcv+0x15/0x20
>>> [   43.122001]  [<ffffffff81cfea19>] system_call_fastpath+0x16/0x1b
>>> [   43.123044] ---[ end trace db5952f0fa3bedc7 ]---
>>> [   43.123815]
>>> [   43.124096] ===============================
>>> [   43.124804] [ INFO: suspicious RCU usage. ]
>>> [   43.125531] 3.8.0-rc6+ #37 Tainted: G        W
>>> [   43.126344] -------------------------------
>>> [   43.127083] /home/ttrantal/git/linux-2.6/include/linux/rcupdate.h:468
>>> Illegal context switch in RCU read-side critical section!
>>> [   43.129015]
>>> [   43.129015] other info that might help us debug this:
>>> [   43.129015]
>>> [   43.130367]
>>> [   43.130367] rcu_scheduler_active = 1, debug_locks = 0
>>> [   43.131481] 3 locks held by trinity-child9/2387:
>>> [   43.132266]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff812fd725>]
>>> ipc_lock+0x5/0x1c0
>>> [   43.133709]  #1:  (&(&new->lock)->rlock){+.+...}, at:
>>> [<ffffffff812fd7a1>] ipc_lock+0x81/0x1c0
>>> [   43.135294]  #2:  (&mm->mmap_sem){++++++}, at: [<ffffffff8108e1d4>]
>>> __do_page_fault+0x114/0x4e0
>>> [   43.136864]
>>> [   43.136864] stack backtrace:
>>> [   43.137619] Pid: 2387, comm: trinity-child9 Tainted: G        W
>>> 3.8.0-rc6+ #37
>>> [   43.138897] Call Trace:
>>> [   43.139338]  [<ffffffff810fdd1d>] lockdep_rcu_suspicious+0xfd/0x130
>>> [   43.140417]  [<ffffffff81cfb783>] __schedule+0x543/0x900
>>> [   43.141342]  [<ffffffff810d38ba>] __cond_resched+0x2a/0x40
>>> [   43.142291]  [<ffffffff8108e1d4>] ? __do_page_fault+0x114/0x4e0
>>> [   43.143440]  [<ffffffff81cfbc6f>] _cond_resched+0x2f/0x40
>>> [   43.144362]  [<ffffffff8108e1e1>] __do_page_fault+0x121/0x4e0
>>> [   43.145362]  [<ffffffff810fb3fd>] ? trace_hardirqs_on+0xd/0x10
>>> [   43.146316]  [<ffffffff8137319d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>>> [   43.147386]  [<ffffffff8108e5de>] do_page_fault+0xe/0x10
>>> [   43.148254]  [<ffffffff810889fa>] do_async_page_fault+0x2a/0xa0
>>> [   43.149239]  [<ffffffff81cfe138>] async_page_fault+0x28/0x30
>>> [   43.150167]  [<ffffffff8131e017>] ? selinux_msg_queue_msgrcv+0xe7/0x210
>>> [   43.151263]  [<ffffffff8131e12f>] ?
>>> selinux_msg_queue_msgrcv+0x1ff/0x210
>>> [   43.152357]  [<ffffffff8131df35>] ? selinux_msg_queue_msgrcv+0x5/0x210
>>> [   43.153475]  [<ffffffff81313f99>] ? security_ipc_permission+0x19/0x20
>>> [   43.154828]  [<ffffffff812fd725>] ? ipc_lock+0x5/0x1c0
>>> [   43.156052]  [<ffffffff813140b6>] security_msg_queue_msgrcv+0x16/0x20
>>> [   43.157586]  [<ffffffff812ff96f>] do_msgrcv+0x1ef/0x6e0
>>> [   43.158830]  [<ffffffff812fe370>] ? load_msg+0x180/0x180
>>> [   43.160131]  [<ffffffff810fb35d>] ?
>>> trace_hardirqs_on_caller+0x10d/0x1a0
>>> [   43.161736]  [<ffffffff8137315e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>> [   43.163238]  [<ffffffff812ffe75>] sys_msgrcv+0x15/0x20
>>> [   43.164453]  [<ffffffff81cfea19>] system_call_fastpath+0x16/0x1b
>>> [   43.176035] BUG: unable to handle kernel NULL pointer dereference
>>> at           (null)
>>> [   43.177016] IP: [<ffffffff8131e017>]
>>> selinux_msg_queue_msgrcv+0xe7/0x210
>>> [   43.177016] PGD 3189b067 PUD 3189c067 PMD 0
>>> [   43.177016] Oops: 0000 [#1] SMP
>>> [   43.177016] CPU 0
>>> [   43.177016] Pid: 2387, comm: trinity-child9 Tainted: G        W
>>> 3.8.0-rc6+ #37 Bochs Bochs
>>> [   43.177016] RIP: 0010:[<ffffffff8131e017>]  [<ffffffff8131e017>]
>>> selinux_msg_queue_msgrcv+0xe7/0x210
>>> [   43.177016] RSP: 0018:ffff8800318a7e18  EFLAGS: 00010296
>>> [   43.177016] RAX: 0000000000000000 RBX: ffff880032e0e810 RCX:
>>> 0000000000000006
>>> [   43.177016] RDX: 0000000000003e50 RSI: ffff88003b7c4c68 RDI:
>>> 0000000000000009
>>> [   43.177016] RBP: ffff8800318a7e68 R08: 0000000000000001 R09:
>>> 0000000000000000
>>> [   43.177016] R10: 0000000000000000 R11: 0000000000000288 R12:
>>> 0000000000000001
>>> [   43.177016] R13: 0000000000000000 R14: ffff88003b22ae80 R15:
>>> ffff880032e0e810
>>> [   43.177016] FS:  00007fc6ba864700(0000) GS:ffff88003fc00000(0000)
>>> knlGS:0000000000000000
>>> [   43.177016] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [   43.177016] CR2: 00007fc6ba6471f0 CR3: 0000000031898000 CR4:
>>> 00000000000006f0
>>> [   43.177016] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>> 0000000000000000
>>> [   43.177016] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>>> 0000000000000400
>>> [   43.177016] Process trinity-child9 (pid: 2387, threadinfo
>>> ffff8800318a6000, task ffff88003b7c4560)
>>> [   43.177016] Stack:
>>> [   43.177016]  ffffffff8131df35 ffffffff81313f99 ffff8800318a7e04
>>> ffffffff5d6d982a
>>> [   43.177016]  ffffffff812fd725 ffff880039c675c0 0000000000000000
>>> 0000000000000001
>>> [   43.177016]  0000000000000000 ffff880032e0e8c0 ffff8800318a7e78
>>> ffffffff813140b6
>>> [   43.177016] Call Trace:
>>> [   43.177016]  [<ffffffff8131df35>] ? selinux_msg_queue_msgrcv+0x5/0x210
>>> [   43.177016]  [<ffffffff81313f99>] ? security_ipc_permission+0x19/0x20
>>> [   43.177016]  [<ffffffff812fd725>] ? ipc_lock+0x5/0x1c0
>>> [   43.177016]  [<ffffffff813140b6>] security_msg_queue_msgrcv+0x16/0x20
>>> [   43.177016]  [<ffffffff812ff96f>] do_msgrcv+0x1ef/0x6e0
>>> [   43.177016]  [<ffffffff812fe370>] ? load_msg+0x180/0x180
>>> [   43.177016]  [<ffffffff810fb35d>] ?
>>> trace_hardirqs_on_caller+0x10d/0x1a0
>>> [   43.177016]  [<ffffffff8137315e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>> [   43.177016]  [<ffffffff812ffe75>] sys_msgrcv+0x15/0x20
>>> [   43.177016]  [<ffffffff81cfea19>] system_call_fastpath+0x16/0x1b
>>> [   43.177016] Code: 00 00 00 44 89 e7 4d 8b 6d 28 c6 45 c0 04 89 55
>>> c8 8b 70 04 ba 1b 00 00 00 e8 f6 7c ff ff 85 c0 75 26 4d 85 ed 0f 84
>>> 00 01 00 00 <41> 8b 75 00 4c 8d 45 c0 45 31 c9 b9 02 00 00 00 ba 1a 00
>>> 00 00
>>> [   43.177016] RIP  [<ffffffff8131e017>]
>>> selinux_msg_queue_msgrcv+0xe7/0x210
>>> [   43.177016]  RSP <ffff8800318a7e18>
>>> [   43.177016] CR2: 0000000000000000
>>> [   43.228535] ---[ end trace db5952f0fa3bedc8 ]---
>>> [   68.106008] BUG: soft lockup - CPU#0 stuck for 22s!
>>> [trinity-child8:2382]
>>>
>>> Tommi
>>>
>>


--------------050308000306020901090205
Content-Type: text/x-patch;
 name="0001-Fix-selinux_msg_queue_msgrcv-oops.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Fix-selinux_msg_queue_msgrcv-oops.patch"

>From 694502e960af954c4203d1b76837e51ce6720576 Mon Sep 17 00:00:00 2001
From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Wed, 6 Feb 2013 11:15:08 -0500
Subject: [PATCH] Fix selinux_msg_queue_msgrcv() oops.

Fix an oops in selinux_msg_queue_msgrcv() by ensuring that
copied messages preserve security information.

Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Reported-by: Tommi Rantala <tt.rantala@gmail.com>
---
 include/linux/security.h | 12 ++++++++++++
 ipc/msgutil.c            |  6 +++++-
 security/security.c      |  5 +++++
 security/selinux/hooks.c | 10 ++++++++++
 4 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index eee7478..4737635 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1126,6 +1126,11 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	created.
  *	@msg contains the message structure to be modified.
  *	Return 0 if operation was successful and permission is granted.
+ * @msg_msg_copy_security:
+ *	Propagate security information on a msg copy operation.
+ *	@src contains the source message structure.
+ *	@dst contains the destination message structure.
+ *	Return 0 if operation was successful.
  * @msg_msg_free_security:
  *	Deallocate the security structure for this message.
  *	@msg contains the message structure to be modified.
@@ -1553,6 +1558,7 @@ struct security_operations {
 	void (*ipc_getsecid) (struct kern_ipc_perm *ipcp, u32 *secid);
 
 	int (*msg_msg_alloc_security) (struct msg_msg *msg);
+	int (*msg_msg_copy_security) (struct msg_msg *src, struct msg_msg *dst);
 	void (*msg_msg_free_security) (struct msg_msg *msg);
 
 	int (*msg_queue_alloc_security) (struct msg_queue *msq);
@@ -1811,6 +1817,7 @@ void security_task_to_inode(struct task_struct *p, struct inode *inode);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
 void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
 int security_msg_msg_alloc(struct msg_msg *msg);
+int security_msg_msg_copy(struct msg_msg *src, struct msg_msg *dst);
 void security_msg_msg_free(struct msg_msg *msg);
 int security_msg_queue_alloc(struct msg_queue *msq);
 void security_msg_queue_free(struct msg_queue *msq);
@@ -2409,6 +2416,11 @@ static inline int security_msg_msg_alloc(struct msg_msg *msg)
 	return 0;
 }
 
+static inline int security_msg_msg_copy(struct msg_msg *src, struct msg_msg *dst)
+{
+	return 0;
+}
+
 static inline void security_msg_msg_free(struct msg_msg *msg)
 { }
 
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index ebfcbfa..7837257 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -108,6 +108,7 @@ struct msg_msg *copy_msg(struct msg_msg *src, struct msg_msg *dst)
 	struct msg_msgseg *dst_pseg, *src_pseg;
 	int len = src->m_ts;
 	int alen;
+	int err;
 
 	BUG_ON(dst == NULL);
 	if (src->m_ts > dst->m_ts)
@@ -118,7 +119,10 @@ struct msg_msg *copy_msg(struct msg_msg *src, struct msg_msg *dst)
 		alen = DATALEN_MSG;
 
 	dst->next = NULL;
-	dst->security = NULL;
+
+	err = security_msg_msg_copy(src, dst);
+	if (err < 0)
+		return ERR_PTR(err);
 
 	memcpy(dst + 1, src + 1, alen);
 
diff --git a/security/security.c b/security/security.c
index 7b88c6a..85cd39d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -936,6 +936,11 @@ int security_msg_msg_alloc(struct msg_msg *msg)
 	return security_ops->msg_msg_alloc_security(msg);
 }
 
+int security_msg_msg_copy(struct msg_msg *src, struct msg_msg *dst)
+{
+	return security_ops->msg_msg_copy_security(src, dst);
+}
+
 void security_msg_msg_free(struct msg_msg *msg)
 {
 	security_ops->msg_msg_free_security(msg);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ef26e96..79f93ad 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4840,6 +4840,15 @@ static int selinux_msg_msg_alloc_security(struct msg_msg *msg)
 	return msg_msg_alloc_security(msg);
 }
 
+static int selinux_msg_msg_copy_security(struct msg_msg *src, struct msg_msg *dst)
+{
+	struct msg_security_struct *smsec, *dmsec;
+	smsec = src->security;
+	dmsec = dst->security;
+	dmsec->sid = smsec->sid;
+	return 0;
+}
+
 static void selinux_msg_msg_free_security(struct msg_msg *msg)
 {
 	msg_msg_free_security(msg);
@@ -5603,6 +5612,7 @@ static struct security_operations selinux_ops = {
 	.ipc_getsecid =			selinux_ipc_getsecid,
 
 	.msg_msg_alloc_security =	selinux_msg_msg_alloc_security,
+	.msg_msg_copy_security =	selinux_msg_msg_copy_security,
 	.msg_msg_free_security =	selinux_msg_msg_free_security,
 
 	.msg_queue_alloc_security =	selinux_msg_queue_alloc_security,
-- 
1.7.11.7


--------------050308000306020901090205--
