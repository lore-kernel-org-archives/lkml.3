Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbbAUVdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:33:18 -0500
Received: from smtp105.biz.mail.bf1.yahoo.com ([98.139.221.43]:21130 "EHLO
	smtp105.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbbAUVdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:33:05 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ZfGwmC0VM1kiLdaySlche3xGd9_eiuQuoIMa8rlwmPLM9rx
 clWHT.DseSgqokCZ3JQzfu9cOmqtWNCxYSuG2tjYAmPO_Iv8BvfiOVyC3AF3
 L4RsfpwAb61U2IwlXMqHcWw9XxEUpVUS6Dh.E7oh3LXCrxL1DfZWMfPanj26
 BltRJIkvoglxa9qqCaE8_edmzL9R7L3172koMmusZw34.Xw3Rny6KRe_Xsjd
 Csdy1PXcdRKtcm3Jj96Y_Q3mdf92q8bvJq6OTw_7MSXxnNbK3qzsICkKbYyD
 7DoE0Tg69mPHoC2fT1STynDGMEgPv711i8zZbBFjaqv2okvs1ImXMPkYQiCB
 NEDgWG4uGy4bosh5mheu44mLwiKUTcAHTzPJOEaVVaug_PbOrM4ZMpHbD1__
 YJQNbBdiBDJ5XFP3Yw25KGGXm52mzmJFfqJ8iYaw0euA76cqGyJTJDfv_.dB
 p.PRDREgGr6fOnrzLoZTwN6t32C6moplRTXOkHQ8ZTKYQA8GYSS_N.MYbPnq
 VceZ2C9c0s1XYU32vr7iMC3Ga4KhwV_Onn0oAyMyrEyokWKnwyfUBMM3Klvk
 N0WajCwwXCJV6zdKLVsUrWNZPNIm7rHW0InLM7bnzqwoUutIki8fU4OLfVzQ
 a4i46f.5WzEu4
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <54C01B0D.6080701@schaufler-ca.com>
Date: Wed, 21 Jan 2015 13:33:01 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>
CC: James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] smack: fix possible use after frees in task_security()
 callers
