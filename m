Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaBFIIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:08:01 -0500
Received: from eu1sys200aog125.obsmtp.com ([207.126.144.159]:58289 "EHLO
	eu1sys200aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbaBFIIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:08:00 -0500
X-Greylist: delayed 6090 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Feb 2014 03:07:57 EST
Date: Thu, 6 Feb 2014 13:37:11 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>, Viresh Kumar <viresh.linux@gmail.com>,
        Tejun Heo <tj@kernel.org>, spear-devel <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 5/8] SPEAr13xx: Fixup: Move SPEAr1340 SATA platform
 code to phy driver
Message-ID: <20140206080710.GD2394@pratyush-vbox>
References: <cover.1391661589.git.pratyush.anand@st.com>
 <ab13bc3c8147974e58425604667737723c3aa3a6.1391661589.git.pratyush.anand@st.com>
 <52F32C8A.5060100@ti.com>
 <20140206070053.GC2394@pratyush-vbox>
 <52F34155.8010900@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52F34155.8010900@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 04:01:25PM +0800, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Thursday 06 February 2014 12:30 PM, Pratyush Anand wrote:
> > On Thu, Feb 06, 2014 at 02:32:42PM +0800, Kishon Vijay Abraham I wrote:
> >> Hi,
> >>
> >> On Thursday 06 February 2014 10:14 AM, Pratyush Anand wrote:
> >>> ahci driver needs some platform specific functions which are called at
> >>> init, exit, suspend and resume conditions. Till now these functions were
> >>> present in a platform driver with a fixme notes.
> >>>
> >>> Similar functions modifying same set of registers will also be needed in
> >>> case of PCIe phy init/exit.
> >>>
> >>> So move all these SATA platform code to phy-miphy40lp driver.
> >>>
> >>> Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
> >>> Tested-by: Mohit Kumar <mohit.kumar@st.com>
> >>> Cc: Viresh Kumar <viresh.linux@gmail.com>
> >>> Cc: Tejun Heo <tj@kernel.org>
> >>> Cc: Arnd Bergmann <arnd@arndb.de>
> >>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> >>> Cc: spear-devel@list.st.com
> >>> Cc: linux-arm-kernel@lists.infradead.org
> >>> Cc: devicetree@vger.kernel.org
> >>> Cc: linux-ide@vger.kernel.org
> >>> Cc: linux-kernel@vger.kernel.org
> >>> ---
> >>>  .../devicetree/bindings/arm/spear-misc.txt         |   4 +
> >>>  arch/arm/boot/dts/spear1310-evb.dts                |   4 +
> >>>  arch/arm/boot/dts/spear1310.dtsi                   |  39 +++-
> >>>  arch/arm/boot/dts/spear1340-evb.dts                |   4 +
> >>>  arch/arm/boot/dts/spear1340.dtsi                   |  13 +-
> >>>  arch/arm/boot/dts/spear13xx.dtsi                   |   5 +
> >>>  arch/arm/mach-spear/Kconfig                        |   2 +
> >>>  arch/arm/mach-spear/spear1340.c                    | 127 +------------
> >>>  drivers/phy/phy-miphy40lp.c                        | 204 ++++++++++++++++++++-
> >>
> >> It would be better if you can split this patch. Keep arch/ in separate patch
> >> and drivers/ in separate patch.
> > 
> > Code is actually moving from arch to driver. Therefore I kept it in
> > same patch.
> > 
> >>>  9 files changed, 266 insertions(+), 136 deletions(-)
> >>>  create mode 100644 Documentation/devicetree/bindings/arm/spear-misc.txt
> >>>
> >> .
> >> .
> >> <snip>
> >> .
> >> .
> >>>  static const char * const spear1340_dt_board_compat[] = {
> >>> diff --git a/drivers/phy/phy-miphy40lp.c b/drivers/phy/phy-miphy40lp.c
> >>> index d478c14..cc7f45d 100644
> >>> --- a/drivers/phy/phy-miphy40lp.c
> >>> +++ b/drivers/phy/phy-miphy40lp.c
> >>> @@ -8,6 +8,7 @@
> >>>   * it under the terms of the GNU General Public License version 2 as
> >>>   * published by the Free Software Foundation.
> >>>   *
> >>> + * 04/02/2014: Adding support of SATA mode for SPEAr1340.
> >>>   */
> >>>  
> >>>  #include <linux/delay.h>
> >>> @@ -19,6 +20,60 @@
> >>>  #include <linux/phy/phy.h>
> >>>  #include <linux/regmap.h>
> >>>  
> >>> +/* SPEAr1340 Registers */
> >>> +/* Power Management Registers */
> >>> +#define SPEAR1340_PCM_CFG			0x100
> >>> +	#define SPEAR1340_PCM_CFG_SATA_POWER_EN	0x800
> >>> +#define SPEAR1340_PCM_WKUP_CFG			0x104
> >>> +#define SPEAR1340_SWITCH_CTR			0x108
> >>> +
> >>> +#define SPEAR1340_PERIP1_SW_RST			0x318
> >>> +	#define SPEAR1340_PERIP1_SW_RST_SATA	0x1000
> >>> +#define SPEAR1340_PERIP2_SW_RST			0x31C
> >>> +#define SPEAR1340_PERIP3_SW_RST			0x320
> >>> +
> >>> +/* PCIE - SATA configuration registers */
> >>> +#define SPEAR1340_PCIE_SATA_CFG			0x424
> >>> +	/* PCIE CFG MASks */
> >>> +	#define SPEAR1340_PCIE_CFG_DEVICE_PRESENT	(1 << 11)
> >>
> >> use BIT() wherever possible.
> > 
> > OK.
> > 
> >>> +	#define SPEAR1340_PCIE_CFG_POWERUP_RESET	(1 << 10)
> >>> +	#define SPEAR1340_PCIE_CFG_CORE_CLK_EN		(1 << 9)
> >>> +	#define SPEAR1340_PCIE_CFG_AUX_CLK_EN		(1 << 8)
> >>> +	#define SPEAR1340_SATA_CFG_TX_CLK_EN		(1 << 4)
> >>> +	#define SPEAR1340_SATA_CFG_RX_CLK_EN		(1 << 3)
> >>> +	#define SPEAR1340_SATA_CFG_POWERUP_RESET	(1 << 2)
> >>> +	#define SPEAR1340_SATA_CFG_PM_CLK_EN		(1 << 1)
> >>> +	#define SPEAR1340_PCIE_SATA_SEL_PCIE		(0)
> >>> +	#define SPEAR1340_PCIE_SATA_SEL_SATA		(1)
> >>> +	#define SPEAR1340_PCIE_SATA_CFG_MASK		0xF1F
> >>> +	#define SPEAR1340_PCIE_CFG_VAL	(SPEAR1340_PCIE_SATA_SEL_PCIE | \
> >>> +			SPEAR1340_PCIE_CFG_AUX_CLK_EN | \
> >>> +			SPEAR1340_PCIE_CFG_CORE_CLK_EN | \
> >>> +			SPEAR1340_PCIE_CFG_POWERUP_RESET | \
> >>> +			SPEAR1340_PCIE_CFG_DEVICE_PRESENT)
> >>> +	#define SPEAR1340_SATA_CFG_VAL	(SPEAR1340_PCIE_SATA_SEL_SATA | \
> >>> +			SPEAR1340_SATA_CFG_PM_CLK_EN | \
> >>> +			SPEAR1340_SATA_CFG_POWERUP_RESET | \
> >>> +			SPEAR1340_SATA_CFG_RX_CLK_EN | \
> >>> +			SPEAR1340_SATA_CFG_TX_CLK_EN)
> >>> +
> >>> +#define SPEAR1340_PCIE_MIPHY_CFG		0x428
> >>> +	#define SPEAR1340_MIPHY_OSC_BYPASS_EXT		(1 << 31)
> >>> +	#define SPEAR1340_MIPHY_CLK_REF_DIV2		(1 << 27)
> >>> +	#define SPEAR1340_MIPHY_CLK_REF_DIV4		(2 << 27)
> >>> +	#define SPEAR1340_MIPHY_CLK_REF_DIV8		(3 << 27)
> >>> +	#define SPEAR1340_MIPHY_PLL_RATIO_TOP(x)	(x << 0)
> >>> +	#define SPEAR1340_PCIE_MIPHY_CFG_MASK		0xF80000FF
> >>> +	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA \
> >>> +			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
> >>> +			SPEAR1340_MIPHY_CLK_REF_DIV2 | \
> >>> +			SPEAR1340_MIPHY_PLL_RATIO_TOP(60))
> >>> +	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK \
> >>> +			(SPEAR1340_MIPHY_PLL_RATIO_TOP(120))
> >>> +	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_PCIE \
> >>> +			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
> >>> +			SPEAR1340_MIPHY_PLL_RATIO_TOP(25))
> >>> +
> >>>  enum phy_mode {
> >>>  	SATA,
> >>>  	PCIE,
> >>> @@ -38,28 +93,145 @@ struct st_miphy40lp_priv {
> >>>  	u32			id;
> >>>  };
> >>>  
> >>> +static int spear1340_sata_miphy_init(struct st_miphy40lp_priv *phypriv)
> >>
> >> The function name format here differs from what you have already added. It will
> >> be good to have consistent name in the file.
> > 
> > You mean to pass "struct phy *phy" in all the internal functions too?
> 
> No. I meant let all the function names begin with miphy40lp_.

okkk.. miphy40lp_spear1340_sata_init looks better :)

Rgds
Pratyush

