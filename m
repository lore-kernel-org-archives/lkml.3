Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaA1RC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:02:56 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:46548 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbaA1RCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:02:54 -0500
Subject: Re: [BISECTED] OMAP: DSS: clk rate mismatch
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Tero Kristo <t-kristo@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        Nishanth Menon <nm@ti.com>
In-Reply-To: <52E7B361.2030601@ti.com>
References: <52E697C0.6000202@gmail.com> <1390848104.4936.62.camel@mars>
	 <52E772A3.4090401@ti.com> <1390901735.2963.8.camel@lovely>
	 <52E77D03.8090001@ti.com>  <52E7B361.2030601@ti.com>
Content-Type: multipart/mixed; boundary="=-O2t8ZVrguv+r9YKMKeGI"
Date: Tue, 28 Jan 2014 18:02:45 +0100
Message-ID: <1390928565.4904.88.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-O2t8ZVrguv+r9YKMKeGI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2014-01-28 at 15:40 +0200, Tero Kristo wrote:
> On 01/28/2014 11:48 AM, Tomi Valkeinen wrote:
> > On 2014-01-28 11:35, Christoph Fritz wrote:
> >> On Tue, 2014-01-28 at 11:04 +0200, Tomi Valkeinen wrote:
> >>> On 2014-01-27 20:41, Christoph Fritz wrote:
> >>>> On Mon, 2014-01-27 at 19:30 +0200, Ivaylo Dimitrov wrote:
> >>>>> linux-next-20140124 DSS is broken on N900  - display stays black (there
> >>>>> is some noise though). I booted the kernel with qemu and it gives the
> >>>>> following warning:
> >>>>>
> >>>>> [    0.623779] DSS: set fck to 172800000
> >>>>> [    0.624237] ------------[ cut here ]------------
> >>>>> [    0.624298] WARNING: CPU: 0 PID: 1 at
> >>>>> drivers/video/omap2/dss/dss.c:497 dss_set_fck_rate+0x68/0x8c()
> >>>>> [    0.624359] clk rate mismatch: 288000000 != 172800000
> >>>>
> >>>> Here are also clock regressions since next-20140122 regarding
> >>>> dss_set_fck_rate() and sys_clkout2 occuring in my current patchset for a
> >>>> dm37xx100 board. Please see here:
> >>>
> >>> I presume you get a similar warning on your board? What rates does it
> >>> report?
> >>
> >> None, dss_set_fck_rate() just fails so omapdss_dss exits with error -22.
> >
> > Ok, then it's something else. That means clk_set_rate() fails.
> >
> > If you can do some tests, you could print the rate that the
> > dss_set_fck_rate() is given, to see that it's something reasonable, and
> > also do a clk_get_rate(dss.dss_clk) to see that the clock itself is ok
> > and there's some valid rate there.
> >
> >> To quote the cover-letter[1] of my board-support patch series here:
> >>
> >> Due to a regression since next-20140122 the following errors are present:
> >>
> >>   - pin sys_clkout2, which gets configured to 24 Mhz by the fourth patch
> >>     in this set, erroneously outputs only 12 Mhz.
> >>     Just out of curiosity, configuring it to 48 Mhz puts out desired 24 Mhz.
> >>
> >>   - omap_dss, which gets configured by the third patch in this set, fails
> >>     to do 'dss_set_fck_rate(fck);' in
> >>     drivers/video/omap2/dss/dss.c:dss_setup_default_clock() which leads to:
> >>
> >>      | omapdss_dss: probe of omapdss_dss failed with error -22
> >>      | omapdss CORE error: Failed to initialize DSS platform driver
> >>      | panel-dpi panel-dpi.0: failed to find video source 'dpi.0
> >>
> >>    Both regressions seem to have something to do with the clock framework.
> >>    Could this be related to the DT clock conversion patches?
> >
> > No idea...
> 
> Yea its definitely possible, as the clock DT conversion touches pretty 
> much everything. Have you tried whether this works properly with legacy 
> boot? Personally I don't have access to any omap3 devices that would 
> have display and have no possibility to check this out myself. Anyway, 
> my initial guess is that some clock divider setup might be wrong with 
> omap3, or we are missing some ti,set-rate-parent flag for some clock 
> node which prevents escalating clk_set_rate properly. However, it should 
> be easy to debug this by looking at the clock node in question, and its 
> parent nodes to see if there are any problems.

Currently I only analyzed sys_clkout2 (see attachments for full
clk_summary files):

clk_summary__next-20140115__works_as_expected:
             dpll4_m2_ck        1           1            96000000
                dpll4_m2x2_ck   1           1            96000000
                   omap_192m_alwon_fck 1           1            96000000
                      omap_96m_alwon_fck 1           2            96000000
                         per_96m_fck 0           6            96000000
                            mcbsp4_fck 0           1            96000000
                            mcbsp3_fck 0           2            96000000
                            mcbsp2_fck 0           2            96000000
                         cm_96m_fck 2           3            96000000
                            clkout2_src_ck 1           1            96000000
                               sys_clkout2 1           1            24000000

For real, on pin sys_clkout2 are correctly 24 Mhz measured.

clk_summary__next-20140124__sysclkout2_dss_fails:
             dpll4_m2_ck        1           1            96000000
                dpll4_m2x2_mul_ck 1           1            192000000
                   dpll4_m2x2_ck 1           1            192000000
                      omap_192m_alwon_fck 0           0            192000000
                      omap_96m_alwon_fck 1           2            192000000
                         per_96m_fck 0           6            192000000
                            mcbsp4_fck 0           1            192000000
                            mcbsp3_fck 0           2            192000000
                            mcbsp2_fck 0           2            192000000
                         cm_96m_fck 2           3            192000000
                            clkout2_src_ck 1           1            192000000
                               sys_clkout2 1           1            24000000

