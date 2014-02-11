Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaBKLuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:50:37 -0500
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:51666 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbaBKLue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:50:34 -0500
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Kishon Vijay Abraham I <kishon@ti.com>, "arnd@arndb.de" <arnd@arndb.de>
Cc: Pratyush ANAND <pratyush.anand@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>, Tejun Heo <tj@kernel.org>,
        spear-devel <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 11 Feb 2014 19:50:17 +0800
Subject: RE: [PATCH V6 06/12] SPEAr13xx: Fixup: Move SPEAr1340 SATA platform
 code to phy driver
Thread-Topic: [PATCH V6 06/12] SPEAr13xx: Fixup: Move SPEAr1340 SATA
 platform code to phy driver
Thread-Index: Ac8nHXXXPpnZ4WURSSWutgBFt5vfAgAATkNw
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB66189FD2CAC1F@EAPEX1MAIL1.st.com>
References: <cover.1392109054.git.mohit.kumar@st.com>
 <15e900d387a71e48387cf322ca065e38691c50e5.1392109054.git.mohit.kumar@st.com>
 <52FA0B0C.3050801@ti.com>
In-Reply-To: <52FA0B0C.3050801@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1BBojKE006449



> -----Original Message-----
> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> Sent: Tuesday, February 11, 2014 5:06 PM
> To: Mohit KUMAR DCG; arnd@arndb.de
> Cc: Pratyush ANAND; Viresh Kumar; Tejun Heo; spear-devel; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V6 06/12] SPEAr13xx: Fixup: Move SPEAr1340 SATA
> platform code to phy driver
>
> Hi,
>
> On Tuesday 11 February 2014 03:00 PM, Mohit Kumar wrote:
> > From: Pratyush Anand <pratyush.anand@st.com>
> >
> > ahci driver needs some platform specific functions which are called at
> > init, exit, suspend and resume conditions. Till now these functions
> > were present in a platform driver with a fixme notes.
> >
> > Similar functions modifying same set of registers will also be needed
> > in case of PCIe phy init/exit.
> >
> > So move all these SATA platform code to phy-miphy40lp driver.
> >
> > Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
> > Tested-by: Mohit Kumar <mohit.kumar@st.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Viresh Kumar <viresh.linux@gmail.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Kishon Vijay Abraham I <kishon@ti.com>
> > Cc: spear-devel@list.st.com
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  arch/arm/boot/dts/spear1310-evb.dts |    4 +
> >  arch/arm/boot/dts/spear1310.dtsi    |   39 +++++++++-
> >  arch/arm/boot/dts/spear1340-evb.dts |    4 +
> >  arch/arm/boot/dts/spear1340.dtsi    |   13 +++-
> >  arch/arm/boot/dts/spear13xx.dtsi    |    5 +
> >  arch/arm/mach-spear/Kconfig         |    2 +
> >  arch/arm/mach-spear/spear1340.c     |  127 +------------------------------
> >  drivers/phy/phy-miphy40lp.c         |  144
> +++++++++++++++++++++++++++++++++++
> >  8 files changed, 208 insertions(+), 130 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/spear1310-evb.dts
> > b/arch/arm/boot/dts/spear1310-evb.dts
> > index b56a801..d42c84b 100644
> > --- a/arch/arm/boot/dts/spear1310-evb.dts
> > +++ b/arch/arm/boot/dts/spear1310-evb.dts
> > @@ -106,6 +106,10 @@
> >                     status = "okay";
> >             };
> >
> > +           miphy@eb800000 {
> > +                   status = "okay";
> > +           };
> > +
> >             cf@b2800000 {
> >                     status = "okay";
> >             };
> > diff --git a/arch/arm/boot/dts/spear1310.dtsi
> > b/arch/arm/boot/dts/spear1310.dtsi
> > index 122ae94..64e7dd5 100644
> > --- a/arch/arm/boot/dts/spear1310.dtsi
> > +++ b/arch/arm/boot/dts/spear1310.dtsi
> > @@ -29,24 +29,57 @@
> >                     #gpio-cells = <2>;
> >             };
> >
> > -           ahci@b1000000 {
> > +           miphy0: miphy@eb800000 {
> > +                   compatible = "st,miphy", "st,spear1310-miphy";
> > +                   reg = <0xeb800000 0x4000>;
> > +                   misc = <&misc>;
> > +                   phy-id = <0>;
> > +                   #phy-cells = <1>;
> > +                   status = "disabled";
> > +           };
> > +
> > +           miphy1: miphy@eb804000 {
> > +                   compatible = "st,miphy", "st,spear1310-miphy";
> > +                   reg = <0xeb804000 0x4000>;
> > +                   misc = <&misc>;
> > +                   phy-id = <1>;
> > +                   #phy-cells = <1>;
> > +                   status = "disabled";
> > +           };
> > +
> > +           miphy2: miphy@eb808000 {
> > +                   compatible = "st,miphy", "st,spear1310-miphy";
> > +                   reg = <0xeb808000 0x4000>;
> > +                   misc = <&misc>;
> > +                   phy-id = <2>;
> > +                   #phy-cells = <1>;
> > +                   status = "disabled";
> > +           };
> > +
> > +           ahci0: ahci@b1000000 {
> >                     compatible = "snps,spear-ahci";
> >                     reg = <0xb1000000 0x10000>;
> >                     interrupts = <0 68 0x4>;
> > +                   phys = <&miphy0 0>;
> > +                   phy-names = "sata-phy";
> >                     status = "disabled";
> >             };
> >
> > -           ahci@b1800000 {
> > +           ahci1: ahci@b1800000 {
> >                     compatible = "snps,spear-ahci";
> >                     reg = <0xb1800000 0x10000>;
> >                     interrupts = <0 69 0x4>;
> > +                   phys = <&miphy1 0>;
> > +                   phy-names = "sata-phy";
> >                     status = "disabled";
> >             };
> >
> > -           ahci@b4000000 {
> > +           ahci2: ahci@b4000000 {
> >                     compatible = "snps,spear-ahci";
> >                     reg = <0xb4000000 0x10000>;
> >                     interrupts = <0 70 0x4>;
> > +                   phys = <&miphy2 0>;
> > +                   phy-names = "sata-phy";
> >                     status = "disabled";
> >             };
> >
> > diff --git a/arch/arm/boot/dts/spear1340-evb.dts
> > b/arch/arm/boot/dts/spear1340-evb.dts
> > index d6c30ae..b23e05e 100644
> > --- a/arch/arm/boot/dts/spear1340-evb.dts
> > +++ b/arch/arm/boot/dts/spear1340-evb.dts
> > @@ -122,6 +122,10 @@
> >                     status = "okay";
> >             };
> >
> > +           miphy@eb800000 {
> > +                   status = "okay";
> > +           };
> > +
> >             dma@ea800000 {
> >                     status = "okay";
> >             };
> > diff --git a/arch/arm/boot/dts/spear1340.dtsi
> > b/arch/arm/boot/dts/spear1340.dtsi
> > index 54d128d..7e3a04b 100644
> > --- a/arch/arm/boot/dts/spear1340.dtsi
> > +++ b/arch/arm/boot/dts/spear1340.dtsi
> > @@ -31,10 +31,21 @@
> >                     status = "disabled";
> >             };
> >
> > -           ahci@b1000000 {
> > +           miphy0: miphy@eb800000 {
> > +                   compatible = "st,miphy", "st,spear1340-miphy";
> > +                   reg = <0xeb800000 0x4000>;
> > +                   misc = <&misc>;
> > +                   phy-id = <0>;
> > +                   #phy-cells = <1>;
> > +                   status = "disabled";
> > +           };
> > +
> > +           ahci0: ahci@b1000000 {
> >                     compatible = "snps,spear-ahci";
> >                     reg = <0xb1000000 0x10000>;
> >                     interrupts = <0 72 0x4>;
> > +                   phys = <&miphy0 0>;
> > +                   phy-names = "sata-phy";
> >                     status = "disabled";
> >             };
> >
> > diff --git a/arch/arm/boot/dts/spear13xx.dtsi
> > b/arch/arm/boot/dts/spear13xx.dtsi
> > index 4382547..3a72508 100644
> > --- a/arch/arm/boot/dts/spear13xx.dtsi
> > +++ b/arch/arm/boot/dts/spear13xx.dtsi
> > @@ -220,6 +220,11 @@
> >                               0xd8000000 0xd8000000 0x01000000
> >                               0xe0000000 0xe0000000 0x10000000>;
> >
> > +                   misc: syscon@e0700000 {
> > +                           compatible = "st,spear1340-misc", "syscon";
> > +                           reg = <0xe0700000 0x1000>;
> > +                   };
> > +
> >                     gpio0: gpio@e0600000 {
> >                             compatible = "arm,pl061", "arm,primecell";
> >                             reg = <0xe0600000 0x1000>;
> > diff --git a/arch/arm/mach-spear/Kconfig b/arch/arm/mach-spear/Kconfig
> > index ac1710e..7e7f1b0 100644
> > --- a/arch/arm/mach-spear/Kconfig
> > +++ b/arch/arm/mach-spear/Kconfig
> > @@ -26,6 +26,8 @@ config ARCH_SPEAR13XX
> >     select MIGHT_HAVE_CACHE_L2X0
> >     select PINCTRL
> >     select USE_OF
> > +   select MFD_SYSCON
> > +   select PHY_ST_MIPHY40LP
> >     help
> >       Supports for ARM's SPEAR13XX family
> >
> > diff --git a/arch/arm/mach-spear/spear1340.c
> > b/arch/arm/mach-spear/spear1340.c index 3fb6834..8e27093 100644
> > --- a/arch/arm/mach-spear/spear1340.c
> > +++ b/arch/arm/mach-spear/spear1340.c
> > @@ -11,138 +11,13 @@
> >   * warranty of any kind, whether express or implied.
> >   */
> >
> > -#define pr_fmt(fmt) "SPEAr1340: " fmt
> > -
> > -#include <linux/ahci_platform.h>
> > -#include <linux/amba/serial.h>
> > -#include <linux/delay.h>
> >  #include <linux/of_platform.h>
> >  #include <asm/mach/arch.h>
> >  #include "generic.h"
> > -#include <mach/spear.h>
> > -
> > -/* FIXME: Move SATA PHY code into a standalone driver */
> > -
> > -/* Base addresses */
> > -#define SPEAR1340_SATA_BASE                        UL(0xB1000000)
> > -
> > -/* Power Management Registers */
> > -#define SPEAR1340_PCM_CFG                  (VA_MISC_BASE +
> 0x100)
> > -#define SPEAR1340_PCM_WKUP_CFG
>       (VA_MISC_BASE + 0x104)
> > -#define SPEAR1340_SWITCH_CTR                       (VA_MISC_BASE +
> 0x108)
> > -
> > -#define SPEAR1340_PERIP1_SW_RST
>       (VA_MISC_BASE + 0x318)
> > -#define SPEAR1340_PERIP2_SW_RST
>       (VA_MISC_BASE + 0x31C)
> > -#define SPEAR1340_PERIP3_SW_RST
>       (VA_MISC_BASE + 0x320)
> > -
> > -/* PCIE - SATA configuration registers */
> > -#define SPEAR1340_PCIE_SATA_CFG
>       (VA_MISC_BASE + 0x424)
> > -   /* PCIE CFG MASks */
> > -   #define SPEAR1340_PCIE_CFG_DEVICE_PRESENT       (1 << 11)
> > -   #define SPEAR1340_PCIE_CFG_POWERUP_RESET        (1 << 10)
> > -   #define SPEAR1340_PCIE_CFG_CORE_CLK_EN          (1 << 9)
> > -   #define SPEAR1340_PCIE_CFG_AUX_CLK_EN           (1 << 8)
> > -   #define SPEAR1340_SATA_CFG_TX_CLK_EN            (1 << 4)
> > -   #define SPEAR1340_SATA_CFG_RX_CLK_EN            (1 << 3)
> > -   #define SPEAR1340_SATA_CFG_POWERUP_RESET        (1 << 2)
> > -   #define SPEAR1340_SATA_CFG_PM_CLK_EN            (1 << 1)
> > -   #define SPEAR1340_PCIE_SATA_SEL_PCIE            (0)
> > -   #define SPEAR1340_PCIE_SATA_SEL_SATA            (1)
> > -   #define SPEAR1340_SATA_PCIE_CFG_MASK            0xF1F
> > -   #define SPEAR1340_PCIE_CFG_VAL
>       (SPEAR1340_PCIE_SATA_SEL_PCIE | \
> > -                   SPEAR1340_PCIE_CFG_AUX_CLK_EN | \
> > -                   SPEAR1340_PCIE_CFG_CORE_CLK_EN | \
> > -                   SPEAR1340_PCIE_CFG_POWERUP_RESET | \
> > -                   SPEAR1340_PCIE_CFG_DEVICE_PRESENT)
> > -   #define SPEAR1340_SATA_CFG_VAL
>       (SPEAR1340_PCIE_SATA_SEL_SATA | \
> > -                   SPEAR1340_SATA_CFG_PM_CLK_EN | \
> > -                   SPEAR1340_SATA_CFG_POWERUP_RESET | \
> > -                   SPEAR1340_SATA_CFG_RX_CLK_EN | \
> > -                   SPEAR1340_SATA_CFG_TX_CLK_EN)
> > -
> > -#define SPEAR1340_PCIE_MIPHY_CFG           (VA_MISC_BASE +
> 0x428)
> > -   #define SPEAR1340_MIPHY_OSC_BYPASS_EXT          (1 << 31)
> > -   #define SPEAR1340_MIPHY_CLK_REF_DIV2            (1 << 27)
> > -   #define SPEAR1340_MIPHY_CLK_REF_DIV4            (2 << 27)
> > -   #define SPEAR1340_MIPHY_CLK_REF_DIV8            (3 << 27)
> > -   #define SPEAR1340_MIPHY_PLL_RATIO_TOP(x)        (x << 0)
> > -   #define SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA \
> > -                   (SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
> > -                   SPEAR1340_MIPHY_CLK_REF_DIV2 | \
> > -                   SPEAR1340_MIPHY_PLL_RATIO_TOP(60))
> > -   #define
> SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK \
> > -                   (SPEAR1340_MIPHY_PLL_RATIO_TOP(120))
> > -   #define SPEAR1340_PCIE_SATA_MIPHY_CFG_PCIE \
> > -                   (SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
> > -                   SPEAR1340_MIPHY_PLL_RATIO_TOP(25))
> > -
> > -/* SATA device registration */
> > -static int sata_miphy_init(struct device *dev, void __iomem *addr) -{
> > -   writel(SPEAR1340_SATA_CFG_VAL, SPEAR1340_PCIE_SATA_CFG);
> > -
>       writel(SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CL
> K,
> > -                   SPEAR1340_PCIE_MIPHY_CFG);
> > -   /* Switch on sata power domain */
> > -   writel((readl(SPEAR1340_PCM_CFG) | (0x800)),
> SPEAR1340_PCM_CFG);
> > -   msleep(20);
> > -   /* Disable PCIE SATA Controller reset */
> > -   writel((readl(SPEAR1340_PERIP1_SW_RST) & (~0x1000)),
> > -                   SPEAR1340_PERIP1_SW_RST);
> > -   msleep(20);
> > -
> > -   return 0;
> > -}
> > -
> > -void sata_miphy_exit(struct device *dev) -{
> > -   writel(0, SPEAR1340_PCIE_SATA_CFG);
> > -   writel(0, SPEAR1340_PCIE_MIPHY_CFG);
> > -
> > -   /* Enable PCIE SATA Controller reset */
> > -   writel((readl(SPEAR1340_PERIP1_SW_RST) | (0x1000)),
> > -                   SPEAR1340_PERIP1_SW_RST);
> > -   msleep(20);
> > -   /* Switch off sata power domain */
> > -   writel((readl(SPEAR1340_PCM_CFG) & (~0x800)),
> SPEAR1340_PCM_CFG);
> > -   msleep(20);
> > -}
> > -
> > -int sata_suspend(struct device *dev)
> > -{
> > -   if (dev->power.power_state.event == PM_EVENT_FREEZE)
> > -           return 0;
> > -
> > -   sata_miphy_exit(dev);
> > -
> > -   return 0;
> > -}
> > -
> > -int sata_resume(struct device *dev)
> > -{
> > -   if (dev->power.power_state.event == PM_EVENT_THAW)
> > -           return 0;
> > -
> > -   return sata_miphy_init(dev, NULL);
> > -}
> > -
> > -static struct ahci_platform_data sata_pdata = {
> > -   .init = sata_miphy_init,
> > -   .exit = sata_miphy_exit,
> > -   .suspend = sata_suspend,
> > -   .resume = sata_resume,
> > -};
> > -
> > -/* Add SPEAr1340 auxdata to pass platform data */ -static struct
> > of_dev_auxdata spear1340_auxdata_lookup[] __initdata = {
> > -   OF_DEV_AUXDATA("snps,spear-ahci", SPEAR1340_SATA_BASE,
> NULL,
> > -                   &sata_pdata),
> > -   {}
> > -};
> >
> >  static void __init spear1340_dt_init(void)  {
> > -   of_platform_populate(NULL, of_default_bus_match_table,
> > -                   spear1340_auxdata_lookup, NULL);
> > +   of_platform_populate(NULL, of_default_bus_match_table, NULL,
> NULL);
> >  }
> >
> >  static const char * const spear1340_dt_board_compat[] = { diff --git
> > a/drivers/phy/phy-miphy40lp.c b/drivers/phy/phy-miphy40lp.c index
> > 98859ff..16da55b 100644
> > --- a/drivers/phy/phy-miphy40lp.c
> > +++ b/drivers/phy/phy-miphy40lp.c
> > @@ -8,8 +8,10 @@
> >   * it under the terms of the GNU General Public License version 2 as
> >   * published by the Free Software Foundation.
> >   *
> > + * 04/02/2014: Adding support of SATA mode for SPEAr1340.
> >   */
> >
> > +#include <linux/bitops.h>
> >  #include <linux/delay.h>
> >  #include <linux/dma-mapping.h>
> >  #include <linux/kernel.h>
> > @@ -19,6 +21,60 @@
> >  #include <linux/phy/phy.h>
> >  #include <linux/regmap.h>
> >
> > +/* SPEAr1340 Registers */
> > +/* Power Management Registers */
> > +#define SPEAR1340_PCM_CFG                  0x100
> > +   #define SPEAR1340_PCM_CFG_SATA_POWER_EN
>       BIT(11)
>
> No tabs in the beginning. Just my personal preference though. No strong
> feelings.
> > +#define SPEAR1340_PCM_WKUP_CFG                     0x104
> > +#define SPEAR1340_SWITCH_CTR                       0x108
> > +
> > +#define SPEAR1340_PERIP1_SW_RST                    0x318
> > +   #define SPEAR1340_PERIP1_SW_RSATA               BIT(12)
> > +#define SPEAR1340_PERIP2_SW_RST                    0x31C
> > +#define SPEAR1340_PERIP3_SW_RST                    0x320
> > +
> > +/* PCIE - SATA configuration registers */
> > +#define SPEAR1340_PCIE_SATA_CFG                    0x424
> > +   /* PCIE CFG MASks */
> > +   #define SPEAR1340_PCIE_CFG_DEVICE_PRESENT       BIT(11)
> > +   #define SPEAR1340_PCIE_CFG_POWERUP_RESET        BIT(10)
> > +   #define SPEAR1340_PCIE_CFG_CORE_CLK_EN          BIT(9)
> > +   #define SPEAR1340_PCIE_CFG_AUX_CLK_EN           BIT(8)
> > +   #define SPEAR1340_SATA_CFG_TX_CLK_EN            BIT(4)
> > +   #define SPEAR1340_SATA_CFG_RX_CLK_EN            BIT(3)
> > +   #define SPEAR1340_SATA_CFG_POWERUP_RESET        BIT(2)
> > +   #define SPEAR1340_SATA_CFG_PM_CLK_EN            BIT(1)
> > +   #define SPEAR1340_PCIE_SATA_SEL_PCIE            (0)
> > +   #define SPEAR1340_PCIE_SATA_SEL_SATA            (1)
> > +   #define SPEAR1340_PCIE_SATA_CFG_MASK            0xF1F
> > +   #define SPEAR1340_PCIE_CFG_VAL
>       (SPEAR1340_PCIE_SATA_SEL_PCIE | \
> > +                   SPEAR1340_PCIE_CFG_AUX_CLK_EN | \
> > +                   SPEAR1340_PCIE_CFG_CORE_CLK_EN | \
> > +                   SPEAR1340_PCIE_CFG_POWERUP_RESET | \
> > +                   SPEAR1340_PCIE_CFG_DEVICE_PRESENT)
> > +   #define SPEAR1340_SATA_CFG_VAL
>       (SPEAR1340_PCIE_SATA_SEL_SATA | \
> > +                   SPEAR1340_SATA_CFG_PM_CLK_EN | \
> > +                   SPEAR1340_SATA_CFG_POWERUP_RESET | \
> > +                   SPEAR1340_SATA_CFG_RX_CLK_EN | \
> > +                   SPEAR1340_SATA_CFG_TX_CLK_EN)
> > +
> > +#define SPEAR1340_PCIE_MIPHY_CFG           0x428
> > +   #define SPEAR1340_MIPHY_OSC_BYPASS_EXT          BIT(31)
> > +   #define SPEAR1340_MIPHY_CLK_REF_DIV2            BIT(27)
> > +   #define SPEAR1340_MIPHY_CLK_REF_DIV4            (2 << 27)
> > +   #define SPEAR1340_MIPHY_CLK_REF_DIV8            (3 << 27)
>
> This doesn't look very nice. But I'm not sure if there are similar macros to
> handle sequence of bits.

- We tried to look but didn't find any.

> > +   #define SPEAR1340_MIPHY_PLL_RATIO_TOP(x)        (x << 0)
> > +   #define SPEAR1340_PCIE_MIPHY_CFG_MASK           0xF80000FF
> > +   #define SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA \
> > +                   (SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
> > +                   SPEAR1340_MIPHY_CLK_REF_DIV2 | \
> > +                   SPEAR1340_MIPHY_PLL_RATIO_TOP(60))
> > +   #define
> SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK \
> > +                   (SPEAR1340_MIPHY_PLL_RATIO_TOP(120))
> > +   #define SPEAR1340_PCIE_SATA_MIPHY_CFG_PCIE \
> > +                   (SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
> > +                   SPEAR1340_MIPHY_PLL_RATIO_TOP(25))
> > +
> >  enum phy_mode {
> >     SATA,
> >     PCIE,
> > @@ -50,6 +106,93 @@ struct miphy40lp_priv {
> >     const struct miphy40lp_plat_ops *plat_ops;
> >  };
> >
> > +static int miphy40lp_spear1340_sata_init(struct miphy40lp_priv *priv)
> > +{
> > +   regmap_update_bits(priv->misc, SPEAR1340_PCIE_SATA_CFG,
> > +                   SPEAR1340_PCIE_SATA_CFG_MASK,
> SPEAR1340_SATA_CFG_VAL);
> > +   regmap_update_bits(priv->misc, SPEAR1340_PCIE_MIPHY_CFG,
> > +                   SPEAR1340_PCIE_MIPHY_CFG_MASK,
> > +
>       SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK);
> > +   /* Switch on sata power domain */
> > +   regmap_update_bits(priv->misc, SPEAR1340_PCM_CFG,
> > +                   SPEAR1340_PCM_CFG_SATA_POWER_EN,
> > +                   SPEAR1340_PCM_CFG_SATA_POWER_EN);
> > +   msleep(20);
> > +   /* Disable PCIE SATA Controller reset */
> > +   regmap_update_bits(priv->misc, SPEAR1340_PERIP1_SW_RST,
> > +                   SPEAR1340_PERIP1_SW_RSATA, 0);
> > +   msleep(20);
> > +
> > +   return 0;
> > +}
> > +
> > +static int miphy40lp_spear1340_sata_exit(struct miphy40lp_priv *priv)
> > +{
> > +   regmap_update_bits(priv->misc, SPEAR1340_PCIE_SATA_CFG,
> > +                   SPEAR1340_PCIE_SATA_CFG_MASK, 0);
> > +   regmap_update_bits(priv->misc, SPEAR1340_PCIE_MIPHY_CFG,
> > +                   SPEAR1340_PCIE_MIPHY_CFG_MASK, 0);
> > +
> > +   /* Enable PCIE SATA Controller reset */
> > +   regmap_update_bits(priv->misc, SPEAR1340_PERIP1_SW_RST,
> > +                   SPEAR1340_PERIP1_SW_RSATA,
> > +                   SPEAR1340_PERIP1_SW_RSATA);
> > +   msleep(20);
> > +   /* Switch off sata power domain */
> > +   regmap_update_bits(priv->misc, SPEAR1340_PCM_CFG,
> > +                   SPEAR1340_PCM_CFG_SATA_POWER_EN, 0);
> > +   msleep(20);
> > +
> > +   return 0;
> > +}
> > +
> > +static int miphy40lp_spear1340_init(struct miphy40lp_priv *priv) {
> > +   int ret = 0;
> > +
> > +   if (priv->mode == SATA)
> > +           ret = miphy40lp_spear1340_sata_init(priv);
> > +
> > +   return ret;
> > +}
> > +
> > +static int miphy40lp_spear1340_exit(struct miphy40lp_priv *priv) {
> > +   int ret = 0;
> > +
> > +   if (priv->mode == SATA)
> > +           ret = miphy40lp_spear1340_sata_exit(priv);
> > +
> > +   return ret;
> > +}
> > +
> > +static int miphy40lp_spear1340_suspend(struct miphy40lp_priv *priv) {
> > +   int ret = 0;
> > +
> > +   if (priv->mode == SATA)
> > +           ret = miphy40lp_spear1340_sata_exit(priv);
> > +
> > +   return ret;
> > +}
> > +
> > +static int miphy40lp_spear1340_resume(struct miphy40lp_priv *priv) {
> > +   int ret = 0;
> > +
> > +   if (priv->mode == SATA)
> > +           ret = miphy40lp_spear1340_sata_init(priv);
> > +
> > +   return ret;
> > +}
> > +
> > +static struct miphy40lp_plat_ops spear1340_phy_ops = {
> > +   .plat_init = miphy40lp_spear1340_init,
> > +   .plat_exit = miphy40lp_spear1340_exit,
> > +   .plat_suspend = miphy40lp_spear1340_suspend,
> > +   .plat_resume = miphy40lp_spear1340_resume, };
> > +
> >  static int miphy40lp_init(struct phy *phy)  {
> >     struct miphy40lp_priv *priv = phy_get_drvdata(phy); @@ -100,6
> +243,7
> > @@ static int miphy40lp_power_on(struct phy *phy)
> >
> >  static const struct of_device_id miphy40lp_of_match[] = {
> >     { .compatible = "st,miphy40lp-phy", .data = NULL },
>
> Do we still need this compatible? Because it doesn't do anything anyways?
>
- May be we can keep it here as generic option. In future we may add a platform that
 do not require any plat specific ops but modifying miphy40lp regs .

Thanks
Mohit

> Thanks
> Kishon
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
