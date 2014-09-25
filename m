Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaIYPvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:51:08 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:56835 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbaIYPvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:51:04 -0400
Date: Thu, 25 Sep 2014 09:51:00 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: rdunlap@infradead.org, bp@alien8.de, tony.luck@intel.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heather Brown <hbrown@hp.com>
Subject: Re: [RESEND 2/5] PCIe, AER: Replenish missed AER status bits for AER
 driver
Message-ID: <20140925155100.GA12200@google.com>
References: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
 <1407910961-7798-3-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407910961-7798-3-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Heather]

On Wed, Aug 13, 2014 at 02:22:38AM -0400, Chen, Gong wrote:
> Since commit 6c2b374d is commited, the capability of PCI-e AER
> has changed a lot. This patch adds all missed CE/UC error bits
> existed in PCI-e SPEC r3.0. Meanwhile, adjust the code format
> to make it simpler to read/maintain.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  drivers/pci/pcie/aer/aerdrv_errprint.c | 60 ++++++++++++++--------------------
>  1 file changed, 25 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
> index 35d06e177917..5c4f7e252e5e 100644
> --- a/drivers/pci/pcie/aer/aerdrv_errprint.c
> +++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
> @@ -75,44 +75,34 @@ static const char *aer_error_layer[] = {
>  };
>  
>  static const char *aer_correctable_error_string[] = {
> -	"Receiver Error",		/* Bit Position 0	*/
> -	NULL,
> -	NULL,
> -	NULL,
> -	NULL,
> -	NULL,
> -	"Bad TLP",			/* Bit Position 6	*/
> -	"Bad DLLP",			/* Bit Position 7	*/
> -	"RELAY_NUM Rollover",		/* Bit Position 8	*/
> -	NULL,
> -	NULL,
> -	NULL,
> -	"Replay Timer Timeout",		/* Bit Position 12	*/
> -	"Advisory Non-Fatal",		/* Bit Position 13	*/
> +	[0] = "Receiver Error",
> +	[6] = "Bad TLP",
> +	[7] = "Bad DLLP",
> +	[8] = "RELAY_NUM Rollover",
> +	[12] = "Replay Timer Timeout",
> +	[13] = "Advisory Non-Fatal Error",
> +	[14] = "Corrected Internal Error",
> +	[15] = "Header Log Overflow",

This patch does two things at once: (1) adds new error strings and (2)
converts to the designated initializer style.  The first is useful but I
don't think the second really helps anything.

We still have to manually match up the array index, e.g., "14", with the
#define, PCI_ERR_COR_INTERNAL, and then count bits to make sure it
matches the constant 0x00004000.

I'm still holding out for a change that solves that problem.  I would also
like to avoid duplicating all the strings between include/ras/ras_event.h
and drivers/pci/pcie/aer/aerdrv_errprint.c.

In the meantime, I applied the patch below, which does just (1).

Bjorn


commit d179111767aa2a1d594023ce65abf9c81bfbb0cf
Author: Chen, Gong <gong.chen@linux.intel.com>
Date:   Thu Sep 25 09:36:43 2014 -0600

    PCI/AER: Add additional PCIe AER error strings
    
    Add strings for all AER error bits defined in PCIe r3.0.
    
    [bhelgaas: changelog, drop designated initializer change]
    Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
index 35d06e177917..c6849d9e86ce 100644
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -89,15 +89,17 @@ static const char *aer_correctable_error_string[] = {
 	NULL,
 	"Replay Timer Timeout",		/* Bit Position 12	*/
 	"Advisory Non-Fatal",		/* Bit Position 13	*/
+	"Corrected Internal Error",	/* Bit Position 14	*/
+	"Header Log Overflow",		/* Bit Position 15	*/
 };
 
 static const char *aer_uncorrectable_error_string[] = {
-	NULL,
+	"Undefined",			/* Bit Position 0	*/
 	NULL,
 	NULL,
 	NULL,
 	"Data Link Protocol",		/* Bit Position 4	*/
-	NULL,
+	"Surprise Down Error",		/* Bit Position 5	*/
 	NULL,
 	NULL,
 	NULL,
@@ -113,6 +115,11 @@ static const char *aer_uncorrectable_error_string[] = {
 	"Malformed TLP",		/* Bit Position 18	*/
 	"ECRC",				/* Bit Position 19	*/
 	"Unsupported Request",		/* Bit Position 20	*/
+	"ACS Violation",		/* Bit Position 21	*/
+	"Uncorrectable Internal Error",	/* Bit Position 22	*/
+	"MC Blocked TLP",		/* Bit Position 23	*/
+	"AtomicOp Egress Blocked",	/* Bit Position 24	*/
+	"TLP Prefix Blocked Error",	/* Bit Position 25	*/
 };
 
 static const char *aer_agent_string[] = {