For real, on pin sys_clkout2 are only ~12 Mhz measured.

So I added this patch:

>From c1f8a2aa60cb8973f7eeeb517fb067b1fce66c1f Mon Sep 17 00:00:00 2001
From: Christoph Fritz <chf.fritz@googlemail.com>
Date: Tue, 28 Jan 2014 17:35:10 +0100
Subject: [PATCH] ARM: dts: fix omap3 clock multiplier for dpll4_m2x2_ck

Before DT clock conversion, there was no multiplier for dpll4_m2x2_ck.
So to be compatible again, set dpll4_m2x2_mul_ck multiplier back to 1.
---
 arch/arm/boot/dts/omap3xxx-clocks.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3xxx-clocks.dtsi b/arch/arm/boot/dts/omap3xxx-clocks.dtsi
index cb04d4b..b594050 100644
--- a/arch/arm/boot/dts/omap3xxx-clocks.dtsi
+++ b/arch/arm/boot/dts/omap3xxx-clocks.dtsi
@@ -212,7 +212,7 @@
 		#clock-cells = <0>;
 		compatible = "fixed-factor-clock";
 		clocks = <&dpll4_m2_ck>;
-		clock-mult = <2>;
+		clock-mult = <1>;
 		clock-div = <1>;
 	};
 
-- 

And it works again. But due to the fact that sys_clkout2 was at 12 Mhz
instead of 24, shouldn't it have been at 48 caused by "clock-mult = 2 ?

Thanks
  -- Christoph

--=-O2t8ZVrguv+r9YKMKeGI
Content-Disposition: attachment; filename="clk_summary__next-20140115__works_as_expected.txt"
Content-Type: text/plain; name="clk_summary__next-20140115__works_as_expected.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

   clock                        enable_cnt  prepare_cnt  rate
