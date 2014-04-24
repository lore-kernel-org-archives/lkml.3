Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbaDXSp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:45:57 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34728 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758799AbaDXSpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:45:52 -0400
Message-ID: <1398365099.3395.24.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 00/20] in-kernel IMA/EVM initialization
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, jmorris@namei.org, roberto.sassu@polito.it,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 24 Apr 2014 14:44:59 -0400
In-Reply-To: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042418-9332-0000-0000-00000099F46D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 16:30 +0300, Dmitry Kasatkin wrote: 
> Hi,
> 
> Currently secure IMA/EVM initialization has to be done from the
> initramfs, embedded in the signed kernel image. Many systems do
> not want to use initramfs or use unsigned locally generated images.
> 
> This patchset introduces kernel functionality, which allows to perform
> IMA/EVM initialization without initramfs from the kernel, which
> includes mainly following:
> - loading EVM hmac encrypted keys
> - loading and verification of signed X509 certificates
> - loading and verification of signed IMA policy
> 
> Patchset introduces the set of new kernel configuration options,
> which makes this functionality entirely configurable.
> Not enabling any of the options does not change original IMA/EVM
> behavior. In order not to bloat security configuration menu,
> integrity subsystem options were moved to the separate menu.
> It does not affect existing configuration. Re-configuration is
> not needed.

Loading the IMA/EVM keys onto their respective keyrings by the kernel,
as early as possible, is a good idea, but unfortunately, at least in the
past, having the kernel open files (eg. configuration, policies, kernel
module public key) has not been permitted.  LSM policies were initially
loaded by the initramfs, but more recently by dracut.  As for the kernel
module public key, the key is built into the kernel and loaded onto the
system keyring.  I'm not aware that this limitation of opening files
from the kernel has been removed.

thanks,

Mimi

> 
> Dmitry Kasatkin (19):
>   integrity: initialize EVM before IMA
>   ima: move asymmetric keys config option
>   integrity: move integrity subsystem options to a separate menu
>   integrity: provide builtin 'trusted' keyrings
>   ima: create '_ima' as a builtin 'trusted' keyring
>   integrity: provide x509 certificate loading from the kernel
>   ima: load x509 certificate from the kernel
>   evm: create '_evm' as a builtin 'trusted' keyring
>   evm: load x509 certificate from the kernel
>   ima: added kernel parameter for disabling IMA
>   ima: provide buffer hash calculation function
>   ima: replace opencount with bitop
>   ima: check if policy was set at open
>   ima: path based policy loading interface
>   ima: load policy from the kernel
>   ima: make IMA policy replaceable at runtime
>   evm: added kernel parameter for disabling EVM
>   evm: try enable EVM from the kernel
>   evm: read EVM key from the kernel
> 
> Mimi Zohar (1):
>   KEYS: verify a certificate is signed by a 'trusted' key
> 
>  crypto/asymmetric_keys/x509_public_key.c |  85 +++++++++++++++++++++++-
>  security/integrity/Kconfig               |  41 ++++++++----
>  security/integrity/Makefile              |   4 +-
>  security/integrity/digsig.c              | 103 +++++++++++++++++++++++++++++
>  security/integrity/evm/Kconfig           |  32 +++++++--
>  security/integrity/evm/evm.h             |  14 ++++
>  security/integrity/evm/evm_crypto.c      | 101 ++++++++++++++++++++++++++++
>  security/integrity/evm/evm_main.c        |  25 +++++--
>  security/integrity/evm/evm_secfs.c       |  13 ++--
>  security/integrity/ima/Kconfig           |  49 +++++++++++++-
>  security/integrity/ima/ima.h             |  19 ++++++
>  security/integrity/ima/ima_crypto.c      |  11 +++-
>  security/integrity/ima/ima_fs.c          |  48 ++++++++++----
>  security/integrity/ima/ima_init.c        |   3 +
>  security/integrity/ima/ima_main.c        |  12 +++-
>  security/integrity/ima/ima_policy.c      | 109 ++++++++++++++++++++++++++++---
>  security/integrity/integrity.h           |  20 ++++++
>  17 files changed, 626 insertions(+), 63 deletions(-)
> 


