Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbaBZJnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:43:43 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57837 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbaBZJnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:43:37 -0500
Message-ID: <530DB713.6000701@ti.com>
Date: Wed, 26 Feb 2014 15:12:43 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Loc Ho <lho@apm.com>, <tj@kernel.org>
CC: <olof@lixom.net>, <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <ddutile@redhat.com>, <jcm@redhat.com>, <patches@apm.com>,
        Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
Subject: Re: [PATCH RESEND v10 3/4] PHY: add APM X-Gene SoC 15Gbps Multi-purpose
 PHY driver
References: <1393308882-3964-1-git-send-email-lho@apm.com> <1393308882-3964-2-git-send-email-lho@apm.com> <1393308882-3964-3-git-send-email-lho@apm.com> <1393308882-3964-4-git-send-email-lho@apm.com>
In-Reply-To: <1393308882-3964-4-git-send-email-lho@apm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 February 2014 11:44 AM, Loc Ho wrote:
> This patch adds support for APM X-Gene SoC 15Gbps Multi-purpose PHY.
> This is the physical layer interface for the corresponding host
> controller. Currently, only external clock and SATA mode
> are supported.
>
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>  drivers/phy/Kconfig     |    7 +
>  drivers/phy/Makefile    |    2 +
>  drivers/phy/phy-xgene.c | 1826 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1835 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/phy/phy-xgene.c
>
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index afa2354..229db49 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -64,4 +64,11 @@ config BCM_KONA_USB2_PHY
>  	help
>  	  Enable this to support the Broadcom Kona USB 2.0 PHY.
>
> +config PHY_XGENE
> +	tristate "APM X-Gene 15Gbps PHY support"
> +	depends on ARM64 || COMPILE_TEST
> +	select GENERIC_PHY

depends on HAS_IOMEM and CONFIG_OF..
> +	help
> +	  This option enables support for APM X-Gene SoC multi-purpose PHY.
> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index b57c253..dee70f4 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -9,3 +9,5 @@ obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>  obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
>  obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
>  obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
> +obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
> +
> diff --git a/drivers/phy/phy-xgene.c b/drivers/phy/phy-xgene.c
> new file mode 100644
> index 0000000..653868d
> --- /dev/null
> +++ b/drivers/phy/phy-xgene.c
> @@ -0,0 +1,1826 @@
> +/*
> + * AppliedMicro X-Gene Multi-purpose PHY driver
> + *
> + * Copyright (c) 2014, Applied Micro Circuits Corporation
> + * Author: Loc Ho <lho@apm.com>
> + *         Tuan Phan <tphan@apm.com>
> + *         Suman Tripathi <stripathi@apm.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + *
> + * The APM X-Gene PHY consists of two PLL clock macro's (CMU) and lanes.
> + * The first PLL clock macro is used for internal reference clock. The second
> + * PLL clock macro is used to generate the clock for the PHY. This driver
> + * configures the first PLL CMU, the second PLL CMU, and programs the PHY to
> + * operate according to the mode of operation. The first PLL CMU is only
> + * required if internal clock is enabled.
> + *
> + * Logical Layer Out Of HW module units:
> + *
> + * -----------------
> + * | Internal      |    |------|
> + * | Ref PLL CMU   |----|      |     -------------    ---------
> + * ------------ ----    | MUX  |-----|PHY PLL CMU|----| Serdes|
> + *                      |      |     |           |    ---------
> + * External Clock ------|      |     -------------
> + *                      |------|
> + *
> + * The Ref PLL CMU CSR (Configureation System Registers) is accessed

%s/Configureation/Configuration
> + * indirectly from the SDS offset at 0x2000. It is only required for
> + * internal reference clock.
> + * The PHY PLL CMU CSR is accessed indirectly from the SDS offset at 0x0000.
> + * The Serdes CSR is accessed indirectly from the SDS offset at 0x0400.
> + *
> + * The Ref PLL CMU can be located within the same PHY IP or outside the PHY IP
> + * due to shared Ref PLL CMU. For PHY with Ref PLL CMU shared with another IP,
> + * it is located outside the PHY IP. This is the case for the PHY located
> + * at 0x1f23a000 (SATA Port 4/5). For such PHY, another resource is required
> + * to located the SDS/Ref PLL CMU module and its clock for that IP enabled.
> + *
> + * Currently, this driver only supports SATA mode with external clock.
> + */
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/phy/phy.h>
> +#include <linux/clk.h>
> +
> +/* Max 2 lanes per a PHY unit */
> +#define MAX_LANE			2
> +
> +/* Register offset inside the PHY */
> +#define SERDES_PLL_INDIRECT_OFFSET	0x0000
> +#define SERDES_PLL_REF_INDIRECT_OFFSET	0x2000
> +#define SERDES_INDIRECT_OFFSET		0x0400
> +#define SERDES_LANE_STRIDE		0x0200
> +
> +/* Some default Serdes parameters */
> +#define DEFAULT_SATA_TXBOOST_GAIN	{ 0x1e, 0x1e, 0x1e }
> +#define DEFAULT_SATA_TXEYEDIRECTION	{ 0x0, 0x0, 0x0 }
> +#define DEFAULT_SATA_TXEYETUNING	{ 0xa, 0xa, 0xa }
> +#define DEFAULT_SATA_SPD_SEL		{ 0x1, 0x3, 0x7 }
> +#define DEFAULT_SATA_TXAMP		{ 0x8, 0x8, 0x8 }
> +#define DEFAULT_SATA_TXCN1		{ 0x2, 0x2, 0x2 }
> +#define DEFAULT_SATA_TXCN2		{ 0x0, 0x0, 0x0 }
> +#define DEFAULT_SATA_TXCP1		{ 0xa, 0xa, 0xa }
> +
> +#define SATA_SPD_SEL_GEN3		0x7
> +#define SATA_SPD_SEL_GEN2		0x3
> +#define SATA_SPD_SEL_GEN1		0x1
> +
> +#define SSC_DISABLE			0
> +#define SSC_ENABLE			1
> +
> +#define FBDIV_VAL_50M			0x77
> +#define REFDIV_VAL_50M			0x1
> +#define FBDIV_VAL_100M			0x3B
> +#define REFDIV_VAL_100M			0x0
> +
> +/* SATA Clock/Reset CSR */
> +#define SATACLKENREG			0x00000000
> +#define  SATA0_CORE_CLKEN		0x00000002
> +#define  SATA1_CORE_CLKEN		0x00000004
> +#define SATASRESETREG			0x00000004
> +#define  SATA_MEM_RESET_MASK		0x00000020
> +#define  SATA_MEM_RESET_RD(src)		(((src) & 0x00000020) >> 5)
> +#define  SATA_SDS_RESET_MASK		0x00000004
> +#define  SATA_CSR_RESET_MASK		0x00000001
> +#define  SATA_CORE_RESET_MASK		0x00000002
> +#define  SATA_PMCLK_RESET_MASK		0x00000010
> +#define  SATA_PCLK_RESET_MASK		0x00000008
> +
> +/* SDS CSR used for PHY Indirect access */
> +#define SATA_ENET_SDS_PCS_CTL0		0x00000000
> +#define  REGSPEC_CFG_I_TX_WORDMODE0_SET(dst, src) \
> +		(((dst) & ~0x00070000) | (((u32)(src)<<16) & 0x00070000))
> +#define  REGSPEC_CFG_I_RX_WORDMODE0_SET(dst, src) \
> +		(((dst) & ~0x00e00000) | (((u32)(src)<<21) & 0x00e00000))
> +#define SATA_ENET_SDS_CTL0		0x0000000c
> +#define  REGSPEC_CFG_I_CUSTOMER_PIN_MODE0_SET(dst, src) \
> +		(((dst) & ~0x00007fff) | (((u32)(src)) & 0x00007fff))
> +#define SATA_ENET_SDS_CTL1		0x00000010
> +#define  CFG_I_SPD_SEL_CDR_OVR1_SET(dst, src) \
> +		(((dst) & ~0x0000000f) | (((u32)(src)) & 0x0000000f))
> +#define SATA_ENET_SDS_RST_CTL		0x00000024
> +#define SATA_ENET_SDS_IND_CMD_REG	0x0000003c
> +#define  CFG_IND_WR_CMD_MASK		0x00000001
> +#define  CFG_IND_RD_CMD_MASK		0x00000002
> +#define  CFG_IND_CMD_DONE_MASK		0x00000004
> +#define  CFG_IND_ADDR_SET(dst, src) \
> +		(((dst) & ~0x003ffff0) | (((u32)(src)<<4) & 0x003ffff0))
> +#define SATA_ENET_SDS_IND_RDATA_REG	0x00000040
> +#define SATA_ENET_SDS_IND_WDATA_REG	0x00000044
> +#define SATA_ENET_CLK_MACRO_REG		0x0000004c
> +#define  I_RESET_B_SET(dst, src) \
> +		(((dst) & ~0x00000001) | (((u32)(src)) & 0x00000001))
> +#define  I_PLL_FBDIV_SET(dst, src) \
> +		(((dst) & ~0x001ff000) | (((u32)(src)<<12) & 0x001ff000))
> +#define  I_CUSTOMEROV_SET(dst, src) \
> +		(((dst) & ~0x00000f80) | (((u32)(src)<<7) & 0x00000f80))
> +#define  O_PLL_LOCK_RD(src)		(((src) & 0x40000000)>>30)
> +#define  O_PLL_READY_RD(src)		(((src) & 0x80000000)>>31)
> +
> +/* PLL Clock Macro Unit (CMU) CSR accessing from SDS indirectly */
> +#define CMU_REG0			0x00000
> +#define  CMU_REG0_PLL_REF_SEL_MASK	0x00002000
> +#define  CMU_REG0_PLL_REF_SEL_SET(dst, src)	\
> +		(((dst) & ~0x00002000) | (((u32)(src) << 0xd) & 0x00002000))