---------------------------------------------------------------------
 secure_32k_fck                 0           1            32768
    wdt1_fck                    0           0            32768
    gpt12_fck                   0           1            32768
 mcbsp_clks                     0           5            0
 sys_altclk                     0           0            0
 virt_38_4m_ck                  0           0            38400000
 virt_26000000_ck               1           1            26000000
    osc_sys_ck                  1           1            26000000
       sys_clkout1              0           0            26000000
       sys_ck                   4           18           13000000
          traceclk_src_fck      0           0            13000000
             traceclk_fck       0           0            13000000
          emu_src_ck            0           1            13000000
             atclk_fck          0           0            13000000
             pclkx2_fck         0           0            13000000
             pclk_fck           0           0            6500000
          gpt9_fck              0           1            13000000
          gpt8_fck              0           1            13000000
          gpt7_fck              0           1            13000000
          gpt6_fck              0           1            13000000
          gpt5_fck              0           1            13000000
          gpt4_fck              0           1            13000000
          gpt3_fck              0           1            13000000
          gpt2_fck              0           1            13000000
          dss2_alwon_fck        0           2            13000000
          dpll4_ck              2           3            864000000
             dpll4_m6_ck        0           0            288000000
                dpll4_m6x2_ck   0           0            288000000
                   emu_per_alwon_ck 0           0            288000000
             dpll4_m5_ck        0           0            216000000
                dpll4_m5x2_ck   0           0            216000000
                   cam_mclk     0           0            216000000
             dpll4_m4_ck        1           1            57600000
                dpll4_m4x2_ck   1           1            57600000
                   dss1_alwon_fck_3430es2 2           4            57600000
             dpll4_m3_ck        0           1            54000000
                dpll4_m3x2_ck   0           1            54000000
                   omap_54m_fck 0           1            54000000
                      dss_tv_fck 0           2            54000000
             dpll4_m2_ck        1           1            96000000
                dpll4_m2x2_ck   1           1            96000000
                   omap_192m_alwon_fck 1           1            96000000
                      omap_96m_alwon_fck 1           2            96000000
                         per_96m_fck 0           6            96000000
                            mcbsp4_fck 0           1            96000000
                            mcbsp3_fck 0           2            96000000
                            mcbsp2_fck 0           2            96000000
                         cm_96m_fck 2           3            96000000
                            clkout2_src_ck 1           1            96000000
                               sys_clkout2 1           1            24000000
                            omap_48m_fck 3           4            48000000
                               per_48m_fck 2           2            48000000
                                  uart3_fck 1           1            48000000
                                  uart4_fck 1           1            48000000
                               core_48m_fck 2           6            48000000
                                  uart1_fck 1           1            48000000
                                  uart2_fck 1           1            48000000
                                  mcspi1_fck 0           1            48000000
                                  mcspi2_fck 0           1            48000000
                                  mcspi3_fck 0           1            48000000
                                  mcspi4_fck 0           1            48000000
                               omap_12m_fck 0           1            12000000
                                  core_12m_fck 0           1            12000000
                                     hdq_fck 0           1            12000000
                               usbhost_48m_fck 1           1            48000000
                            omap_96m_fck 0           2            96000000
                               dss_96m_fck 0           2            96000000
                               core_96m_fck 0           10           96000000
                                  mcbsp1_fck 0           1            96000000
                                  mcbsp5_fck 0           1            96000000
                                  i2c1_fck 0           1            96000000
                                  i2c2_fck 0           1            96000000
                                  i2c3_fck 0           1            96000000
                                  mmchs1_fck 0           1            96000000
                                  mmchs2_fck 0           1            96000000
                                  csi2_96m_fck 0           0            96000000
                                  mspro_fck 0           0            96000000
                                  mmchs3_fck 0           1            96000000
             dpll4_x2_ck        0           0            1728000000
          dpll3_ck              1           1            400000000
             dpll3_m3_ck        0           0            200000000
                dpll3_m3x2_ck   0           0            400000000
                   emu_core_alwon_ck 0           0            400000000
             dpll3_m2_ck        1           1            400000000
                dpll3_m2x2_ck   0           0            800000000
                   corex2_fck   0           0            800000000
                      ssi_ssr_fck_3430es2 0           0            266666666
                         ssi_sst_fck_3430es2 0           0            133333333
                core_ck         1           1            400000000
                   l3_ick       2           3            200000000
                      core_l3_ick 8           10           200000000
                         gpmc_fck 2           2            200000000
                         sdrc_ick 1           1            200000000
                         hsotgusb_ick_3430es2 0           1            200000000
                      l4_ick    6           7            100000000
                         per_l4_ick 16          18           100000000
                            mcbsp4_ick 2           2            100000000
                            mcbsp3_ick 2           2            100000000
                            mcbsp2_ick 1           1            100000000
                            gpt2_ick 1           1            100000000
                            gpt3_ick 1           1            100000000
                            gpt4_ick 1           1            100000000
                            gpt5_ick 1           1            100000000
                            gpt6_ick 1           1            100000000
                            gpt7_ick 1           1            100000000
                            gpt8_ick 1           1            100000000
                            gpt9_ick 1           1            100000000
                            uart4_ick 1           1            100000000
                            uart3_ick 1           1            100000000
                            wdt3_ick 0           0            100000000
                            gpio2_ick 0           1            100000000
                            gpio3_ick 0           1            100000000
                            gpio4_ick 1           1            100000000
                            gpio5_ick 1           1            100000000
                            gpio6_ick 1           1            100000000
                         core_l4_ick 21          23           100000000
                            omapctrl_ick 1           1            100000000
                            mcbsp1_ick 1           1            100000000
                            mcbsp5_ick 1           1            100000000
                            gpt10_ick 1           1            100000000
                            gpt11_ick 1           1            100000000
                            uart1_ick 1           1            100000000
                            uart2_ick 1           1            100000000
                            i2c1_ick 1           1            100000000
                            i2c2_ick 1           1            100000000
                            i2c3_ick 1           1            100000000
                            mcspi1_ick 1           1            100000000
                            mcspi2_ick 1           1            100000000
                            mcspi3_ick 1           1            100000000
                            mcspi4_ick 1           1            100000000
                            hdq_ick 0           1            100000000
                            mmchs1_ick 1           1            100000000
                            mmchs2_ick 1           1            100000000
                            icr_ick 0           0            100000000
                            aes2_ick 1           2            100000000
                            sha12_ick 1           2            100000000
                            des2_ick 0           0            100000000
                            mspro_ick 0           0            100000000
                            mailboxes_ick 0           1            100000000
                            usbtll_ick 1           1            100000000
                            mmchs3_ick 1           1            100000000
                         rm_ick 0           0            50000000
                         cam_ick 0           1            100000000
                         ssi_l4_ick 0           0            100000000
                            ssi_ick_3430es2 0           0            100000000
                         sr_l4_ick 2           2            100000000
                         security_l4_ick2 0           0            100000000
                            aes1_ick 0           0            100000000
                            rng_ick 0           0            100000000
                            sha11_ick 0           0            100000000
                            des1_ick 0           0            100000000
                         dss_ick_3430es2 4           6            100000000
                         usbhost_ick 1           1            100000000
                      security_l3_ick 0           0            200000000
                         pka_ick 0           0            200000000
                      sad2d_ick 0           1            200000000
                      mad2d_ick 0           0            200000000
                      sgx_ick   0           0            200000000
                   dpll1_fck    0           0            200000000
                   dpll2_fck    0           0            400000000
                   sgx_fck      0           0            200000000
             dpll3_x2_ck        0           0            800000000
          dpll1_ck              0           1            600000000
             dpll1_x2_ck        0           1            1200000000
                dpll1_x2m2_ck   0           1            1200000000
                   mpu_ck       0           1            1200000000
                      emu_mpu_alwon_ck 0           0            1200000000
                      arm_fck   0           1            600000000
          usim_fck              0           0            6500000
          sr1_fck               0           1            13000000
          sr2_fck               0           1            13000000
          wkup_l4_ick           5           5            13000000
             gpt1_ick           1           1            13000000
             gpt12_ick          1           1            13000000
             omap_32ksync_ick   1           1            13000000
             gpio1_ick          1           1            13000000
             wdt1_ick           0           0            13000000
             wdt2_ick           1           1            13000000
             usim_ick           0           0            13000000
          modem_fck             0           0            13000000
          dpll2_ck              0           1            260000000
             dpll2_m2_ck        0           1            260000000
                iva2_ck         0           1            260000000
          dpll5_ck              1           1            120000000
             dpll5_m2_ck        2           2            120000000
                usbhost_120m_fck 1           2            120000000
                usbtll_fck      1           1            120000000
          cpefuse_fck           0           0            13000000
 virt_19200000_ck               0           0            19200000
 virt_13m_ck                    0           0            13000000
 virt_12m_ck                    0           0            12000000
 omap_32k_fck                   2           8            32768
    gpt1_fck                    1           1            32768
    per_32k_alwon_fck           0           5            32768
       wdt3_fck                 0           0            32768
       gpio2_dbck               0           1            32768
       gpio3_dbck               0           1            32768
       gpio4_dbck               0           1            32768
       gpio5_dbck               0           1            32768
       gpio6_dbck               0           1            32768
    wkup_32k_fck                1           3            32768
       wdt2_fck                 0           1            32768
       gpio1_dbck               0           1            32768
    gpt11_fck                   0           1            32768
    gpt10_fck                   0           1            32768
    ts_fck                      0           0            32768
 dummy_apb_pclk                 0           0            0
 virt_16_8m_ck                  0           0            16800000
 dummy_clk                      0           0            0

