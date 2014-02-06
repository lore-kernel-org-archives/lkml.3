Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbaBFPhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:37:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbaBFPhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:37:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pratyush Anand <pratyush.anand@st.com>
Subject: Re: [PATCH V4 6/8] phy: st-miphy-40lp: Add SPEAr1310 and SPEAr1340 PCIe phy support
Date: Thu, 6 Feb 2014 16:37:05 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Kishon Vijay Abraham I <kishon@ti.com>, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1391661589.git.pratyush.anand@st.com> <dca9c501de8386003142b463469c3d267a049eeb.1391661589.git.pratyush.anand@st.com>
In-Reply-To: <dca9c501de8386003142b463469c3d267a049eeb.1391661589.git.pratyush.anand@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402061637.05414.arnd@arndb.de>
X-Provags-ID: V02:K0:uC7zM+YIEedRlFUbg6KmHUUQqa8utpLkQLqObQrgtPj
 mZ+kxwXOs5lS40hekjir8GaZMx3JbEfH02mJVJ0QcK59FIkUu3
 EDgRd5nXTzq5I18hgXl4WGRInZWCXnEjuI+fXBRqaQG69kvv3H
 ZZLkxlGVjU+ucW931++OOesMILUKjKlg6+jKsThSVbDnh61bZ7
 wLVB/YFkLye2Wtu4nnwwaVmFuaWhtZpG1W7PoJZekGsBwYOphe
 S2iqPFBcnNchKcN0Q7mntSkpdHI3fBSBHd69R9sY9RqdHEUDRH
 sSfqr3s1UzkLRg6uzBeXuul7PCWRZXLspBoKtk2HCgIUUCaY0z
 CXrDxGBE5zrDWTpHnEO0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 February 2014, Pratyush Anand wrote:
> +static int spear1310_pcie_miphy_exit(struct st_miphy40lp_priv *phypriv)
> +{
> +       u32 mask;
> +
> +       switch (phypriv->id) {
> +       case 0:
> +               mask = SPEAR1310_PCIE_CFG_MASK(0);
> +               break;
> +       case 1:
> +               mask = SPEAR1310_PCIE_CFG_MASK(1);
> +               break;
> +       case 2:
> +               mask = SPEAR1310_PCIE_CFG_MASK(2);
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       regmap_update_bits(phypriv->misc, SPEAR1310_PCIE_SATA_CFG,
> +                       SPEAR1310_PCIE_CFG_MASK(phypriv->id), 0);
> +
> +       regmap_update_bits(phypriv->misc, SPEAR1310_PCIE_MIPHY_CFG_1,
> +                       SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE_MASK, 0);
> +
> +       return 0;
> +}

hmm, you set the mask based on the id, but then use the macro below
and ignore the mask?

> +
> +static int pcie_miphy_init(struct st_miphy40lp_priv *phypriv)
> +{
> +       if (of_device_is_compatible(phypriv->np, "st,spear1340-miphy"))
> +               return spear1340_pcie_miphy_init(phypriv);
> +       else if (of_device_is_compatible(phypriv->np, "st,spear1310-miphy"))
> +               return spear1310_pcie_miphy_init(phypriv);
> +       else
> +               return -EINVAL;
> +}
> +
> +static int pcie_miphy_exit(struct st_miphy40lp_priv *phypriv)
> +{
> +       if (of_device_is_compatible(phypriv->np, "st,spear1340-miphy"))
> +               return spear1340_pcie_miphy_exit(phypriv);
> +       else if (of_device_is_compatible(phypriv->np, "st,spear1310-miphy"))
> +               return spear1310_pcie_miphy_exit(phypriv);
> +       else
> +               return -EINVAL;
> +}

I think it's better to make this code table-driven. Rather than checking
'of_device_is_compatible()', it's much easier to add a .data field to
the of_device_id array that describes the PHY. You can use .data to
point to a structure containing per-device function pointers or
(better) values and offsets to be used.

	Arnd