using decimals for shift value would be better. No strong feeling though.
> +#define  CMU_REG0_PDOWN_MASK		0x00004000
> +#define  CMU_REG0_CAL_COUNT_RESOL_SET(dst, src) \
> +		(((dst) & ~0x000000e0) | (((u32)(src) << 0x5) & 0x000000e0))
> +#define CMU_REG1			0x00002
> +#define  CMU_REG1_PLL_CP_SET(dst, src) \
> +		(((dst) & ~0x00003c00) | (((u32)(src) << 0xa) & 0x00003c00))
> +#define  CMU_REG1_PLL_MANUALCAL_SET(dst, src) \
> +		(((dst) & ~0x00000008) | (((u32)(src) << 0x3) & 0x00000008))
> +#define  CMU_REG1_PLL_CP_SEL_SET(dst, src) \
> +		(((dst) & ~0x000003e0) | (((u32)(src) << 0x5) & 0x000003e0))
> +#define  CMU_REG1_REFCLK_CMOS_SEL_MASK	0x00000001
> +#define  CMU_REG1_REFCLK_CMOS_SEL_SET(dst, src)	\
> +		(((dst) & ~0x00000001) | (((u32)(src) << 0x0) & 0x00000001))
> +#define CMU_REG2			0x00004
> +#define  CMU_REG2_PLL_REFDIV_SET(dst, src) \
> +		(((dst) & ~0x0000c000) | (((u32)(src) << 0xe) & 0x0000c000))
> +#define  CMU_REG2_PLL_LFRES_SET(dst, src) \
> +		(((dst) & ~0x0000001e) | (((u32)(src) << 0x1) & 0x0000001e))
> +#define  CMU_REG2_PLL_FBDIV_SET(dst, src) \
> +		(((dst) & ~0x00003fe0) | (((u32)(src) << 0x5) & 0x00003fe0))
> +#define CMU_REG3			0x00006
> +#define  CMU_REG3_VCOVARSEL_SET(dst, src) \
> +		(((dst) & ~0x0000000f) | (((u32)(src) << 0x0) & 0x0000000f))
> +#define  CMU_REG3_VCO_MOMSEL_INIT_SET(dst, src) \
> +		(((dst) & ~0x000003f0) | (((u32)(src) << 0x4) & 0x000003f0))
> +#define  CMU_REG3_VCO_MANMOMSEL_SET(dst, src) \
> +		(((dst) & ~0x0000fc00) | (((u32)(src) << 0xa) & 0x0000fc00))
> +#define CMU_REG4			0x00008
> +#define CMU_REG5			0x0000a
> +#define  CMU_REG5_PLL_LFSMCAP_SET(dst, src) \
> +		(((dst) & ~0x0000c000) | (((u32)(src) << 0xe) & 0x0000c000))
> +#define  CMU_REG5_PLL_LOCK_RESOLUTION_SET(dst, src) \
> +		(((dst) & ~0x0000000e) | (((u32)(src) << 0x1) & 0x0000000e))
> +#define  CMU_REG5_PLL_LFCAP_SET(dst, src) \
> +		(((dst) & ~0x00003000) | (((u32)(src) << 0xc) & 0x00003000))
> +#define  CMU_REG5_PLL_RESETB_MASK	0x00000001
> +#define CMU_REG6			0x0000c
> +#define  CMU_REG6_PLL_VREGTRIM_SET(dst, src) \
> +		(((dst) & ~0x00000600) | (((u32)(src) << 0x9) & 0x00000600))
> +#define  CMU_REG6_MAN_PVT_CAL_SET(dst, src) \
> +		(((dst) & ~0x00000004) | (((u32)(src) << 0x2) & 0x00000004))
> +#define CMU_REG7			0x0000e
> +#define  CMU_REG7_PLL_CALIB_DONE_RD(src) \
> +		((0x00004000 & (u32)(src)) >> 0xe)
> +#define  CMU_REG7_VCO_CAL_FAIL_RD(src) \
> +		((0x00000c00 & (u32)(src)) >> 0xa)
> +#define CMU_REG8			0x00010
> +#define CMU_REG9			0x00012
> +#define  CMU_REG9_WORD_LEN_8BIT		0x000
> +#define  CMU_REG9_WORD_LEN_10BIT	0x001
> +#define  CMU_REG9_WORD_LEN_16BIT	0x002
> +#define  CMU_REG9_WORD_LEN_20BIT	0x003
> +#define  CMU_REG9_WORD_LEN_32BIT	0x004
> +#define  CMU_REG9_WORD_LEN_40BIT	0x005
> +#define  CMU_REG9_WORD_LEN_64BIT	0x006
> +#define  CMU_REG9_WORD_LEN_66BIT	0x007
> +#define  CMU_REG9_TX_WORD_MODE_CH1_SET(dst, src) \
> +		(((dst) & ~0x00000380) | (((u32)(src) << 0x7) & 0x00000380))
> +#define  CMU_REG9_TX_WORD_MODE_CH0_SET(dst, src) \
> +		(((dst) & ~0x00000070) | (((u32)(src) << 0x4) & 0x00000070))
> +#define  CMU_REG9_PLL_POST_DIVBY2_SET(dst, src) \
> +		(((dst) & ~0x00000008) | (((u32)(src) << 0x3) & 0x00000008))
> +#define  CMU_REG9_VBG_BYPASSB_SET(dst, src) \
> +		(((dst) & ~0x00000004) | (((u32)(src) << 0x2) & 0x00000004))
> +#define  CMU_REG9_IGEN_BYPASS_SET(dst, src) \
> +		(((dst) & ~0x00000002) | (((u32)(src) << 0x1) & 0x00000002))
> +#define CMU_REG10			0x00014
> +#define  CMU_REG10_VREG_REFSEL_SET(dst, src) \
> +		(((dst) & ~0x00000001) | (((u32)(src) << 0x0) & 0x00000001))
> +#define CMU_REG11			0x00016
> +#define CMU_REG12			0x00018
> +#define  CMU_REG12_STATE_DELAY9_SET(dst, src) \
> +		(((dst) & ~0x000000f0) | (((u32)(src) << 0x4) & 0x000000f0))
> +#define CMU_REG13			0x0001a
> +#define CMU_REG14			0x0001c
> +#define CMU_REG15			0x0001e
> +#define CMU_REG16			0x00020
> +#define  CMU_REG16_PVT_DN_MAN_ENA_MASK	0x00000001
> +#define  CMU_REG16_PVT_UP_MAN_ENA_MASK	0x00000002
> +#define  CMU_REG16_VCOCAL_WAIT_BTW_CODE_SET(dst, src) \
> +		(((dst) & ~0x0000001c) | (((u32)(src) << 0x2) & 0x0000001c))
> +#define  CMU_REG16_CALIBRATION_DONE_OVERRIDE_SET(dst, src) \
> +		(((dst) & ~0x00000040) | (((u32)(src) << 0x6) & 0x00000040))
> +#define  CMU_REG16_BYPASS_PLL_LOCK_SET(dst, src) \
> +		(((dst) & ~0x00000020) | (((u32)(src) << 0x5) & 0x00000020))
> +#define CMU_REG17			0x00022
> +#define  CMU_REG17_PVT_CODE_R2A_SET(dst, src) \
> +		(((dst) & ~0x00007f00) | (((u32)(src) << 0x8) & 0x00007f00))
> +#define  CMU_REG17_RESERVED_7_SET(dst, src) \
> +		(((dst) & ~0x000000e0) | (((u32)(src) << 0x5) & 0x000000e0))
> +#define  CMU_REG17_PVT_TERM_MAN_ENA_MASK	0x00008000
> +#define CMU_REG18			0x00024
> +#define CMU_REG19			0x00026
> +#define CMU_REG20			0x00028
> +#define CMU_REG21			0x0002a
> +#define CMU_REG22			0x0002c
> +#define CMU_REG23			0x0002e
> +#define CMU_REG24			0x00030
> +#define CMU_REG25			0x00032
> +#define CMU_REG26			0x00034
> +#define  CMU_REG26_FORCE_PLL_LOCK_SET(dst, src) \
> +		(((dst) & ~0x00000001) | (((u32)(src) << 0x0) & 0x00000001))
> +#define CMU_REG27			0x00036
> +#define CMU_REG28			0x00038
> +#define CMU_REG29			0x0003a
> +#define CMU_REG30			0x0003c
> +#define  CMU_REG30_LOCK_COUNT_SET(dst, src) \
> +		(((dst) & ~0x00000006) | (((u32)(src) << 0x1) & 0x00000006))
> +#define  CMU_REG30_PCIE_MODE_SET(dst, src) \
> +		(((dst) & ~0x00000008) | (((u32)(src) << 0x3) & 0x00000008))
> +#define CMU_REG31			0x0003e
> +#define CMU_REG32			0x00040
> +#define  CMU_REG32_FORCE_VCOCAL_START_MASK	0x00004000
> +#define  CMU_REG32_PVT_CAL_WAIT_SEL_SET(dst, src) \
> +		(((dst) & ~0x00000006) | (((u32)(src) << 0x1) & 0x00000006))
> +#define  CMU_REG32_IREF_ADJ_SET(dst, src) \
> +		(((dst) & ~0x00000180) | (((u32)(src) << 0x7) & 0x00000180))
> +#define CMU_REG33			0x00042
> +#define CMU_REG34			0x00044
> +#define  CMU_REG34_VCO_CAL_VTH_LO_MAX_SET(dst, src) \
> +		(((dst) & ~0x0000000f) | (((u32)(src) << 0x0) & 0x0000000f))
> +#define  CMU_REG34_VCO_CAL_VTH_HI_MAX_SET(dst, src) \
> +		(((dst) & ~0x00000f00) | (((u32)(src) << 0x8) & 0x00000f00))
> +#define  CMU_REG34_VCO_CAL_VTH_LO_MIN_SET(dst, src) \
> +		(((dst) & ~0x000000f0) | (((u32)(src) << 0x4) & 0x000000f0))
> +#define  CMU_REG34_VCO_CAL_VTH_HI_MIN_SET(dst, src) \
> +		(((dst) & ~0x0000f000) | (((u32)(src) << 0xc) & 0x0000f000))
> +#define CMU_REG35			0x00046
> +#define  CMU_REG35_PLL_SSC_MOD_SET(dst, src) \
> +		(((dst) & ~0x0000fe00) | (((u32)(src) << 0x9) & 0x0000fe00))
> +#define CMU_REG36				0x00048
> +#define  CMU_REG36_PLL_SSC_EN_SET(dst, src) \
> +		(((dst) & ~0x00000010) | (((u32)(src) << 0x4) & 0x00000010))
> +#define  CMU_REG36_PLL_SSC_VSTEP_SET(dst, src) \
> +		(((dst) & ~0x0000ffc0) | (((u32)(src) << 0x6) & 0x0000ffc0))
> +#define  CMU_REG36_PLL_SSC_DSMSEL_SET(dst, src) \
> +		(((dst) & ~0x00000020) | (((u32)(src) << 0x5) & 0x00000020))
> +#define CMU_REG37			0x0004a
> +#define CMU_REG38			0x0004c
> +#define CMU_REG39			0x0004e
> +
> +/* PHY lane CSR accessing from SDS indirectly */
> +#define RXTX_REG0			0x000
> +#define  RXTX_REG0_CTLE_EQ_HR_SET(dst, src) \
> +		(((dst) & ~0x0000f800) | (((u32)(src) << 0xb) & 0x0000f800))
> +#define  RXTX_REG0_CTLE_EQ_QR_SET(dst, src) \
> +		(((dst) & ~0x000007c0) | (((u32)(src) << 0x6) & 0x000007c0))
> +#define  RXTX_REG0_CTLE_EQ_FR_SET(dst, src) \
> +		(((dst) & ~0x0000003e) | (((u32)(src) << 0x1) & 0x0000003e))
> +#define RXTX_REG1			0x002
> +#define  RXTX_REG1_RXACVCM_SET(dst, src) \
> +		(((dst) & ~0x0000f000) | (((u32)(src) << 0xc) & 0x0000f000))
> +#define  RXTX_REG1_CTLE_EQ_SET(dst, src) \
> +		(((dst) & ~0x00000f80) | (((u32)(src) << 0x7) & 0x00000f80))
> +#define  RXTX_REG1_RXVREG1_SET(dst, src) \
> +                (((dst) & ~0x00000060) | (((u32)(src) << 0x5) & 0x00000060))
> +#define  RXTX_REG1_RXIREF_ADJ_SET(dst, src) \
> +               (((dst) & ~0x00000006) | (((u32)(src) << 0x1) &  0x00000006))
> +#define RXTX_REG2			0x004
> +#define  RXTX_REG2_VTT_ENA_SET(dst, src) \
> +		(((dst) & ~0x00000100) | (((u32)(src) << 0x8) & 0x00000100))
> +#define  RXTX_REG2_TX_FIFO_ENA_SET(dst, src) \
> +		(((dst) & ~0x00000020) | (((u32)(src) << 0x5) & 0x00000020))
> +#define  RXTX_REG2_VTT_SEL_SET(dst, src) \
> +		(((dst) & ~0x000000c0) | (((u32)(src) << 0x6) & 0x000000c0))
> +#define RXTX_REG4			0x008
> +#define  RXTX_REG4_TX_LOOPBACK_BUF_EN_MASK	0x00000040
> +#define  RXTX_REG4_TX_DATA_RATE_SET(dst, src) \
> +		(((dst) & ~0x0000c000) | (((u32)(src) << 0xe) & 0x0000c000))
> +#define  RXTX_REG4_TX_WORD_MODE_SET(dst, src) \
> +		(((dst) & ~0x00003800) | (((u32)(src) << 0xb) & 0x00003800))
> +#define RXTX_REG5			0x00a
> +#define  RXTX_REG5_TX_CN1_SET(dst, src) \
> +		(((dst) & ~0x0000f800) | (((u32)(src) << 0xb) & 0x0000f800))
> +#define  RXTX_REG5_TX_CP1_SET(dst, src) \
> +		(((dst) & ~0x000007e0) | (((u32)(src) << 0x5) & 0x000007e0))
> +#define  RXTX_REG5_TX_CN2_SET(dst, src) \
> +		(((dst) & ~0x0000001f) | (((u32)(src) << 0x0) & 0x0000001f))
> +#define RXTX_REG6			0x00c
> +#define  RXTX_REG6_TXAMP_CNTL_SET(dst, src) \
> +		(((dst) & ~0x00000780) | (((u32)(src) << 0x7) & 0x00000780))
> +#define  RXTX_REG6_TXAMP_ENA_SET(dst, src) \
> +		(((dst) & ~0x00000040) | (((u32)(src) << 0x6) & 0x00000040))
> +#define  RXTX_REG6_RX_BIST_ERRCNT_RD_SET(dst, src) \
> +		(((dst) & ~0x00000001) | (((u32)(src) << 0x0) & 0x00000001))
> +#define  RXTX_REG6_TX_IDLE_SET(dst, src) \
> +		(((dst) & ~0x00000008) | (((u32)(src) << 0x3) & 0x00000008))
> +#define  RXTX_REG6_RX_BIST_RESYNC_SET(dst, src) \
> +		(((dst) & ~0x00000002) | (((u32)(src) << 0x1) & 0x00000002))
> +#define RXTX_REG7			0x00e
> +#define  RXTX_REG7_RESETB_RXD_MASK	0x00000100
> +#define  RXTX_REG7_RESETB_RXA_MASK	0x00000080
> +#define  RXTX_REG7_BIST_ENA_RX_SET(dst, src) \
> +		(((dst) & ~0x00000040) | (((u32)(src) << 0x6) & 0x00000040))
> +#define  RXTX_REG7_RX_WORD_MODE_SET(dst, src) \
> +		(((dst) & ~0x00003800) | (((u32)(src) << 0xb) & 0x00003800))
> +#define RXTX_REG8			0x010
> +#define  RXTX_REG8_CDR_LOOP_ENA_SET(dst, src) \
> +		(((dst) & ~0x00004000) | (((u32)(src) << 0xe) & 0x00004000))
> +#define  RXTX_REG8_CDR_BYPASS_RXLOS_SET(dst, src) \
> +		(((dst) & ~0x00000800) | (((u32)(src) << 0xb) & 0x00000800))
> +#define  RXTX_REG8_SSC_ENABLE_SET(dst, src) \
> +		(((dst) & ~0x00000200) | (((u32)(src) << 0x9) & 0x00000200))
> +#define  RXTX_REG8_SD_VREF_SET(dst, src) \
> +		(((dst) & ~0x000000f0) | (((u32)(src) << 0x4) & 0x000000f0))
> +#define  RXTX_REG8_SD_DISABLE_SET(dst, src) \
> +		(((dst) & ~0x00000100) | (((u32)(src) << 0x8) & 0x00000100))
> +#define RXTX_REG7			0x00e
> +#define  RXTX_REG7_RESETB_RXD_SET(dst, src) \
> +		(((dst) & ~0x00000100) | (((u32)(src) << 0x8) & 0x00000100))
> +#define  RXTX_REG7_RESETB_RXA_SET(dst, src) \
> +		(((dst) & ~0x00000080) | (((u32)(src) << 0x7) & 0x00000080))
> +#define  RXTX_REG7_LOOP_BACK_ENA_CTLE_MASK	0x00004000
> +#define  RXTX_REG7_LOOP_BACK_ENA_CTLE_SET(dst, src) \
> +		(((dst) & ~0x00004000) | (((u32)(src) << 0xe) & 0x00004000))
> +#define RXTX_REG11			0x016
> +#define  RXTX_REG11_PHASE_ADJUST_LIMIT_SET(dst, src) \
> +		(((dst) & ~0x0000f800) | (((u32)(src) << 0xb) & 0x0000f800))
> +#define RXTX_REG12			0x018
> +#define  RXTX_REG12_LATCH_OFF_ENA_SET(dst, src) \
> +		(((dst) & ~0x00002000) | (((u32)(src) << 0xd) & 0x00002000))
> +#define  RXTX_REG12_SUMOS_ENABLE_SET(dst, src) \
> +		(((dst) & ~0x00000004) | (((u32)(src) << 0x2) & 0x00000004))
> +#define  RXTX_REG12_RX_DET_TERM_ENABLE_MASK	0x00000002
> +#define  RXTX_REG12_RX_DET_TERM_ENABLE_SET(dst, src) \
> +		(((dst) & ~0x00000002) | (((u32)(src) << 0x1) & 0x00000002))
> +#define RXTX_REG13			0x01a
> +#define RXTX_REG14			0x01c
> +#define  RXTX_REG14_CLTE_LATCAL_MAN_PROG_SET(dst, src) \
> +		(((dst) & ~0x0000003f) | (((u32)(src) << 0x0) & 0x0000003f))
> +#define  RXTX_REG14_CTLE_LATCAL_MAN_ENA_SET(dst, src) \
> +		(((dst) & ~0x00000040) | (((u32)(src) << 0x6) & 0x00000040))
> +#define RXTX_REG26			0x034
> +#define  RXTX_REG26_PERIOD_ERROR_LATCH_SET(dst, src) \
> +		(((dst) & ~0x00003800) | (((u32)(src) << 0xb) & 0x00003800))
> +#define  RXTX_REG26_BLWC_ENA_SET(dst, src) \
> +		(((dst) & ~0x00000008) | (((u32)(src) << 0x3) & 0x00000008))
> +#define RXTX_REG21			0x02a
> +#define  RXTX_REG21_DO_LATCH_CALOUT_RD(src) \
> +		((0x0000fc00 & (u32)(src)) >> 0xa)
> +#define  RXTX_REG21_XO_LATCH_CALOUT_RD(src) \
> +		((0x000003f0 & (u32)(src)) >> 0x4)
> +#define  RXTX_REG21_LATCH_CAL_FAIL_ODD_RD(src) \
> +		((0x0000000f & (u32)(src)))
> +#define RXTX_REG22			0x02c
> +#define  RXTX_REG22_SO_LATCH_CALOUT_RD(src) \
> +		((0x000003f0 & (u32)(src)) >> 0x4)
> +#define  RXTX_REG22_EO_LATCH_CALOUT_RD(src) \
> +		((0x0000fc00 & (u32)(src)) >> 0xa)
> +#define  RXTX_REG22_LATCH_CAL_FAIL_EVEN_RD(src) \
> +		((0x0000000f & (u32)(src)))
> +#define RXTX_REG23			0x02e
> +#define  RXTX_REG23_DE_LATCH_CALOUT_RD(src) \
> +		((0x0000fc00 & (u32)(src)) >> 0xa)
> +#define  RXTX_REG23_XE_LATCH_CALOUT_RD(src) \
> +		((0x000003f0 & (u32)(src)) >> 0x4)
> +#define RXTX_REG24			0x030
> +#define  RXTX_REG24_EE_LATCH_CALOUT_RD(src) \
> +		((0x0000fc00 & (u32)(src)) >> 0xa)
> +#define  RXTX_REG24_SE_LATCH_CALOUT_RD(src) \
> +		((0x000003f0 & (u32)(src)) >> 0x4)
> +#define RXTX_REG27			0x036
> +#define RXTX_REG28			0x038
> +#define RXTX_REG31			0x03e
> +#define RXTX_REG38			0x04c
> +#define  RXTX_REG38_CUSTOMER_PINMODE_INV_SET(dst, src) \
> +		(((dst) & 0x0000fffe) | (((u32)(src) << 0x1) & 0x0000fffe))
> +#define RXTX_REG39			0x04e
> +#define RXTX_REG40			0x050
> +#define RXTX_REG41			0x052
> +#define RXTX_REG42			0x054
> +#define RXTX_REG43			0x056
> +#define RXTX_REG44			0x058
> +#define RXTX_REG45			0x05a
> +#define RXTX_REG46			0x05c
> +#define RXTX_REG47			0x05e
> +#define RXTX_REG48			0x060
> +#define RXTX_REG49			0x062
> +#define RXTX_REG50			0x064
> +#define RXTX_REG51			0x066
> +#define RXTX_REG52			0x068
> +#define RXTX_REG53			0x06a
> +#define RXTX_REG54			0x06c
> +#define RXTX_REG55			0x06e
> +#define RXTX_REG61			0x07a
> +#define  RXTX_REG61_ISCAN_INBERT_SET(dst, src) \
> +		(((dst) & ~0x00000010) | (((u32)(src) << 0x4) & 0x00000010))
> +#define  RXTX_REG61_LOADFREQ_SHIFT_SET(dst, src) \
> +		(((dst) & ~0x00000008) | (((u32)(src) << 0x3) & 0x00000008))
> +#define  RXTX_REG61_EYE_COUNT_WIDTH_SEL_SET(dst, src) \
> +		(((dst) & ~0x000000c0) | (((u32)(src) << 0x6) & 0x000000c0))
> +#define  RXTX_REG61_SPD_SEL_CDR_SET(dst, src) \
> +		(((dst) & ~0x00003c00) | (((u32)(src) << 0xa) & 0x00003c00))
> +#define RXTX_REG62			0x07c
> +#define  RXTX_REG62_PERIOD_H1_QLATCH_SET(dst, src) \
> +		(((dst) & ~0x00003800) | (((u32)(src) << 0xb) & 0x00003800))
> +#define RXTX_REG81			0x0a2
> +#define  RXTX_REG89_MU_TH7_SET(dst, src) \
> +		(((dst) & ~0x0000f800) | (((u32)(src) << 0xb) & 0x0000f800))
> +#define  RXTX_REG89_MU_TH8_SET(dst, src) \
> +		(((dst) & ~0x000007c0) | (((u32)(src) << 0x6) & 0x000007c0))
> +#define  RXTX_REG89_MU_TH9_SET(dst, src) \
> +		(((dst) & ~0x0000003e) | (((u32)(src) << 0x1) & 0x0000003e))
> +#define RXTX_REG96			0x0c0
> +#define  RXTX_REG96_MU_FREQ1_SET(dst, src) \
> +		(((dst) & ~0x0000f800) | (((u32)(src) << 0xb) & 0x0000f800))
> +#define  RXTX_REG96_MU_FREQ2_SET(dst, src) \
> +		(((dst) & ~0x000007c0) | (((u32)(src) << 0x6) & 0x000007c0))
> +#define  RXTX_REG96_MU_FREQ3_SET(dst, src) \
> +		(((dst) & ~0x0000003e) | (((u32)(src) << 0x1) & 0x0000003e))
> +#define RXTX_REG99			0x0c6
> +#define  RXTX_REG99_MU_PHASE1_SET(dst, src) \
> +		(((dst) & ~0x0000f800) | (((u32)(src) << 0xb) & 0x0000f800))
> +#define  RXTX_REG99_MU_PHASE2_SET(dst, src) \
> +		(((dst) & ~0x000007c0) | (((u32)(src) << 0x6) & 0x000007c0))
> +#define  RXTX_REG99_MU_PHASE3_SET(dst, src) \
> +		(((dst) & ~0x0000003e) | (((u32)(src) << 0x1) & 0x0000003e))
> +#define RXTX_REG102			0x0cc
> +#define  RXTX_REG102_FREQLOOP_LIMIT_SET(dst, src) \
> +		(((dst) & ~0x00000060) | (((u32)(src) << 0x5) & 0x00000060))
> +#define RXTX_REG114			0x0e4
> +#define RXTX_REG121			0x0f2
> +#define  RXTX_REG121_SUMOS_CAL_CODE_RD(src) \
> +		((0x0000003e & (u32)(src)) >> 0x1)
> +#define RXTX_REG125			0x0fa
> +#define  RXTX_REG125_PQ_REG_SET(dst, src) \
> +		(((dst) & ~0x0000fe00) | (((u32)(src) << 0x9) & 0x0000fe00))
> +#define  RXTX_REG125_SIGN_PQ_SET(dst, src) \
> +		(((dst) & ~0x00000100) | (((u32)(src) << 0x8) & 0x00000100))
> +#define  RXTX_REG125_SIGN_PQ_2C_SET(dst, src) \
> +		(((dst) & ~0x00000080) | (((u32)(src) << 0x7) & 0x00000080))
> +#define  RXTX_REG125_PHZ_MANUALCODE_SET(dst, src) \
> +		(((dst) & ~0x0000007c) | (((u32)(src) << 0x2) & 0x0000007c))
> +#define  RXTX_REG125_PHZ_MANUAL_SET(dst, src) \
> +		(((dst) & ~0x00000002) | (((u32)(src) << 0x1) & 0x00000002))
> +#define RXTX_REG127			0x0fe
> +#define  RXTX_REG127_FORCE_SUM_CAL_START_MASK	0x00000002
> +#define  RXTX_REG127_FORCE_LAT_CAL_START_MASK	0x00000004
> +#define  RXTX_REG127_FORCE_SUM_CAL_START_SET(dst, src) \
> +		(((dst) & ~0x00000002) | (((u32)(src) << 0x1) & 0x00000002))
> +#define  RXTX_REG127_FORCE_LAT_CAL_START_SET(dst, src) \
> +		(((dst) & ~0x00000004) | (((u32)(src) << 0x2) & 0x00000004))
> +#define  RXTX_REG127_LATCH_MAN_CAL_ENA_SET(dst, src) \
> +		(((dst) & ~0x00000008) | (((u32)(src) << 0x3) & 0x00000008))
> +#define  RXTX_REG127_DO_LATCH_MANCAL_SET(dst, src) \
> +		(((dst) & ~0x0000fc00) | (((u32)(src) << 0xa) & 0x0000fc00))
> +#define  RXTX_REG127_XO_LATCH_MANCAL_SET(dst, src) \
> +		(((dst) & ~0x000003f0) | (((u32)(src) << 0x4) & 0x000003f0))
> +#define RXTX_REG128			0x100
> +#define  RXTX_REG128_LATCH_CAL_WAIT_SEL_SET(dst, src) \
> +		(((dst) & ~0x0000000c) | (((u32)(src) << 0x2) & 0x0000000c))
> +#define  RXTX_REG128_EO_LATCH_MANCAL_SET(dst, src) \
> +		(((dst) & ~0x0000fc00) | (((u32)(src) << 0xa) & 0x0000fc00))
> +#define  RXTX_REG128_SO_LATCH_MANCAL_SET(dst, src) \
> +		(((dst) & ~0x000003f0) | (((u32)(src) << 0x4) & 0x000003f0))
> +#define RXTX_REG129			0x102
> +#define  RXTX_REG129_DE_LATCH_MANCAL_SET(dst, src) \
> +		(((dst) & ~0x0000fc00) | (((u32)(src) << 0xa) & 0x0000fc00))
> +#define  RXTX_REG129_XE_LATCH_MANCAL_SET(dst, src) \
> +		(((dst) & ~0x000003f0) | (((u32)(src) << 0x4) & 0x000003f0))
> +#define RXTX_REG130			0x104
> +#define  RXTX_REG130_EE_LATCH_MANCAL_SET(dst, src) \
> +		(((dst) & ~0x0000fc00) | (((u32)(src) << 0xa) & 0x0000fc00))
> +#define  RXTX_REG130_SE_LATCH_MANCAL_SET(dst, src) \
> +		(((dst) & ~0x000003f0) | (((u32)(src) << 0x4) & 0x000003f0))
> +#define RXTX_REG145			0x122
> +#define  RXTX_REG145_TX_IDLE_SATA_SET(dst, src) \
> +		(((dst) & ~0x00000001) | (((u32)(src) << 0x0) & 0x00000001))
> +#define  RXTX_REG145_RXES_ENA_SET(dst, src) \
> +		(((dst) & ~0x00000002) | (((u32)(src) << 0x1) & 0x00000002))
> +#define  RXTX_REG145_RXDFE_CONFIG_SET(dst, src) \
> +		(((dst) & ~0x0000c000) | (((u32)(src) << 0xe) & 0x0000c000))
> +#define  RXTX_REG145_RXVWES_LATENA_SET(dst, src) \
> +		(((dst) & ~0x00000004) | (((u32)(src) << 0x2) & 0x00000004))
> +#define RXTX_REG147			0x126
> +#define RXTX_REG148			0x128
> +
> +/* Clock macro type */
> +enum cmu_type_t {
> +	REF_CMU = 0,	/* Clock macro is the internal reference clock */
> +	PHY_CMU = 1,	/* Clock macro is the PLL for the Serdes */
> +};
> +
> +enum mux_type_t {
> +	MUX_SELECT_ATA = 0,	/* Switch the MUX to ATA */
> +	MUX_SELECT_SGMMII = 0,	/* Switch the MUX to SGMII */
> +};
> +
> +enum clk_type_t {
> +	CLK_EXT_DIFF = 0,	/* External differential */
> +	CLK_INT_DIFF = 1,	/* Internal differential */
> +	CLK_INT_SING = 2,	/* Internal single ended */
> +};
> +
> +enum phy_mode {
> +	MODE_SATA	= 0,	/* List them for simple reference */
> +	MODE_SGMII	= 1,
> +	MODE_PCIE	= 2,
> +	MODE_USB	= 3,
> +	MODE_XFI	= 4,
> +	MODE_MAX
> +};
> +
> +struct xgene_sata_override_param {
> +	u32 speed[MAX_LANE]; /* Index for override parameter per lane */
> +	u32 txspeed[3]; 		/* Tx speed */
> +	u32 txboostgain[MAX_LANE*3];	/* Tx freq boost and gain control */
> +	u32 txeyetuning[MAX_LANE*3]; 	/* Tx eye tuning */
> +	u32 txeyedirection[MAX_LANE*3]; /* Tx eye tuning direction */
> +	u32 txamplitude[MAX_LANE*3];	/* Tx amplitude control */
> +	u32 txprecursor_cn1[MAX_LANE*3]; /* Tx emphasis taps 1st pre-cursor */
> +	u32 txprecursor_cn2[MAX_LANE*3]; /* Tx emphasis taps 2nd pre-cursor */
> +	u32 txpostcursor_cp1[MAX_LANE*3]; /* Tx emphasis taps post-cursor */
> +};
> +
> +struct xgene_phy_ctx {
> +	struct device *dev;
> +	struct phy *phy;
> +	enum phy_mode mode;		/* Mode of operation */
> +	enum clk_type_t clk_type;	/* Input clock selection */
> +	void __iomem *sds_base;		/* PHY CSR base addr */
> +	struct clk *clk;		/* Optional clock */
> +
> +	/* Override Serdes parameters */
> +	struct xgene_sata_override_param sata_param;
> +};
> +
> +/*
> + * For chip earlier than A3 version, enable this flag.
> + * To enable, pass boot argument phy_xgene.preA3Chip=1
> + */
> +static int preA3Chip;
> +MODULE_PARM_DESC(preA3Chip, "Enable pre-A3 chip support (1=enable 0=disable)");
> +module_param_named(preA3Chip, preA3Chip, int, 0444);