--=-O2t8ZVrguv+r9YKMKeGI
Content-Disposition: attachment; filename="clk_summary__next-20140124__sysclkout2_dss_fails.txt"
Content-Type: text/plain; name="clk_summary__next-20140124__sysclkout2_dss_fails.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

   clock                        enable_cnt  prepare_cnt  rate
------------------------------------------------------------------
 secure_32k_fck                 0           1            32768
    wdt1_fck                    0           0            32768
    gpt12_fck                   0           1            32768
 dummy_ck                       0           0            0
 mcbsp_clks                     0           5            0
 sys_altclk                     0           0            0
 virt_38_4m_ck                  0           0            38400000
 virt_26000000_ck               1           1            26000000
    osc_sys_ck                  1           1            26000000
       sys_clkout1              0           0            26000000
       sys_ck                   4           18           13000000
          cpefuse_fck           0           0            13000000
          dpll5_ck              1           1            120000000
             dpll5_m2_ck        2           2            120000000
                usbhost_120m_fck 1           2            120000000
                usbtll_fck      1           1            120000000
                dpll5_m2_d4_ck  0           0            30000000
                dpll5_m2_d8_ck  0           0            15000000
                dpll5_m2_d16_ck 0           0            7500000
                dpll5_m2_d20_ck 0           0            6000000
          sys_d2_ck             0           0            6500000
             usim_fck           0           0            6500000
          modem_fck             0           0            13000000
          dpll2_ck              0           1            260000000
             dpll2_m2_ck        0           1            260000000
                iva2_ck         0           1            260000000
          sr2_fck               0           1            13000000
          sr1_fck               0           1            13000000
          traceclk_src_fck      0           0            13000000
             traceclk_fck       0           0            13000000
          emu_src_mux_ck        0           1            13000000
             emu_src_ck         0           1            13000000
                atclk_fck       0           0            13000000
                pclkx2_fck      0           0            13000000
                pclk_fck        0           0            6500000
          gpt9_fck              0           1            13000000
          gpt8_fck              0           1            13000000
          gpt7_fck              0           1            13000000
          gpt6_fck              0           1            13000000
          gpt5_fck              0           1            13000000
          gpt4_fck              0           1            13000000
          gpt3_fck              0           1            13000000
          gpt2_fck              0           1            13000000
          dss2_alwon_fck        0           2            13000000
          dpll1_ck              0           1            600000000
             dpll1_x2_ck        0           1            1200000000 0
                dpll1_x2m2_ck   0           1            1200000000 0
                   mpu_ck       0           1            1200000000 0
                      emu_mpu_alwon_ck 0           0            1200000000 0
                      arm_fck   0           1            600000000
          dpll3_ck              1           1            400000000
             dpll3_m2_ck        1           1            400000000
                core_ck         1           1            400000000
                   core_d2_ck   0           0            200000000
                      sgx_fck   0           0            200000000
                   core_d6_ck   0           0            66666666
                   core_d4_ck   0           0            100000000
                   core_d3_ck   0           0            133333333
                   dpll2_fck    0           0            400000000
                   l3_ick       2           3            200000000
                      sgx_ick   0           0            200000000
                      mad2d_ick 0           0            200000000
                      sad2d_ick 0           1            200000000
                      security_l3_ick 0           0            200000000
                         pka_ick 0           0            200000000
                      core_l3_ick 8           10           200000000
                         hsotgusb_ick_3430es2 0           1            200000000
                         gpmc_fck 2           2            200000000
                         sdrc_ick 1           1            200000000
                      l4_ick    6           7            100000000
                         usbhost_ick 1           1            100000000
                         dss_ick_3430es2 4           6            100000000
                         sr_l4_ick 2           2            100000000
                         ssi_l4_ick 0           0            100000000
                            ssi_ick_3430es2 0           0            100000000
                         cam_ick 0           1            100000000
                         security_l4_ick2 0           0            100000000
                            des1_ick 0           0            100000000
                            sha11_ick 0           0            100000000
                            rng_ick 0           0            100000000
                            aes1_ick 0           0            100000000
                         per_l4_ick 16          18           100000000
                            mcbsp4_ick 2           2            100000000
                            mcbsp3_ick 2           2            100000000
                            mcbsp2_ick 1           1            100000000
                            gpt2_ick 1           1            100000000
                            gpt3_ick 1           1            100000000
                            gpt4_ick 1           1            100000000
                            gpt5_ick 1           1            100000000
                            gpt6_ick 1           1            100000000
                            gpt7_ick 1           1            100000000
                            gpt8_ick 1           1            100000000
                            gpt9_ick 1           1            100000000
                            uart4_ick 1           1            100000000
                            uart3_ick 1           1            100000000
                            wdt3_ick 0           0            100000000
                            gpio2_ick 0           1            100000000
                            gpio3_ick 0           1            100000000
                            gpio4_ick 1           1            100000000
                            gpio5_ick 1           1            100000000
                            gpio6_ick 1           1            100000000
                         core_l4_ick 21          23           100000000
                            mmchs3_ick 1           1            100000000
                            usbtll_ick 1           1            100000000
                            mailboxes_ick 0           1            100000000
                            mspro_ick 0           0            100000000
                            des2_ick 0           0            100000000
                            icr_ick 0           0            100000000
                            sha12_ick 1           2            100000000
                            aes2_ick 1           2            100000000
                            omapctrl_ick 1           1            100000000
                            mcbsp1_ick 1           1            100000000
                            mcbsp5_ick 1           1            100000000
                            gpt10_ick 1           1            100000000
                            gpt11_ick 1           1            100000000
                            uart1_ick 1           1            100000000
                            uart2_ick 1           1            100000000
                            i2c1_ick 1           1            100000000
                            i2c2_ick 1           1            100000000
                            i2c3_ick 1           1            100000000
                            mcspi1_ick 1           1            100000000
                            mcspi2_ick 1           1            100000000
                            mcspi3_ick 1           1            100000000
                            mcspi4_ick 1           1            100000000
                            hdq_ick 0           1            100000000
                            mmchs1_ick 1           1            100000000
                            mmchs2_ick 1           1            100000000
                         rm_ick 0           0            50000000
                   dpll1_fck    0           0            200000000
                dpll3_m2x2_ck   0           0            800000000
                   corex2_fck   0           0            800000000
                      ssi_ssr_fck_3430es2 0           0            266666666
                         ssi_sst_fck_3430es2 0           0            133333333
                      corex2_d5_fck 0           0            160000000
                      corex2_d3_fck 0           0            266666666
             dpll3_m3_ck        0           0            200000000
                dpll3_m3x2_mul_ck 0           0            400000000
                   dpll3_m3x2_ck 0           0            400000000
                      emu_core_alwon_ck 0           0            400000000
             dpll3_x2_ck        0           0            800000000
          dpll4_ck              1           3            864000000
             dpll4_m6_ck        0           0            288000000
                dpll4_m6x2_mul_ck 0           0            576000000
                   dpll4_m6x2_ck 0           0            576000000
                      emu_per_alwon_ck 0           0            576000000
             dpll4_m5_ck        0           0            216000000
                dpll4_m5x2_mul_ck 0           0            432000000
                   dpll4_m5x2_ck 0           0            432000000
                      cam_mclk  0           0            432000000
             dpll4_m4_ck        0           1            96000000
                dpll4_m4x2_mul_ck 0           1            192000000
                   dpll4_m4x2_ck 0           1            192000000
                      dss1_alwon_fck_3430es2 0           4            192000000
             dpll4_m3_ck        0           1            54000000
                dpll4_m3x2_mul_ck 0           1            108000000
                   dpll4_m3x2_ck 0           1            108000000
                      omap_54m_fck 0           1            108000000
                         dss_tv_fck 0           2            108000000
             dpll4_m2_ck        1           1            96000000
                dpll4_m2x2_mul_ck 1           1            192000000
                   dpll4_m2x2_ck 1           1            192000000
                      omap_192m_alwon_fck 0           0            192000000
                      omap_96m_alwon_fck 1           2            192000000
                         per_96m_fck 0           6            192000000
                            mcbsp4_fck 0           1            192000000
                            mcbsp3_fck 0           2            192000000
                            mcbsp2_fck 0           2            192000000
                         cm_96m_fck 2           3            192000000
                            clkout2_src_ck 1           1            192000000
                               sys_clkout2 1           1            24000000
                            cm_96m_d2_fck 1           1            96000000
                               omap_48m_fck 3           4            96000000
                                  usbhost_48m_fck 1           1            96000000
                                  per_48m_fck 1           2            96000000
                                     uart4_fck 0           1            96000000
                                     uart3_fck 1           1            96000000
                                  core_48m_fck 2           6            96000000
                                     uart1_fck 1           1            96000000
                                     uart2_fck 1           1            96000000
                                     mcspi1_fck 0           1            96000000
                                     mcspi2_fck 0           1            96000000
                                     mcspi3_fck 0           1            96000000
                                     mcspi4_fck 0           1            96000000
                                  omap_12m_fck 0           1            24000000
                                     core_12m_fck 0           1            24000000
                                        hdq_fck   0           1            24000000
                            omap_96m_fck 0           2            192000000
                               omap_96m_d10_fck 0           0            19200000
                               omap_96m_d8_fck 0           0            24000000
                               omap_96m_d4_fck 0           0            48000000
                               omap_96m_d2_fck 0           0            96000000
                               dss_96m_fck 0           2            192000000
                               core_96m_fck 0           10           192000000
                                  mcbsp1_fck 0           1            192000000
                                  mcbsp5_fck 0           1            192000000
                                  mmchs3_fck 0           1            192000000
                                  mspro_fck 0           0            192000000
                                  csi2_96m_fck 0           0            192000000
                                  i2c1_fck 0           1            192000000
                                  i2c2_fck 0           1            192000000
                                  i2c3_fck 0           1            192000000
                                  mmchs1_fck 0           1            192000000
                                  mmchs2_fck 0           1            192000000
             dpll4_x2_ck        0           0            1728000000 0
          wkup_l4_ick           5           5            13000000
             usim_ick           0           0            13000000
             gpt1_ick           1           1            13000000
             gpt12_ick          1           1            13000000
             omap_32ksync_ick   1           1            13000000
             gpio1_ick          1           1            13000000
             wdt1_ick           0           0            13000000
             wdt2_ick           1           1            13000000
 virt_19200000_ck               0           0            19200000
 virt_13m_ck                    0           0            13000000
 virt_12m_ck                    0           0            12000000
 omap_32k_fck                   2           8            32768
    gpt1_fck                    1           1            32768
    ts_fck                      0           0            32768
    per_32k_alwon_fck           0           5            32768
       wdt3_fck                 0           0            32768
       gpio2_dbck               0           1            32768
       gpio3_dbck               0           1            32768
       gpio4_dbck               0           1            32768
       gpio5_dbck               0           1            32768
       gpio6_dbck               0           1            32768
    wkup_32k_fck                1           3            32768
       wdt2_fck                 0           1            32768
       gpio1_dbck               0           1            32768
    gpt11_fck                   0           1            32768
    gpt10_fck                   0           1            32768
 dummy_apb_pclk                 0           0            0
 virt_16_8m_ck                  0           0            16800000

