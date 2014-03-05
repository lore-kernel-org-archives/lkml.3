Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaCEJ0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:26:43 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:43121 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbaCEJ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:26:35 -0500
MIME-Version: 1.0
In-Reply-To: <1393965405.10148.112.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
	<20312cf18c698d0e918bde022a76edf2705f1e17.1393599538.git.d.kasatkin@samsung.com>
	<1393900797.10148.41.camel@dhcp-9-2-203-236.watson.ibm.com>
	<531541DB.7000406@schaufler-ca.com>
	<1393903276.10148.51.camel@dhcp-9-2-203-236.watson.ibm.com>
	<CACE9dm8qTb1vWS-1KFrYpOkX1RoQPe0oKyyGtTw7c+4PJCJKLA@mail.gmail.com>
	<1393965405.10148.112.camel@dhcp-9-2-203-236.watson.ibm.com>
Date: Wed, 5 Mar 2014 11:26:33 +0200
Message-ID: <CACE9dm8F2uPqeSuMwCjRBtdCJ-kfrw_v581P3W+kVQJR5Ninqg@mail.gmail.com>
Subject: Re: [PATCH 8/8] evm: introduce EVM hmac xattr list
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 10:36 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Tue, 2014-03-04 at 16:18 +0200, Dmitry Kasatkin wrote:
>> On Tue, Mar 4, 2014 at 5:21 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> > On Mon, 2014-03-03 at 19:00 -0800, Casey Schaufler wrote:
>> >> On 3/3/2014 6:39 PM, Mimi Zohar wrote:
>> >> > On Fri, 2014-02-28 at 16:59 +0200, Dmitry Kasatkin wrote:
>> >> >> EVM currently uses source hard coded list of xattrs which needs to be
>> >> >> included into the HMAC calculation. This is very unflexible.
>> >> >> Adding new attributes requires modifcation of the source code and
>> >> >> prevents building the kernel which works with previously labeled
>> >> >> filesystems.
>> >> >>
>> >> >> Early versions of Smack used only one xattr security.SMACK64,
>> >> >> which is protected by EVM. Now Smack has a few more attributes and
>> >> >> they are not protected. Adding support to the source code makes it
>> >> >> impossible to use new kernel with previousely labeled filesystems.
>> >> > I think this patch will break any existing filesystems labeled with
>> >> > 'security.smack64'.  Details inline.
>> >> >
>> >> >> This patch replaces hardcoded xattr array with dynamic list which is
>> >> >> initialized from CONFIG_EVM_HMAC_XATTRS variable. It allows to build
>> >> >> kernel with with support of older and newer EVM HMAC formats.
>
> So instead of having a single kernel, this allows you to build different
> kernels with different xattr labels included in the HMAC.  Wouldn't you
> want a migration mode, similar to 'fix' mode, that only updates the
> HMAC, if the existing HMAC verified based on the prior set of xattrs?
>

It would require to maintain 2 sets of xattrs: "old" and "new".
What if "new" becomes "old" again, while there were still not updated
previous "old" :)

I think it would bring unnecessary complexity.
System designers define what xattrs they want to protect and stick with that.
Filesystems stays anyway, but allows to upgrade to new kernels.

If someone really wants to upgrade the system, just use "evm=fix" and run
recursive fix.., e.g. 'evmctl -r ima_fix /'

- Dmitry