Do we need to have module param for this? I mean we can differentiate 
between
different chip versions in dt data only.
> +
> +static void sds_wr(void __iomem *csr_base, u32 indirect_cmd_reg,
> +		   u32 indirect_data_reg, u32 addr, u32 data)
> +{
> +	u32 val;
> +	u32 cmd;
> +
> +	cmd = CFG_IND_WR_CMD_MASK | CFG_IND_CMD_DONE_MASK;
> +	cmd = CFG_IND_ADDR_SET(cmd, addr);

This looks hacky. If 'CFG_IND_WR_CMD_MASK | CFG_IND_CMD_DONE_MASK' 
should be set then it should be part of the second argument. From the 
macro 'CFG_IND_ADDR_SET' the first argument should be more like the 
current value present in the register right? I feel the macro 
(CFG_IND_ADDR_SET) is not used in the way it is intended to.


> +	writel(data, csr_base + indirect_data_reg);
> +	readl(csr_base + indirect_data_reg); /* Force a barrier */
> +	writel(cmd, csr_base + indirect_cmd_reg);
> +	readl(csr_base + indirect_cmd_reg); /* Force a barrier */
> +	do {
> +		val = readl(csr_base + indirect_cmd_reg);

better to have a timeout here and return error so we don't loop 
infinitively.
> +	} while (!(val & CFG_IND_CMD_DONE_MASK));
> +}
> +
> +static void sds_rd(void __iomem *csr_base, u32 indirect_cmd_reg,
> +		   u32 indirect_data_reg, u32 addr, u32 *data)
> +{
> +	u32 val;
> +	u32 cmd;
> +
> +	cmd = CFG_IND_RD_CMD_MASK | CFG_IND_CMD_DONE_MASK;
> +	cmd = CFG_IND_ADDR_SET(cmd, addr);
> +	writel(cmd, csr_base + indirect_cmd_reg);
> +	readl(csr_base + indirect_cmd_reg); /* Force a barrier */
> +	do {
> +		val = readl(csr_base + indirect_cmd_reg);

same here.
> +	} while (!(val & CFG_IND_CMD_DONE_MASK));
> +	*data = readl(csr_base + indirect_data_reg);
> +}
> +
> +static void cmu_wr(struct xgene_phy_ctx *ctx, enum cmu_type_t cmu_type,
> +		   u32 reg, u32 data)
> +{
> +	void __iomem *sds_base = ctx->sds_base;
> +	u32 val;
> +
> +	if (cmu_type == REF_CMU)
> +		reg += SERDES_PLL_REF_INDIRECT_OFFSET;
> +	else
> +		reg += SERDES_PLL_INDIRECT_OFFSET;
> +	sds_wr(sds_base, SATA_ENET_SDS_IND_CMD_REG,
> +		SATA_ENET_SDS_IND_WDATA_REG, reg, data);
> +	sds_rd(sds_base, SATA_ENET_SDS_IND_CMD_REG,
> +		SATA_ENET_SDS_IND_RDATA_REG, reg, &val);
> +	pr_debug("CMU WR addr 0x%X value 0x%08X <-> 0x%08X\n", reg, data, val);
> +}
> +
.
.
<snip>
.
.
> +
> +static int xgene_phy_probe(struct platform_device *pdev)
> +{
> +	struct phy_provider *phy_provider;
> +	struct xgene_phy_ctx *ctx;
> +	struct resource *res;
> +	int rc = 0;
> +	u32 default_spd[] = DEFAULT_SATA_SPD_SEL;
> +	u32 default_txboost_gain[] = DEFAULT_SATA_TXBOOST_GAIN;
> +	u32 default_txeye_direction[] = DEFAULT_SATA_TXEYEDIRECTION;
> +	u32 default_txeye_tuning[] = DEFAULT_SATA_TXEYETUNING;
> +	u32 default_txamp[] = DEFAULT_SATA_TXAMP;
> +	u32 default_txcn1[] = DEFAULT_SATA_TXCN1;
> +	u32 default_txcn2[] = DEFAULT_SATA_TXCN2;
> +	u32 default_txcp1[] = DEFAULT_SATA_TXCP1;
> +	int i;
> +
> +	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx) {
> +		dev_err(&pdev->dev, "can't allocate PHY context\n");
> +		return -ENOMEM;
> +	}
> +	ctx->dev = &pdev->dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "no PHY resource address\n");
> +		goto error;
> +	}
> +	ctx->sds_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (!ctx->sds_base) {
> +		dev_err(&pdev->dev, "can't map PHY resource\n");
> +		rc = -ENOMEM;
> +		goto error;
> +	}
> +
> +	/* Retrieve optional clock */
> +	ctx->clk = clk_get(&pdev->dev, NULL);
> +
> +	/* Load override paramaters */
> +	xgene_phy_get_param(pdev, "apm,tx-eye-tuning",
> +		ctx->sata_param.txeyetuning, 6, default_txeye_tuning, 1);
> +	xgene_phy_get_param(pdev, "apm,tx-eye-direction",
> +		ctx->sata_param.txeyedirection, 6, default_txeye_direction, 1);
> +	xgene_phy_get_param(pdev, "apm,tx-boost-gain",
> +		ctx->sata_param.txboostgain, 6, default_txboost_gain, 1);
> +	xgene_phy_get_param(pdev, "apm,tx-amplitude",
> +		ctx->sata_param.txamplitude, 6, default_txamp, 13300);
> +	xgene_phy_get_param(pdev, "apm,tx-pre-cursor1",
> +		ctx->sata_param.txprecursor_cn1, 6, default_txcn1, 18200);
> +	xgene_phy_get_param(pdev, "apm,tx-pre-cursor2",
> +		ctx->sata_param.txprecursor_cn2, 6, default_txcn2, 18200);
> +	xgene_phy_get_param(pdev, "apm,tx-post-cursor",
> +		ctx->sata_param.txpostcursor_cp1, 6, default_txcp1, 18200);
> +	xgene_phy_get_param(pdev, "apm,tx-speed",
> +		ctx->sata_param.txspeed, 3, default_spd, 1);
> +	for (i = 0; i < MAX_LANE; i++)
> +		ctx->sata_param.speed[i] = 2; /* Default to Gen3 */
> +
> +	ctx->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, ctx);
> +
> +	phy_provider = devm_of_phy_provider_register(ctx->dev,
> +						     xgene_phy_xlate);
> +	if (IS_ERR(phy_provider)) {
> +		rc = PTR_ERR(phy_provider);
> +		goto error;
> +	}