--=-O2t8ZVrguv+r9YKMKeGI
Content-Disposition: attachment; filename="clk_summary_diff.txt"
Content-Type: text/plain; name="clk_summary_diff.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

--- clk_summary__next-20140115__works_as_expected.txt	2014-01-28 16:44:07.226039395 +0100
+++ clk_summary__next-20140124__sysclkout2_dss_fails.txt	2014-01-28 16:44:00.596273550 +0100
@@ -1,8 +1,9 @@
    clock                        enable_cnt  prepare_cnt  rate
----------------------------------------------------------------------
+------------------------------------------------------------------
  secure_32k_fck                 0           1            32768
     wdt1_fck                    0           0            32768
     gpt12_fck                   0           1            32768
+ dummy_ck                       0           0            0
  mcbsp_clks                     0           5            0
  sys_altclk                     0           0            0
  virt_38_4m_ck                  0           0            38400000
@@ -10,12 +11,30 @@
     osc_sys_ck                  1           1            26000000
        sys_clkout1              0           0            26000000
        sys_ck                   4           18           13000000
+          cpefuse_fck           0           0            13000000
+          dpll5_ck              1           1            120000000
+             dpll5_m2_ck        2           2            120000000
+                usbhost_120m_fck 1           2            120000000
+                usbtll_fck      1           1            120000000
+                dpll5_m2_d4_ck  0           0            30000000
+                dpll5_m2_d8_ck  0           0            15000000
+                dpll5_m2_d16_ck 0           0            7500000
+                dpll5_m2_d20_ck 0           0            6000000
+          sys_d2_ck             0           0            6500000
+             usim_fck           0           0            6500000
+          modem_fck             0           0            13000000
+          dpll2_ck              0           1            260000000
+             dpll2_m2_ck        0           1            260000000
+                iva2_ck         0           1            260000000
+          sr2_fck               0           1            13000000
+          sr1_fck               0           1            13000000
           traceclk_src_fck      0           0            13000000
              traceclk_fck       0           0            13000000
