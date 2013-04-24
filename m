Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab3DXTJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 15:09:55 -0400
Received: from nm5-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.155]:43555
	"EHLO nm5-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757057Ab3DXTJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 15:09:50 -0400
X-Yahoo-Newman-Id: 988431.98502.bm@smtp102.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iD9sesYVM1nU_bsQ06h7U8AsXsrpa6XUsTe0Zapbd.Zp3o3
 1vLlvytcJ7h88MIJ3AkVXAsIPvtMzvsdSrjdKLtRYhDxdNFigPu_ulf442aX
 kyq0lRkqbbuPwZtDulUQPhvzVd3YOnWDTk1CQa3Ng4CS15LPqtIxQQdtQtJP
 H8km2JiXTZ_TnnZmTiE7xOtqgBzxXj1sqe0_Qc953XaS_7Gg6KFO1AC4PLIX
 .OnW04dBV4Fgox18FhEZa5Xe5_Kno2jdIq9jPpJLddDOxVEkuDbiol_2yOh0
 VbDwfcOg0E.OmQVpmqW_SD7G2OdhDBROpZRpHl_OgPKIDsLD6Sf3oOqrUY2Q
 EYaF6LPN70Wk7wFjxJsVfS0ase47SYBdHKPdl0jrkyAaKvueQekF_MCZfW4V
 uD6qmrR3wvvt_5PR23UAL7LgDYqrOx7lHXPB8hp9e_0Atwaxe_pQHJUGKWR.
 e
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp102.biz.mail.ne1.yahoo.com with SMTP; 24 Apr 2013 12:09:48 -0700 PDT
Message-ID: <51782DFE.3060808@schaufler-ca.com>
Date: Wed, 24 Apr 2013 12:09:50 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v13 5/9] LSM: Networking component isolation
References: <5176ABB7.5080300@schaufler-ca.com> <5176B10F.9040607@schaufler-ca.com> <18474523.4Ny9IacvUQ@sifl>
In-Reply-To: <18474523.4Ny9IacvUQ@sifl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/2013 11:51 AM, Paul Moore wrote:
> On Tuesday, April 23, 2013 09:04:31 AM Casey Schaufler wrote:
>> Subject: [PATCH v13 5/9] LSM: Networking component isolation
>>
>> The NetLabel, XFRM and secmark networking mechanisms are
>> limited to providing security information managed by one
>> LSM. These changes interface the single LSM networking
>> components with the multiple LSM system. Each of the
>> networking components will identify the security ops
>> vector of the LSM that will use it. There are various
>> wrapper functions provided to make this obvious and
>> painless.
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> ...
>
>> diff --git a/include/net/netlabel.h b/include/net/netlabel.h
>> index 2c95d55..c0cf965 100644
>> --- a/include/net/netlabel.h
>> +++ b/include/net/netlabel.h
>> @@ -406,7 +406,8 @@ int netlbl_secattr_catmap_setrng(struct
>> netlbl_lsm_secattr_catmap *catmap, /*
>>   * LSM protocol operations (NetLabel LSM/kernel API)
>>   */
>> -int netlbl_enabled(void);
>> +int netlbl_register_lsm(struct security_operations *lsmops);
> Nit picky, but I'd prefer "netlbl_lsm_register()".

Not a problem. I will conform to your conventions.

>
>> +int netlbl_enabled(struct security_operations *lsmops);
>>  int netlbl_sock_setattr(struct sock *sk,
>>  			u16 family,
>>  			const struct netlbl_lsm_secattr *secattr);
> ...
>
>> diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
>> index 7c94aed..2881d48 100644
>> --- a/net/netlabel/netlabel_kapi.c
>> +++ b/net/netlabel/netlabel_kapi.c
>> @@ -607,23 +607,48 @@ int netlbl_secattr_catmap_setrng(struct
>> netlbl_lsm_secattr_catmap *catmap, * LSM Functions
>>   */
>>
>> +struct security_operations *netlbl_active_lsm;
>> +/**
>> + * netlbl_register_lsm - Reserve the NetLabel subsystem for an LSM
>> + *
>> + * Description:
>> + * To avoid potential conflicting views between LSMs over
>> + * what should go in the network label reserve the Netlabel
>> + * mechanism for use by one LSM. netlbl_enabled will return
>> + * false for all other LSMs.
>> + *
>> + */
> You need a description for the 'lsm' parameter in the comment header above.

Thank you. I missed that.

> Also, this is extremely nit picky but I'd like to see some vertical whitespace 
> between the netlbl_active_lsm declaration and the function header.

White space is easy.

>> +int netlbl_register_lsm(struct security_operations *lsm)
>> +{
>> +	if (lsm == NULL)
>> +		return -EINVAL;
>> +
>> +	if (netlbl_active_lsm == NULL)
>> +		netlbl_active_lsm = lsm;
>> +	else if (netlbl_active_lsm != lsm)
>> +		return -EBUSY;
>> +
>> +	printk(KERN_INFO "NetLabel: Registered LSM \"%s\".\n", lsm->name);
>> +	return 0;
>> +}
>> +
>>  /**
>>   * netlbl_enabled - Determine if the NetLabel subsystem is enabled
>>   *
>>   * Description:
>>   * The LSM can use this function to determine if it should use NetLabel
>> - * security attributes in it's enforcement mechanism.  Currently, NetLabel
>> - * considered to be enabled when it's configuration contains a valid
>> + * security attributes in it's enforcement mechanism.  NetLabel
>> + * considered to be enabled when the LSM making the call is registered
>> + * the netlabel configuration contains a valid setup for
>>   * at least one labeled protocol (i.e. NetLabel can understand incoming
>>   * labeled packets of at least one type); otherwise NetLabel is considered
>>   * be disabled.
>>   *
>>   */
> Same thing, you need a description for the 'lsm' parameter in the comment 
> header above.

I'll add that.

>> -int netlbl_enabled(void)
>> +int netlbl_enabled(struct security_operations *lsm)
>>  {
>> -	/* At some point we probably want to expose this mechanism to the user
>> -	 * as well so that admins can toggle NetLabel regardless of the
>> -	 * configuration */
> It really doesn't matter if you remove that comment or not, but I believe it 
> still applies so long as we do the LSM check first.

OK. I'll leave it alone.

>> +	if (netlbl_active_lsm != lsm)
>> +		return 0;
>>  	return (atomic_read(&netlabel_mgmt_protocount) > 0);
>>  }
> ...
>
>> diff --git a/net/netlabel/netlabel_user.h b/net/netlabel/netlabel_user.h
>> index a6f1705..9990b24 100644
>> --- a/net/netlabel/netlabel_user.h
>> +++ b/net/netlabel/netlabel_user.h
>> @@ -41,6 +41,65 @@
>>
>>  /* NetLabel NETLINK helper functions */
>>
>> +extern struct security_operations *netlbl_active_lsm;
>> +
>> +/**
>> + * netlbl_secid_to_secctx - call the registered secid_to_secctx LSM hook
>> + * @secid - The secid to convert
>> + * @secdata - Where to put the result
>> + * @seclen - Where to put the length of the result
>> + *
>> + * Returns: the result of calling the hook.
>> + */
>> +static inline int netlbl_secid_to_secctx(u32 secid, char **secdata, u32
>> *seclen) +{
>> +	if (netlbl_active_lsm == NULL)
>> +		return -EINVAL;
>> +	return netlbl_active_lsm->secid_to_secctx(secid, secdata, seclen);
>> +}
>> +
>> +/**
>> + * netlbl_release_secctx - call the registered release_secctx LSM hook
>> + * @secdata - The security context to release
>> + * @seclen - The size of the context to release
>> + *
>> + */
>> +static inline void netlbl_release_secctx(char *secdata, u32 seclen)
>> +{
>> +	if (netlbl_active_lsm != NULL)
>> +		netlbl_active_lsm->release_secctx(secdata, seclen);
>> +}
>> +
>> +/**
>> + * netlbl_secctx_to_secid - call the registered seccts_to_secid LSM hook
>> + * @secdata - The security context
>> + * @seclen - The size of the security context
>> + * @secid - Where to put the result
>> + *
>> + * Returns: the result of calling the hook
>> + */
>> +static inline int netlbl_secctx_to_secid(const char *secdata, u32 seclen,
>> +					 u32 *secid)
>> +{
>> +	if (netlbl_active_lsm == NULL) {
>> +		*secid = 0;
>> +		return -EINVAL;
>> +	}
>> +	return netlbl_active_lsm->secctx_to_secid(secdata, seclen, secid);
>> +}
>> +
>> +/**
>> + * netlbl_task_getsecid - call the registered task_getsecid LSM hook
>> + * @p - The task
>> + * @secid - Where to put the secid
>> + *
>> + */
>> +static inline void netlbl_task_getsecid(struct task_struct *p, u32 *secid)
>> +{
>> +	if (netlbl_active_lsm)
>> +		netlbl_active_lsm->task_getsecid(p, secid);
>> +}
> Any particular reason you put all these functions in 'netlabel_user.h'?  I ask 
> because this header is related to the NetLabel netlink interface, with some 
> minor audit stuff tossed in for good measure; it really has nothing to do with 
> the LSM secctx/secid stuff.  I'd probably prefer these functions end up in 
> their own header file for the sake of better organization, maybe 
> 'netlabel_secid.h'?

I can put it anywhere you like. I'd prefer netlabel_lsm.h to netlabel_secid.h,
but if you have a strong preference I'll defer to your conventions.

Thank you.

