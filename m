Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaDKVus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:50:48 -0400
Received: from smtp103.biz.mail.ne1.yahoo.com ([98.138.207.10]:26492 "HELO
	smtp103.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754159AbaDKVur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:50:47 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KKy_2_MVM1n4yE8K.TlqIXrh7NKheBORK0YcP3G6FD.9yNP
 ebO3fPa1Ym2D8Yq0_Ma5XF3qhA47x.tSwxsFASzW57oZ3oMGruoL3x8i56ch
 omNp1Wa4pVtH6oCCn69eHRp8Gk_8c.I_nPZSoQHelilahK_xCYS13YoLx3oG
 lIVaDcfvRN3vVg691UCL8f3AiaD_hImhS57kEnx.VkaIB.GR426_iu4q79sT
 YnidWPpkmA0M_4jO9pAaD.0.BmCh_gimbgsRgqNuP8HzQ94yE28qoOmhNlIb
 RMhTomfzu4uozdGb4p8K7WPSz_zs7nc_PQQRpy5hroQRT4xAOy3Owa2JNcHo
 Wggjjb37kILI0XdcWawojUBAdXFBj7lRG0c0u576RsKcG6JPysz3KhtKp9Og
 1fp.E8HQeS6nv165Yl8A5eS6rfoBDwPayiPNIyXEZTagFcho1SpfylasdeZN
 L8FDb5zd62mR0kZPr1ddZQcILDLi8HOBO5oenDdVG4oIWEyvR3tbomy6oqrr
 tIJbX0QLcpG7Vp5SPfrTgvsdjAJwZ2f0dgoUQdU4ZmpEW0aq.SnJvHIHEQzZ
 pmDjwwHXBSG9Xet9Kusmt_H9_qV8cE16RLs_G.Wcs2yRUocfJU_fkeW6RRdq
 AG9rh
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.105] (casey@67.180.103.242 with plain [98.138.105.25])
        by smtp103.biz.mail.ne1.yahoo.com with SMTP; 11 Apr 2014 14:50:46 -0700 PDT
Message-ID: <534863CF.5040303@schaufler-ca.com>
Date: Fri, 11 Apr 2014 14:51:11 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Lukasz Pawelczyk <l.pawelczyk@partner.samsung.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
CC: r.krypa@samsung.com, t.swierczek@samsung.com
Subject: Re: [PATCH 2/3] Smack: unify all ptrace accesses in the smack
References: <1394554026-23924-1-git-send-email-l.pawelczyk@partner.samsung.com> <1394554026-23924-3-git-send-email-l.pawelczyk@partner.samsung.com>
In-Reply-To: <1394554026-23924-3-git-send-email-l.pawelczyk@partner.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/2014 9:07 AM, Lukasz Pawelczyk wrote:
> The decision whether we can trace a process is made in the following
> functions:
> 	smack_ptrace_traceme()
> 	smack_ptrace_access_check()
> 	smack_bprm_set_creds() (in case the proces is traced)
>
> This patch unifies all those decisions by introducing one function that
> checks whether ptrace is allowed: smk_ptrace_rule_check().
>
> This makes possible to actually trace with TRACEME where first the
> TRACEME itself must be allowed and then exec() on a traced process.
>
> Additional bugs fixed:
> - The decision is made according to the mode parameter that is now correctly
>   translated from PTRACE_MODE_* to MAY_* instead of being treated 1:1.
>   PTRACE_MODE_READ requires MAY_READ.
>   PTRACE_MODE_ATTACH requires MAY_READWRITE.
> - Add a smack audit log in case of exec() refused by bprm_set_creds().
> - Honor the PTRACE_MODE_NOAUDIT flag and don't put smack audit info
>   in case this flag is set.
>
> Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@partner.samsung.com>
> Signed-off-by: Rafal Krypa <r.krypa@samsung.com>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Applied to git://git.gitorious.org/smack-next/kernel.git smack-for-3.16