References: <1421164360-15330-1-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1421164360-15330-1-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/13/2015 7:52 AM, Andrey Ryabinin wrote:
> We hit use after free on dereferncing pointer to task_smack struct in
> smk_of_task() called from smack_task_to_inode().
>
> task_security() macro uses task_cred_xxx() to get pointer to the task_smack.
> task_cred_xxx() could be used only for non-pointer members of task's
> credentials. It cannot be used for pointer members since what they point
> to may disapper after dropping RCU read lock.
>
> Mainly task_security() used this way:
> 	smk_of_task(task_security(p))
>
> Intead of this introduce function smk_of_task_struct() which
> takes task_struct as argument and returns pointer to smk_known struct
> and do this under RCU read lock.
> Bogus task_security() macro is not used anymore, so remove it.
>
> KASan's report for this:
>
> 	AddressSanitizer: use after free in smack_task_to_inode+0x50/0x70 at addr c4635600
> 	=============================================================================
> 	BUG kmalloc-64 (Tainted: PO): kasan error
> 	-----------------------------------------------------------------------------
>
> 	Disabling lock debugging due to kernel taint
> 	INFO: Allocated in new_task_smack+0x44/0xd8 age=39 cpu=0 pid=1866
> 		kmem_cache_alloc_trace+0x88/0x1bc
> 		new_task_smack+0x44/0xd8
> 		smack_cred_prepare+0x48/0x21c
> 		security_prepare_creds+0x44/0x4c
> 		prepare_creds+0xdc/0x110
> 		smack_setprocattr+0x104/0x150
> 		security_setprocattr+0x4c/0x54
> 		proc_pid_attr_write+0x12c/0x194
> 		vfs_write+0x1b0/0x370
> 		SyS_write+0x5c/0x94
> 		ret_fast_syscall+0x0/0x48
> 	INFO: Freed in smack_cred_free+0xc4/0xd0 age=27 cpu=0 pid=1564
> 		kfree+0x270/0x290
> 		smack_cred_free+0xc4/0xd0
> 		security_cred_free+0x34/0x3c
> 		put_cred_rcu+0x58/0xcc
> 		rcu_process_callbacks+0x738/0x998
> 		__do_softirq+0x264/0x4cc
> 		do_softirq+0x94/0xf4
> 		irq_exit+0xbc/0x120
> 		handle_IRQ+0x104/0x134
> 		gic_handle_irq+0x70/0xac
> 		__irq_svc+0x44/0x78
> 		_raw_spin_unlock+0x18/0x48
> 		sync_inodes_sb+0x17c/0x1d8
> 		sync_filesystem+0xac/0xfc
> 		vdfs_file_fsync+0x90/0xc0
> 		vfs_fsync_range+0x74/0x7c
> 	INFO: Slab 0xd3b23f50 objects=32 used=31 fp=0xc4635600 flags=0x4080
> 	INFO: Object 0xc4635600 @offset=5632 fp=0x  (null)
>
> 	Bytes b4 c46355f0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
> 	Object c4635600: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> 	Object c4635610: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> 	Object c4635620: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> 	Object c4635630: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
> 	Redzone c4635640: bb bb bb bb                                      ....
> 	Padding c46356e8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
> 	Padding c46356f8: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
> 	CPU: 5 PID: 834 Comm: launchpad_prelo Tainted: PBO 3.10.30 #1
> 	Backtrace:
> 	[<c00233a4>] (dump_backtrace+0x0/0x158) from [<c0023dec>] (show_stack+0x20/0x24)
> 	 r7:c4634010 r6:d3b23f50 r5:c4635600 r4:d1002140
> 	[<c0023dcc>] (show_stack+0x0/0x24) from [<c06d6d7c>] (dump_stack+0x20/0x28)
> 	[<c06d6d5c>] (dump_stack+0x0/0x28) from [<c01c1d50>] (print_trailer+0x124/0x144)
> 	[<c01c1c2c>] (print_trailer+0x0/0x144) from [<c01c1e88>] (object_err+0x3c/0x44)
> 	 r7:c4635600 r6:d1002140 r5:d3b23f50 r4:c4635600
> 	[<c01c1e4c>] (object_err+0x0/0x44) from [<c01cac18>] (kasan_report_error+0x2b8/0x538)
> 	 r6:d1002140 r5:d3b23f50 r4:c6429cf8 r3:c09e1aa7
> 	[<c01ca960>] (kasan_report_error+0x0/0x538) from [<c01c9430>] (__asan_load4+0xd4/0xf8)
> 	[<c01c935c>] (__asan_load4+0x0/0xf8) from [<c031e168>] (smack_task_to_inode+0x50/0x70)
> 	 r5:c4635600 r4:ca9da000
> 	[<c031e118>] (smack_task_to_inode+0x0/0x70) from [<c031af64>] (security_task_to_inode+0x3c/0x44)
> 	 r5:cca25e80 r4:c0ba9780
> 	[<c031af28>] (security_task_to_inode+0x0/0x44) from [<c023d614>] (pid_revalidate+0x124/0x178)
> 	 r6:00000000 r5:cca25e80 r4:cbabe3c0 r3:00008124
> 	[<c023d4f0>] (pid_revalidate+0x0/0x178) from [<c01db98c>] (lookup_fast+0x35c/0x43y4)
> 	 r9:c6429efc r8:00000101 r7:c079d940 r6:c6429e90 r5:c6429ed8 r4:c83c4148
> 	[<c01db630>] (lookup_fast+0x0/0x434) from [<c01deec8>] (do_last.isra.24+0x1c0/0x1108)
> 	[<c01ded08>] (do_last.isra.24+0x0/0x1108) from [<c01dff04>] (path_openat.isra.25+0xf4/0x648)
> 	[<c01dfe10>] (path_openat.isra.25+0x0/0x648) from [<c01e1458>] (do_filp_open+0x3c/0x88)
> 	[<c01e141c>] (do_filp_open+0x0/0x88) from [<c01ccb28>] (do_sys_open+0xf0/0x198)
> 	 r7:00000001 r6:c0ea2180 r5:0000000b r4:00000000
> 	[<c01cca38>] (do_sys_open+0x0/0x198) from [<c01ccc00>] (SyS_open+0x30/0x34)
> 	[<c01ccbd0>] (SyS_open+0x0/0x34) from [<c001db80>] (ret_fast_syscall+0x0/0x48)
> 	Read of size 4 by thread T834:
> 	Memory state around the buggy address:
> 	 c4635380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> 	 c4635400: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> 	 c4635480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> 	 c4635500: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
> 	 c4635580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> 	>c4635600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> 	           ^
> 	 c4635680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> 	 c4635700: 00 00 00 00 04 fc fc fc fc fc fc fc fc fc fc fc
> 	 c4635780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> 	 c4635800: 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc fc
> 	 c4635880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> 	==================================================================
>
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Applied to git://git.gitorious.org/smack-next/kernel.git#smack-for-3.20-rebased

