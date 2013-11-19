Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab3KSWjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:39:11 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:48824 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3KSWi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:38:57 -0500
From: Paul Moore <paul@paul-moore.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH linux-next] SELinux: security_load_policy: Silence frame-larger-than warning
Date: Tue, 19 Nov 2013 17:38:51 -0500
Message-ID: <2344755.pvM4VQSB59@sifl>
User-Agent: KMail/4.11.2 (Linux/3.12.0-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1384466691-42392-1-git-send-email-tim.gardner@canonical.com>
References: <1384466691-42392-1-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 14, 2013 03:04:51 PM Tim Gardner wrote:
> Dynamically allocate a couple of the larger stack variables in order to
> reduce the stack footprint below 1024. gcc-4.8
> 
> security/selinux/ss/services.c: In function 'security_load_policy':
> security/selinux/ss/services.c:1964:1: warning: the frame size of 1104 bytes
> is larger than 1024 bytes [-Wframe-larger-than=] }
> 
> Also silence a couple of checkpatch warnings at the same time.
> 
> WARNING: sizeof policydb should be sizeof(policydb)
> +	memcpy(oldpolicydb, &policydb, sizeof policydb);
> 
> WARNING: sizeof policydb should be sizeof(policydb)
> +	memcpy(&policydb, newpolicydb, sizeof policydb);
> 
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: James Morris <james.l.morris@oracle.com>
> Cc: Eric Paris <eparis@parisplace.org>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  security/selinux/ss/services.c |   54 ++++++++++++++++++++++--------------
>  1 file changed, 32 insertions(+), 22 deletions(-)

Applied, thanks.  It will be pushed to my next tree once -rc1 is released.

In the future, please send SELinux patches to the SELinux mailing list.

> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> index b4feecc..c8317c8 100644
> --- a/security/selinux/ss/services.c
> +++ b/security/selinux/ss/services.c
> @@ -1828,7 +1828,7 @@ static int security_preserve_bools(struct policydb
> *p); */
>  int security_load_policy(void *data, size_t len)
>  {
> -	struct policydb oldpolicydb, newpolicydb;
> +	struct policydb *oldpolicydb, *newpolicydb;
>  	struct sidtab oldsidtab, newsidtab;
>  	struct selinux_mapping *oldmap, *map = NULL;
>  	struct convert_context_args args;
> @@ -1837,12 +1837,19 @@ int security_load_policy(void *data, size_t len)
>  	int rc = 0;
>  	struct policy_file file = { data, len }, *fp = &file;
> 
> +	oldpolicydb = kzalloc(2 * sizeof(*oldpolicydb), GFP_KERNEL);
> +	if (!oldpolicydb) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +	newpolicydb = oldpolicydb + 1;
> +
>  	if (!ss_initialized) {
>  		avtab_cache_init();
>  		rc = policydb_read(&policydb, fp);
>  		if (rc) {
>  			avtab_cache_destroy();
> -			return rc;
> +			goto out;
>  		}
> 
>  		policydb.len = len;
> @@ -1852,14 +1859,14 @@ int security_load_policy(void *data, size_t len)
>  		if (rc) {
>  			policydb_destroy(&policydb);
>  			avtab_cache_destroy();
> -			return rc;
> +			goto out;
>  		}
> 
>  		rc = policydb_load_isids(&policydb, &sidtab);
>  		if (rc) {
>  			policydb_destroy(&policydb);
>  			avtab_cache_destroy();
> -			return rc;
> +			goto out;
>  		}
> 
>  		security_load_policycaps();
> @@ -1871,36 +1878,36 @@ int security_load_policy(void *data, size_t len)
>  		selinux_status_update_policyload(seqno);
>  		selinux_netlbl_cache_invalidate();
>  		selinux_xfrm_notify_policyload();
> -		return 0;
> +		goto out;
>  	}
> 
>  #if 0
>  	sidtab_hash_eval(&sidtab, "sids");
>  #endif
> 
> -	rc = policydb_read(&newpolicydb, fp);
> +	rc = policydb_read(newpolicydb, fp);
>  	if (rc)
> -		return rc;
> +		goto out;
> 
> -	newpolicydb.len = len;
> +	newpolicydb->len = len;
>  	/* If switching between different policy types, log MLS status */
> -	if (policydb.mls_enabled && !newpolicydb.mls_enabled)
> +	if (policydb.mls_enabled && !newpolicydb->mls_enabled)
>  		printk(KERN_INFO "SELinux: Disabling MLS support...\n");
> -	else if (!policydb.mls_enabled && newpolicydb.mls_enabled)
> +	else if (!policydb.mls_enabled && newpolicydb->mls_enabled)
>  		printk(KERN_INFO "SELinux: Enabling MLS support...\n");
> 
> -	rc = policydb_load_isids(&newpolicydb, &newsidtab);
> +	rc = policydb_load_isids(newpolicydb, &newsidtab);
>  	if (rc) {
>  		printk(KERN_ERR "SELinux:  unable to load the initial SIDs\n");
> -		policydb_destroy(&newpolicydb);
> -		return rc;
> +		policydb_destroy(newpolicydb);
> +		goto out;
>  	}
> 
> -	rc = selinux_set_mapping(&newpolicydb, secclass_map, &map, &map_size);
> +	rc = selinux_set_mapping(newpolicydb, secclass_map, &map, &map_size);
>  	if (rc)
>  		goto err;
> 
> -	rc = security_preserve_bools(&newpolicydb);
> +	rc = security_preserve_bools(newpolicydb);
>  	if (rc) {
>  		printk(KERN_ERR "SELinux:  unable to preserve booleans\n");
>  		goto err;
> @@ -1918,7 +1925,7 @@ int security_load_policy(void *data, size_t len)
>  	 * in the new SID table.
>  	 */
>  	args.oldp = &policydb;
> -	args.newp = &newpolicydb;
> +	args.newp = newpolicydb;
>  	rc = sidtab_map(&newsidtab, convert_context, &args);
>  	if (rc) {
>  		printk(KERN_ERR "SELinux:  unable to convert the internal"
> @@ -1928,12 +1935,12 @@ int security_load_policy(void *data, size_t len)
>  	}
> 
>  	/* Save the old policydb and SID table to free later. */
> -	memcpy(&oldpolicydb, &policydb, sizeof policydb);
> +	memcpy(oldpolicydb, &policydb, sizeof(policydb));
>  	sidtab_set(&oldsidtab, &sidtab);
> 
>  	/* Install the new policydb and SID table. */
>  	write_lock_irq(&policy_rwlock);
> -	memcpy(&policydb, &newpolicydb, sizeof policydb);
> +	memcpy(&policydb, newpolicydb, sizeof(policydb));
>  	sidtab_set(&sidtab, &newsidtab);
>  	security_load_policycaps();
>  	oldmap = current_mapping;
> @@ -1943,7 +1950,7 @@ int security_load_policy(void *data, size_t len)
>  	write_unlock_irq(&policy_rwlock);
> 
>  	/* Free the old policydb and SID table. */
> -	policydb_destroy(&oldpolicydb);
> +	policydb_destroy(oldpolicydb);
>  	sidtab_destroy(&oldsidtab);
>  	kfree(oldmap);
> 
> @@ -1953,14 +1960,17 @@ int security_load_policy(void *data, size_t len)
>  	selinux_netlbl_cache_invalidate();
>  	selinux_xfrm_notify_policyload();
> 
> -	return 0;
> +	rc = 0;
> +	goto out;
> 
>  err:
>  	kfree(map);
>  	sidtab_destroy(&newsidtab);
> -	policydb_destroy(&newpolicydb);
> -	return rc;
> +	policydb_destroy(newpolicydb);
> 
> +out:
> +	kfree(oldpolicydb);
> +	return rc;
>  }
> 
>  size_t security_policydb_len(void)

-- 
paul moore
www.paul-moore.com

