Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbaE1T03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:26:29 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49053 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbaE1T01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:26:27 -0400
Message-ID: <1401305182.13546.152.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC PATCH v4 3/4] ima: define '.ima' as a builtin 'trusted'
 keyring
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 28 May 2014 15:26:22 -0400
In-Reply-To: <CACE9dm8K8Qs_p3fcsW2m9h-M+iX7m=F=hbTeUeyi4vp_Pq7k0g@mail.gmail.com>
References: <1401289784-31340-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1401289784-31340-4-git-send-email-zohar@linux.vnet.ibm.com>
	 <CACE9dm8K8Qs_p3fcsW2m9h-M+iX7m=F=hbTeUeyi4vp_Pq7k0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052819-1542-0000-0000-000002283386
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 21:55 +0300, Dmitry Kasatkin wrote: 
> On 28 May 2014 18:09, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > Require all keys added to the IMA keyring be signed by an
> > existing trusted key on the system trusted keyring.
> >
> > Changelog v1:
> > - don't link IMA trusted keyring to user keyring
> >
> > Changelog:
> > - define stub integrity_init_keyring() function (reported-by Fengguang Wu)
> > - differentiate between regular and trusted keyring names.
> > - replace printk with pr_info (D. Kasatkin)
> > - only make the IMA keyring a trusted keyring (reported-by D. Kastatkin)
> > - define stub integrity_init_keyring() definition based on
> >   CONFIG_INTEGRITY_SIGNATURE, not CONFIG_INTEGRITY_ASYMMETRIC_KEYS.
> >   (reported-by Jim Davis)
> >
> > Signed-off-by: Mimi Zohar<zohar@linux.vnet.ibm.com>
> > ---
> >  security/integrity/digsig.c           | 26 +++++++++++++++++++++++++-
> >  security/integrity/ima/Kconfig        |  8 ++++++++
> >  security/integrity/ima/ima_appraise.c | 11 +++++++++++
> >  security/integrity/integrity.h        |  5 +++++
> >  4 files changed, 49 insertions(+), 1 deletion(-)
> >
> > diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
> > index b4af4eb..7da5f9c 100644
> > --- a/security/integrity/digsig.c
> > +++ b/security/integrity/digsig.c
> > @@ -13,7 +13,9 @@
> >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >
> >  #include <linux/err.h>
> > +#include <linux/sched.h>
> >  #include <linux/rbtree.h>
> > +#include <linux/cred.h>
> >  #include <linux/key-type.h>
> >  #include <linux/digsig.h>
> >
> > @@ -24,7 +26,11 @@ static struct key *keyring[INTEGRITY_KEYRING_MAX];
> >  static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
> >         "_evm",
> >         "_module",
> > +#ifndef CONFIG_IMA_TRUSTED_KEYRING
> >         "_ima",
> > +#else
> > +       ".ima",
> > +#endif
> >  };
> >
> >  int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
> > @@ -35,7 +41,7 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
> >
> >         if (!keyring[id]) {
> >                 keyring[id] =
> > -                       request_key(&key_type_keyring, keyring_name[id], NULL);
> > +                   request_key(&key_type_keyring, keyring_name[id], NULL);
> >                 if (IS_ERR(keyring[id])) {
> >                         int err = PTR_ERR(keyring[id]);
> >                         pr_err("no %s keyring: %d\n", keyring_name[id], err);
> > @@ -56,3 +62,21 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
> >
> >         return -EOPNOTSUPP;
> >  }
> > +
> > +int integrity_init_keyring(const unsigned int id)
> > +{
> > +       const struct cred *cred = current_cred();
> > +
> > +       keyring[id] = keyring_alloc(keyring_name[id], KUIDT_INIT(0),
> > +                                   KGIDT_INIT(0), cred,
> > +                                   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
> > +                                     KEY_USR_VIEW | KEY_USR_READ |
> > +                                     KEY_USR_WRITE | KEY_USR_SEARCH),
> > +                                   KEY_ALLOC_NOT_IN_QUOTA, NULL);
> 
> Last parameter "destination" is NULL. It makes keyring "unsearchable"
> from user space.
> It prevents loading trusted keys from user-space, e.g. initramfs...
> 
> Should it be "cred->user->uid_keyring"??

David extended keyctl with the '%keyring' option.  For example,
"keyctl show %keyring:.ima" returns the .ima keyring id with a list of
all the keys.

> 
> 
> > +       if (!IS_ERR(keyring[id]))
> > +               set_bit(KEY_FLAG_TRUSTED_ONLY, &keyring[id]->flags);
> > +       else
> > +               pr_info("Can't allocate %s keyring (%ld)\n",
> > +                       keyring_name[id], PTR_ERR(keyring[id]));
> 
> keyring[id] should be set "back" to NULL. Otherwise bad value might be
> used in other places.

Good catch, thanks.

> 
> > +       return 0;
> > +}
> > diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> > index 81a2797..dad8d4c 100644
> > --- a/security/integrity/ima/Kconfig
> > +++ b/security/integrity/ima/Kconfig
> > @@ -123,3 +123,11 @@ config IMA_APPRAISE
> >           For more information on integrity appraisal refer to:
> >           <http://linux-ima.sourceforge.net>
> >           If unsure, say N.
> > +
> > +config IMA_TRUSTED_KEYRING
> > +       bool "Require all keys on the _ima keyring be signed"
> > +       depends on IMA_APPRAISE && SYSTEM_TRUSTED_KEYRING
> > +       default y
> > +       help
> > +          This option requires that all keys added to the _ima
> > +          keyring be signed by a key on the system trusted keyring.
> > diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> > index d3113d4..003ff46 100644
> > --- a/security/integrity/ima/ima_appraise.c
> > +++ b/security/integrity/ima/ima_appraise.c
> > @@ -385,3 +385,14 @@ int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name)
> >         }
> >         return result;
> >  }
> > +
> > +#ifdef CONFIG_IMA_TRUSTED_KEYRING
> > +static int __init init_ima_keyring(void)
> > +{
> > +       int ret;
> > +
> > +       ret = integrity_init_keyring(INTEGRITY_KEYRING_IMA);
> > +       return 0;
> > +}
> > +late_initcall(init_ima_keyring);
> 
> 
> late_initcall(init_ima_keyring) ordering competes with late_initcall(init_ima);
> but we want keyring to be initialized before IMA might use it.

> In the case when we would load keys from ima kernel initialization
> code, order is important.
> 
> we already have init_ima() and ima_init calls().
> Why not call integrity_init_keyring() from there?
> 
> Indeed, we have one late_initcall(init_evm) for EVM, and one
> late_initcall(init_ima) for IMA.
> 
> It's enough...

Right, there's no reason to have an additional call.

thanks,

Mimi

