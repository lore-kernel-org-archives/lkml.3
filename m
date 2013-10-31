Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3JaMnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:43:18 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60009 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab3JaMnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:43:15 -0400
Message-ID: <1383223387.5434.111.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH] ima: define '_ima' as a builtin 'trusted' keyring
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 31 Oct 2013 08:43:07 -0400
In-Reply-To: <52724BAC.1080902@samsung.com>
References: <1383159291.5434.18.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <5272153D.4080801@samsung.com>
	 <1383221007.5434.98.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <52724BAC.1080902@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103112-0320-0000-0000-000001945B71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-31 at 14:23 +0200, Dmitry Kasatkin wrote:
> On 31/10/13 14:03, Mimi Zohar wrote:
> > On Thu, 2013-10-31 at 10:30 +0200, Dmitry Kasatkin wrote:
> >> On 30/10/13 20:54, Mimi Zohar wrote:
> >>> Require all keys added to the IMA keyring be signed by an
> >>> existing trusted key on the system trusted keyring.
> >>>
> >>> Changelog:
> >>> - define stub integrity_init_keyring() function (reported-by Fengguang Wu)
> >>> - differentiate between regular and trusted keyring names.
> >>> - replace printk with pr_info (D. Kasatkin)
> >>>
> >>> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> >>> ---
> >>>  security/integrity/digsig.c           | 30 +++++++++++++++++++++++++++++-
> >>>  security/integrity/ima/Kconfig        |  8 ++++++++
> >>>  security/integrity/ima/ima_appraise.c | 11 +++++++++++
> >>>  security/integrity/integrity.h        |  7 +++++++
> >>>  4 files changed, 55 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
> >>> index b4af4eb..77ca965 100644
> >>> --- a/security/integrity/digsig.c
> >>> +++ b/security/integrity/digsig.c
> >>> @@ -13,7 +13,9 @@
> >>>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >>>  
> >>>  #include <linux/err.h>
> >>> +#include <linux/sched.h>
> >>>  #include <linux/rbtree.h>
> >>> +#include <linux/cred.h>
> >>>  #include <linux/key-type.h>
> >>>  #include <linux/digsig.h>
> >>>  
> >>> @@ -21,11 +23,19 @@
> >>>  
> >>>  static struct key *keyring[INTEGRITY_KEYRING_MAX];
> >>>  
> >>> +#ifdef CONFIG_IMA_TRUSTED_KEYRING
> >>> +static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
> >>> +	".evm",
> >>> +	".module",
> >>> +	".ima",
> >>> +};
> >>> +#else
> >>>  static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
> >>>  	"_evm",
> >>>  	"_module",
> >>>  	"_ima",
> >>>  };
> >>> +#endif
> >> Hello,
> >>
> >> I am not sure if having 2 different names "_" and "." makes sense.
> > The existing keyring implementation permits userspace to create a new
> > keyring with the exact same name as a previously defined trusted
> > keyring.  For all practical purposes, replacing a trusted keyring with
> > an untrusted one.  The existing solution is to prohibit userspace from
> > creating a dot prefixed keyring.  
> >
> > Allowing only signed keys to be added to the IMA keyring breaks the
> > existing userspace/kernel ABI, which has existed since linux-3.3.  At
> > some point, we could deprecate the non trusted keyring. 
> >
> >> Setting trusted-only makes sense until we will get support of setting
> >> trusted only from user-space using keyctl...
> > Agreed, userspace should be permitted to create a trusted keyring, but
> > not change an existing keyring to trusted.
> 
> Then all keys on that keyring must be signed..
> This is not what I was saying...
> 
> It is always possible to specify keyring hierarchy and rules what
> verifies what.
> But may be better not to over-engineer...
> 
> It is how it is now.. Will see based on use-cases in the future...

Right, keys can be loaded onto the existing keyring; and the keyring can
be locked in the initramfs.  Moving forward, a trusted keyring implies a
HW based certificate chain of trust.

> >> David, do you remember our discussion in Edinburgh?
> >> Can you provide a way to set keyring as trusted-only from user space..
> >>
> >> Motivation...
> >>
> >> In many embedded systems, initramfs is built into the ker​​nel image.
> >> Kernel image is signed and obviously initramfs as well..
> >> Or initramfs may be signed separately like in my prototype implementation...
> >> Note that non-x86 systems - embedded, mobile, etc has no UEFI, MOK.
> >> Initial keys cannot be verified. (we should not rely on using kernel
> >> modules key)
> >> Thus keys on the protected initramfs may not be required to be signed..
> > In the builtin initramfs case, the public key is included in the signed
> > image.  Where is the key stored that verifies the separately signed
> > initramfs?  Is there a signature chain of trust?
> 
> In prototype implementation I used kernel module verification
> function... module key...

This implies that you rebuilt the kernel. :)  In that case, add your
local-ca public key to the root build tree.  All .x509 suffixed files
are included in the image and loaded on the system keyring.

> >
> > If there is a signature chain of trust and a local-ca signed the
> > initramfs, then the local-ca key could be added to the system keyring
> > and used to sign keys for the IMA keyring.
> >
> > thanks,
> 
> You need to embed local-ca somehow into the kernel..
> Or pass/read and verify it somehow...

Exactly.

Mimi

