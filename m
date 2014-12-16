Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbaLPVbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:31:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:48453 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbaLPVba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:31:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,589,1413270000"; 
   d="scan'208,223";a="648732255"
Date: Tue, 16 Dec 2014 23:31:24 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, stefanb@linux.vnet.ibm.com,
        linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net
Subject: Re: Re: [PATCH v10 0/8] TPM 2.0 support
Message-ID: <20141216213123.GA21710@intel.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141215201757.GA27923@intel.com>
 <trinity-c582edfe-4951-4a31-911d-db0c6f723157-1418764766771@3capp-gmx-bs15>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <trinity-c582edfe-4951-4a31-911d-db0c6f723157-1418764766771@3capp-gmx-bs15>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


On Tue, Dec 16, 2014 at 10:19:26PM +0100, Peter Huewe wrote:
> > So, what do you think? Are we now settled with this?
> 
> Meh...
> It does not recognize my tpm20 with force=1 :( :( :(
> Probably since I don't have a machine with bios integration -> no tpm startup,
> and your startup is returned with RC_SIZE :(

I don't know why it worked for me. My dTPM2 does not export ACPI device
but I guess firmware does execute startup. 

I root caused this quickly and attached patch here. Does that resolve
your issue?


>  rmmod tpm; modprobe tpm_tis force=1 ; dmesg 
> modprobe: ERROR: could not insert 'tpm_tis': No such device
> [   77.744050] tpm_tis tpm_tis: 2.0 TPM (device-id 0x1A, rev-id 16)
> [   77.816049] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   77.888043] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   77.960043] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   77.960057] genirq: Flags mismatch irq 6. 00000080 (tpm0) vs. 00000000 (floppy)
> [   77.960067] tpm_tis tpm_tis: Unable to request irq: 6 for probe
> [   77.960073] genirq: Flags mismatch irq 7. 00000080 (tpm0) vs. 00000000 (parport0)
> [   77.960077] tpm_tis tpm_tis: Unable to request irq: 7 for probe
> [   77.960082] genirq: Flags mismatch irq 8. 00000080 (tpm0) vs. 00000000 (rtc0)
> [   77.960087] tpm_tis tpm_tis: Unable to request irq: 8 for probe
> [   78.032041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   78.104043] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   78.176041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   78.248041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   78.320041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   78.392040] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   78.464041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   78.524041] tpm_tis tpm_tis: A TPM error (256) occurred continue selftest
> [   78.524048] tpm_tis tpm_tis: Firmware has not started TPM
> [   78.596041] tpm_tis tpm_tis: A TPM error (149) occurred attempting to start the TPM
> [   78.596048] tpm_tis tpm_tis: TPM self test failed
> 
> 
> ;(
> Peter

/Jarkko

--5mCyUwZo2JvN/JJP
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-tpm-invalid-size-for-struct-tpm2_startup_header.patch"

>From e8337658b6f29fc1259b1ddaf81e51ede91219e8 Mon Sep 17 00:00:00 2001
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Date: Tue, 16 Dec 2014 23:28:51 +0200
Subject: [PATCH] tpm: invalid size for struct tpm2_startup_header

sizeof(tpm2_pcr_read_in) was used in place of sizeof(tpm2_startup_in).
This patch fixes the issue.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm2-cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 610dc87..d1b99df 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -411,7 +411,7 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
 
 #define TPM2_STARTUP_IN_SIZE \
 	(sizeof(struct tpm_input_header) + \
-	 sizeof(struct tpm2_pcr_read_in))
+	 sizeof(struct tpm2_startup_in))
 
 static const struct tpm_input_header tpm2_startup_header = {
 	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
-- 
2.1.0


--5mCyUwZo2JvN/JJP--
