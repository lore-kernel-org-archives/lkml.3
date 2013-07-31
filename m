Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab3GaQWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:22:31 -0400
Received: from smtp104.biz.mail.bf1.yahoo.com ([98.139.221.63]:22928 "HELO
	smtp104.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751357Ab3GaQW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:22:26 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4VdEEfkVM1lJ037qFqxMOsBKfTATk8wRJrnZswCZyBD9EWr
 KMmf9FHM3jc5r5pNT44qPJvEhjfNkju83axkL_njbsPl9U8_45Icv2tlRaYu
 XQHRtyHu6DwYOriICJQu7zipJ9uoqYu7cIgJGNpysVkdUSdSJpSfQ8_JRqIO
 SYsgWMnuZPRP6nhfa6rLM6apQfKjvl0dJPxjmv9M5HiVqgfoIf0Kop16xRuG
 BxDGpSIaf_X3df8itRzsJfIJiBvIfgH5yUjvlBocS_E1sc32epoOs3fiQ8mJ
 7WAPSz0y6_UjVWOmCF33o77eiA9jFwzqRYWRu7pQold9ufM7YJXLR3U.TEel
 ghq495ZFzwOHhR0y0FGPxdjzmWKxuMpWrz5g1RBCnNeJH_hQOyx66wU4mdF1
 4FzCufgwjpgSvUMsOi8ZQOoIxai92.bvOSrxMeY3gMc9vc3d1VbUbtQ3XiJZ
 Xomd4RTRkkJAZ5SuZ1lx9L2lplndC4M8dFcnw3MfjB86Vay_97MCON096wZv
 6ebc8av.5pDjw
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp104.biz.mail.bf1.yahoo.com with SMTP; 31 Jul 2013 09:22:25 -0700 PDT
Message-ID: <51F939BF.3010404@schaufler-ca.com>
Date: Wed, 31 Jul 2013 09:22:23 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v14 3/6] LSM: Explicit individual LSM associations
References: <51F16CFB.6040603@schaufler-ca.com> <51F16F2B.5020606@schaufler-ca.com> <5154459.vWAL79RUx2@sifl>
In-Reply-To: <5154459.vWAL79RUx2@sifl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/2013 3:08 PM, Paul Moore wrote:
> On Thursday, July 25, 2013 11:32:11 AM Casey Schaufler wrote:
>> Subject: [PATCH v14 3/6] LSM: Explicit individual LSM associations
>>
>> Expand the /proc/.../attr interface set to help include
>> LSM specific entries as well as the traditional shared
>> "current", "prev" and "exec" entries. Each LSM that uses
>> one of the traditional interfaces gets it's own interface
>> prefixed with the LSM name for the ones it cares about.
>> Thus, we have "smack.current", "selinux.current" and
>> "apparmor.current" in addition to "current".
>>
>> Add two new interfaces under /sys/kernel/security.
>> The lsm interface displays the comma seperated list of
>> active LSMs. The present interface displays the name
>> of the LSM providing the traditional /proc/.../attr
>> interfaces. User space code should no longer have to
>> grub around in odd places to determine what LSM is
>> being used and thus what data is available to it.
>>
>> Introduce feature specific security operation vectors
>> for NetLabel, XFRM, secmark and presentation in the
>> traditional /proc/.../attr interfaces. This allows
>> proper handling of secids.
> Maybe I missed something, can you elaborate on this, perhaps even provide an 
> example for us simple minded folk?

There are a set of facilities that (currently, at least)
can't be shared by multiple LSMs for one reason or another.
XFRM and secmark have pretty well been declared as hopeless
for expansion due to the sk_buff "32 bits is all you're ever
going to get now shut up and go away" stance taken by certain
networking maintainers. NetLabel might possibly be made to
support multiple CIPSO tag types and while I don't think that
it makes sense to put much effort into doing so, if there is
a coin flip choice it should go in the direction of allowing
it. The presentation facility is there to address the "current"
interface in /proc, where backward compatibility is necessary.

