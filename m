Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaEOQOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:14:17 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:63891 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaEOQOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:14:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v1 3/5] phy: pci serdes phy driver for keystone
Date: Thu, 15 May 2014 18:14:03 +0200
Message-ID: <9550746.D1ri3H0uvi@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400169692-9677-4-git-send-email-m-karicheri2@ti.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <1400169692-9677-4-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mrQqJ9grDWAIKqtU1Fq/sxCRXYEx0DeA0nREwRiYMHJ
 9mV8ywFED3NkaHdtvADLChwj4yEUKHYZNGu99OorXfkcwfyQfU
 qdn/TTqDeBesjjHJaP9Jz8jWIIstjt+E45FoW8prbcTpbivvh3
 7k9deo2exchnsN/24SD7tXuR2sYWxYDcDtDmdnG3wy08urHAPx
 +Tw2xBilVYETIJlGK3l/LT4H7UniMJaZdwRinYHElTUTKFIhOL
 f7R5zYp5LfwIeRcbkINbyLricOSKr1Vp5+bM+YRh6z29+D9Jl3
 ZgEcxetMqf8tMCqp/SFG3nvqMOSE2PCIMzSdz0knFzBi0EGAf5
 KF/0ZLQwhvGqfM+lQrXU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 12:01:30 Murali Karicheri wrote:
> +static struct serdes_config ks_100mhz_pcie_5gbps_serdes[] = {
> +       {0x0000, 0x00000800, 0x0000ff00},
> +       {0x0060, 0x00041c5c, 0x00ffffff},
> +       {0x0064, 0x0343c700, 0xffffff00},
> +       {0x006c, 0x00000012, 0x000000ff},
> +       {0x0068, 0x00070000, 0x00ff0000},
> +       {0x0078, 0x0000c000, 0x0000ff00},

It looks like the PHY is generic, but the configuration above is
PCI specific. If this is true, you should have #phy-cells=<1>
and document the possible modes, adding a lookup table here to
pick the configuration based on the argument. It's fine to just
implement pcie-5ghz initially, but the binding should list all
the modes that the PHY can support.

Also, please list the exact name of the phy if you can find it
out. You mention that you don't know the register descriptions,
but you should at least be able to let us know what phy this
is, in case some other SoC reuses the same thing.

> +static int ks_phy_init(struct phy *phy)
> +{
> +       struct serdes_config *p;
> +       struct phy_keystone *ks_phy = phy_get_drvdata(phy);
> +
> +       int i;
> +
> +       for (i = 0, p = &ks_100mhz_pcie_5gbps_serdes[0];
> +               i < ARRAY_SIZE(ks_100mhz_pcie_5gbps_serdes);
> +               i++, p++) {
> +               reg_rmw((ks_phy->base + p->reg), p->val, p->mask);
> +               reg_dump((ks_phy->base + p->reg), p->mask);
> +       }
> +       udelay(2000);

This should probably be msleep(2);

	Arnd