-          emu_src_ck            0           1            13000000
-             atclk_fck          0           0            13000000
-             pclkx2_fck         0           0            13000000
-             pclk_fck           0           0            6500000
+          emu_src_mux_ck        0           1            13000000
+             emu_src_ck         0           1            13000000
+                atclk_fck       0           0            13000000
+                pclkx2_fck      0           0            13000000
+                pclk_fck        0           0            6500000
           gpt9_fck              0           1            13000000
           gpt8_fck              0           1            13000000
           gpt7_fck              0           1            13000000
@@ -25,76 +44,43 @@
           gpt3_fck              0           1            13000000
           gpt2_fck              0           1            13000000
           dss2_alwon_fck        0           2            13000000
-          dpll4_ck              2           3            864000000
-             dpll4_m6_ck        0           0            288000000
-                dpll4_m6x2_ck   0           0            288000000
-                   emu_per_alwon_ck 0           0            288000000
-             dpll4_m5_ck        0           0            216000000
-                dpll4_m5x2_ck   0           0            216000000
-                   cam_mclk     0           0            216000000
-             dpll4_m4_ck        1           1            57600000
-                dpll4_m4x2_ck   1           1            57600000
-                   dss1_alwon_fck_3430es2 2           4            57600000
-             dpll4_m3_ck        0           1            54000000
-                dpll4_m3x2_ck   0           1            54000000
-                   omap_54m_fck 0           1            54000000
-                      dss_tv_fck 0           2            54000000
-             dpll4_m2_ck        1           1            96000000
-                dpll4_m2x2_ck   1           1            96000000
-                   omap_192m_alwon_fck 1           1            96000000
-                      omap_96m_alwon_fck 1           2            96000000
-                         per_96m_fck 0           6            96000000
-                            mcbsp4_fck 0           1            96000000
-                            mcbsp3_fck 0           2            96000000
-                            mcbsp2_fck 0           2            96000000
-                         cm_96m_fck 2           3            96000000
-                            clkout2_src_ck 1           1            96000000
-                               sys_clkout2 1           1            24000000
-                            omap_48m_fck 3           4            48000000
-                               per_48m_fck 2           2            48000000
-                                  uart3_fck 1           1            48000000
-                                  uart4_fck 1           1            48000000
-                               core_48m_fck 2           6            48000000
-                                  uart1_fck 1           1            48000000
-                                  uart2_fck 1           1            48000000
-                                  mcspi1_fck 0           1            48000000
-                                  mcspi2_fck 0           1            48000000
-                                  mcspi3_fck 0           1            48000000
-                                  mcspi4_fck 0           1            48000000
-                               omap_12m_fck 0           1            12000000
-                                  core_12m_fck 0           1            12000000
-                                     hdq_fck 0           1            12000000
-                               usbhost_48m_fck 1           1            48000000
-                            omap_96m_fck 0           2            96000000
-                               dss_96m_fck 0           2            96000000
-                               core_96m_fck 0           10           96000000
-                                  mcbsp1_fck 0           1            96000000
-                                  mcbsp5_fck 0           1            96000000
-                                  i2c1_fck 0           1            96000000
-                                  i2c2_fck 0           1            96000000
-                                  i2c3_fck 0           1            96000000
-                                  mmchs1_fck 0           1            96000000
-                                  mmchs2_fck 0           1            96000000
-                                  csi2_96m_fck 0           0            96000000
-                                  mspro_fck 0           0            96000000
-                                  mmchs3_fck 0           1            96000000
-             dpll4_x2_ck        0           0            1728000000
+          dpll1_ck              0           1            600000000
+             dpll1_x2_ck        0           1            1200000000 0
+                dpll1_x2m2_ck   0           1            1200000000 0
+                   mpu_ck       0           1            1200000000 0
+                      emu_mpu_alwon_ck 0           0            1200000000 0
+                      arm_fck   0           1            600000000
           dpll3_ck              1           1            400000000
