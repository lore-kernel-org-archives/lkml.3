Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181AbaLOUSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 15:18:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:35841 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbaLOUSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 15:18:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="429286487"
Date: Mon, 15 Dec 2014 22:17:57 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, stefanb@linux.vnet.ibm.com,
        linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net
Subject: Re: [PATCH v10 0/8] TPM 2.0 support
Message-ID: <20141215201757.GA27923@intel.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, what do you think? Are we now settled with this?

/Jarkko

On Fri, Dec 12, 2014 at 11:46:32AM -0800, Jarkko Sakkinen wrote:
> This patch set enables TPM2 protocol and provides drivers for FIFO and
> CRB interfaces. This patch set does not export any sysfs attributes for
> TPM 2.0 because existing sysfs attributes have three non-trivial issues:
> 
> - They are associated with the platform device instead of character
>   device.
> - They are are not trivial key-value pairs but contain text that is
>   not easily parsed by a computer.
> - Raciness as described in
>   http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-correctly/
> 
> v2:
> - Improved struct tpm_chip life-cycle by taking advantage of devres
>   API.
> - Refined sysfs attributes as simple key-values thereby not repeating
>   mistakes in TPM1 sysfs attributes.
> - Documented functions in tpm-chip.c and tpm2-cmd.c.
> - Documented sysfs attributes.
> 
> v3:
> - Lots of fixes in calling order in device drivers (thanks to Jason
>   Gunthorpe for pointing these out!).
> - Attach sysfs attributes to the misc device because it represents
>   TPM device to the user space.
> 
> v4:
> - Disable sysfs attibutes for TPM 2.0 for until we can sort out the 
>   best approach for them.
> - Fixed all the style issues found with checkpatch.pl.
> 
> v5:
> - missing EXPORT_SYMBOL_GPL()
> - own class for TPM devices used for TPM 2.0 devices and onwards.
> 
> v6:
> - Non-racy initialization for sysfs attributes using struct device's
>   groups field.
> - The class 'tpm' is used now for all TPM devices. For the first device
>   node major MISC_MAJOR and minor TPM_MINOR is used in order to retain
>   backwards compatability.
> 
> v7:
> - Release device number and free struct tpm_chip memory inside
>   tpm_dev_release callback.
> - Moved code from tpm-interface.c and tpm_dev.c to tpm-chip.c.
> 
> v8:
> - Cleaned up unneeded cast from tpm_transmit_cmd().
> - Cleaned up redundant PPI_VERSION_LEN constant from tpm_ppi.c.
> - Fixed tpm_tis to use tpm2_calc_ordinal_duration() for TPM2 devices.
> - tpm_crb: in crb_recv, check that count can hold the TPM header at
>   minimum.
> - tpm_crb: add enumerations for bit flags in start and cancel fields
>   of the control area.
> - tpm_crb: use ioremap() for command and response buffer because
>   they might be anywhere.
> - tpm_crb: use IO access functions for reading ioremapped buffers
>   because using direct pointers is not portable.
> - tpm_crb: only apply ACPI start if start method reported by the
>   TPM2 ACPI table allows it.
> - In tpm2_pcr_read() just calculate index and bit and get rid of
>   hacky loop.
> - Do not add sysfs attributes for TPM 2.0 devices.
> 
> v9:
> - Fixed compilation issues in v8 (sorry for not using the correct
>   tree).
> - Just do "return tpm_chip_register();" instead of copying return
>   value to a variable.
> - Removed unused tpm2_startup().
> - In the CRB driver ACPI TPM2 table could contain platform specific
>   and therefore inequality test does not work. Fixed in this patch
>   set.
> 
> v10:
> - Fixed coccicheck and sparse errors and other reported style errors.
> - Fixed build errors without CONFIG_ACPI.
> - Fixed build error with CONFIG_OF.
> - Added TPM_CHIP_FLAG_REGISTERED to mark successful tpm_chip_register().
>   It is checked in the beginning of tpm_chip_unregister(), which is 
>   called even when "attach" callback for a device fails because "detach"
>   callback is always called.
> - Added TPM_CHIP_FLAG_PPI to mark successful PPI interface lookup because 
>   in older TPM chips version string might be non-existent.
> - Check TPM version from the 4th byte of STS register after requesting 
>   the locality because otherwise the read will return bogus data.
> - Some TPM chips just give 0xff as the 4th byte so using that for detecting
>   TPM family is unstable. Instead I chose the approach of using idempotent 
>   TPM 2.x command to detect such case.
> 
> Jarkko Sakkinen (8):
>   tpm: merge duplicate transmit_cmd() functions
>   tpm: two-phase chip management functions
>   tpm: fix raciness of PPI interface lookup
>   tpm: rename chip->dev to chip->pdev
>   tpm: device class for tpm
>   tpm: TPM 2.0 baseline support
>   tpm: TPM 2.0 CRB Interface
>   tpm: TPM 2.0 FIFO Interface
> 
>  Documentation/ABI/stable/sysfs-class-tpm |  22 +-
>  drivers/char/tpm/Kconfig                 |   9 +
>  drivers/char/tpm/Makefile                |   3 +-
>  drivers/char/tpm/tpm-chip.c              | 256 +++++++++++++
>  drivers/char/tpm/tpm-dev.c               |  42 +--
>  drivers/char/tpm/tpm-interface.c         | 263 +++++--------
>  drivers/char/tpm/tpm-sysfs.c             |  29 +-
>  drivers/char/tpm/tpm.h                   | 118 +++++-
>  drivers/char/tpm/tpm2-cmd.c              | 617 +++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_atmel.c             |  25 +-
>  drivers/char/tpm/tpm_crb.c               | 354 ++++++++++++++++++
>  drivers/char/tpm/tpm_i2c_atmel.c         |  55 +--
>  drivers/char/tpm/tpm_i2c_infineon.c      |  43 +--
>  drivers/char/tpm/tpm_i2c_nuvoton.c       |  71 ++--
>  drivers/char/tpm/tpm_i2c_stm_st33.c      |  32 +-
>  drivers/char/tpm/tpm_ibmvtpm.c           |  17 +-
>  drivers/char/tpm/tpm_infineon.c          |  51 +--
>  drivers/char/tpm/tpm_nsc.c               |  34 +-
>  drivers/char/tpm/tpm_ppi.c               | 141 ++++---
>  drivers/char/tpm/tpm_tis.c               | 224 ++++++-----
>  drivers/char/tpm/xen-tpmfront.c          |  14 +-
>  21 files changed, 1820 insertions(+), 600 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm-chip.c
>  create mode 100644 drivers/char/tpm/tpm2-cmd.c
>  create mode 100644 drivers/char/tpm/tpm_crb.c
> 
> -- 
> 2.1.0
> 
