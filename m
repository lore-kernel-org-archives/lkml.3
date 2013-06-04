Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab3FDBAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 21:00:12 -0400
Received: from smtp103.biz.mail.ne1.yahoo.com ([98.138.207.10]:48229 "HELO
	smtp103.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757267Ab3FDBAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 21:00:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: CyrEddMVM1muhr1FCQJqcyb_mD3OVIcYGG1FczQgCFoQT1M
 l36_F6FPjtW6NybCwM0e6a5iTcY5.DpFt1ZVOPW.574eF4DVJGlY.sy__7xr
 xcy3N_2.KyAfLB2Gw_BRTHYRFjGa2BKDKSypmEp00l0VhIGqcoGUP_5PA8wk
 CM.lE6qJhbIqk3i9TOFD1u0niVK2CTcG_7CJ2zitXXh53AUEFeVw.BBRj.o8
 AvT3161TRh8QIQRNA2yXuLB31d0lR4_vwZHa4jY3ZUIbm31dhCiuble9Cc6e
 bxHy9q4O0XSCFbUNwQplr9EEXheB0KF.mHTOklnRrrOln1G26vfVX50UnQw7
 Y.FWS9JTrvTwic7en8ujvM_auO07zQqAZtTGwbwXR3nfm7RRM8Za8ErEGD.z
 8BNS_uzv7vHS8gn3iY0kzA.3LSoAauD6H77sLjpqmoXARv6Yvmy9T2RadTtY
 Sy4J8wKPkI6SuBGqYhvVqsOWPadfby1DgZn1X_jU_PsZUo4c-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp103.biz.mail.ne1.yahoo.com with SMTP; 03 Jun 2013 18:00:08 -0700 PDT
Message-ID: <51AD3C15.6020102@schaufler-ca.com>
Date: Mon, 03 Jun 2013 18:00:05 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Eric Paris <eparis@redhat.com>, torvalds@linux-foundation.org,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC PATCH 2/2] SELinux: cache inode checks inside struct inode
References: <1370285941-18367-1-git-send-email-eparis@redhat.com> <1370285941-18367-2-git-send-email-eparis@redhat.com> <51ACFBF7.3030204@schaufler-ca.com>
In-Reply-To: <51ACFBF7.3030204@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/2013 1:26 PM, Casey Schaufler wrote:
> On 6/3/2013 11:59 AM, Eric Paris wrote:
>> This patch adds a cache of selinux security checks into struct inode.
> This violates the security blob architecture of the LSM.
>
> Security module specific optimizations in the VFS layer are
> probably going to be pointless if (when) we go to stackable
> security modules. I have based all of the work I've been
> doing on stacking modules on the blob pointer architecture.
> Building special case code into the stacking infrastructure
> to accommodate this optimization, which will apply only if
> SELinux is being used and no other inode blob using LSM is
> in use, will be possible, but heinous.

After further review it turns out that this patch set won't
affect the stacking after all, because the work is still getting
done in the SELinux code. So put me down as having philosophical
objections, but not substantive ones.