>> >> >>
>> >> >> Possible future extension will be to read xattr list from the kernel
>> >> >> command line or from securityfs entry.
>> >> >>
>> >> >> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> >> >> ---
>> >> >>  security/integrity/evm/Kconfig      | 10 ++++++
>> >> >>  security/integrity/evm/evm.h        |  7 +++-
>> >> >>  security/integrity/evm/evm_crypto.c |  8 ++---
>> >> >>  security/integrity/evm/evm_main.c   | 69 +++++++++++++++++++------------------
>> >> >>  4 files changed, 55 insertions(+), 39 deletions(-)
>> >> >>
>> >> >> diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
>> >> >> index 2be51fa..06237b8 100644
>> >> >> --- a/security/integrity/evm/Kconfig
>> >> >> +++ b/security/integrity/evm/Kconfig
>> >> >> @@ -25,3 +25,13 @@ config EVM_HMAC_ATTRS
>> >> >>      WARNING: changing the HMAC calculation method or adding
>> >> >>      additional info to the calculation, requires existing EVM
>> >> >>      labeled file systems to be relabeled.
>> >> >> +
>> >> >> +config EVM_HMAC_XATTRS
>> >> >> +  string "HMAC xattrs"
>> >> >> +  default "security.selinux security.SMACK64 security.ima security.capability"
>> >> >> +  help
>> >> >> +    This options allows to specify list of extended attributes included into HMAC
>> >> >> +    calculation. It makes it possible easily upgrade to newer kernels.
>> >> >> +
>> >> >> +    Default value:
>> >> >> +      security.selinux, security.SMACK64, security.ima, security.capability
>> >> >> diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
>> >> >> index c8fa0aa..4d1c51e 100644
>> >> >> --- a/security/integrity/evm/evm.h
>> >> >> +++ b/security/integrity/evm/evm.h
>> >> >> @@ -31,8 +31,13 @@ extern struct crypto_shash *hash_tfm;
>> >> >>
>> >> >>  #define EVM_HMAC_ATTR_FSUUID              0x0001
>> >> >>
>> >> >> +struct evm_hmac_xattr {
>> >> >> +  struct list_head list;
>> >> >> +  char *xattr;
>> >> >> +};
>> >> >> +
>> >> >>  /* List of EVM protected security xattrs */
>> >> >> -extern char *evm_config_xattrnames[];
>> >> >> +extern struct list_head evm_hmac_xattrs;
>> >> >>
>> >> >>  int evm_init_key(void);
>> >> >>  int evm_update_evmxattr(struct dentry *dentry,
>> >> >> diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
>> >> >> index ab034e5..7e5bfb7 100644
>> >> >> --- a/security/integrity/evm/evm_crypto.c
>> >> >> +++ b/security/integrity/evm/evm_crypto.c
>> >> >> @@ -133,7 +133,7 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
>> >> >>  {
>> >> >>    struct inode *inode = dentry->d_inode;
>> >> >>    struct shash_desc *desc;
>> >> >> -  char **xattrname;
>> >> >> +  struct evm_hmac_xattr *entry;
>> >> >>    size_t xattr_size = 0;
>> >> >>    char *xattr_value = NULL;
>> >> >>    int error;
>> >> >> @@ -146,15 +146,15 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
>> >> >>            return PTR_ERR(desc);
>> >> >>
>> >> >>    error = -ENODATA;
>> >> >> -  for (xattrname = evm_config_xattrnames; *xattrname != NULL; xattrname++) {
>> >> >> +  list_for_each_entry(entry, &evm_hmac_xattrs, list) {
>> >> >>            if ((req_xattr_name && req_xattr_value)
>> >> >> -              && !strcmp(*xattrname, req_xattr_name)) {
>> >> >> +              && !strcmp(entry->xattr, req_xattr_name)) {
>> >> >>                    error = 0;
>> >> >>                    crypto_shash_update(desc, (const u8 *)req_xattr_value,
>> >> >>                                         req_xattr_value_len);
>> >> >>                    continue;
>> >> >>            }
>> >> >> -          size = vfs_getxattr_alloc(dentry, *xattrname,
>> >> >> +          size = vfs_getxattr_alloc(dentry, entry->xattr,
>> >> >>                                      &xattr_value, xattr_size, GFP_NOFS);
>> >> >>            if (size == -ENOMEM) {
>> >> >>                    error = -ENOMEM;
>> >> >> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
>> >> >> index 9c05929..13e03ad 100644
>> >> >> --- a/security/integrity/evm/evm_main.c
>> >> >> +++ b/security/integrity/evm/evm_main.c
>> >> >> @@ -34,19 +34,7 @@ char *evm_hmac = "hmac(sha1)";
>> >> >>  char *evm_hash = "sha1";
>> >> >>  int evm_hmac_attrs;
>> >> >>
>> >> >> -char *evm_config_xattrnames[] = {
>> >> >> -#ifdef CONFIG_SECURITY_SELINUX
>> >> >> -  XATTR_NAME_SELINUX,
>> >> >> -#endif
>> >> >> -#ifdef CONFIG_SECURITY_SMACK
>> >> >> -  XATTR_NAME_SMACK,
>> >> >> -#endif
>> >> >> -#ifdef CONFIG_IMA_APPRAISE
>> >> >> -  XATTR_NAME_IMA,
>> >> >> -#endif
>> >> >> -  XATTR_NAME_CAPS,
>> >> >> -  NULL
>> >> >> -};
>> >> >> +LIST_HEAD(evm_hmac_xattrs);
>> >> >>
>> >> >>  static int evm_fixmode;
>> >> >>  static int __init evm_set_fixmode(char *str)
>> >> >> @@ -61,27 +49,53 @@ static int __init evm_init_config(void)
>> >> >>  {
>> >> >>    char *attrs = CONFIG_EVM_HMAC_ATTRS;
>> >> >>    char *p;
>> >> >> +  char *xattrs = CONFIG_EVM_HMAC_XATTRS;
>> >> >> +  struct evm_hmac_xattr *entry;
>> >> >>
>> >> >>    while ((p = strsep(&attrs, ", \t"))) {
>> >> >>            if (!strcmp(p, "fsuuid"))
>> >> >>                    evm_hmac_attrs |= EVM_HMAC_ATTR_FSUUID;
>> >> >>    }
>> >> >>    pr_info("HMAC attrs: 0x%x\n", evm_hmac_attrs);
>> >> >> +  while ((p = strsep(&xattrs, ", \t"))) {
>> >> >> +#ifndef CONFIG_SECURITY_SELINUX
>> >> >> +          if (!strcmp(p, XATTR_NAME_SELINUX))
>> >> >> +                  continue;
>> >> >> +#endif
>> >> >> +#ifndef CONFIG_SECURITY_SMACK
>> >> >> +          if (strstr(p, "SMACK64"))
>> >> >> +                  continue;
>> >> >> +#endif
>> >> > As you mentioned, filesystems previously only included
>> >> > 'security.smack64' in the HMAC calculation.  This patch includes all
>> >> > xattrs prefixed with smack64.  All previously labeled filesystems would
>> >> > need to be relabeled.
>> >> >
>> >> > Mimi
>> >>
>> >> Only the SMACK64 attribute is assigned to all files. The SMACK64EXEC
>> >> and SMACK64TRANSMUTE attributes are optional. You do not want these
>> >> attributes in most cases. Few files should actually have them. They
>> >> should only be used if they are there, and ignored otherwise. If that
>> >> is not possible it is better to ignore them completely.
>> >
>> > Going forward the code would work just fine.  All smack64 prefixed
>> > labels would be included in the HMAC calculation.  My concern is for
>> > existing labeled filesystems, which only included the SMACK64 label in
>> > the HMAC calculation, but have other SMACK64 labels.  The HMAC
>> > verification would fail for these files.
>> >
>>
>> Hello,
>>
>> There is no problem for existing labeled filesystems.
>>
>> Patch does not work with SMACK64 prefix, but with exact name.
>>
>> Only xattrs listed in the configuration options are included
>> By default "security.selinux, security.SMACK64, security.ima,
>> security.capability"
>> which correspond to EVM current functionality...
>>
>> Existing systems using new kernel may stick to original EVM xattr set.
>>
>> But new systems might prefer to add "more" xattrs..
>>
>> This patch makes it flexible...
>
> Ok, the list of xattrs included in the HMAC calculation is build time
> configurable and runtime verified.
>

yes.

> thanks,
>
> Mimi
>
>



-- 
Thanks,
Dmitry
