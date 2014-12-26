Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaLZIRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 03:17:45 -0500
Received: from mout2.freenet.de ([195.4.92.92]:60972 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbaLZIRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 03:17:43 -0500
X-Greylist: delayed 1144 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Dec 2014 03:17:43 EST
Message-ID: <549D14A1.6070708@maya.org>
Date: Fri, 26 Dec 2014 08:56:17 +0100
From: Andreas Hartmann <andihartmann@freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: bhelgaas@google.com
CC: Alex Williamson <alex.williamson@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] PCI: quirk Atheros AR93xx to avoid bus reset
References: <20141121180322.26669.65689.stgit@gimli.home> <20141121182427.26669.82417.stgit@gimli.home>
In-Reply-To: <20141121182427.26669.82417.stgit@gimli.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originated-At: 79.222.36.194!39586
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bjorn,

I'm running this patch and the corresponding "[PATCH 3/4] PCI: Allow
device quirks to exclude bus reset" patch meanwhile since a month w/
kernel 3.14.x and couldn't find any problem. Would it be possible to
apply these patches to main kernel? Or even to lt-kernel 3.14?


Thanks.
kind regards,
Andreas Hartmann


Alex Williamson wrote:
> Reports against the TL-WDN4800 card indicate that PCI bus reset of
> this Atheros device cause system lock-ups and resets.  I've also
> been able to confirm this behavior on multiple systems.  The device
> never returns from reset and attempts to access config space of the
> device after reset result in hangs.  Blacklist bus reset for the
> device to avoid this issue.
> 
> Reported-by: Andreas Hartmann <andihartmann@freenet.de>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Tested-by: Andreas Hartmann <andihartmann@freenet.de>
> ---
> 
>  drivers/pci/quirks.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 561e10d..ebbd5b4 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3029,6 +3029,20 @@ static void quirk_no_pm_reset(struct pci_dev *dev)
>  DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
>  			       PCI_CLASS_DISPLAY_VGA, 8, quirk_no_pm_reset);
>  
> +static void quirk_no_bus_reset(struct pci_dev *dev)
> +{
> +	dev->dev_flags |= PCI_DEV_FLAGS_NO_BUS_RESET;
> +}
> +
> +/*
> + * Atheros AR93xx chips do not behave after a bus reset.  The device will
> + * throw a Link Down error on AER capable system and regardless of AER,
> + * config space of the device is never accessible again and typically
> + * causes the system to hang or reset when access is attempted.
> + * http://www.spinics.net/lists/linux-pci/msg34797.html
> + */
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0030, quirk_no_bus_reset);
> +
>  #ifdef CONFIG_ACPI
>  /*
>   * Apple: Shutdown Cactus Ridge Thunderbolt controller.
> 

