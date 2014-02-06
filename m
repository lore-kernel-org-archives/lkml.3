Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbaBFIC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:02:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51404 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbaBFICN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:02:13 -0500
Message-ID: <52F34155.8010900@ti.com>
Date: Thu, 6 Feb 2014 13:31:25 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pratyush Anand <pratyush.anand@st.com>
CC: "arnd@arndb.de" <arnd@arndb.de>, Viresh Kumar <viresh.linux@gmail.com>,
        Tejun Heo <tj@kernel.org>, spear-devel <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 5/8] SPEAr13xx: Fixup: Move SPEAr1340 SATA platform
 code to phy driver
References: <cover.1391661589.git.pratyush.anand@st.com> <ab13bc3c8147974e58425604667737723c3aa3a6.1391661589.git.pratyush.anand@st.com> <52F32C8A.5060100@ti.com> <20140206070053.GC2394@pratyush-vbox>
In-Reply-To: <20140206070053.GC2394@pratyush-vbox>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 06 February 2014 12:30 PM, Pratyush Anand wrote:
> On Thu, Feb 06, 2014 at 02:32:42PM +0800, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Thursday 06 February 2014 10:14 AM, Pratyush Anand wrote:
>>> ahci driver needs some platform specific functions which are called at
>>> init, exit, suspend and resume conditions. Till now these functions were
>>> present in a platform driver with a fixme notes.
>>>
>>> Similar functions modifying same set of registers will also be needed in
>>> case of PCIe phy init/exit.
>>>
>>> So move all these SATA platform code to phy-miphy40lp driver.
>>>
>>> Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
>>> Tested-by: Mohit Kumar <mohit.kumar@st.com>
>>> Cc: Viresh Kumar <viresh.linux@gmail.com>
>>> Cc: Tejun Heo <tj@kernel.org>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
>>> Cc: spear-devel@list.st.com
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: devicetree@vger.kernel.org
>>> Cc: linux-ide@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>  .../devicetree/bindings/arm/spear-misc.txt         |   4 +
>>>  arch/arm/boot/dts/spear1310-evb.dts                |   4 +
>>>  arch/arm/boot/dts/spear1310.dtsi                   |  39 +++-
>>>  arch/arm/boot/dts/spear1340-evb.dts                |   4 +
>>>  arch/arm/boot/dts/spear1340.dtsi                   |  13 +-
>>>  arch/arm/boot/dts/spear13xx.dtsi                   |   5 +
>>>  arch/arm/mach-spear/Kconfig                        |   2 +
>>>  arch/arm/mach-spear/spear1340.c                    | 127 +------------
>>>  drivers/phy/phy-miphy40lp.c                        | 204 ++++++++++++++++++++-
>>
>> It would be better if you can split this patch. Keep arch/ in separate patch
>> and drivers/ in separate patch.
> 
> Code is actually moving from arch to driver. Therefore I kept it in
> same patch.
> 
>>>  9 files changed, 266 insertions(+), 136 deletions(-)
>>>  create mode 100644 Documentation/devicetree/bindings/arm/spear-misc.txt
>>>
>> .
>> .
>> <snip>
>> .
>> .
>>>  static const char * const spear1340_dt_board_compat[] = {
>>> diff --git a/drivers/phy/phy-miphy40lp.c b/drivers/phy/phy-miphy40lp.c
>>> index d478c14..cc7f45d 100644
>>> --- a/drivers/phy/phy-miphy40lp.c
>>> +++ b/drivers/phy/phy-miphy40lp.c
>>> @@ -8,6 +8,7 @@
>>>   * it under the terms of the GNU General Public License version 2 as
>>>   * published by the Free Software Foundation.
>>>   *
>>> + * 04/02/2014: Adding support of SATA mode for SPEAr1340.
>>>   */
>>>  
>>>  #include <linux/delay.h>
>>> @@ -19,6 +20,60 @@
>>>  #include <linux/phy/phy.h>
>>>  #include <linux/regmap.h>
>>>  
>>> +/* SPEAr1340 Registers */
>>> +/* Power Management Registers */
>>> +#define SPEAR1340_PCM_CFG			0x100
>>> +	#define SPEAR1340_PCM_CFG_SATA_POWER_EN	0x800
>>> +#define SPEAR1340_PCM_WKUP_CFG			0x104
>>> +#define SPEAR1340_SWITCH_CTR			0x108
>>> +
>>> +#define SPEAR1340_PERIP1_SW_RST			0x318
>>> +	#define SPEAR1340_PERIP1_SW_RST_SATA	0x1000
>>> +#define SPEAR1340_PERIP2_SW_RST			0x31C
>>> +#define SPEAR1340_PERIP3_SW_RST			0x320
>>> +
>>> +/* PCIE - SATA configuration registers */
>>> +#define SPEAR1340_PCIE_SATA_CFG			0x424
>>> +	/* PCIE CFG MASks */
>>> +	#define SPEAR1340_PCIE_CFG_DEVICE_PRESENT	(1 << 11)
>>
>> use BIT() wherever possible.
> 
> OK.
> 
>>> +	#define SPEAR1340_PCIE_CFG_POWERUP_RESET	(1 << 10)
>>> +	#define SPEAR1340_PCIE_CFG_CORE_CLK_EN		(1 << 9)
>>> +	#define SPEAR1340_PCIE_CFG_AUX_CLK_EN		(1 << 8)
>>> +	#define SPEAR1340_SATA_CFG_TX_CLK_EN		(1 << 4)
>>> +	#define SPEAR1340_SATA_CFG_RX_CLK_EN		(1 << 3)
>>> +	#define SPEAR1340_SATA_CFG_POWERUP_RESET	(1 << 2)
>>> +	#define SPEAR1340_SATA_CFG_PM_CLK_EN		(1 << 1)
>>> +	#define SPEAR1340_PCIE_SATA_SEL_PCIE		(0)
>>> +	#define SPEAR1340_PCIE_SATA_SEL_SATA		(1)
>>> +	#define SPEAR1340_PCIE_SATA_CFG_MASK		0xF1F
>>> +	#define SPEAR1340_PCIE_CFG_VAL	(SPEAR1340_PCIE_SATA_SEL_PCIE | \
>>> +			SPEAR1340_PCIE_CFG_AUX_CLK_EN | \
>>> +			SPEAR1340_PCIE_CFG_CORE_CLK_EN | \
>>> +			SPEAR1340_PCIE_CFG_POWERUP_RESET | \
>>> +			SPEAR1340_PCIE_CFG_DEVICE_PRESENT)
>>> +	#define SPEAR1340_SATA_CFG_VAL	(SPEAR1340_PCIE_SATA_SEL_SATA | \
>>> +			SPEAR1340_SATA_CFG_PM_CLK_EN | \
>>> +			SPEAR1340_SATA_CFG_POWERUP_RESET | \
>>> +			SPEAR1340_SATA_CFG_RX_CLK_EN | \
>>> +			SPEAR1340_SATA_CFG_TX_CLK_EN)
>>> +
>>> +#define SPEAR1340_PCIE_MIPHY_CFG		0x428
>>> +	#define SPEAR1340_MIPHY_OSC_BYPASS_EXT		(1 << 31)
>>> +	#define SPEAR1340_MIPHY_CLK_REF_DIV2		(1 << 27)
>>> +	#define SPEAR1340_MIPHY_CLK_REF_DIV4		(2 << 27)
>>> +	#define SPEAR1340_MIPHY_CLK_REF_DIV8		(3 << 27)
>>> +	#define SPEAR1340_MIPHY_PLL_RATIO_TOP(x)	(x << 0)
>>> +	#define SPEAR1340_PCIE_MIPHY_CFG_MASK		0xF80000FF
>>> +	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA \
>>> +			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
>>> +			SPEAR1340_MIPHY_CLK_REF_DIV2 | \
>>> +			SPEAR1340_MIPHY_PLL_RATIO_TOP(60))
>>> +	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK \
>>> +			(SPEAR1340_MIPHY_PLL_RATIO_TOP(120))
>>> +	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_PCIE \
>>> +			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
>>> +			SPEAR1340_MIPHY_PLL_RATIO_TOP(25))
>>> +
>>>  enum phy_mode {
>>>  	SATA,
>>>  	PCIE,
>>> @@ -38,28 +93,145 @@ struct st_miphy40lp_priv {
>>>  	u32			id;
>>>  };
>>>  
>>> +static int spear1340_sata_miphy_init(struct st_miphy40lp_priv *phypriv)
>>
>> The function name format here differs from what you have already added. It will
>> be good to have consistent name in the file.
> 
> You mean to pass "struct phy *phy" in all the internal functions too?

No. I meant let all the function names begin with miphy40lp_.
> 
>>> +{
>>> +	regmap_update_bits(phypriv->misc, SPEAR1340_PCIE_SATA_CFG,
>>> +			SPEAR1340_PCIE_SATA_CFG_MASK, SPEAR1340_SATA_CFG_VAL);
>>> +	regmap_update_bits(phypriv->misc, SPEAR1340_PCIE_MIPHY_CFG,
>>> +			SPEAR1340_PCIE_MIPHY_CFG_MASK,
>>> +			SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK);
>>> +	/* Switch on sata power domain */
>>> +	regmap_update_bits(phypriv->misc, SPEAR1340_PCM_CFG,
>>> +			SPEAR1340_PCM_CFG_SATA_POWER_EN,
>>> +			SPEAR1340_PCM_CFG_SATA_POWER_EN);
>>> +	msleep(20);
>>> +	/* Disable PCIE SATA Controller reset */
>>> +	regmap_update_bits(phypriv->misc, SPEAR1340_PERIP1_SW_RST,
>>> +			SPEAR1340_PERIP1_SW_RST_SATA, 0);
>>> +	msleep(20);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int spear1340_sata_miphy_exit(struct st_miphy40lp_priv *phypriv)
>>> +{
>>> +	regmap_update_bits(phypriv->misc, SPEAR1340_PCIE_SATA_CFG,
>>> +			SPEAR1340_PCIE_SATA_CFG_MASK, 0);
>>> +	regmap_update_bits(phypriv->misc, SPEAR1340_PCIE_MIPHY_CFG,
>>> +			SPEAR1340_PCIE_MIPHY_CFG_MASK, 0);
>>> +
>>> +	/* Enable PCIE SATA Controller reset */
>>> +	regmap_update_bits(phypriv->misc, SPEAR1340_PERIP1_SW_RST,
>>> +			SPEAR1340_PERIP1_SW_RST_SATA,
>>> +			SPEAR1340_PERIP1_SW_RST_SATA);
>>> +	msleep(20);
>>> +	/* Switch off sata power domain */
>>> +	regmap_update_bits(phypriv->misc, SPEAR1340_PCM_CFG,
>>> +			SPEAR1340_PCM_CFG_SATA_POWER_EN, 0);
>>> +	msleep(20);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int sata_miphy_init(struct st_miphy40lp_priv *phypriv)
>>> +{
>>> +	if (of_device_is_compatible(phypriv->np, "st,spear1340-miphy"))
>>
>> This compatible value is a bit confusing since it doesn't have 'sata' in it.
>> spear1340 can have usb phy or pcie phy too no? How do we differentiate it then?
> 
> same spear1340 miphy is used for sata as well as for pcie. sata or
> pcie mode is selected using mode args passed in phys.

Alright. Got it while reading the next patch ;-)

Thanks
Kishon
