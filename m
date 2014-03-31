Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaCaUjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:39:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:25599 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaCaUjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:39:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,767,1389772800"; 
   d="scan'208";a="511861631"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        "Nikola Ciprich" <nikola.ciprich@linuxbox.cz>,
        Prarit Bhargava <prarit@redhat.com>
Subject: RE: [char-misc-next] mei: me: do not load the driver if the FW
 doesn't support MEI interface
Thread-Topic: [char-misc-next] mei: me: do not load the driver if the FW
 doesn't support MEI interface
Thread-Index: AQHPSGAXwF6yQdfMTEealirybjm4tZr7ridg
Date: Mon, 31 Mar 2014 20:39:18 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AFAEBE3@HASMSX106.ger.corp.intel.com>
References: <1395775518-2132-1-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1395775518-2132-1-git-send-email-tomas.winkler@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> NM and SPS  FW types that may run on ME device on server platforms
> do not have valid MEI/HECI interface and driver should not
> be bound to it as this might lead to system hung.
> In practice not all BIOSes effectively hide such devices from the
> OS and in some cases it is not possible.
> 
> We determine FW type by examining Host FW status registers in order to
> unbind the driver.
> In this patch we are adding check for ME on Cougar Point, Lynx Point
> Devices
> 
> Cc: stable <stable@vger.kernel.org> # 3.10+
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Please add 
Tested-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Also fixes RH issue described in  https://bugzilla.redhat.com/show_bug.cgi?id=1080155

Thanks
Tomas


> ---
>  drivers/misc/mei/hw-me-regs.h |  5 +++++
>  drivers/misc/mei/pci-me.c     | 30 +++++++++++++++++++++++-------
>  2 files changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
> index 72ba4d5..a7856c0 100644
> --- a/drivers/misc/mei/hw-me-regs.h
> +++ b/drivers/misc/mei/hw-me-regs.h
> @@ -115,6 +115,11 @@
>  #define MEI_DEV_ID_LPT_HR     0x8CBA  /* Lynx Point H Refresh */
> 
>  #define MEI_DEV_ID_WPT_LP     0x9CBA  /* Wildcat Point LP */
> +
> +/* Host Firmware Status Registers in PCI Config Space */
> +#define PCI_CFG_HFS_1         0x40
> +#define PCI_CFG_HFS_2         0x48
> +
>  /*
>   * MEI HW Section
>   */
> diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
> index bc3e043..88516b0 100644
> --- a/drivers/misc/mei/pci-me.c
> +++ b/drivers/misc/mei/pci-me.c
> @@ -107,15 +107,31 @@ static bool mei_me_quirk_probe(struct pci_dev *pdev,
>  				const struct pci_device_id *ent)
>  {
>  	u32 reg;
> -	if (ent->device == MEI_DEV_ID_PBG_1) {
> -		pci_read_config_dword(pdev, 0x48, &reg);
> -		/* make sure that bit 9 is up and bit 10 is down */
> -		if ((reg & 0x600) == 0x200) {
> -			dev_info(&pdev->dev, "Device doesn't have valid ME
> Interface\n");
> -			return false;
> -		}
> +	/* Cougar Point || Patsburg */
> +	if (ent->device == MEI_DEV_ID_CPT_1 ||
> +	    ent->device == MEI_DEV_ID_PBG_1) {
> +		pci_read_config_dword(pdev, PCI_CFG_HFS_2, &reg);
> +		/* make sure that bit 9 (NM) is up and bit 10 (DM) is down */
> +		if ((reg & 0x600) == 0x200)
> +			goto no_mei;
>  	}
> +
> +	/* Lynx Point */
> +	if (ent->device == MEI_DEV_ID_LPT_H  ||
> +	    ent->device == MEI_DEV_ID_LPT_W  ||
> +	    ent->device == MEI_DEV_ID_LPT_HR) {
> +		/* Read ME FW Status check for SPS Firmware */
> +		pci_read_config_dword(pdev, PCI_CFG_HFS_1, &reg);
> +		/* if bits [19:16] = 15, running SPS Firmware */
> +		if ((reg & 0xf0000) == 0xf0000)
> +			goto no_mei;
> +	}
> +
>  	return true;
> +
> +no_mei:
> +	dev_info(&pdev->dev, "Device doesn't have valid ME Interface\n");
> +	return false;
>  }
>  /**
>   * mei_probe - Device Initialization Routine
> --
> 1.8.5.3