> ---
>  security/smack/smack_lsm.c | 84 +++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 71 insertions(+), 13 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 48d61f6..3da13fd 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -157,6 +157,54 @@ static int smk_copy_rules(struct list_head *nhead, struct list_head *ohead,
>  	return rc;
>  }
>  
> +/**
> + * smk_ptrace_mode - helper function for converting PTRACE_MODE_* into MAY_*
> + * @mode - input mode in form of PTRACE_MODE_*
> + *
> + * Returns a converted MAY_* mode usable by smack rules
> + */
> +static inline unsigned int smk_ptrace_mode(unsigned int mode)
> +{
> +	switch (mode) {
> +	case PTRACE_MODE_READ:
> +		return MAY_READ;
> +	case PTRACE_MODE_ATTACH:
> +		return MAY_READWRITE;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * smk_ptrace_rule_check - helper for ptrace access
> + * @tracer: tracer process
> + * @tracee_label: label of the process that's about to be traced
> + * @mode: ptrace attachment mode (PTRACE_MODE_*)
> + * @func: name of the function that called us, used for audit
> + *
> + * Returns 0 on access granted, -error on error
> + */
> +static int smk_ptrace_rule_check(struct task_struct *tracer, char *tracee_label,
> +				 unsigned int mode, const char *func)
> +{
> +	int rc;
> +	struct smk_audit_info ad, *saip = NULL;
> +	struct task_smack *tsp;
> +	struct smack_known *skp;
> +
> +	if ((mode & PTRACE_MODE_NOAUDIT) == 0) {
> +		smk_ad_init(&ad, func, LSM_AUDIT_DATA_TASK);
> +		smk_ad_setfield_u_tsk(&ad, tracer);
> +		saip = &ad;
> +	}
> +
> +	tsp = task_security(tracer);
> +	skp = smk_of_task(tsp);
> +
> +	rc = smk_tskacc(tsp, tracee_label, smk_ptrace_mode(mode), saip);
> +	return rc;
> +}
> +
>  /*
>   * LSM hooks.
>   * We he, that is fun!
> @@ -165,16 +213,15 @@ static int smk_copy_rules(struct list_head *nhead, struct list_head *ohead,
>  /**
>   * smack_ptrace_access_check - Smack approval on PTRACE_ATTACH
>   * @ctp: child task pointer
> - * @mode: ptrace attachment mode
> + * @mode: ptrace attachment mode (PTRACE_MODE_*)
>   *
>   * Returns 0 if access is OK, an error code otherwise
>   *
> - * Do the capability checks, and require read and write.
> + * Do the capability checks.
>   */
>  static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
>  {
>  	int rc;
> -	struct smk_audit_info ad;
>  	struct smack_known *skp;
>  
>  	rc = cap_ptrace_access_check(ctp, mode);
> @@ -182,10 +229,8 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
>  		return rc;
>  
>  	skp = smk_of_task(task_security(ctp));
> -	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
> -	smk_ad_setfield_u_tsk(&ad, ctp);
>  
> -	rc = smk_curacc(skp->smk_known, mode, &ad);
> +	rc = smk_ptrace_rule_check(current, skp->smk_known, mode, __func__);
>  	return rc;
>  }
>  
> @@ -195,12 +240,11 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
>   *
>   * Returns 0 if access is OK, an error code otherwise
>   *
> - * Do the capability checks, and require read and write.
> + * Do the capability checks, and require PTRACE_MODE_ATTACH.
>   */
>  static int smack_ptrace_traceme(struct task_struct *ptp)
>  {
>  	int rc;
> -	struct smk_audit_info ad;
>  	struct smack_known *skp;
>  
>  	rc = cap_ptrace_traceme(ptp);
> @@ -208,10 +252,9 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
>  		return rc;
>  
>  	skp = smk_of_task(current_security());
> -	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
> -	smk_ad_setfield_u_tsk(&ad, ptp);
>  
> -	rc = smk_tskacc(ptp, skp->smk_known, MAY_READWRITE, &ad);
> +	rc = smk_ptrace_rule_check(ptp, skp->smk_known,
> +				   PTRACE_MODE_ATTACH, __func__);
>  	return rc;
>  }
>  
> @@ -453,7 +496,7 @@ static int smack_sb_statfs(struct dentry *dentry)
>   * smack_bprm_set_creds - set creds for exec
>   * @bprm: the exec information
>   *
> - * Returns 0 if it gets a blob, -ENOMEM otherwise
> + * Returns 0 if it gets a blob, -EPERM if exec forbidden and -ENOMEM otherwise
>   */
>  static int smack_bprm_set_creds(struct linux_binprm *bprm)
>  {
> @@ -473,7 +516,22 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
>  	if (isp->smk_task == NULL || isp->smk_task == bsp->smk_task)
>  		return 0;
>  
> -	if (bprm->unsafe)
> +	if (bprm->unsafe & (LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)) {
> +		struct task_struct *tracer;
> +		rc = 0;
> +
> +		rcu_read_lock();
> +		tracer = ptrace_parent(current);
> +		if (likely(tracer != NULL))
> +			rc = smk_ptrace_rule_check(tracer,
> +						   isp->smk_task->smk_known,
> +						   PTRACE_MODE_ATTACH,
> +						   __func__);
> +		rcu_read_unlock();
> +
> +		if (rc != 0)
> +			return rc;
> +	} else if (bprm->unsafe)
>  		return -EPERM;
>  
>  	bsp->smk_task = isp->smk_task;