-             dpll3_m3_ck        0           0            200000000
-                dpll3_m3x2_ck   0           0            400000000
-                   emu_core_alwon_ck 0           0            400000000
              dpll3_m2_ck        1           1            400000000
-                dpll3_m2x2_ck   0           0            800000000
-                   corex2_fck   0           0            800000000
-                      ssi_ssr_fck_3430es2 0           0            266666666
-                         ssi_sst_fck_3430es2 0           0            133333333
                 core_ck         1           1            400000000
+                   core_d2_ck   0           0            200000000
+                      sgx_fck   0           0            200000000
+                   core_d6_ck   0           0            66666666
+                   core_d4_ck   0           0            100000000
+                   core_d3_ck   0           0            133333333
+                   dpll2_fck    0           0            400000000
                    l3_ick       2           3            200000000
+                      sgx_ick   0           0            200000000
+                      mad2d_ick 0           0            200000000
+                      sad2d_ick 0           1            200000000
+                      security_l3_ick 0           0            200000000
+                         pka_ick 0           0            200000000
                       core_l3_ick 8           10           200000000
+                         hsotgusb_ick_3430es2 0           1            200000000
                          gpmc_fck 2           2            200000000
                          sdrc_ick 1           1            200000000
-                         hsotgusb_ick_3430es2 0           1            200000000
                       l4_ick    6           7            100000000
+                         usbhost_ick 1           1            100000000
+                         dss_ick_3430es2 4           6            100000000
+                         sr_l4_ick 2           2            100000000
+                         ssi_l4_ick 0           0            100000000
+                            ssi_ick_3430es2 0           0            100000000
+                         cam_ick 0           1            100000000
+                         security_l4_ick2 0           0            100000000
+                            des1_ick 0           0            100000000
+                            sha11_ick 0           0            100000000
+                            rng_ick 0           0            100000000
+                            aes1_ick 0           0            100000000
                          per_l4_ick 16          18           100000000
                             mcbsp4_ick 2           2            100000000
                             mcbsp3_ick 2           2            100000000
@@ -116,6 +102,14 @@
                             gpio5_ick 1           1            100000000
                             gpio6_ick 1           1            100000000
                          core_l4_ick 21          23           100000000
+                            mmchs3_ick 1           1            100000000
+                            usbtll_ick 1           1            100000000
+                            mailboxes_ick 0           1            100000000
+                            mspro_ick 0           0            100000000
+                            des2_ick 0           0            100000000
+                            icr_ick 0           0            100000000
+                            sha12_ick 1           2            100000000
+                            aes2_ick 1           2            100000000
                             omapctrl_ick 1           1            100000000
                             mcbsp1_ick 1           1            100000000
                             mcbsp5_ick 1           1            100000000
@@ -133,66 +127,97 @@
                             hdq_ick 0           1            100000000
                             mmchs1_ick 1           1            100000000
                             mmchs2_ick 1           1            100000000
-                            icr_ick 0           0            100000000
-                            aes2_ick 1           2            100000000
-                            sha12_ick 1           2            100000000
-                            des2_ick 0           0            100000000
-                            mspro_ick 0           0            100000000
-                            mailboxes_ick 0           1            100000000
-                            usbtll_ick 1           1            100000000
-                            mmchs3_ick 1           1            100000000
                          rm_ick 0           0            50000000
-                         cam_ick 0           1            100000000
-                         ssi_l4_ick 0           0            100000000
-                            ssi_ick_3430es2 0           0            100000000
-                         sr_l4_ick 2           2            100000000
-                         security_l4_ick2 0           0            100000000
-                            aes1_ick 0           0            100000000
-                            rng_ick 0           0            100000000
-                            sha11_ick 0           0            100000000
-                            des1_ick 0           0            100000000
-                         dss_ick_3430es2 4           6            100000000
-                         usbhost_ick 1           1            100000000
-                      security_l3_ick 0           0            200000000
-                         pka_ick 0           0            200000000
-                      sad2d_ick 0           1            200000000
-                      mad2d_ick 0           0            200000000
-                      sgx_ick   0           0            200000000
                    dpll1_fck    0           0            200000000
-                   dpll2_fck    0           0            400000000
-                   sgx_fck      0           0            200000000
+                dpll3_m2x2_ck   0           0            800000000
+                   corex2_fck   0           0            800000000
+                      ssi_ssr_fck_3430es2 0           0            266666666
+                         ssi_sst_fck_3430es2 0           0            133333333
+                      corex2_d5_fck 0           0            160000000
+                      corex2_d3_fck 0           0            266666666
+             dpll3_m3_ck        0           0            200000000
+                dpll3_m3x2_mul_ck 0           0            400000000
+                   dpll3_m3x2_ck 0           0            400000000
+                      emu_core_alwon_ck 0           0            400000000
              dpll3_x2_ck        0           0            800000000