> Cc: <stable@vger.kernel.org>
> ---
>  security/smack/smack.h     | 10 ++++++++++
>  security/smack/smack_lsm.c | 24 +++++++++++++-----------
>  2 files changed, 23 insertions(+), 11 deletions(-)
>
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index b828a37..b48359c 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -298,6 +298,16 @@ static inline struct smack_known *smk_of_task(const struct task_smack *tsp)
>  	return tsp->smk_task;
>  }
>  
> +static inline struct smack_known *smk_of_task_struct(const struct task_struct *t)
> +{
> +	struct smack_known *skp;
> +
> +	rcu_read_lock();
> +	skp = smk_of_task(__task_cred(t)->security);
> +	rcu_read_unlock();
> +	return skp;
> +}
> +
>  /*
>   * Present a pointer to the forked smack label entry in an task blob.
>   */
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index f1b17a4..a717877 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -43,8 +43,6 @@
>  #include <linux/binfmts.h>
>  #include "smack.h"
>  
> -#define task_security(task)	(task_cred_xxx((task), security))
> -
>  #define TRANS_TRUE	"TRUE"
>  #define TRANS_TRUE_SIZE	4
>  
> @@ -120,7 +118,7 @@ static int smk_bu_current(char *note, struct smack_known *oskp,
>  static int smk_bu_task(struct task_struct *otp, int mode, int rc)
>  {
>  	struct task_smack *tsp = current_security();
> -	struct task_smack *otsp = task_security(otp);
> +	struct smack_known *smk_task = smk_of_task_struct(otp);
>  	char acc[SMK_NUM_ACCESS_TYPE + 1];
>  
>  	if (rc <= 0)
> @@ -128,7 +126,7 @@ static int smk_bu_task(struct task_struct *otp, int mode, int rc)
>  
>  	smk_bu_mode(mode, acc);
>  	pr_info("Smack Bringup: (%s %s %s) %s to %s\n",
> -		tsp->smk_task->smk_known, otsp->smk_task->smk_known, acc,
> +		tsp->smk_task->smk_known, smk_task->smk_known, acc,
>  		current->comm, otp->comm);
>  	return 0;
>  }
> @@ -345,7 +343,8 @@ static int smk_ptrace_rule_check(struct task_struct *tracer,
>  		saip = &ad;
>  	}
>  
> -	tsp = task_security(tracer);
> +	rcu_read_lock();
> +	tsp = __task_cred(tracer)->security;
>  	tracer_known = smk_of_task(tsp);
>  
>  	if ((mode & PTRACE_MODE_ATTACH) &&
> @@ -365,11 +364,14 @@ static int smk_ptrace_rule_check(struct task_struct *tracer,
>  				  tracee_known->smk_known,
>  				  0, rc, saip);
>  
> +		rcu_read_unlock();
>  		return rc;
>  	}
>  
>  	/* In case of rule==SMACK_PTRACE_DEFAULT or mode==PTRACE_MODE_READ */
>  	rc = smk_tskacc(tsp, tracee_known, smk_ptrace_mode(mode), saip);
> +
> +	rcu_read_unlock();
>  	return rc;
>  }
>  
> @@ -396,7 +398,7 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
>  	if (rc != 0)
>  		return rc;
>  
> -	skp = smk_of_task(task_security(ctp));
> +	skp = smk_of_task_struct(ctp);
>  
>  	rc = smk_ptrace_rule_check(current, skp, mode, __func__);
>  	return rc;
> @@ -1826,7 +1828,7 @@ static int smk_curacc_on_task(struct task_struct *p, int access,
>  				const char *caller)
>  {
>  	struct smk_audit_info ad;
> -	struct smack_known *skp = smk_of_task(task_security(p));
> +	struct smack_known *skp = smk_of_task_struct(p);
>  	int rc;
>  
>  	smk_ad_init(&ad, caller, LSM_AUDIT_DATA_TASK);
> @@ -1879,7 +1881,7 @@ static int smack_task_getsid(struct task_struct *p)
>   */
>  static void smack_task_getsecid(struct task_struct *p, u32 *secid)
>  {
> -	struct smack_known *skp = smk_of_task(task_security(p));
> +	struct smack_known *skp = smk_of_task_struct(p);
>  
>  	*secid = skp->smk_secid;
>  }
> @@ -1986,7 +1988,7 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
>  {
>  	struct smk_audit_info ad;
>  	struct smack_known *skp;
> -	struct smack_known *tkp = smk_of_task(task_security(p));
> +	struct smack_known *tkp = smk_of_task_struct(p);
>  	int rc;
>  
>  	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
> @@ -2040,7 +2042,7 @@ static int smack_task_wait(struct task_struct *p)
>  static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
>  {
>  	struct inode_smack *isp = inode->i_security;
> -	struct smack_known *skp = smk_of_task(task_security(p));
> +	struct smack_known *skp = smk_of_task_struct(p);
>  
>  	isp->smk_inode = skp;
>  }
> @@ -3200,7 +3202,7 @@ unlockandout:
>   */
>  static int smack_getprocattr(struct task_struct *p, char *name, char **value)
>  {
> -	struct smack_known *skp = smk_of_task(task_security(p));
> +	struct smack_known *skp = smk_of_task_struct(p);
>  	char *cp;
>  	int slen;
>  

