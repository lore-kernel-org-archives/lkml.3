Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3IMSzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:55:09 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:36520 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab3IMSzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:55:05 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-ide@vger.kernel.org
Subject: Re: [PATCH] pata_isapnp: Don't use invalid I/O ports
Date: Fri, 13 Sep 2013 20:54:37 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: linux-kernel@vger.kernel.org
References: <1379019689-21467-1-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1379019689-21467-1-git-send-email-linux@rainbow-software.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201309132054.38278.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 September 2013 23:01:29 Ondrej Zary wrote:
> The test for 2nd I/O port validity is broken (reversed):
> On devices with no control port, the driver attempts to use invalid port 0,
> resulting in logs full of bad_io_access errors.
> On devices with control port, the driver does not use it.
>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/ata/pata_isapnp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
> index 4bceb88..b33d1f9 100644
> --- a/drivers/ata/pata_isapnp.c
> +++ b/drivers/ata/pata_isapnp.c
> @@ -78,7 +78,7 @@ static int isapnp_init_one(struct pnp_dev *idev, const
> struct pnp_device_id *dev
>
>  	ap->ioaddr.cmd_addr = cmd_addr;
>
> -	if (pnp_port_valid(idev, 1) == 0) {
> +	if (pnp_port_valid(idev, 1)) {
>  		ctl_addr = devm_ioport_map(&idev->dev,
>  					   pnp_port_start(idev, 1), 1);
>  		ap->ioaddr.altstatus_addr = ctl_addr;

With this patch, the ATA port works fine if there is a device connected to it. 
However, it takes ages to boot if there are no devices connected. Looks like 
the driver retries IDENTIFY command for both slave and master drives in a 
hope that the devices are there.

log:

[    7.692344] pata_isapnp 01:01.02: [io  0x01e8-0x01ef]
[    7.692474] pata_isapnp 01:01.02: [io  0x0168-0x016f]
[    7.692644] pata_isapnp 01:01.02: [irq 10]
[    7.695012] pata_isapnp 01:01.02: activated
[    7.751153] scsi2 : pata_isapnp
[    7.751781] ata3: PATA max PIO0 cmd 0x168 ctl 0x0 irq 10
[   12.751446] ata3.01: qc timeout (cmd 0xec)
[   12.751571] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
[   22.752270] ata3.01: qc timeout (cmd 0xec)
[   22.752396] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
[   52.754737] ata3.01: qc timeout (cmd 0xec)
[   52.754861] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
[   57.755149] ata3.00: qc timeout (cmd 0xec)
[   57.755275] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[   67.755974] ata3.00: qc timeout (cmd 0xec)
[   67.756099] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x5)

-- 
Ondrej Zary