-          dpll1_ck              0           1            600000000
-             dpll1_x2_ck        0           1            1200000000
-                dpll1_x2m2_ck   0           1            1200000000
-                   mpu_ck       0           1            1200000000
-                      emu_mpu_alwon_ck 0           0            1200000000
-                      arm_fck   0           1            600000000
-          usim_fck              0           0            6500000
-          sr1_fck               0           1            13000000
-          sr2_fck               0           1            13000000
+          dpll4_ck              1           3            864000000
+             dpll4_m6_ck        0           0            288000000
+                dpll4_m6x2_mul_ck 0           0            576000000
+                   dpll4_m6x2_ck 0           0            576000000
+                      emu_per_alwon_ck 0           0            576000000
+             dpll4_m5_ck        0           0            216000000
+                dpll4_m5x2_mul_ck 0           0            432000000
+                   dpll4_m5x2_ck 0           0            432000000
+                      cam_mclk  0           0            432000000
+             dpll4_m4_ck        0           1            96000000
+                dpll4_m4x2_mul_ck 0           1            192000000
+                   dpll4_m4x2_ck 0           1            192000000
+                      dss1_alwon_fck_3430es2 0           4            192000000
+             dpll4_m3_ck        0           1            54000000
+                dpll4_m3x2_mul_ck 0           1            108000000
+                   dpll4_m3x2_ck 0           1            108000000
+                      omap_54m_fck 0           1            108000000
+                         dss_tv_fck 0           2            108000000
+             dpll4_m2_ck        1           1            96000000
+                dpll4_m2x2_mul_ck 1           1            192000000
+                   dpll4_m2x2_ck 1           1            192000000
+                      omap_192m_alwon_fck 0           0            192000000
+                      omap_96m_alwon_fck 1           2            192000000
+                         per_96m_fck 0           6            192000000
+                            mcbsp4_fck 0           1            192000000
+                            mcbsp3_fck 0           2            192000000
+                            mcbsp2_fck 0           2            192000000
+                         cm_96m_fck 2           3            192000000
+                            clkout2_src_ck 1           1            192000000
+                               sys_clkout2 1           1            24000000
+                            cm_96m_d2_fck 1           1            96000000
+                               omap_48m_fck 3           4            96000000
+                                  usbhost_48m_fck 1           1            96000000
+                                  per_48m_fck 1           2            96000000
+                                     uart4_fck 0           1            96000000
+                                     uart3_fck 1           1            96000000
+                                  core_48m_fck 2           6            96000000
+                                     uart1_fck 1           1            96000000
+                                     uart2_fck 1           1            96000000
+                                     mcspi1_fck 0           1            96000000
+                                     mcspi2_fck 0           1            96000000
+                                     mcspi3_fck 0           1            96000000
+                                     mcspi4_fck 0           1            96000000
+                                  omap_12m_fck 0           1            24000000
+                                     core_12m_fck 0           1            24000000
+                                        hdq_fck   0           1            24000000
+                            omap_96m_fck 0           2            192000000
+                               omap_96m_d10_fck 0           0            19200000
+                               omap_96m_d8_fck 0           0            24000000
+                               omap_96m_d4_fck 0           0            48000000
+                               omap_96m_d2_fck 0           0            96000000
+                               dss_96m_fck 0           2            192000000
+                               core_96m_fck 0           10           192000000
+                                  mcbsp1_fck 0           1            192000000
+                                  mcbsp5_fck 0           1            192000000
+                                  mmchs3_fck 0           1            192000000
+                                  mspro_fck 0           0            192000000
+                                  csi2_96m_fck 0           0            192000000
+                                  i2c1_fck 0           1            192000000
+                                  i2c2_fck 0           1            192000000
+                                  i2c3_fck 0           1            192000000
+                                  mmchs1_fck 0           1            192000000
+                                  mmchs2_fck 0           1            192000000
+             dpll4_x2_ck        0           0            1728000000 0
           wkup_l4_ick           5           5            13000000
+             usim_ick           0           0            13000000
              gpt1_ick           1           1            13000000
              gpt12_ick          1           1            13000000
              omap_32ksync_ick   1           1            13000000
              gpio1_ick          1           1            13000000
              wdt1_ick           0           0            13000000
              wdt2_ick           1           1            13000000
-             usim_ick           0           0            13000000
-          modem_fck             0           0            13000000
-          dpll2_ck              0           1            260000000
-             dpll2_m2_ck        0           1            260000000
-                iva2_ck         0           1            260000000
-          dpll5_ck              1           1            120000000
-             dpll5_m2_ck        2           2            120000000
-                usbhost_120m_fck 1           2            120000000
-                usbtll_fck      1           1            120000000
-          cpefuse_fck           0           0            13000000
  virt_19200000_ck               0           0            19200000
  virt_13m_ck                    0           0            13000000
  virt_12m_ck                    0           0            12000000
  omap_32k_fck                   2           8            32768
     gpt1_fck                    1           1            32768
+    ts_fck                      0           0            32768
     per_32k_alwon_fck           0           5            32768
        wdt3_fck                 0           0            32768
        gpio2_dbck               0           1            32768
@@ -205,7 +230,5 @@
        gpio1_dbck               0           1            32768
     gpt11_fck                   0           1            32768
     gpt10_fck                   0           1            32768
-    ts_fck                      0           0            32768
  dummy_apb_pclk                 0           0            0
  virt_16_8m_ck                  0           0            16800000
- dummy_clk                      0           0            0

--=-O2t8ZVrguv+r9YKMKeGI--

