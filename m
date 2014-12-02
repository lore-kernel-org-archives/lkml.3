Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465AbaLBXP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:15:57 -0500
Received: from mout.gmx.net ([212.227.15.15]:60688 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbaLBXP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:15:56 -0500
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v8 0/8] TPM 2.0 support
Date: Wed, 3 Dec 2014 00:21:07 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-rc6-dirty; KDE/4.12.5; x86_64; ; )
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        christophe.ricard@gmail.com, josh.triplett@intel.com,
        linux-api@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        linux-kernel@vger.kernel.org, jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <201412030016.20268.PeterHuewe@gmx.de>
In-Reply-To: <201412030016.20268.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201412030021.07882.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:0XMBH+pjMovGQhO2pR7ay48NZNXuooz7DYcxAT+oMAXP/gh+46u
 0l/IiosfhAJIOL+Y4DYZOhl8VOMCmjPcaP8SV4KWfjwd1uIolGaqIxtpcU6KPI5GUvq7DvR
 zg2RHtGBqLmoncqrQNgVmu6q4gSEC7TuYmLSi1/tED0UW3fZj8s8+dWG+MvJiLaQeBtCKnu
 5E0WT11j8ofFYvMfcPryg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 3. Dezember 2014, 00:16:19 schrieb Peter Hüwe:
> Am Dienstag, 2. Dezember 2014, 23:31:12 schrieb Jarkko Sakkinen:
> > This patch set enables TPM2 protocol and provides drivers for FIFO and
> > CRB interfaces. This patch set does not export any sysfs attributes for
> > TPM 2.0 because existing sysfs attributes have three non-trivial issues:
> > 
> > - They are associated with the platform device instead of character
> > 
> >   device.
> > 
> > - They are are not trivial key-value pairs but contain text that is
> > 
> >   not easily parsed by a computer.
> > 
> > - Raciness as described in
> > 
> > http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-correctly
> > /
> > 
> > This is too big effort to be included into this patch set and requires
> > more discussion.
> > 
> > v2:
> > - Improved struct tpm_chip life-cycle by taking advantage of devres
> > 
> >   API.
> > 
> > - Refined sysfs attributes as simple key-values thereby not repeating
> > 
> >   mistakes in TPM1 sysfs attributes.
> > 
> > - Documented functions in tpm-chip.c and tpm2-cmd.c.
> > - Documented sysfs attributes.
> > 
> > v3:
> > - Lots of fixes in calling order in device drivers (thanks to Jason
> > 
> >   Gunthorpe for pointing these out!).
> > 
> > - Attach sysfs attributes to the misc device because it represents
> > 
> >   TPM device to the user space.
> > 
> > v4:
> > - Disable sysfs attibutes for TPM 2.0 for until we can sort out the
> > 
> >   best approach for them.
> > 
> > - Fixed all the style issues found with checkpatch.pl.
> > 
> > v5:
> > - missing EXPORT_SYMBOL_GPL()
> > - own class for TPM devices used for TPM 2.0 devices and onwards.
> > 
> > v6:
> > - Non-racy initialization for sysfs attributes using struct device's
> > 
> >   groups field.
> > 
> > - The class 'tpm' is used now for all TPM devices. For the first device
> > 
> >   node major MISC_MAJOR and minor TPM_MINOR is used in order to retain
> >   backwards compatability.
> > 
> > v7:
> > - Release device number and free struct tpm_chip memory inside
> > 
> >   tpm_dev_release callback.
> > 
> > - Moved code from tpm-interface.c and tpm_dev.c to tpm-chip.c.
> > 
> > v8:
> > - Cleaned up unneeded cast from tpm_transmit_cmd().
> > - Cleaned up redundant PPI_VERSION_LEN constant from tpm_ppi.c.
> > - Fixed tpm_tis to use tpm2_calc_ordinal_duration() for TPM2 devices.
> > - tpm_crb: in crb_recv, check that count can hold the TPM header at
> > 
> >   minimum.
> > 
> > - tpm_crb: add enumerations for bit flags in start and cancel fields
> > 
> >   of the control area.
> > 
> > - tpm_crb: use ioremap() for command and response buffer because
> > 
> >   they might be anywhere.
> > 
> > - tpm_crb: use IO access functions for reading ioremapped buffers
> > 
> >   because using direct pointers is not portable.
> > 
> > - tpm_crb: only apply ACPI start if start method reported by the
> > 
> >   TPM2 ACPI table allows it.
> > 
> > - In tpm2_pcr_read() just calculate index and bit and get rid of
> > 
> >   hacky loop.
> > 
> > - Do not add sysfs attributes for TPM 2.0 devices.
> > 
> > Jarkko Sakkinen (7):
> >   tpm: merge duplicate transmit_cmd() functions
> >   tpm: two-phase chip management functions
> >   tpm: fix raciness of PPI interface lookup
> >   tpm: rename chip->dev to chip->pdev
> >   tpm: device class for tpm
> >   tpm: TPM 2.0 baseline support
> >   tpm: TPM 2.0 CRB Interface
> > 
> > Will Arthur (1):
> >   tpm: TPM 2.0 FIFO Interface
> >  
> >  drivers/char/tpm/Kconfig            |   9 +
> >  drivers/char/tpm/Makefile           |   3 +-
> >  drivers/char/tpm/tpm-chip.c         | 251 ++++++++++++++++
> >  drivers/char/tpm/tpm-dev.c          |  42 +--
> >  drivers/char/tpm/tpm-interface.c    | 261 ++++++----------
> >  drivers/char/tpm/tpm-sysfs.c        |  29 +-
> >  drivers/char/tpm/tpm.h              | 113 ++++++-
> >  drivers/char/tpm/tpm2-cmd.c         | 571
> > 
> > ++++++++++++++++++++++++++++++++++++ drivers/char/tpm/tpm_atmel.c       
> > |
> > 
> >  25 +-
> >  drivers/char/tpm/tpm_crb.c          | 356 ++++++++++++++++++++++
> >  drivers/char/tpm/tpm_i2c_atmel.c    |  49 ++--
> >  drivers/char/tpm/tpm_i2c_infineon.c |  43 +--
> >  drivers/char/tpm/tpm_i2c_nuvoton.c  |  68 ++---
> 
> When applying to linux-v3.18-rc6 I get this new coccinelle warning:
> drivers/char/tpm/tpm_i2c_nuvoton.c:607:1-3: WARNING: end returns can be
> simpified
> 
> 
> make -C ../../../linux/ M=$(pwd) coccicheck
> 
Consider folding this patch to remove the warning

----

>From cb1b82859ba98f8573624905d2b3cc8d10f456b2 Mon Sep 17 00:00:00 2001
From: Peter Huewe <peterhuewe@gmx.de>
Date: Wed, 3 Dec 2014 00:18:52 +0100
Subject: [PATCH] tpm:tpm_i2c_nuvoton: simpyl return statements

if !rc evals to false it is 0
-> we can return rc in both cases

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_i2c_nuvoton.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 14246e2..79f4fef 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -605,10 +605,8 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 		return -ENODEV;
 
 	rc = tpm_chip_register(chip);
-	if (rc)
-		return rc;
 
-	return 0;
+	return rc;
 }
 
 static int i2c_nuvoton_remove(struct i2c_client *client)
-- 
2.0.4



