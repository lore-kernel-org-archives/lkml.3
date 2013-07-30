Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab3G3WJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 18:09:05 -0400
Received: from mail-ye0-f181.google.com ([209.85.213.181]:65361 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab3G3WJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 18:09:01 -0400
From: Paul Moore <paul@paul-moore.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v14 3/6] LSM: Explicit individual LSM associations
Date: Tue, 30 Jul 2013 18:08:56 -0400
Message-ID: <5154459.vWAL79RUx2@sifl>
User-Agent: KMail/4.10.5 (Linux/3.10.2-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <51F16F2B.5020606@schaufler-ca.com>
References: <51F16CFB.6040603@schaufler-ca.com> <51F16F2B.5020606@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 25, 2013 11:32:11 AM Casey Schaufler wrote:
> Subject: [PATCH v14 3/6] LSM: Explicit individual LSM associations
> 
> Expand the /proc/.../attr interface set to help include
> LSM specific entries as well as the traditional shared
> "current", "prev" and "exec" entries. Each LSM that uses
> one of the traditional interfaces gets it's own interface
> prefixed with the LSM name for the ones it cares about.
> Thus, we have "smack.current", "selinux.current" and
> "apparmor.current" in addition to "current".
> 
> Add two new interfaces under /sys/kernel/security.
> The lsm interface displays the comma seperated list of
> active LSMs. The present interface displays the name
> of the LSM providing the traditional /proc/.../attr
> interfaces. User space code should no longer have to
> grub around in odd places to determine what LSM is
> being used and thus what data is available to it.
> 
> Introduce feature specific security operation vectors
> for NetLabel, XFRM, secmark and presentation in the
> traditional /proc/.../attr interfaces. This allows
> proper handling of secids.

Maybe I missed something, can you elaborate on this, perhaps even provide an 
example for us simple minded folk?

> Add NetLabel interfaces that allow an LSM to request
> ownership of the NetLabel subsystem and to determine
> whether or not it has that ownership. These interfaces
> are intended to allow a future in which NetLabel can
> support multiple LSMs at the same time, although they
> do not do so now.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

...

> --- a/include/net/netlabel.h
> +++ b/include/net/netlabel.h
> @@ -407,7 +407,9 @@ int netlbl_secattr_catmap_setrng(struct
> netlbl_lsm_secattr_catmap *catmap, /*
>   * LSM protocol operations (NetLabel LSM/kernel API)
>   */
> -int netlbl_enabled(void);
> +int netlbl_enabled(struct security_operations *lsm);
> +int netlbl_lsm_owner(struct security_operations *lsm);
> +int netlbl_lsm_register(struct security_operations *lsm);
>  int netlbl_sock_setattr(struct sock *sk,
>  			u16 family,
>  			const struct netlbl_lsm_secattr *secattr);
> @@ -521,7 +523,11 @@ static inline int netlbl_secattr_catmap_setrng(
>  {
>  	return 0;
>  }
> -static inline int netlbl_enabled(void)
> +static inline int netlbl_lsm_register(struct security_operations *lsm)
> +{
> +	return 0;
> +}
> +static inline int netlbl_enabled(struct security_operations *lsm)
>  {
>  	return 0;
>  }

Is it worth including a static inline for netlabel_lsm_owner() for the sake of 
completeness?  I haven't looked closely enough yet to know if it is strictly 
necessary or not.

> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> index 00a2b2b..5ca352b 100644
> --- a/net/ipv4/cipso_ipv4.c
> +++ b/net/ipv4/cipso_ipv4.c
> @@ -1594,7 +1594,7 @@ static int cipso_v4_parsetag_loc(const struct
> cipso_v4_doi *doi_def, u32 secid;
> 
>  	secid = *(u32 *)&tag[2];
> -	lsm_init_secid(&secattr->attr.secid, secid, 0);
> +	lsm_init_secid(&secattr->attr.secid, secid, lsm_netlbl_order());
>  	secattr->flags |= NETLBL_SECATTR_SECID;

I still need to wrap my head around all the changes, but I *think* this change 
may not be necessary since NetLabel isn't multi-LSM aware at the moment.  If 
this change is necessary, then there are likely other changes that need to be 
made as well, the NetLabel LSM cache would be my main concern.

> diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
> index 7c94aed..bd5fee6 100644
> --- a/net/netlabel/netlabel_kapi.c
> +++ b/net/netlabel/netlabel_kapi.c
> @@ -608,6 +608,47 @@ int netlbl_secattr_catmap_setrng(struct
> netlbl_lsm_secattr_catmap *catmap, */
> 
>  /**
> + * netlbl_lsm_register - Reserve the NetLabel subsystem for an LSM
> + * @lsm: the security module making the request
> + *
> + * Description:
> + * To avoid potential conflicting views between LSMs over
> + * what should go in the network label reserve the Netlabel
> + * mechanism for use by one LSM. netlbl_enabled will return
> + * false for all other LSMs.
> + *
> + */
> +int netlbl_lsm_register(struct security_operations *lsm)
> +{
> +	if (lsm == NULL)
> +		return -EINVAL;
> +
> +	if (lsm_netlbl_ops() == NULL)
> +		netlbl_ops = lsm;
> +	else if (lsm_netlbl_ops() != lsm)
> +		return -EBUSY;
> +
> +	printk(KERN_INFO "NetLabel: Registered LSM \"%s\".\n", lsm->name);
> +	return 0;
> +}
> +
> +/**
> + * netlbl_lsm_owner - Report if the NetLabel subsystem is registered for an
> LSM + * @lsm: the security module making the request
> + *
> + * Description:
> + * Report whether the LSM passed is the LSM registered for NetLabel
> + *
> + * Returns 1 if this is the registered NetLabel LSM, 0 otherwise
> + */
> +int netlbl_lsm_owner(struct security_operations *lsm)
> +{
> +	if (lsm_netlbl_ops() == lsm)
> +		return 1;
> +	return 0;
> +}
> +
> +/**
>   * netlbl_enabled - Determine if the NetLabel subsystem is enabled
>   *
>   * Description:
> @@ -619,8 +660,12 @@ int netlbl_secattr_catmap_setrng(struct
> netlbl_lsm_secattr_catmap *catmap, * be disabled.
>   *
>   */
> -int netlbl_enabled(void)
> +int netlbl_enabled(struct security_operations *lsm)
>  {
> +	if (lsm_netlbl_ops() == NULL)
> +		return 0;
> +	if (lsm_netlbl_ops() != lsm)
> +		return 0;

How about some simplification in the above?

	struct security_operations *sops = lsm_netlbl_ops();

	if (sops == NULL || sops != lsm)
		return 0;

>  	/* At some point we probably want to expose this mechanism to the user
>  	 * as well so that admins can toggle NetLabel regardless of the
>  	 * configuration */

...

> diff --git a/net/netlabel/netlabel_unlabeled.c
> b/net/netlabel/netlabel_unlabeled.c index 3e9064a..be4e083 100644
> --- a/net/netlabel/netlabel_unlabeled.c
> +++ b/net/netlabel/netlabel_unlabeled.c
> @@ -263,7 +263,7 @@ static int netlbl_unlhsh_add_addr4(struct
> netlbl_unlhsh_iface *iface, entry->list.addr = addr->s_addr & mask->s_addr;
>  	entry->list.mask = mask->s_addr;
>  	entry->list.valid = 1;
> -	lsm_init_secid(&entry->secid, secid, 0);
> +	lsm_init_secid(&entry->secid, secid, lsm_netlbl_order());

See my above comments in the CIPSO code.

>  	spin_lock(&netlbl_unlhsh_lock);
>  	ret_val = netlbl_af4list_add(&entry->list, &iface->addr4_list);
> @@ -307,7 +307,7 @@ static int netlbl_unlhsh_add_addr6(struct
> netlbl_unlhsh_iface *iface, entry->list.addr.s6_addr32[3] &=
> mask->s6_addr32[3];
>  	entry->list.mask = *mask;
>  	entry->list.valid = 1;
> -	lsm_init_secid(&entry->secid, secid, 0);
> +	lsm_init_secid(&entry->secid, secid, lsm_netlbl_order());

Same.  You get the idea ...

-- 
paul moore
www.paul-moore.com

