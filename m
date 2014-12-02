Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491AbaLBXLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:11:07 -0500
Received: from mout.gmx.net ([212.227.15.15]:54941 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933235AbaLBXLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:11:04 -0500
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v8 0/8] TPM 2.0 support
Date: Wed, 3 Dec 2014 00:16:19 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-rc6-dirty; KDE/4.12.5; x86_64; ; )
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201412030016.20268.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:ncruGpOG0X25eqhjjCk6lnGcm8muntwlB0dquoKHG/968Djm3eK
 qGGgIuqBolZ7Vy3ktrS65SVNXR5GC4rtm8vLmpTI8pTYPrTmkdID4axe2yuwecC2QXB6fJo
 vUebX7WnS2khYbxkW5VPLt5c3lcYWRfpxDjwo+NQnbwsqRSQ35VA2hE/giMNZfprVvT3FGg
 tyslY8CcVHPUSqCzq2eYQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 2. Dezember 2014, 23:31:12 schrieb Jarkko Sakkinen:
> This patch set enables TPM2 protocol and provides drivers for FIFO and
> CRB interfaces. This patch set does not export any sysfs attributes for
> TPM 2.0 because existing sysfs attributes have three non-trivial issues:
> 
> - They are associated with the platform device instead of character
>   device.
> - They are are not trivial key-value pairs but contain text that is
>   not easily parsed by a computer.
> - Raciness as described in
>  
> http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-correctly/
> 
> This is too big effort to be included into this patch set and requires
> more discussion.
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
> Jarkko Sakkinen (7):
>   tpm: merge duplicate transmit_cmd() functions
>   tpm: two-phase chip management functions
>   tpm: fix raciness of PPI interface lookup
>   tpm: rename chip->dev to chip->pdev
>   tpm: device class for tpm
>   tpm: TPM 2.0 baseline support
>   tpm: TPM 2.0 CRB Interface
> 
> Will Arthur (1):
>   tpm: TPM 2.0 FIFO Interface
> 
>  drivers/char/tpm/Kconfig            |   9 +
>  drivers/char/tpm/Makefile           |   3 +-
>  drivers/char/tpm/tpm-chip.c         | 251 ++++++++++++++++
>  drivers/char/tpm/tpm-dev.c          |  42 +--
>  drivers/char/tpm/tpm-interface.c    | 261 ++++++----------
>  drivers/char/tpm/tpm-sysfs.c        |  29 +-
>  drivers/char/tpm/tpm.h              | 113 ++++++-
>  drivers/char/tpm/tpm2-cmd.c         | 571
> ++++++++++++++++++++++++++++++++++++ drivers/char/tpm/tpm_atmel.c        |
>  25 +-
>  drivers/char/tpm/tpm_crb.c          | 356 ++++++++++++++++++++++
>  drivers/char/tpm/tpm_i2c_atmel.c    |  49 ++--
>  drivers/char/tpm/tpm_i2c_infineon.c |  43 +--
>  drivers/char/tpm/tpm_i2c_nuvoton.c  |  68 ++---

When applying to linux-v3.18-rc6 I get this new coccinelle warning:
drivers/char/tpm/tpm_i2c_nuvoton.c:607:1-3: WARNING: end returns can be 
simpified


make -C ../../../linux/ M=$(pwd) coccicheck

Peter
