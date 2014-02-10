Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaBJPyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:54:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56246 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaBJPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:54:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mohit Kumar <mohit.kumar@st.com>
Subject: Re: [PATCH V5 4/8] phy: st-miphy-40lp: Add skeleton driver
Date: Mon, 10 Feb 2014 16:54:21 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Pratyush Anand <pratyush.anand@st.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1391871170.git.pratyush.anand@st.com> <fb505abd332645671d9ad125003d8253b6346715.1391871170.git.pratyush.anand@st.com>
In-Reply-To: <fb505abd332645671d9ad125003d8253b6346715.1391871170.git.pratyush.anand@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402101654.22187.arnd@arndb.de>
X-Provags-ID: V02:K0:isDP6Aeuj4UIoL4ihOLV5j5eMmMo21LBR4UVWMMvnoe
 oufCNvQ38WXnGPIU/Rhco7bibYNSwW+7xy/fiT86KMBg94HhoM
 lWwz17NyWw4YI+E8mQImb7qANVAjkgVvdqZZ0eO6LZP/vdlX9s
 q/j94rIIuSN0JvW7pNpMCanwfGZl7s3ochi6dAxPHBzwyUtpvr
 wYh8cJX+HLedI45Nuid6WPe01YVGp6P0WVGiqlKNekRCqiBKrO
 ItDNtoNtMhUXeD5sLAiXvOTuocmZD8TbEZedtqC9FApMLubf3d
 6tzSawdeK8/1WoScytLh4Su7s5oTCPzx1nfDb/CYtKn/NhGvUz
 bdjZp41VL7oNVOY8u870=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 February 2014, Mohit Kumar wrote:
> diff --git a/Documentation/devicetree/bindings/phy/st-miphy40lp.txt b/Documentation/devicetree/bindings/phy/st-miphy40lp.txt
> new file mode 100644
> index 0000000..d0c7096
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/st-miphy40lp.txt
> @@ -0,0 +1,12 @@
> +Required properties:
> +- compatible : should be "st,miphy40lp-phy"
> +	Other supported soc specific compatible:
> +		"st,spear1310-miphy"
> +		"st,spear1340-miphy"
> +- reg : offset and length of the PHY register set.
> +- misc: phandle for the syscon node to access misc registers
> +- phy-id: Instance id of the phy.
> +- #phy-cells : from the generic PHY bindings, must be 1.
> +	- 1st cell: phandle to the phy node.
> +	- 2nd cell: 0 if phy (in 1st cell) is to be used for SATA, 1 for PCIe
> +	  and 2 for Super Speed USB.

It's common to start this file with a small header explaining what this
hardware is.

> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index afa2354..2f58993 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -64,4 +64,10 @@ config BCM_KONA_USB2_PHY
>  	help
>  	  Enable this to support the Broadcom Kona USB 2.0 PHY.
>  
> +config PHY_ST_MIPHY40LP
> +	tristate "ST MIPHY 40LP driver"
> +	help
> +	  Support for ST MIPHY 40LP which can be used for PCIe, SATA and Super Speed USB.
> +	select GENERIC_PHY
> +
>  endmenu

The 'select' statement should come before 'help', for consistency with the
rest of the kernel. Maybe mention that this phy is used inside the
spear13xx SoC here rather than a standalone phy.

> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv) {
> +		dev_err(dev, "can't alloc miphy40lp private date memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	priv->plat_ops = (struct miphy40lp_plat_ops *)of_id->data;

The cast would incorrectly remove the 'const' attribute of the pointer.
Better remove the cast and make priv->plat_ops const.

> +static int __init miphy40lp_phy_init(void)
> +{
> +
> +	return platform_driver_probe(&miphy40lp_driver,
> +				miphy40lp_probe);
> +}
> +module_init(miphy40lp_phy_init);

There should certainly be a module_exit() function here so you can unload the
driver.

	Arnd