Audit, on the other hand, uses secids but is capable of dealing
with multiple LSMs, provided it can identify which LSM goes
with which secid.

The most general case (audit) needs to keep a secid for each LSM.
This is easy enough to do. The networking facilities (XFRM,
secmark and NetLabel) always want to deal with exactly one,
although as I mentioned previously, NetLabel could conceivably
be multiple LSM aware someday. When audit and XFRM interact
there needs to be a way to identify which of the secids audit
is going to use is the one XFRM cares about.

There are two ways to do this. One is to identify the
security_operations structure associated with the LSM or to
identify the slot in the secids structure that holds that LSM's
secid. The security_operations structure contains the
information about the slot in the secids structure. The most
general way to identify the information about these special
cases is to identify the security_operations that go with them.


I hope that is helpful. I fear that I may not be getting
the core concept across. The idea is to make it easier to
deal with the special interfaces in the general cases.


>> Add NetLabel interfaces that allow an LSM to request
>> ownership of the NetLabel subsystem and to determine
>> whether or not it has that ownership. These interfaces
>> are intended to allow a future in which NetLabel can
>> support multiple LSMs at the same time, although they
>> do not do so now.
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> ...
>
>> --- a/include/net/netlabel.h
>> +++ b/include/net/netlabel.h
>> @@ -407,7 +407,9 @@ int netlbl_secattr_catmap_setrng(struct
>> netlbl_lsm_secattr_catmap *catmap, /*
>>   * LSM protocol operations (NetLabel LSM/kernel API)
>>   */
>> -int netlbl_enabled(void);
>> +int netlbl_enabled(struct security_operations *lsm);
>> +int netlbl_lsm_owner(struct security_operations *lsm);
>> +int netlbl_lsm_register(struct security_operations *lsm);
>>  int netlbl_sock_setattr(struct sock *sk,
>>  			u16 family,
>>  			const struct netlbl_lsm_secattr *secattr);
>> @@ -521,7 +523,11 @@ static inline int netlbl_secattr_catmap_setrng(
>>  {
>>  	return 0;
>>  }
>> -static inline int netlbl_enabled(void)
>> +static inline int netlbl_lsm_register(struct security_operations *lsm)
>> +{
>> +	return 0;
>> +}
>> +static inline int netlbl_enabled(struct security_operations *lsm)
>>  {
>>  	return 0;
>>  }
> Is it worth including a static inline for netlabel_lsm_owner() for the sake of 
> completeness?  I haven't looked closely enough yet to know if it is strictly 
> necessary or not.

I don't think it ever comes up, which would imply we don't need
netlbl_enabled(), either.

>> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
>> index 00a2b2b..5ca352b 100644
>> --- a/net/ipv4/cipso_ipv4.c
>> +++ b/net/ipv4/cipso_ipv4.c
>> @@ -1594,7 +1594,7 @@ static int cipso_v4_parsetag_loc(const struct
>> cipso_v4_doi *doi_def, u32 secid;
>>
>>  	secid = *(u32 *)&tag[2];
>> -	lsm_init_secid(&secattr->attr.secid, secid, 0);
>> +	lsm_init_secid(&secattr->attr.secid, secid, lsm_netlbl_order());
>>  	secattr->flags |= NETLBL_SECATTR_SECID;
> I still need to wrap my head around all the changes, but I *think* this change 
> may not be necessary since NetLabel isn't multi-LSM aware at the moment.  If 
> this change is necessary, then there are likely other changes that need to be 
> made as well, the NetLabel LSM cache would be my main concern.

Using the NetLabel secid slot is necessary because when we get into
the auditing code the secid needs to be in the right place to associate
it with the right LSM.

>> diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
>> index 7c94aed..bd5fee6 100644
>> --- a/net/netlabel/netlabel_kapi.c
>> +++ b/net/netlabel/netlabel_kapi.c
>> @@ -608,6 +608,47 @@ int netlbl_secattr_catmap_setrng(struct
>> netlbl_lsm_secattr_catmap *catmap, */
>>
>>  /**
>> + * netlbl_lsm_register - Reserve the NetLabel subsystem for an LSM
>> + * @lsm: the security module making the request
>> + *
>> + * Description:
>> + * To avoid potential conflicting views between LSMs over
>> + * what should go in the network label reserve the Netlabel
>> + * mechanism for use by one LSM. netlbl_enabled will return
>> + * false for all other LSMs.
>> + *
>> + */
>> +int netlbl_lsm_register(struct security_operations *lsm)
>> +{
>> +	if (lsm == NULL)
>> +		return -EINVAL;
>> +
>> +	if (lsm_netlbl_ops() == NULL)
>> +		netlbl_ops = lsm;
>> +	else if (lsm_netlbl_ops() != lsm)
>> +		return -EBUSY;
>> +
>> +	printk(KERN_INFO "NetLabel: Registered LSM \"%s\".\n", lsm->name);
>> +	return 0;
>> +}
>> +
>> +/**
>> + * netlbl_lsm_owner - Report if the NetLabel subsystem is registered for an
>> LSM + * @lsm: the security module making the request
>> + *
>> + * Description:
>> + * Report whether the LSM passed is the LSM registered for NetLabel
>> + *
>> + * Returns 1 if this is the registered NetLabel LSM, 0 otherwise
>> + */
>> +int netlbl_lsm_owner(struct security_operations *lsm)
>> +{
>> +	if (lsm_netlbl_ops() == lsm)
>> +		return 1;
>> +	return 0;
>> +}
>> +
>> +/**
>>   * netlbl_enabled - Determine if the NetLabel subsystem is enabled
>>   *
>>   * Description:
>> @@ -619,8 +660,12 @@ int netlbl_secattr_catmap_setrng(struct
>> netlbl_lsm_secattr_catmap *catmap, * be disabled.
>>   *
>>   */
>> -int netlbl_enabled(void)
>> +int netlbl_enabled(struct security_operations *lsm)
>>  {
>> +	if (lsm_netlbl_ops() == NULL)
>> +		return 0;
>> +	if (lsm_netlbl_ops() != lsm)
>> +		return 0;
> How about some simplification in the above?
>
> 	struct security_operations *sops = lsm_netlbl_ops();
>
> 	if (sops == NULL || sops != lsm)
> 		return 0;

Sure.

>>  	/* At some point we probably want to expose this mechanism to the user
>>  	 * as well so that admins can toggle NetLabel regardless of the
>>  	 * configuration */
> ...
>
>> diff --git a/net/netlabel/netlabel_unlabeled.c
>> b/net/netlabel/netlabel_unlabeled.c index 3e9064a..be4e083 100644
>> --- a/net/netlabel/netlabel_unlabeled.c
>> +++ b/net/netlabel/netlabel_unlabeled.c
>> @@ -263,7 +263,7 @@ static int netlbl_unlhsh_add_addr4(struct
>> netlbl_unlhsh_iface *iface, entry->list.addr = addr->s_addr & mask->s_addr;
>>  	entry->list.mask = mask->s_addr;
>>  	entry->list.valid = 1;
>> -	lsm_init_secid(&entry->secid, secid, 0);
>> +	lsm_init_secid(&entry->secid, secid, lsm_netlbl_order());
> See my above comments in the CIPSO code.
>
>>  	spin_lock(&netlbl_unlhsh_lock);
>>  	ret_val = netlbl_af4list_add(&entry->list, &iface->addr4_list);
>> @@ -307,7 +307,7 @@ static int netlbl_unlhsh_add_addr6(struct
>> netlbl_unlhsh_iface *iface, entry->list.addr.s6_addr32[3] &=
>> mask->s6_addr32[3];
>>  	entry->list.mask = *mask;
>>  	entry->list.valid = 1;
>> -	lsm_init_secid(&entry->secid, secid, 0);
>> +	lsm_init_secid(&entry->secid, secid, lsm_netlbl_order());
> Same.  You get the idea ...
>