phy_provider_register should be the last step in registering the PHY 
with the framework.
> +
> +	ctx->phy = devm_phy_create(ctx->dev, &xgene_phy_ops, NULL);
> +	if (IS_ERR(ctx->phy)) {
> +		dev_dbg(&pdev->dev, "Failed to create PHY\n");
> +		return PTR_ERR(ctx->phy);
> +	}
> +
> +	phy_set_drvdata(ctx->phy, ctx);
> +
> +	dev_info(&pdev->dev, "X-Gene PHY registered\n");

lets not make the boot log noisy.
> +	return 0;
> +
> +error:
> +	return rc;
> +}
> +
> +static const struct of_device_id xgene_phy_of_match[] = {
> +	{.compatible = "apm,xgene-phy",},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, xgene_phy_of_match);
> +
> +static struct platform_driver xgene_phy_driver = {
> +	.probe = xgene_phy_probe,
> +	.driver = {
> +		   .name = "xgene-phy",
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = xgene_phy_of_match,
> +	},
> +};
> +
> +static int __init xgene_phy_init(void)
> +{
> +	return platform_driver_register(&xgene_phy_driver);
> +}
> +module_init(xgene_phy_init);
> +
> +static void __exit xgene_phy_exit(void)
> +{
> +	platform_driver_unregister(&xgene_phy_driver);
> +}
> +module_exit(xgene_phy_exit);

This can simply be replaced with 'module_platform_driver'.
> +
> +MODULE_DESCRIPTION("APM X-Gene Multi-Purpose PHY driver");
> +MODULE_AUTHOR("Loc Ho <lho@apm.com>");
> +MODULE_LICENSE("GPL");

GPL v2?

Thanks
Kishon
