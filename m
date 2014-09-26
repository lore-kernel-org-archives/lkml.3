Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaIZITr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:19:47 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:37929 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbaIZITo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:19:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140926112344.3ee87d2f@canb.auug.org.au>
References: <20140926112344.3ee87d2f@canb.auug.org.au>
Date: Fri, 26 Sep 2014 10:19:43 +0200
X-Google-Sender-Auth: mFkJpPdw464BbAdt-yfkRwLcGPA
Message-ID: <CAOQ7t2Z8SgjMMM_QgUuAgezMXDBYyJM4kez-3WzGE4jgutjX6g@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
From: Carlo Caione <carlo@caione.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Carlo Caione <carlo@caione.org>,
        =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 3:23 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/Kconfig.debug between commits 0889a9e35bd3 ("ARM: 8142/1:
> ks8695: Migrate debug_ll macros to shared directory"), e38c399ca584
> ("ARM: 8144/2: netx: Migrate DEBUG_LL macros to shared directory"),
> 6741cacfa3f1 ("ARM: 8145/1: sa1100: Migrate DEBUG_LL macros to shared
> directory") and debf843bf7ee ("ARM: 8146/1: Seperate DEBUG_UART_PHYS
> from DEBUG_LL on EP93XX") from the arm tree and commits d8a00916b303
> ("ARM: meson: debug: add debug UART for earlyprintk support"),
> b125170a39ea ("CNS3xxx: Fix debug UART") and b51312bebfa4 ("ARM:
> BCM63XX: add low-level UART debug support") from the arm-soc tree.
>
> I fixed it up (hopefully - see below) and can carry the fix as
> necessary (no action is required).
>
> You may be able to clean some of this up by using intermediate config
> symbols that are selected by the low level symbols and depended upon by
> the higher level config symbols.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc arch/arm/Kconfig.debug
> index 4fcff7737dd1,0d714e10f0a2..000000000000
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@@ -348,13 -365,13 +365,20 @@@ choic
>                   Say Y here if you want the debug print routines to direct
>                   their output to UART1 serial port on KEYSTONE2 devices.
>
>  +      config DEBUG_KS8695_UART
>  +              bool "KS8695 Debug UART"
>  +              depends on ARCH_KS8695
>  +              help
>  +                Say Y here if you want kernel low-level debugging support
>  +                on KS8695.
>  +
> +       config DEBUG_MESON_UARTAO
> +               bool "Kernel low-level debugging via Meson6 UARTAO"
> +               depends on ARCH_MESON
> +               help
> +                 Say Y here if you want kernel low-lever debugging support
> +                 on Amlogic Meson6 based platforms on the UARTAO.
> +
>         config DEBUG_MMP_UART2
>                 bool "Kernel low-level debugging message via MMP UART2"
>                 depends on ARCH_MMP
> @@@ -1136,9 -1091,12 +1170,13 @@@ config DEBUG_UART_825
>                 ARCH_IOP33X || ARCH_IXP4XX || \
>                 ARCH_LPC32XX || ARCH_MV78XX0 || ARCH_ORION5X || ARCH_RPC
>
> + # Compatibility options for BCM63xx
> + config DEBUG_UART_BCM63XX
> +       def_bool ARCH_BCM_63XX
> +
>   config DEBUG_UART_PHYS
>         hex "Physical base address of debug UART"
>  +      default 0x00100a00 if DEBUG_NETX_UART
>         default 0x01c20000 if DEBUG_DAVINCI_DMx_UART0
>         default 0x01c28000 if DEBUG_SUNXI_UART0
>         default 0x01c28400 if DEBUG_SUNXI_UART1
> @@@ -1174,9 -1133,7 +1213,10 @@@
>         default 0x50008000 if DEBUG_S3C24XX_UART && (DEBUG_S3C_UART2 || \
>                                 DEBUG_S3C2410_UART2)
>         default 0x7c0003f8 if FOOTBRIDGE
>  +      default 0x80010000 if DEBUG_SA1100_UART1
>  +      default 0x80030000 if DEBUG_SA1100_UART2
>  +      default 0x80050000 if DEBUG_SA1100_UART3
> +       default 0x78000000 if DEBUG_CNS3XXX
>         default 0x80070000 if DEBUG_IMX23_UART
>         default 0x80074000 if DEBUG_IMX28_UART
>         default 0x80230000 if DEBUG_PICOXCELL_UART
> @@@ -1204,17 -1163,14 +1246,18 @@@
>         default 0xff690000 if DEBUG_RK32_UART2
>         default 0xffc02000 if DEBUG_SOCFPGA_UART
>         default 0xffd82340 if ARCH_IOP13XX
>  +      default 0xfffb0000 if DEBUG_OMAP1UART1 || DEBUG_OMAP7XXUART1
>  +      default 0xfffb0800 if DEBUG_OMAP1UART2 || DEBUG_OMAP7XXUART2
>  +      default 0xfffb9800 if DEBUG_OMAP1UART3 || DEBUG_OMAP7XXUART3
>         default 0xfff36000 if DEBUG_HIGHBANK_UART
> +       default 0xfffe8600 if DEBUG_UART_BCM63XX
>         default 0xfffff700 if ARCH_IOP33X
>         depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
>                 DEBUG_LL_UART_EFM32 || \
> -               DEBUG_UART_8250 || DEBUG_UART_PL01X || \
> +               DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_MESON_UARTAO || \
>  -              DEBUG_MSM_UART || DEBUG_QCOM_UARTDM || DEBUG_S3C24XX_UART || \
>  -              DEBUG_UART_BCM63XX
>  +              DEBUG_MSM_UART || DEBUG_NETX_UART || DEBUG_QCOM_UARTDM || \
>  +              DEBUG_S3C24XX_UART || DEBUG_SA1100_UART || \
> -               ARCH_EP93XX
> ++              ARCH_EP93XX || DEBUG_UART_BCM63XX
>
>   config DEBUG_UART_VIRT
>         hex "Virtual base address of debug UART"
> @@@ -1241,14 -1196,14 +1284,17 @@@
>         default 0xf7008000 if DEBUG_S3C24XX_UART && (DEBUG_S3C_UART2 || \
>                                 DEBUG_S3C2410_UART2)
>         default 0xf7fc9000 if DEBUG_BERLIN_UART
> +       default 0xf8007000 if DEBUG_HIP04_UART
>         default 0xf8009000 if DEBUG_VEXPRESS_UART0_CA9
>  +      default 0xf8010000 if DEBUG_SA1100_UART1
>  +      default 0xf8030000 if DEBUG_SA1100_UART2
>  +      default 0xf8050000 if DEBUG_SA1100_UART3
>         default 0xf8090000 if DEBUG_VEXPRESS_UART0_RS1
>         default 0xfa71e000 if DEBUG_QCOM_UARTDM
> +       default 0xfb002000 if DEBUG_CNS3XXX
>         default 0xfb009000 if DEBUG_REALVIEW_STD_PORT
>         default 0xfb10c000 if DEBUG_REALVIEW_PB1176_PORT
> +       default 0xfcfe8600 if DEBUG_UART_BCM63XX
>         default 0xfd000000 if ARCH_SPEAR3XX || ARCH_SPEAR6XX
>         default 0xfd000000 if ARCH_SPEAR13XX
>         default 0xfd012000 if ARCH_MV78XX0
> @@@ -1288,9 -1241,9 +1335,9 @@@
>         default 0xff003000 if DEBUG_U300_UART
>         default DEBUG_UART_PHYS if !MMU
>         depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
> -               DEBUG_UART_8250 || DEBUG_UART_PL01X || \
> +               DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_MESON_UARTAO || \
>  -              DEBUG_MSM_UART || DEBUG_QCOM_UARTDM || DEBUG_S3C24XX_UART || \
>  -              DEBUG_UART_BCM63XX
>  +              DEBUG_MSM_UART || DEBUG_NETX_UART || DEBUG_QCOM_UARTDM || \
> -               DEBUG_S3C24XX_UART || DEBUG_SA1100_UART
> ++              DEBUG_S3C24XX_UART || DEBUG_SA1100_UART || DEBUG_UART_BCM63XX
>
>   config DEBUG_UART_8250_SHIFT
>         int "Register offset shift for the 8250 debug UART"

Hi Stephen,
Am I going blind or these two lines are missing from d8a00916b303

+       default 0xc81004c0 if DEBUG_MESON_UARTAO
...
+       default 0xf31004c0 if DEBUG_MESON_UARTAO

Thanks,

-- 
Carlo Caione
