Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaJMRdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 13:33:03 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58002 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaJMRc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 13:32:59 -0400
Message-ID: <1413221571.13530.16.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v3 0/6] ima: provide signature based 'init' appraisal
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Mon, 13 Oct 2014 13:32:51 -0400
In-Reply-To: <cover.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101317-0005-0000-0000-00000599BAC4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 17:09 +0300, Dmitry Kasatkin wrote: 
> Currently secure IMA/EVM initialization has to be done from the initramfs,
> embedded in the signed kernel image. Many systems do not want to use
> initramfs or usage of embedded initramfs makes it difficult to have
> multi-target kernels.
> 
> This is a very simple patchset which makes it possible to perform secure
> initialization by requiring initial user-space to be signed.
> 
> It does it by:
> - introducing a hook to load keys
> - loading IMA signed public key certificate into the '.ima' trusted keyring
> - making default IMA appraisal policy to require everything to be signed
> 
> When builtin initramfs is not in use, keys cannot be read from initcalls,
> because root filesystem is not yet mounted. In order to read keys before
> executing init process, ima_prepare_keys() hook is introduced. Reading
> public keys from the kernel is justified because signature verification
> key is needed in order to verify anything else which is read from the
> file system. Public keys are X509 certificates and itself signed by the
> trusted key from the .system keyring. Kernel BIG KEYS support is an example
> of reading keys directly by the kernel.
> 
> CONFIG_IMA_APPRAISE_SIGNED_INIT kernel option is provided to make the IMA
> default appraisal policy to required signature validation. Signed init
> process need to initialize EVM key and load appropriate IMA policy which
> would not require everything to be signed.
> 
> Unless real '/sbin/init' is signed, a simple and practical way is to place
> all signed programs, libraries, scripts and configuration files under
> dedicated directory, for example '/ima', and run signed init process by
> providing a kernel command line parameter 'init=/ima/init'.
> 
> In the first post of these patches Andrew Morton noted that
> integrity_read_file() is a very simple open-file-and-slurp-it-into-memory
> and if there are other similar functions that can be made in ./lib.
> I found out that only sound:sound_firmware.c:do_mod_firmware_load(),
> which is enabled by CONFIG_SOUND_PRIME which is related to deprecated OSS
> interface and is not enabled anymore in latest Ubuntu kernels, at least.
> So I am keeping integrity_read_file() in integrity subsystem.
> 
> cpio based initramfs currently does not support extended attributes.
> There is an initial agreement to introduce light-weight tar parser to
> the kernel to support extended attributes which will make it possible to
> use IMA appraisal with external initramfs. It will benefit from this
> patchset and allow to update initramfs with signed files also on the
> running system as distros do.

Thanks, Dmitry.  The patches look good, but I still will need to test.
(Once I figure out how to build a kernel without an initramfs, that
boots a distro kernel.)  Only some minor suggested patch descriptions
changes ...

Mimi

> Changes in v3:
> * ima_prepare_keys() renamed to integrity_load_keys() to be the hook
>   for both modules of integrity subsystem IMA/EVM.
> * removed unnecessary configuration options and declared init functions
>   with '__init'.
> * updated to lately introduced 'ima_policy_flag' variable to disabled and
>   enable IMA appraisal.
> * separated key loading patch from policy change patch
> * added patch which refactor vfs_read(). Agreed with Mimi to offer to
>   move calling file operations hooks to a separate helper function which
>   is then used by vfs_read() and integrity_kernel_read(). Applying this
>   patch does not affect functionality and can be applied if agreed so.
> 
> Changes in v2:
> * ima_kernel_read() moved as integrity_kernel_read() from ima_crypto.c to
>   iint.c for use by integrity_read_file. The reason for keeping internal
>   version is because 'integrity' version does not call fsnotify_access(),
>   add_rchar() and inc_syscr().
> * integrity_read_file() moved from digsig.c to iint.c because it is used
>   by IMA crypto subsystem and should not depend on digsig support being
>   enabled.
> 
> -Dmitry
> 
> Dmitry Kasatkin (6):
>   integrity: provide integrity_read_file()
>   integrity: provide x509 certificate loading from the kernel
>   ima: load x509 certificate from the kernel
>   integrity: provide hook to load keys when rootfs is ready
>   ima: require signature based appraisal
>   VFS: refactor vfs_read()
> 
>  fs/read_write.c                     | 24 ++++++++---
>  include/linux/fs.h                  |  1 +
>  include/linux/integrity.h           |  6 +++
>  init/main.c                         |  6 ++-
>  security/integrity/digsig.c         | 37 +++++++++++++++-
>  security/integrity/iint.c           | 85 +++++++++++++++++++++++++++++++++++++
>  security/integrity/ima/Kconfig      | 22 ++++++++++
>  security/integrity/ima/ima_crypto.c | 35 ++-------------
>  security/integrity/ima/ima_init.c   | 17 ++++++++
>  security/integrity/ima/ima_policy.c |  5 +++
>  security/integrity/integrity.h      | 14 ++++++
>  11 files changed, 212 insertions(+), 40 deletions(-)
> 