>
> We (the LSM community) agreed to the blob pointer architecture
> for a number of reasons, one of which was that it keeps all of
> the details of the implementation hidden from the VFS. Pulling
> SELinux specific code into the VFS violates that dramatically.
>
> I understand that Linus has chimed in on this issue and has
> spoken well of the potential performance improvement. I suggest
> that if we have a module independent "cache" we (for values of
> "we" that include modules other than SELinux) will be better off.
> *I understand that today only SELinux and Smack use i_security.*
> I do not expect that to continue into the future.
>
>
>> It is protected by the seq counter against updates by other nodes.  This
>> has a measurable impact on one benchmark Linus mentioned.  The cpu
>> time using make to check a huge project for changes.  It is going to
>> have a negative impact on cases where tasks with different labels are
>> accessing the same object.  In these cases each one will grab the i_lock
>> to reset the in inode cache.  The only place I imagine this would be
>> common would be with shared libraries.  But as those are typically
>> openned and mmapped, they don't have continuous checks...
>>
>> Stock Kernel:
>> 8.23%      make  [k] __d_lookup_rcu
>> 6.27%      make  [k] link_path_walk
>> 3.91%      make  [k] selinux_inode_permission <----
>> 3.37%      make  [k] avc_has_perm_noaudit <----
>> 2.26%      make  [k] lookup_fast
>> 2.12%      make  [k] system_call
>> 1.86%      make  [k] path_lookupat
>> 1.82%      make  [k] inode_has_perm.isra.32.constprop.61 <----
>> 1.57%      make  [k] copy_user_enhanced_fast_string
>> 1.48%      make  [k] generic_permission
>> 1.34%      make  [k] __audit_syscall_exit
>> 1.31%      make  [k] kmem_cache_free
>> 1.24%      make  [k] kmem_cache_alloc
>> 1.20%      make  [k] generic_fillattr
>> 1.12%      make  [k] __inode_permission
>> 1.06%      make  [k] dput
>> 1.04%      make  [k] strncpy_from_user
>> 1.04%      make  [k] _raw_spin_lock
>> Total: 3.91 + 3.37 + 1.82 = 9.1%
>>
>> My Changes:
>> 8.54%      make  [k] __d_lookup_rcu
>> 6.52%      make  [k] link_path_walk
>> 3.93%      make  [k] inode_has_perm <----
>> 2.31%      make  [k] lookup_fast
>> 2.05%      make  [k] system_call
>> 1.79%      make  [k] path_lookupat
>> 1.72%      make  [k] generic_permission
>> 1.50%      make  [k] __audit_syscall_exit
>> 1.49%      make  [k] selinux_inode_permission <----
>> 1.47%      make  [k] copy_user_enhanced_fast_string
>> 1.28%      make  [k] __inode_permission
>> 1.23%      make  [k] kmem_cache_alloc
>> 1.19%      make  [k] _raw_spin_lock
>> 1.15%      make  [k] lg_local_lock
>> 1.10%      make  [k] strncpy_from_user
>> 1.10%      make  [k] dput
>> 1.08%      make  [k] kmem_cache_free
>> 1.08%      make  [k] generic_fillattr
>> Total: 3.93 + 1.49 = 5.42
>>
>> In inode_has_perm the big time takers are loading cred->sid and the
>> raw_seqcount_begin(inode->i_security_seccount).  I'm not certain how to
>> make either of those much faster.
>>
>> In selinux_inode_permission() we spend time in getting current->cred and
>> in calling inode_has_perm().
>>
>> Signed-off-by: Eric Paris <eparis@redhat.com>
>> ---
>>  include/linux/fs.h                  |  5 +++
>>  security/selinux/hooks.c            | 62 ++++++++++++++++++++++++++++++++++---
>>  security/selinux/include/security.h |  1 +
>>  security/selinux/ss/services.c      |  5 +++
>>  4 files changed, 69 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 43db02e..5268cf3 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -535,6 +535,11 @@ struct inode {
>>  	struct address_space	*i_mapping;
>>  
>>  #ifdef CONFIG_SECURITY
> Shouldn't these be under #ifdef SELINUX?
> They're pointless without SELinux.
>
>> +	seqcount_t		i_security_seqcount;
>> +	u32			i_last_task_sid;
>> +	u32			i_last_granting;
>> +	u32			i_last_perms;
>> +	u32			i_audit_allow;
>>  	void			*i_security;
>>  #endif
>>  
>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> index cfecb52..00dd6d9 100644
>> --- a/security/selinux/hooks.c
>> +++ b/security/selinux/hooks.c
>> @@ -82,6 +82,7 @@
>>  #include <linux/user_namespace.h>
>>  #include <linux/export.h>
>>  #include <linux/msg.h>
>> +#include <linux/seqlock.h>
>>  #include <linux/shm.h>
>>  
>>  #include "avc.h"
>> @@ -207,6 +208,7 @@ static int inode_alloc_security(struct inode *inode)
>>  	if (!isec)
>>  		return -ENOMEM;
>>  
>> +	seqcount_init(&inode->i_security_seqcount);
>>  	mutex_init(&isec->lock);
>>  	INIT_LIST_HEAD(&isec->list);
>>  	isec->inode = inode;
>> @@ -1516,6 +1518,44 @@ static noinline int audit_inode_permission(struct inode *inode,
>>  	return 0;
>>  }
>>  
>> +static bool inode_has_perm_cached(u32 sid, struct inode *inode, u32 perms)
>> +{
>> +	unsigned seq;
>> +	u32 last_task_sid;
>> +	u32 last_perms;
>> +	u32 last_granting;
>> +
>> +	seq = raw_seqcount_begin(&inode->i_security_seqcount);
>> +	last_task_sid = inode->i_last_task_sid;
>> +	last_perms = inode->i_last_perms;
>> +	last_granting = inode->i_last_granting;
>> +
>> +	/* something changed, bail! */
>> +	if (read_seqcount_retry(&inode->i_security_seqcount, seq))
>> +		return false;
>> +
>> +	return sid == last_task_sid && (perms & last_perms) == perms &&
>> +	       security_get_latest_granting() == last_granting;
>> +}
>> +
>> +static void inode_set_perm_cache(struct inode *inode, u32 task_sid, u32 perms,
>> +				 u32 granting, u32 audit_allow)
>> +{
>> +	spin_lock(&inode->i_lock);
>> +	write_seqcount_begin(&inode->i_security_seqcount);
>> +	if (inode->i_last_task_sid == task_sid &&
>> +	    inode->i_last_granting == granting) {
>> +		inode->i_last_perms |= perms;
>> +	} else {
>> +		inode->i_last_task_sid = task_sid;
>> +		inode->i_last_perms = perms;
>> +		inode->i_last_granting = granting;
>> +		inode->i_audit_allow = audit_allow;
>> +	}
>> +	write_seqcount_end(&inode->i_security_seqcount);
>> +	spin_unlock(&inode->i_lock);
>> +}
>> +
>>  /* Check whether a task has a particular permission to an inode.
>>     The 'adp' parameter is optional and allows other audit
>>     data to be passed (e.g. the dentry). */
>> @@ -1525,7 +1565,6 @@ static int inode_has_perm(const struct cred *cred,
>>  			  struct common_audit_data *adp,
>>  			  unsigned flags)
>>  {
>> -	struct inode_security_struct *isec;
>>  	struct av_decision avd;
>>  	u32 sid, denied, audited;
>>  	int rc, rc2;
>> @@ -1536,9 +1575,23 @@ static int inode_has_perm(const struct cred *cred,
>>  		return 0;
>>  
>>  	sid = cred_sid(cred);
>> -	isec = inode->i_security;
>>  
>> -	rc = avc_has_perm_noaudit(sid, isec->sid, isec->sclass, perms, 0, &avd);
>> +	if (inode_has_perm_cached(sid, inode, perms)) {
>> +		rc = 0;
>> +	        avd.allowed = -1;
>> +        	avd.auditallow = inode->i_audit_allow;
>> +        	avd.auditdeny = -1;
>> +        	avd.seqno = 0;
>> +        	avd.flags = 0;
>> +	} else {
>> +		struct inode_security_struct *isec;
>> +
>> +		isec = inode->i_security;
>> +
>> +		rc = avc_has_perm_noaudit(sid, isec->sid, isec->sclass, perms, 0, &avd);
>> +		if (!rc)
>> +			inode_set_perm_cache(inode, sid, perms, avd.seqno, avd.auditallow);
>> +	}
>>  	audited = avc_audit_required(perms, &avd, rc, dontaudit, &denied);
>>  	if (likely(!audited))
>>  		return rc;
>> @@ -1546,7 +1599,7 @@ static int inode_has_perm(const struct cred *cred,
>>  	rc2 = audit_inode_permission(inode, adp, perms, audited, denied, flags);
>>  	if (rc2)
>>  		return rc2;
>> -	return avc_has_perm_flags(sid, isec->sid, isec->sclass, perms, adp, flags);
>> +	return rc;
>>  }
>>  
>>  /* Same as inode_has_perm, but pass explicit audit data containing
>> @@ -2841,6 +2894,7 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
>>  		return;
>>  	}
>>  
>> +	inode_set_perm_cache(inode, 0, 0, 0, 0);
>>  	isec->sid = newsid;
>>  	return;
>>  }
>> diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
>> index 6d38851..ec7d984 100644
>> --- a/security/selinux/include/security.h
>> +++ b/security/selinux/include/security.h
>> @@ -85,6 +85,7 @@ extern int selinux_policycap_openperm;
>>  /* limitation of boundary depth  */
>>  #define POLICYDB_BOUNDS_MAXDEPTH	4
>>  
>> +u32 security_get_latest_granting(void);
>>  int security_mls_enabled(void);
>>  
>>  int security_load_policy(void *data, size_t len);
>> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
>> index b4feecc3..c6687ab 100644
>> --- a/security/selinux/ss/services.c
>> +++ b/security/selinux/ss/services.c
>> @@ -87,6 +87,11 @@ int ss_initialized;
>>   */
>>  static u32 latest_granting;
>>  
>> +u32 security_get_latest_granting(void)
>> +{
>> +	return latest_granting;
>> +}
>> +
>>  /* Forward declaration. */
>>  static int context_struct_to_string(struct context *context, char **scontext,
>>  				    u32 *scontext_len);
>
> --
> This message was distributed to subscribers of the selinux mailing list.
> If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
> the words "unsubscribe selinux" without quotes as the message.
>

