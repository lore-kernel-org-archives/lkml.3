Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbaCDOU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:20:56 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:49486 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205AbaCDOUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:20:54 -0500
MIME-Version: 1.0
In-Reply-To: <1393898970.10148.26.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
	<fa83f8d28e068d4cd1625d231302f6cad376ddc2.1393599538.git.d.kasatkin@samsung.com>
	<1393898970.10148.26.camel@dhcp-9-2-203-236.watson.ibm.com>
Date: Tue, 4 Mar 2014 16:20:52 +0200
Message-ID: <CACE9dm8awr4fTAd5i3rjxehqtxwUiJq_VEyaYU4OvjKy4Oe0sA@mail.gmail.com>
Subject: Re: [PATCH 7/8] evm: introduce EVM hmac attribute list
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        casey.schaufler@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 4:09 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Fri, 2014-02-28 at 16:59 +0200, Dmitry Kasatkin wrote:
>> This patch replaces using of hmac version configuration parameter
>> with attribute list. It allows to build kernels which works with
>> previously labeled filesystems.
>>
>> Currently supported attribute is 'fsuuid' which is equivalent of
>> former version 2.
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>
> Please include the new boot command line option in
> Documentation/kernel-parameters.txt.
>

There is no kernel parameter, but configuration parameter..
Again for flexibility to add more parameters and be able to use new
kernel on existing labeled filesystems.

Kernel command line option can be added on the future.

- Dmitry

> Mimi
>
>> ---
>>  security/integrity/evm/Kconfig      | 19 ++++++++++---------
>>  security/integrity/evm/evm.h        |  4 +++-
>>  security/integrity/evm/evm_crypto.c |  2 +-
>>  security/integrity/evm/evm_main.c   | 21 ++++++++++++++++++++-
>>  4 files changed, 34 insertions(+), 12 deletions(-)
>>
>> diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
>> index d35b491..2be51fa 100644
>> --- a/security/integrity/evm/Kconfig
>> +++ b/security/integrity/evm/Kconfig
>> @@ -12,15 +12,16 @@ config EVM
>>
>>         If you are unsure how to answer this question, answer N.
>>
>> -config EVM_HMAC_VERSION
>> -     int "EVM HMAC version"
>> -     depends on EVM
>> -     default 2
>> -     help
>> -       This options adds EVM HMAC version support.
>> -       1 - original version
>> -       2 - add per filesystem unique identifier (UUID) (default)
>> +config EVM_HMAC_ATTRS
>> +     string "HMAC attributes"
>> +     default "fsuuid"
>> +     help
>> +       This options allows to specify list of optional attributes included into HMAC
>> +       calculation. It makes it possible easily upgrade to newer kernels.
>> +
>> +       Default value is 'fsuuid', which is former version 2.
>> +       if blank, it is equivalent of version 1
>>
>>         WARNING: changing the HMAC calculation method or adding
>>         additional info to the calculation, requires existing EVM
>> -       labeled file systems to be relabeled.
>> +       labeled file systems to be relabeled.
>> diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
>> index 37c88dd..c8fa0aa 100644
>> --- a/security/integrity/evm/evm.h
>> +++ b/security/integrity/evm/evm.h
>> @@ -24,11 +24,13 @@
>>  extern int evm_initialized;
>>  extern char *evm_hmac;
>>  extern char *evm_hash;
>> -extern int evm_hmac_version;
>> +extern int evm_hmac_attrs;
>>
>>  extern struct crypto_shash *hmac_tfm;
>>  extern struct crypto_shash *hash_tfm;
>>
>> +#define EVM_HMAC_ATTR_FSUUID         0x0001
>> +
>>  /* List of EVM protected security xattrs */
>>  extern char *evm_config_xattrnames[];
>>
>> diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
>> index babd862..ab034e5 100644
>> --- a/security/integrity/evm/evm_crypto.c
>> +++ b/security/integrity/evm/evm_crypto.c
>> @@ -112,7 +112,7 @@ static void hmac_add_misc(struct shash_desc *desc, struct inode *inode,
>>       hmac_misc.gid = from_kgid(&init_user_ns, inode->i_gid);
>>       hmac_misc.mode = inode->i_mode;
>>       crypto_shash_update(desc, (const u8 *)&hmac_misc, sizeof(hmac_misc));
>> -     if (evm_hmac_version > 1)
>> +     if (evm_hmac_attrs & EVM_HMAC_ATTR_FSUUID)
>>               crypto_shash_update(desc, inode->i_sb->s_uuid,
>>                                   sizeof(inode->i_sb->s_uuid));
>>       crypto_shash_final(desc, digest);
>> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
>> index 996092f..9c05929 100644
>> --- a/security/integrity/evm/evm_main.c
>> +++ b/security/integrity/evm/evm_main.c
>> @@ -32,7 +32,7 @@ static char *integrity_status_msg[] = {
>>  };
>>  char *evm_hmac = "hmac(sha1)";
>>  char *evm_hash = "sha1";
>> -int evm_hmac_version = CONFIG_EVM_HMAC_VERSION;
>> +int evm_hmac_attrs;
>>
>>  char *evm_config_xattrnames[] = {
>>  #ifdef CONFIG_SECURITY_SELINUX
>> @@ -57,6 +57,19 @@ static int __init evm_set_fixmode(char *str)
>>  }
>>  __setup("evm=", evm_set_fixmode);
>>
>> +static int __init evm_init_config(void)
>> +{
>> +     char *attrs = CONFIG_EVM_HMAC_ATTRS;
>> +     char *p;
>> +
>> +     while ((p = strsep(&attrs, ", \t"))) {
>> +             if (!strcmp(p, "fsuuid"))
>> +                     evm_hmac_attrs |= EVM_HMAC_ATTR_FSUUID;
>> +     }
>> +     pr_info("HMAC attrs: 0x%x\n", evm_hmac_attrs);
>> +     return 0;
>> +}
>> +
>>  static int evm_find_protected_xattrs(struct dentry *dentry)
>>  {
>>       struct inode *inode = dentry->d_inode;
>> @@ -432,6 +445,12 @@ static int __init init_evm(void)
>>  {
>>       int error;
>>
>> +     error = evm_init_config();
>> +     if (error < 0) {
>> +             pr_info("Error parsing config lists\n");
>> +             goto err;
>> +     }
>> +
>>       error = evm_init_secfs();
>>       if (error < 0) {
>>               pr_info("Error registering secfs\n");
>
>



-- 
Thanks,
Dmitry
