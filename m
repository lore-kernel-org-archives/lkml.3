Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936065Ab3BOQ3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:29:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45814 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab3BOQ3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:29:43 -0500
Message-ID: <511E6272.1000800@wwwdotorg.org>
Date: Fri, 15 Feb 2013 09:29:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [RFC 2/2] clk: tegra20: Use DT defines for CLK ID
References: <1360918364-27960-1-git-send-email-hdoyu@nvidia.com> <1360918364-27960-2-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1360918364-27960-2-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 01:52 AM, Hiroshi Doyu wrote:
> To avoid the duplication of CLK ID defines both in boot/dts and kernel
> source, use the one from the DT header file and get rid of own
> definitions in kernel source.

(Also CC'ing the DT maintainers here; sorry for the large quote for
everyone else)

One comment below.

> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
>  drivers/clk/tegra/clk-tegra20.c |  307 ++++++++++++++++++---------------------
>  1 file changed, 145 insertions(+), 162 deletions(-)
> 
> diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
> index 847dabc..b2009c9 100644
> --- a/drivers/clk/tegra/clk-tegra20.c
> +++ b/drivers/clk/tegra/clk-tegra20.c
> @@ -23,6 +23,8 @@
>  #include <linux/clk/tegra.h>
>  #include <linux/delay.h>
>  
> +#include <dts/tegra20-car.h>

It's nice that there is a leading <dts/ prefix here to avoid collisions
with internal headers, but I wonder if including the entire arch/*/boot/
tree in the include path is the correct way to do this.

I'm leaning more and more to changing the dtc include patch from
include/dts arch/*/boot/dts to just Documentation/devicetree, and having
both .dts files and kernel source files #include <bindings/xxx>, or
something roughly like that.

Aside from that, this kind of patch is exactly what I was envisaging
with this feature.

> +
>  #include "clk.h"
>  
>  #define RST_DEVICES_L 0x004
> @@ -201,21 +203,21 @@ static DEFINE_SPINLOCK(sysrate_lock);
>  	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
>  			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_ROUND_UP,	\
>  			_regs, _clk_num, periph_clk_enb_refcnt,		\
> -			_gate_flags, _clk_id)
> +			_gate_flags, TEGRA20_CLK_##_clk_id)
>  
>  #define TEGRA_INIT_DATA_INT(_name, _con_id, _dev_id, _parents, _offset,	\
>  			    _clk_num, _regs, _gate_flags, _clk_id)	\
>  	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
>  			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_INT, _regs,	\
>  			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
> -			_clk_id)
> +			TEGRA20_CLK_##_clk_id)
>  
>  #define TEGRA_INIT_DATA_DIV16(_name, _con_id, _dev_id, _parents, _offset, \
>  			      _clk_num, _regs, _gate_flags, _clk_id)	\
>  	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
>  			30, 2, 0, 0, 16, 0, TEGRA_DIVIDER_ROUND_UP, _regs, \
>  			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
> -			_clk_id)
> +			TEGRA20_CLK_##_clk_id)
>  
>  #define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
>  			      _mux_shift, _mux_width, _clk_num, _regs,	\
> @@ -223,28 +225,9 @@ static DEFINE_SPINLOCK(sysrate_lock);
>  	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
>  			_mux_shift, _mux_width, 0, 0, 0, 0, 0, _regs,	\
>  			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
> -			_clk_id)
> -
> -/* IDs assigned here must be in sync with DT bindings definition
> - * for Tegra20 clocks .
> - */
> -enum tegra20_clk {
> -	cpu, ac97 = 3, rtc, timer, uarta, gpio = 8, sdmmc2, i2s1 = 11, i2c1,
> -	ndflash, sdmmc1, sdmmc4, twc, pwm, i2s2, epp, gr2d = 21, usbd, isp,
> -	gr3d, ide, disp2, disp1, host1x, vcp, cache2 = 31, mem, ahbdma, apbdma,
> -	kbc = 36, stat_mon, pmc, fuse, kfuse, sbc1, nor, spi, sbc2, xio, sbc3,
> -	dvc, dsi, mipi = 50, hdmi, csi, tvdac, i2c2, uartc, emc = 57, usb2,
> -	usb3, mpe, vde, bsea, bsev, speedo, uartd, uarte, i2c3, sbc4, sdmmc3,
> -	pex, owr, afi, csite, pcie_xclk, avpucq = 75, la, irama = 84, iramb,
> -	iramc, iramd, cram2, audio_2x, clk_d, csus = 92, cdev1, cdev2,
> -	uartb = 96, vfir, spdif_in, spdif_out, vi, vi_sensor, tvo, cve,
> -	osc, clk_32k, clk_m, sclk, cclk, hclk, pclk, blink, pll_a, pll_a_out0,
> -	pll_c, pll_c_out1, pll_d, pll_d_out0, pll_e, pll_m, pll_m_out1,
> -	pll_p, pll_p_out1, pll_p_out2, pll_p_out3, pll_p_out4, pll_s, pll_u,
> -	pll_x, cop, audio, pll_ref, twd, clk_max,
> -};
> +			TEGRA20_CLK_##_clk_id)
>  
> -static struct clk *clks[clk_max];
> +static struct clk *clks[TEGRA20_CLK_MAX];
>  static struct clk_onecell_data clk_data;
>  
>  static struct tegra_clk_pll_freq_table pll_c_freq_table[] = {
> @@ -580,7 +563,7 @@ static void tegra20_pll_init(void)
>  			    0, &pll_c_params, TEGRA_PLL_HAS_CPCON,
>  			    pll_c_freq_table, NULL);
>  	clk_register_clkdev(clk, "pll_c", NULL);
> -	clks[pll_c] = clk;
> +	clks[TEGRA20_CLK_PLL_C] = clk;
>  
>  	/* PLLC_OUT1 */
>  	clk = tegra_clk_register_divider("pll_c_out1_div", "pll_c",
> @@ -590,14 +573,14 @@ static void tegra20_pll_init(void)
>  				clk_base + PLLC_OUT, 1, 0, CLK_SET_RATE_PARENT,
>  				0, NULL);
>  	clk_register_clkdev(clk, "pll_c_out1", NULL);
> -	clks[pll_c_out1] = clk;
> +	clks[TEGRA20_CLK_PLL_C_OUT1] = clk;
>  
>  	/* PLLP */
>  	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, NULL, 0,
>  			    216000000, &pll_p_params, TEGRA_PLL_FIXED |
>  			    TEGRA_PLL_HAS_CPCON, pll_p_freq_table, NULL);
>  	clk_register_clkdev(clk, "pll_p", NULL);
> -	clks[pll_p] = clk;
> +	clks[TEGRA20_CLK_PLL_P] = clk;
>  
>  	/* PLLP_OUT1 */
>  	clk = tegra_clk_register_divider("pll_p_out1_div", "pll_p",
> @@ -609,7 +592,7 @@ static void tegra20_pll_init(void)
>  				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
>  				&pll_div_lock);
>  	clk_register_clkdev(clk, "pll_p_out1", NULL);
> -	clks[pll_p_out1] = clk;
> +	clks[TEGRA20_CLK_PLL_P_OUT1] = clk;
>  
>  	/* PLLP_OUT2 */
>  	clk = tegra_clk_register_divider("pll_p_out2_div", "pll_p",
> @@ -621,7 +604,7 @@ static void tegra20_pll_init(void)
>  				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
>  				&pll_div_lock);
>  	clk_register_clkdev(clk, "pll_p_out2", NULL);
> -	clks[pll_p_out2] = clk;
> +	clks[TEGRA20_CLK_PLL_P_OUT2] = clk;
>  
>  	/* PLLP_OUT3 */
>  	clk = tegra_clk_register_divider("pll_p_out3_div", "pll_p",
> @@ -633,7 +616,7 @@ static void tegra20_pll_init(void)
>  				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
>  				&pll_div_lock);
>  	clk_register_clkdev(clk, "pll_p_out3", NULL);
> -	clks[pll_p_out3] = clk;
> +	clks[TEGRA20_CLK_PLL_P_OUT3] = clk;
>  
>  	/* PLLP_OUT4 */
>  	clk = tegra_clk_register_divider("pll_p_out4_div", "pll_p",
> @@ -645,7 +628,7 @@ static void tegra20_pll_init(void)
>  				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
>  				&pll_div_lock);
>  	clk_register_clkdev(clk, "pll_p_out4", NULL);
> -	clks[pll_p_out4] = clk;
> +	clks[TEGRA20_CLK_PLL_P_OUT4] = clk;
>  
>  	/* PLLM */
>  	clk = tegra_clk_register_pll("pll_m", "pll_ref", clk_base, NULL,
> @@ -653,7 +636,7 @@ static void tegra20_pll_init(void)
>  			    &pll_m_params, TEGRA_PLL_HAS_CPCON,
>  			    pll_m_freq_table, NULL);
>  	clk_register_clkdev(clk, "pll_m", NULL);
> -	clks[pll_m] = clk;
> +	clks[TEGRA20_CLK_PLL_M] = clk;
>  
>  	/* PLLM_OUT1 */
>  	clk = tegra_clk_register_divider("pll_m_out1_div", "pll_m",
> @@ -663,41 +646,41 @@ static void tegra20_pll_init(void)
>  				clk_base + PLLM_OUT, 1, 0, CLK_IGNORE_UNUSED |
>  				CLK_SET_RATE_PARENT, 0, NULL);
>  	clk_register_clkdev(clk, "pll_m_out1", NULL);
> -	clks[pll_m_out1] = clk;
> +	clks[TEGRA20_CLK_PLL_M_OUT1] = clk;
>  
>  	/* PLLX */
>  	clk = tegra_clk_register_pll("pll_x", "pll_ref", clk_base, NULL, 0,
>  			    0, &pll_x_params, TEGRA_PLL_HAS_CPCON,
>  			    pll_x_freq_table, NULL);
>  	clk_register_clkdev(clk, "pll_x", NULL);
> -	clks[pll_x] = clk;
> +	clks[TEGRA20_CLK_PLL_X] = clk;
>  
>  	/* PLLU */
>  	clk = tegra_clk_register_pll("pll_u", "pll_ref", clk_base, NULL, 0,
>  			    0, &pll_u_params, TEGRA_PLLU | TEGRA_PLL_HAS_CPCON,
>  			    pll_u_freq_table, NULL);
>  	clk_register_clkdev(clk, "pll_u", NULL);
> -	clks[pll_u] = clk;
> +	clks[TEGRA20_CLK_PLL_U] = clk;
>  
>  	/* PLLD */
>  	clk = tegra_clk_register_pll("pll_d", "pll_ref", clk_base, NULL, 0,
>  			    0, &pll_d_params, TEGRA_PLL_HAS_CPCON,
>  			    pll_d_freq_table, NULL);
>  	clk_register_clkdev(clk, "pll_d", NULL);
> -	clks[pll_d] = clk;
> +	clks[TEGRA20_CLK_PLL_D] = clk;
>  
>  	/* PLLD_OUT0 */
>  	clk = clk_register_fixed_factor(NULL, "pll_d_out0", "pll_d",
>  					CLK_SET_RATE_PARENT, 1, 2);
>  	clk_register_clkdev(clk, "pll_d_out0", NULL);
> -	clks[pll_d_out0] = clk;
> +	clks[TEGRA20_CLK_PLL_D_OUT0] = clk;
>  
>  	/* PLLA */
>  	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, NULL, 0,
>  			    0, &pll_a_params, TEGRA_PLL_HAS_CPCON,
>  			    pll_a_freq_table, NULL);
>  	clk_register_clkdev(clk, "pll_a", NULL);
> -	clks[pll_a] = clk;
> +	clks[TEGRA20_CLK_PLL_A] = clk;
>  
>  	/* PLLA_OUT0 */
>  	clk = tegra_clk_register_divider("pll_a_out0_div", "pll_a",
> @@ -707,14 +690,14 @@ static void tegra20_pll_init(void)
>  				clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
>  				CLK_SET_RATE_PARENT, 0, NULL);
>  	clk_register_clkdev(clk, "pll_a_out0", NULL);
> -	clks[pll_a_out0] = clk;
> +	clks[TEGRA20_CLK_PLL_A_OUT0] = clk;
>  
>  	/* PLLE */
>  	clk = tegra_clk_register_plle("pll_e", "pll_ref", clk_base, NULL,
>  			     0, 100000000, &pll_e_params,
>  			     0, pll_e_freq_table, NULL);
>  	clk_register_clkdev(clk, "pll_e", NULL);
> -	clks[pll_e] = clk;
> +	clks[TEGRA20_CLK_PLL_E] = clk;
>  }
>  
>  static const char *cclk_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
> @@ -765,14 +748,14 @@ static void tegra20_super_clk_init(void)
>  			      ARRAY_SIZE(cclk_parents), CLK_SET_RATE_PARENT,
>  			      clk_base + CCLK_BURST_POLICY, 0, 4, 0, 0, NULL);
>  	clk_register_clkdev(clk, "cclk", NULL);
> -	clks[cclk] = clk;
> +	clks[TEGRA20_CLK_CCLK] = clk;
>  
>  	/* SCLK */
>  	clk = tegra_clk_register_super_mux("sclk", sclk_parents,
>  			      ARRAY_SIZE(sclk_parents), CLK_SET_RATE_PARENT,
>  			      clk_base + SCLK_BURST_POLICY, 0, 4, 0, 0, NULL);
>  	clk_register_clkdev(clk, "sclk", NULL);
> -	clks[sclk] = clk;
> +	clks[TEGRA20_CLK_SCLK] = clk;
>  
>  	/* HCLK */
>  	clk = clk_register_divider(NULL, "hclk_div", "sclk", 0,
> @@ -782,7 +765,7 @@ static void tegra20_super_clk_init(void)
>  				clk_base + CLK_SYSTEM_RATE, 7,
>  				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
>  	clk_register_clkdev(clk, "hclk", NULL);
> -	clks[hclk] = clk;
> +	clks[TEGRA20_CLK_HCLK] = clk;
>  
>  	/* PCLK */
>  	clk = clk_register_divider(NULL, "pclk_div", "hclk", 0,
> @@ -792,12 +775,12 @@ static void tegra20_super_clk_init(void)
>  				clk_base + CLK_SYSTEM_RATE, 3,
>  				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
>  	clk_register_clkdev(clk, "pclk", NULL);
> -	clks[pclk] = clk;
> +	clks[TEGRA20_CLK_PCLK] = clk;
>  
>  	/* twd */
>  	clk = clk_register_fixed_factor(NULL, "twd", "cclk", 0, 1, 4);
>  	clk_register_clkdev(clk, "twd", NULL);
> -	clks[twd] = clk;
> +	clks[TEGRA20_CLK_TWD] = clk;
>  }
>  
>  static const char *audio_parents[] = {"spdif_in", "i2s1", "i2s2", "unused",
> @@ -816,7 +799,7 @@ static void __init tegra20_audio_clk_init(void)
>  				clk_base + AUDIO_SYNC_CLK, 4,
>  				CLK_GATE_SET_TO_DISABLE, NULL);
>  	clk_register_clkdev(clk, "audio", NULL);
> -	clks[audio] = clk;
> +	clks[TEGRA20_CLK_AUDIO] = clk;
>  
>  	/* audio_2x */
>  	clk = clk_register_fixed_factor(NULL, "audio_doubler", "audio",
> @@ -826,7 +809,7 @@ static void __init tegra20_audio_clk_init(void)
>  				    CLK_SET_RATE_PARENT, 89, &periph_u_regs,
>  				    periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, "audio_2x", NULL);
> -	clks[audio_2x] = clk;
> +	clks[TEGRA20_CLK_AUDIO_2X] = clk;
>  
>  }
>  
> @@ -846,56 +829,56 @@ static const char *mux_pllpdc_clkm[] = {"pll_p", "pll_d_out0", "pll_c",
>  static const char *mux_pllmcp_clkm[] = {"pll_m", "pll_c", "pll_p", "clk_m"};
>  
>  static struct tegra_periph_init_data tegra_periph_clk_list[] = {
> -	TEGRA_INIT_DATA_MUX("i2s1",	NULL,		"tegra20-i2s.0", i2s1_parents,	    CLK_SOURCE_I2S1,	  11,	&periph_l_regs, TEGRA_PERIPH_ON_APB, i2s1),
> -	TEGRA_INIT_DATA_MUX("i2s2",	NULL,		"tegra20-i2s.1", i2s2_parents,	    CLK_SOURCE_I2S2,	  18,	&periph_l_regs, TEGRA_PERIPH_ON_APB, i2s2),
> -	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out",	"tegra20-spdif", spdif_out_parents, CLK_SOURCE_SPDIF_OUT, 10,	&periph_l_regs, TEGRA_PERIPH_ON_APB, spdif_out),
> -	TEGRA_INIT_DATA_MUX("spdif_in",	"spdif_in",	"tegra20-spdif", spdif_in_parents,  CLK_SOURCE_SPDIF_IN,  10,	&periph_l_regs, TEGRA_PERIPH_ON_APB, spdif_in),
> -	TEGRA_INIT_DATA_MUX("sbc1",	NULL,		"spi_tegra.0",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC1,	  41,	&periph_h_regs, TEGRA_PERIPH_ON_APB, sbc1),
> -	TEGRA_INIT_DATA_MUX("sbc2",	NULL,		"spi_tegra.1",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC2,	  44,	&periph_h_regs, TEGRA_PERIPH_ON_APB, sbc2),
> -	TEGRA_INIT_DATA_MUX("sbc3",	NULL,		"spi_tegra.2",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC3,	  46,	&periph_h_regs, TEGRA_PERIPH_ON_APB, sbc3),
> -	TEGRA_INIT_DATA_MUX("sbc4",	NULL,		"spi_tegra.3",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC4,	  68,	&periph_u_regs, TEGRA_PERIPH_ON_APB, sbc4),
> -	TEGRA_INIT_DATA_MUX("spi",	NULL,		"spi",		 mux_pllpcm_clkm,   CLK_SOURCE_SPI,	  43,	&periph_h_regs, TEGRA_PERIPH_ON_APB, spi),
> -	TEGRA_INIT_DATA_MUX("xio",	NULL,		"xio",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  45,	&periph_h_regs, 0, xio),
> -	TEGRA_INIT_DATA_MUX("twc",	NULL,		"twc",		 mux_pllpcm_clkm,   CLK_SOURCE_TWC,	  16,	&periph_l_regs, TEGRA_PERIPH_ON_APB, twc),
> -	TEGRA_INIT_DATA_MUX("ide",	NULL,		"ide",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  25,	&periph_l_regs, 0, ide),
> -	TEGRA_INIT_DATA_MUX("ndflash",	NULL,		"tegra_nand",	 mux_pllpcm_clkm,   CLK_SOURCE_NDFLASH,	  13,	&periph_l_regs, 0, ndflash),
> -	TEGRA_INIT_DATA_MUX("vfir",	NULL,		"vfir",		 mux_pllpcm_clkm,   CLK_SOURCE_VFIR,	  7,	&periph_l_regs, TEGRA_PERIPH_ON_APB, vfir),
> -	TEGRA_INIT_DATA_MUX("csite",	NULL,		"csite",	 mux_pllpcm_clkm,   CLK_SOURCE_CSITE,	  73,	&periph_u_regs, 0, csite),
> -	TEGRA_INIT_DATA_MUX("la",	NULL,		"la",		 mux_pllpcm_clkm,   CLK_SOURCE_LA,	  76,	&periph_u_regs, 0, la),
> -	TEGRA_INIT_DATA_MUX("owr",	NULL,		"tegra_w1",	 mux_pllpcm_clkm,   CLK_SOURCE_OWR,	  71,	&periph_u_regs, TEGRA_PERIPH_ON_APB, owr),
> -	TEGRA_INIT_DATA_MUX("mipi",	NULL,		"mipi",		 mux_pllpcm_clkm,   CLK_SOURCE_MIPI,	  50,	&periph_h_regs, TEGRA_PERIPH_ON_APB, mipi),
> -	TEGRA_INIT_DATA_MUX("vde",	NULL,		"vde",		 mux_pllpcm_clkm,   CLK_SOURCE_VDE,	  61,	&periph_h_regs, 0, vde),
> -	TEGRA_INIT_DATA_MUX("vi",	"vi",		"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI,	  20,	&periph_l_regs, 0, vi),
> -	TEGRA_INIT_DATA_MUX("epp",	NULL,		"epp",		 mux_pllmcpa,	    CLK_SOURCE_EPP,	  19,	&periph_l_regs, 0, epp),
> -	TEGRA_INIT_DATA_MUX("mpe",	NULL,		"mpe",		 mux_pllmcpa,	    CLK_SOURCE_MPE,	  60,	&periph_h_regs, 0, mpe),
> -	TEGRA_INIT_DATA_MUX("host1x",	NULL,		"host1x",	 mux_pllmcpa,	    CLK_SOURCE_HOST1X,	  28,	&periph_l_regs, 0, host1x),
> -	TEGRA_INIT_DATA_MUX("3d",	NULL,		"3d",		 mux_pllmcpa,	    CLK_SOURCE_3D,	  24,	&periph_l_regs, TEGRA_PERIPH_MANUAL_RESET, gr3d),
> -	TEGRA_INIT_DATA_MUX("2d",	NULL,		"2d",		 mux_pllmcpa,	    CLK_SOURCE_2D,	  21,	&periph_l_regs, 0, gr2d),
> -	TEGRA_INIT_DATA_MUX("nor",	NULL,		"tegra-nor",	 mux_pllpcm_clkm,   CLK_SOURCE_NOR,	  42,	&periph_h_regs, 0, nor),
> -	TEGRA_INIT_DATA_MUX("sdmmc1",	NULL,		"sdhci-tegra.0", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC1,	  14,	&periph_l_regs, 0, sdmmc1),
> -	TEGRA_INIT_DATA_MUX("sdmmc2",	NULL,		"sdhci-tegra.1", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC2,	  9,	&periph_l_regs, 0, sdmmc2),
> -	TEGRA_INIT_DATA_MUX("sdmmc3",	NULL,		"sdhci-tegra.2", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC3,	  69,	&periph_u_regs, 0, sdmmc3),
> -	TEGRA_INIT_DATA_MUX("sdmmc4",	NULL,		"sdhci-tegra.3", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC4,	  15,	&periph_l_regs, 0, sdmmc4),
> -	TEGRA_INIT_DATA_MUX("cve",	NULL,		"cve",		 mux_pllpdc_clkm,   CLK_SOURCE_CVE,	  49,	&periph_h_regs, 0, cve),
> -	TEGRA_INIT_DATA_MUX("tvo",	NULL,		"tvo",		 mux_pllpdc_clkm,   CLK_SOURCE_TVO,	  49,	&periph_h_regs, 0, tvo),
> -	TEGRA_INIT_DATA_MUX("tvdac",	NULL,		"tvdac",	 mux_pllpdc_clkm,   CLK_SOURCE_TVDAC,	  53,	&periph_h_regs, 0, tvdac),
> -	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor",	"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI_SENSOR, 20,	&periph_l_regs, TEGRA_PERIPH_NO_RESET, vi_sensor),
> -	TEGRA_INIT_DATA_DIV16("i2c1",	"div-clk",	"tegra-i2c.0",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C1,	  12,	&periph_l_regs, TEGRA_PERIPH_ON_APB, i2c1),
> -	TEGRA_INIT_DATA_DIV16("i2c2",	"div-clk",	"tegra-i2c.1",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C2,	  54,	&periph_h_regs, TEGRA_PERIPH_ON_APB, i2c2),
> -	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C3,	  67,	&periph_u_regs,	TEGRA_PERIPH_ON_APB, i2c3),
> -	TEGRA_INIT_DATA_DIV16("dvc",	"div-clk",	"tegra-i2c.3",	 mux_pllpcm_clkm,   CLK_SOURCE_DVC,	  47,	&periph_h_regs,	TEGRA_PERIPH_ON_APB, dvc),
> -	TEGRA_INIT_DATA_MUX("hdmi",	NULL,		"hdmi",		 mux_pllpdc_clkm,   CLK_SOURCE_HDMI,	  51,	&periph_h_regs,	0, hdmi),
> -	TEGRA_INIT_DATA("pwm",		NULL,		"tegra-pwm",	 pwm_parents,	    CLK_SOURCE_PWM,	  28, 3, 0, 0, 8, 1, 0, &periph_l_regs, 17, periph_clk_enb_refcnt, TEGRA_PERIPH_ON_APB, pwm),
> +	TEGRA_INIT_DATA_MUX("i2s1",	NULL,		"tegra20-i2s.0", i2s1_parents,	    CLK_SOURCE_I2S1,	  11,	&periph_l_regs, TEGRA_PERIPH_ON_APB, I2S1),
> +	TEGRA_INIT_DATA_MUX("i2s2",	NULL,		"tegra20-i2s.1", i2s2_parents,	    CLK_SOURCE_I2S2,	  18,	&periph_l_regs, TEGRA_PERIPH_ON_APB, I2S2),
> +	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out",	"tegra20-spdif", spdif_out_parents, CLK_SOURCE_SPDIF_OUT, 10,	&periph_l_regs, TEGRA_PERIPH_ON_APB, SPDIF_OUT),
> +	TEGRA_INIT_DATA_MUX("spdif_in",	"spdif_in",	"tegra20-spdif", spdif_in_parents,  CLK_SOURCE_SPDIF_IN,  10,	&periph_l_regs, TEGRA_PERIPH_ON_APB, SPDIF_IN),
> +	TEGRA_INIT_DATA_MUX("sbc1",	NULL,		"spi_tegra.0",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC1,	  41,	&periph_h_regs, TEGRA_PERIPH_ON_APB, SBC1),
> +	TEGRA_INIT_DATA_MUX("sbc2",	NULL,		"spi_tegra.1",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC2,	  44,	&periph_h_regs, TEGRA_PERIPH_ON_APB, SBC2),
> +	TEGRA_INIT_DATA_MUX("sbc3",	NULL,		"spi_tegra.2",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC3,	  46,	&periph_h_regs, TEGRA_PERIPH_ON_APB, SBC3),
> +	TEGRA_INIT_DATA_MUX("sbc4",	NULL,		"spi_tegra.3",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC4,	  68,	&periph_u_regs, TEGRA_PERIPH_ON_APB, SBC4),
> +	TEGRA_INIT_DATA_MUX("spi",	NULL,		"spi",		 mux_pllpcm_clkm,   CLK_SOURCE_SPI,	  43,	&periph_h_regs, TEGRA_PERIPH_ON_APB, SPI),
> +	TEGRA_INIT_DATA_MUX("xio",	NULL,		"xio",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  45,	&periph_h_regs, 0, XIO),
> +	TEGRA_INIT_DATA_MUX("twc",	NULL,		"twc",		 mux_pllpcm_clkm,   CLK_SOURCE_TWC,	  16,	&periph_l_regs, TEGRA_PERIPH_ON_APB, TWC),
> +	TEGRA_INIT_DATA_MUX("ide",	NULL,		"ide",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  25,	&periph_l_regs, 0, IDE),
> +	TEGRA_INIT_DATA_MUX("ndflash",	NULL,		"tegra_nand",	 mux_pllpcm_clkm,   CLK_SOURCE_NDFLASH,	  13,	&periph_l_regs, 0, NDFLASH),
> +	TEGRA_INIT_DATA_MUX("vfir",	NULL,		"vfir",		 mux_pllpcm_clkm,   CLK_SOURCE_VFIR,	  7,	&periph_l_regs, TEGRA_PERIPH_ON_APB, VFIR),
> +	TEGRA_INIT_DATA_MUX("csite",	NULL,		"csite",	 mux_pllpcm_clkm,   CLK_SOURCE_CSITE,	  73,	&periph_u_regs, 0, CSITE),
> +	TEGRA_INIT_DATA_MUX("la",	NULL,		"la",		 mux_pllpcm_clkm,   CLK_SOURCE_LA,	  76,	&periph_u_regs, 0, LA),
> +	TEGRA_INIT_DATA_MUX("owr",	NULL,		"tegra_w1",	 mux_pllpcm_clkm,   CLK_SOURCE_OWR,	  71,	&periph_u_regs, TEGRA_PERIPH_ON_APB, OWR),
> +	TEGRA_INIT_DATA_MUX("mipi",	NULL,		"mipi",		 mux_pllpcm_clkm,   CLK_SOURCE_MIPI,	  50,	&periph_h_regs, TEGRA_PERIPH_ON_APB, MIPI),
> +	TEGRA_INIT_DATA_MUX("vde",	NULL,		"vde",		 mux_pllpcm_clkm,   CLK_SOURCE_VDE,	  61,	&periph_h_regs, 0, VDE),
> +	TEGRA_INIT_DATA_MUX("vi",	"vi",		"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI,	  20,	&periph_l_regs, 0, VI),
> +	TEGRA_INIT_DATA_MUX("epp",	NULL,		"epp",		 mux_pllmcpa,	    CLK_SOURCE_EPP,	  19,	&periph_l_regs, 0, EPP),
> +	TEGRA_INIT_DATA_MUX("mpe",	NULL,		"mpe",		 mux_pllmcpa,	    CLK_SOURCE_MPE,	  60,	&periph_h_regs, 0, MPE),
> +	TEGRA_INIT_DATA_MUX("host1x",	NULL,		"host1x",	 mux_pllmcpa,	    CLK_SOURCE_HOST1X,	  28,	&periph_l_regs, 0, HOST1X),
> +	TEGRA_INIT_DATA_MUX("3d",	NULL,		"3d",		 mux_pllmcpa,	    CLK_SOURCE_3D,	  24,	&periph_l_regs, TEGRA_PERIPH_MANUAL_RESET, GR3D),
> +	TEGRA_INIT_DATA_MUX("2d",	NULL,		"2d",		 mux_pllmcpa,	    CLK_SOURCE_2D,	  21,	&periph_l_regs, 0, GR2D),
> +	TEGRA_INIT_DATA_MUX("nor",	NULL,		"tegra-nor",	 mux_pllpcm_clkm,   CLK_SOURCE_NOR,	  42,	&periph_h_regs, 0, NOR),
> +	TEGRA_INIT_DATA_MUX("sdmmc1",	NULL,		"sdhci-tegra.0", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC1,	  14,	&periph_l_regs, 0, SDMMC1),
> +	TEGRA_INIT_DATA_MUX("sdmmc2",	NULL,		"sdhci-tegra.1", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC2,	  9,	&periph_l_regs, 0, SDMMC2),
> +	TEGRA_INIT_DATA_MUX("sdmmc3",	NULL,		"sdhci-tegra.2", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC3,	  69,	&periph_u_regs, 0, SDMMC3),
> +	TEGRA_INIT_DATA_MUX("sdmmc4",	NULL,		"sdhci-tegra.3", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC4,	  15,	&periph_l_regs, 0, SDMMC4),
> +	TEGRA_INIT_DATA_MUX("cve",	NULL,		"cve",		 mux_pllpdc_clkm,   CLK_SOURCE_CVE,	  49,	&periph_h_regs, 0, CVE),
> +	TEGRA_INIT_DATA_MUX("tvo",	NULL,		"tvo",		 mux_pllpdc_clkm,   CLK_SOURCE_TVO,	  49,	&periph_h_regs, 0, TVO),
> +	TEGRA_INIT_DATA_MUX("tvdac",	NULL,		"tvdac",	 mux_pllpdc_clkm,   CLK_SOURCE_TVDAC,	  53,	&periph_h_regs, 0, TVDAC),
> +	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor",	"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI_SENSOR, 20,	&periph_l_regs, TEGRA_PERIPH_NO_RESET, VI_SENSOR),
> +	TEGRA_INIT_DATA_DIV16("i2c1",	"div-clk",	"tegra-i2c.0",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C1,	  12,	&periph_l_regs, TEGRA_PERIPH_ON_APB, I2C1),
> +	TEGRA_INIT_DATA_DIV16("i2c2",	"div-clk",	"tegra-i2c.1",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C2,	  54,	&periph_h_regs, TEGRA_PERIPH_ON_APB, I2C2),
> +	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C3,	  67,	&periph_u_regs,	TEGRA_PERIPH_ON_APB, I2C3),
> +	TEGRA_INIT_DATA_DIV16("dvc",	"div-clk",	"tegra-i2c.3",	 mux_pllpcm_clkm,   CLK_SOURCE_DVC,	  47,	&periph_h_regs,	TEGRA_PERIPH_ON_APB, DVC),
> +	TEGRA_INIT_DATA_MUX("hdmi",	NULL,		"hdmi",		 mux_pllpdc_clkm,   CLK_SOURCE_HDMI,	  51,	&periph_h_regs,	0, HDMI),
> +	TEGRA_INIT_DATA("pwm",		NULL,		"tegra-pwm",	 pwm_parents,	    CLK_SOURCE_PWM,	  28, 3, 0, 0, 8, 1, 0, &periph_l_regs, 17, periph_clk_enb_refcnt, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_PWM),
>  };
>  
>  static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
> -	TEGRA_INIT_DATA_NODIV("uarta",	NULL, "tegra_uart.0", mux_pllpcm_clkm, CLK_SOURCE_UARTA, 30, 2, 6,  &periph_l_regs, TEGRA_PERIPH_ON_APB, uarta),
> -	TEGRA_INIT_DATA_NODIV("uartb",	NULL, "tegra_uart.1", mux_pllpcm_clkm, CLK_SOURCE_UARTB, 30, 2, 7,  &periph_l_regs, TEGRA_PERIPH_ON_APB, uartb),
> -	TEGRA_INIT_DATA_NODIV("uartc",	NULL, "tegra_uart.2", mux_pllpcm_clkm, CLK_SOURCE_UARTC, 30, 2, 55, &periph_h_regs, TEGRA_PERIPH_ON_APB, uartc),
> -	TEGRA_INIT_DATA_NODIV("uartd",	NULL, "tegra_uart.3", mux_pllpcm_clkm, CLK_SOURCE_UARTD, 30, 2, 65, &periph_u_regs, TEGRA_PERIPH_ON_APB, uartd),
> -	TEGRA_INIT_DATA_NODIV("uarte",	NULL, "tegra_uart.4", mux_pllpcm_clkm, CLK_SOURCE_UARTE, 30, 2, 66, &periph_u_regs, TEGRA_PERIPH_ON_APB, uarte),
> -	TEGRA_INIT_DATA_NODIV("disp1",	NULL, "tegradc.0",    mux_pllpdc_clkm, CLK_SOURCE_DISP1, 30, 2, 27, &periph_l_regs, 0, disp1),
> -	TEGRA_INIT_DATA_NODIV("disp2",	NULL, "tegradc.1",    mux_pllpdc_clkm, CLK_SOURCE_DISP2, 30, 2, 26, &periph_l_regs, 0, disp2),
> +	TEGRA_INIT_DATA_NODIV("uarta",	NULL, "tegra_uart.0", mux_pllpcm_clkm, CLK_SOURCE_UARTA, 30, 2, 6,  &periph_l_regs, TEGRA_PERIPH_ON_APB, UARTA),
> +	TEGRA_INIT_DATA_NODIV("uartb",	NULL, "tegra_uart.1", mux_pllpcm_clkm, CLK_SOURCE_UARTB, 30, 2, 7,  &periph_l_regs, TEGRA_PERIPH_ON_APB, UARTB),
> +	TEGRA_INIT_DATA_NODIV("uartc",	NULL, "tegra_uart.2", mux_pllpcm_clkm, CLK_SOURCE_UARTC, 30, 2, 55, &periph_h_regs, TEGRA_PERIPH_ON_APB, UARTC),
> +	TEGRA_INIT_DATA_NODIV("uartd",	NULL, "tegra_uart.3", mux_pllpcm_clkm, CLK_SOURCE_UARTD, 30, 2, 65, &periph_u_regs, TEGRA_PERIPH_ON_APB, UARTD),
> +	TEGRA_INIT_DATA_NODIV("uarte",	NULL, "tegra_uart.4", mux_pllpcm_clkm, CLK_SOURCE_UARTE, 30, 2, 66, &periph_u_regs, TEGRA_PERIPH_ON_APB, UARTE),
> +	TEGRA_INIT_DATA_NODIV("disp1",	NULL, "tegradc.0",    mux_pllpdc_clkm, CLK_SOURCE_DISP1, 30, 2, 27, &periph_l_regs, 0, DISP1),
> +	TEGRA_INIT_DATA_NODIV("disp2",	NULL, "tegradc.1",    mux_pllpdc_clkm, CLK_SOURCE_DISP2, 30, 2, 26, &periph_l_regs, 0, DISP2),
>  };
>  
>  static void __init tegra20_periph_clk_init(void)
> @@ -909,7 +892,7 @@ static void __init tegra20_periph_clk_init(void)
>  				    0, 34, &periph_h_regs,
>  				    periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, NULL, "tegra-apbdma");
> -	clks[apbdma] = clk;
> +	clks[TEGRA20_CLK_APBDMA] = clk;
>  
>  	/* rtc */
>  	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
> @@ -917,14 +900,14 @@ static void __init tegra20_periph_clk_init(void)
>  				    clk_base, 0, 4, &periph_l_regs,
>  				    periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, NULL, "rtc-tegra");
> -	clks[rtc] = clk;
> +	clks[TEGRA20_CLK_RTC] = clk;
>  
>  	/* timer */
>  	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base,
>  				    0, 5, &periph_l_regs,
>  				    periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, NULL, "timer");
> -	clks[timer] = clk;
> +	clks[TEGRA20_CLK_TIMER] = clk;
>  
>  	/* kbc */
>  	clk = tegra_clk_register_periph_gate("kbc", "clk_32k",
> @@ -932,7 +915,7 @@ static void __init tegra20_periph_clk_init(void)
>  				    clk_base, 0, 36, &periph_h_regs,
>  				    periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, NULL, "tegra-kbc");
> -	clks[kbc] = clk;
> +	clks[TEGRA20_CLK_KBC] = clk;
>  
>  	/* csus */
>  	clk = tegra_clk_register_periph_gate("csus", "clk_m",
> @@ -940,28 +923,28 @@ static void __init tegra20_periph_clk_init(void)
>  				    clk_base, 0, 92, &periph_u_regs,
>  				    periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, "csus", "tengra_camera");
> -	clks[csus] = clk;
> +	clks[TEGRA20_CLK_CSUS] = clk;
>  
>  	/* vcp */
>  	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0,
>  				    clk_base, 0, 29, &periph_l_regs,
>  				    periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, "vcp", "tegra-avp");
> -	clks[vcp] = clk;
> +	clks[TEGRA20_CLK_VCP] = clk;
>  
>  	/* bsea */
>  	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0,
>  				    clk_base, 0, 62, &periph_h_regs,
>  				    periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, "bsea", "tegra-avp");
> -	clks[bsea] = clk;
> +	clks[TEGRA20_CLK_BSEA] = clk;
>  
>  	/* bsev */
>  	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0,
>  				    clk_base, 0, 63, &periph_h_regs,
>  				    periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, "bsev", "tegra-aes");
> -	clks[bsev] = clk;
> +	clks[TEGRA20_CLK_BSEV] = clk;
>  
>  	/* emc */
>  	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
> @@ -971,63 +954,63 @@ static void __init tegra20_periph_clk_init(void)
>  	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base, 0,
>  				    57, &periph_h_regs, periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, "emc", NULL);
> -	clks[emc] = clk;
> +	clks[TEGRA20_CLK_EMC] = clk;
>  
>  	/* usbd */
>  	clk = tegra_clk_register_periph_gate("usbd", "clk_m", 0, clk_base, 0,
>  				    22, &periph_l_regs, periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, NULL, "fsl-tegra-udc");
> -	clks[usbd] = clk;
> +	clks[TEGRA20_CLK_USBD] = clk;
>  
>  	/* usb2 */
>  	clk = tegra_clk_register_periph_gate("usb2", "clk_m", 0, clk_base, 0,
>  				    58, &periph_h_regs, periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, NULL, "tegra-ehci.1");
> -	clks[usb2] = clk;
> +	clks[TEGRA20_CLK_USB2] = clk;
>  
>  	/* usb3 */
>  	clk = tegra_clk_register_periph_gate("usb3", "clk_m", 0, clk_base, 0,
>  				    59, &periph_h_regs, periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, NULL, "tegra-ehci.2");
> -	clks[usb3] = clk;
> +	clks[TEGRA20_CLK_USB3] = clk;
>  
>  	/* dsi */
>  	clk = tegra_clk_register_periph_gate("dsi", "pll_d", 0, clk_base, 0,
>  				    48, &periph_h_regs, periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, NULL, "dsi");
> -	clks[dsi] = clk;
> +	clks[TEGRA20_CLK_DSI] = clk;
>  
>  	/* csi */
>  	clk = tegra_clk_register_periph_gate("csi", "pll_p_out3", 0, clk_base,
>  				    0, 52, &periph_h_regs,
>  				    periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, "csi", "tegra_camera");
> -	clks[csi] = clk;
> +	clks[TEGRA20_CLK_CSI] = clk;
>  
>  	/* isp */
>  	clk = tegra_clk_register_periph_gate("isp", "clk_m", 0, clk_base, 0, 23,
>  				    &periph_l_regs, periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, "isp", "tegra_camera");
> -	clks[isp] = clk;
> +	clks[TEGRA20_CLK_ISP] = clk;
>  
>  	/* pex */
>  	clk = tegra_clk_register_periph_gate("pex", "clk_m", 0, clk_base, 0, 70,
>  				    &periph_u_regs, periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, "pex", NULL);
> -	clks[pex] = clk;
> +	clks[TEGRA20_CLK_PEX] = clk;
>  
>  	/* afi */
>  	clk = tegra_clk_register_periph_gate("afi", "clk_m", 0, clk_base, 0, 72,
>  				    &periph_u_regs, periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, "afi", NULL);
> -	clks[afi] = clk;
> +	clks[TEGRA20_CLK_AFI] = clk;
>  
>  	/* pcie_xclk */
>  	clk = tegra_clk_register_periph_gate("pcie_xclk", "clk_m", 0, clk_base,
>  				    0, 74, &periph_u_regs,
>  				    periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, "pcie_xclk", NULL);
> -	clks[pcie_xclk] = clk;
> +	clks[TEGRA20_CLK_PCIE_XCLK] = clk;
>  
>  	/* cdev1 */
>  	clk = clk_register_fixed_rate(NULL, "cdev1_fixed", NULL, CLK_IS_ROOT,
> @@ -1036,7 +1019,7 @@ static void __init tegra20_periph_clk_init(void)
>  				    clk_base, 0, 94, &periph_u_regs,
>  				    periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, "cdev1", NULL);
> -	clks[cdev1] = clk;
> +	clks[TEGRA20_CLK_CDEV1] = clk;
>  
>  	/* cdev2 */
>  	clk = clk_register_fixed_rate(NULL, "cdev2_fixed", NULL, CLK_IS_ROOT,
> @@ -1045,7 +1028,7 @@ static void __init tegra20_periph_clk_init(void)
>  				    clk_base, 0, 93, &periph_u_regs,
>  				    periph_clk_enb_refcnt);
>  	clk_register_clkdev(clk, "cdev2", NULL);
> -	clks[cdev2] = clk;
> +	clks[TEGRA20_CLK_CDEV2] = clk;
>  
>  	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
>  		data = &tegra_periph_clk_list[i];
> @@ -1076,7 +1059,7 @@ static void __init tegra20_fixed_clk_init(void)
>  	clk = clk_register_fixed_rate(NULL, "clk_32k", NULL, CLK_IS_ROOT,
>  				      32768);
>  	clk_register_clkdev(clk, "clk_32k", NULL);
> -	clks[clk_32k] = clk;
> +	clks[TEGRA20_CLK_32K] = clk;
>  }
>  
>  static void __init tegra20_pmc_clk_init(void)
> @@ -1092,7 +1075,7 @@ static void __init tegra20_pmc_clk_init(void)
>  				pmc_base + PMC_CTRL,
>  				PMC_CTRL_BLINK_ENB, 0, NULL);
>  	clk_register_clkdev(clk, "blink", NULL);
> -	clks[blink] = clk;
> +	clks[TEGRA20_CLK_BLINK] = clk;
>  }
>  
>  static void __init tegra20_osc_clk_init(void)
> @@ -1107,14 +1090,14 @@ static void __init tegra20_osc_clk_init(void)
>  	clk = clk_register_fixed_rate(NULL, "clk_m", NULL, CLK_IS_ROOT |
>  				      CLK_IGNORE_UNUSED, input_freq);
>  	clk_register_clkdev(clk, "clk_m", NULL);
> -	clks[clk_m] = clk;
> +	clks[TEGRA20_CLK_M] = clk;
>  
>  	/* pll_ref */
>  	pll_ref_div = tegra20_get_pll_ref_div();
>  	clk = clk_register_fixed_factor(NULL, "pll_ref", "clk_m",
>  					CLK_SET_RATE_PARENT, 1, pll_ref_div);
>  	clk_register_clkdev(clk, "pll_ref", NULL);
> -	clks[pll_ref] = clk;
> +	clks[TEGRA20_CLK_PLL_REF] = clk;
>  }
>  
>  /* Tegra20 CPU clock and reset control functions */
> @@ -1248,42 +1231,42 @@ static struct tegra_cpu_car_ops tegra20_cpu_car_ops = {
>  };
>  
>  static __initdata struct tegra_clk_init_table init_table[] = {
> -	{pll_p, clk_max, 216000000, 1},
> -	{pll_p_out1, clk_max, 28800000, 1},
> -	{pll_p_out2, clk_max, 48000000, 1},
> -	{pll_p_out3, clk_max, 72000000, 1},
> -	{pll_p_out4, clk_max, 24000000, 1},
> -	{pll_c, clk_max, 600000000, 1},
> -	{pll_c_out1, clk_max, 120000000, 1},
> -	{sclk, pll_c_out1, 0, 1},
> -	{hclk, clk_max, 0, 1},
> -	{pclk, clk_max, 60000000, 1},
> -	{csite, clk_max, 0, 1},
> -	{emc, clk_max, 0, 1},
> -	{cclk, clk_max, 0, 1},
> -	{uarta, pll_p, 0, 1},
> -	{uartd, pll_p, 0, 1},
> -	{usbd, clk_max, 12000000, 0},
> -	{usb2, clk_max, 12000000, 0},
> -	{usb3, clk_max, 12000000, 0},
> -	{pll_a, clk_max, 56448000, 1},
> -	{pll_a_out0, clk_max, 11289600, 1},
> -	{cdev1, clk_max, 0, 1},
> -	{blink, clk_max, 32768, 1},
> -	{i2s1, pll_a_out0, 11289600, 0},
> -	{i2s2, pll_a_out0, 11289600, 0},
> -	{sdmmc1, pll_p, 48000000, 0},
> -	{sdmmc3, pll_p, 48000000, 0},
> -	{sdmmc4, pll_p, 48000000, 0},
> -	{spi, pll_p, 20000000, 0},
> -	{sbc1, pll_p, 100000000, 0},
> -	{sbc2, pll_p, 100000000, 0},
> -	{sbc3, pll_p, 100000000, 0},
> -	{sbc4, pll_p, 100000000, 0},
> -	{host1x, pll_c, 150000000, 0},
> -	{disp1, pll_p, 600000000, 0},
> -	{disp2, pll_p, 600000000, 0},
> -	{clk_max, clk_max, 0, 0}, /* This MUST be the last entry */
> +	{TEGRA20_CLK_PLL_P, TEGRA20_CLK_MAX, 216000000, 1},
> +	{TEGRA20_CLK_PLL_P_OUT1, TEGRA20_CLK_MAX, 28800000, 1},
> +	{TEGRA20_CLK_PLL_P_OUT2, TEGRA20_CLK_MAX, 48000000, 1},
> +	{TEGRA20_CLK_PLL_P_OUT3, TEGRA20_CLK_MAX, 72000000, 1},
> +	{TEGRA20_CLK_PLL_P_OUT4, TEGRA20_CLK_MAX, 24000000, 1},
> +	{TEGRA20_CLK_PLL_C, TEGRA20_CLK_MAX, 600000000, 1},
> +	{TEGRA20_CLK_PLL_C_OUT1, TEGRA20_CLK_MAX, 120000000, 1},
> +	{TEGRA20_CLK_SCLK, TEGRA20_CLK_PLL_C_OUT1, 0, 1},
> +	{TEGRA20_CLK_HCLK, TEGRA20_CLK_MAX, 0, 1},
> +	{TEGRA20_CLK_PCLK, TEGRA20_CLK_MAX, 60000000, 1},
> +	{TEGRA20_CLK_CSITE, TEGRA20_CLK_MAX, 0, 1},
> +	{TEGRA20_CLK_EMC, TEGRA20_CLK_MAX, 0, 1},
> +	{TEGRA20_CLK_CCLK, TEGRA20_CLK_MAX, 0, 1},
> +	{TEGRA20_CLK_UARTA, TEGRA20_CLK_PLL_P, 0, 1},
> +	{TEGRA20_CLK_UARTD, TEGRA20_CLK_PLL_P, 0, 1},
> +	{TEGRA20_CLK_USBD, TEGRA20_CLK_MAX, 12000000, 0},
> +	{TEGRA20_CLK_USB2, TEGRA20_CLK_MAX, 12000000, 0},
> +	{TEGRA20_CLK_USB3, TEGRA20_CLK_MAX, 12000000, 0},
> +	{TEGRA20_CLK_PLL_A, TEGRA20_CLK_MAX, 56448000, 1},
> +	{TEGRA20_CLK_PLL_A_OUT0, TEGRA20_CLK_MAX, 11289600, 1},
> +	{TEGRA20_CLK_CDEV1, TEGRA20_CLK_MAX, 0, 1},
> +	{TEGRA20_CLK_BLINK, TEGRA20_CLK_MAX, 32768, 1},
> +	{TEGRA20_CLK_I2S1, TEGRA20_CLK_PLL_A_OUT0, 11289600, 0},
> +	{TEGRA20_CLK_I2S2, TEGRA20_CLK_PLL_A_OUT0, 11289600, 0},
> +	{TEGRA20_CLK_SDMMC1, TEGRA20_CLK_PLL_P, 48000000, 0},
> +	{TEGRA20_CLK_SDMMC3, TEGRA20_CLK_PLL_P, 48000000, 0},
> +	{TEGRA20_CLK_SDMMC4, TEGRA20_CLK_PLL_P, 48000000, 0},
> +	{TEGRA20_CLK_SPI, TEGRA20_CLK_PLL_P, 20000000, 0},
> +	{TEGRA20_CLK_SBC1, TEGRA20_CLK_PLL_P, 100000000, 0},
> +	{TEGRA20_CLK_SBC2, TEGRA20_CLK_PLL_P, 100000000, 0},
> +	{TEGRA20_CLK_SBC3, TEGRA20_CLK_PLL_P, 100000000, 0},
> +	{TEGRA20_CLK_SBC4, TEGRA20_CLK_PLL_P, 100000000, 0},
> +	{TEGRA20_CLK_HOST1X, TEGRA20_CLK_PLL_C, 150000000, 0},
> +	{TEGRA20_CLK_DISP1, TEGRA20_CLK_PLL_P, 600000000, 0},
> +	{TEGRA20_CLK_DISP2, TEGRA20_CLK_PLL_P, 600000000, 0},
> +	{TEGRA20_CLK_MAX, TEGRA20_CLK_MAX, 0, 0}, /* This MUST be the last entry */
>  };
>  
>  /*
> @@ -1292,12 +1275,12 @@ static __initdata struct tegra_clk_init_table init_table[] = {
>   * table under two names.
>   */
>  static struct tegra_clk_duplicate tegra_clk_duplicates[] = {
> -	TEGRA_CLK_DUPLICATE(usbd,   "utmip-pad",    NULL),
> -	TEGRA_CLK_DUPLICATE(usbd,   "tegra-ehci.0", NULL),
> -	TEGRA_CLK_DUPLICATE(usbd,   "tegra-otg",    NULL),
> -	TEGRA_CLK_DUPLICATE(cclk,   NULL,           "cpu"),
> -	TEGRA_CLK_DUPLICATE(twd,    "smp_twd",      NULL),
> -	TEGRA_CLK_DUPLICATE(clk_max, NULL, NULL), /* Must be the last entry */
> +	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_USBD, "utmip-pad", NULL),
> +	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_USBD,"tegra-ehci.0", NULL),
> +	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_USBD, "tegra-otg", NULL),
> +	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_CCLK, NULL, "cpu"),
> +	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_TWD, "smp_twd", NULL),
> +	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_MAX, NULL, NULL), /* Must be the last entry */
>  };
>  
>  static const struct of_device_id pmc_match[] __initconst = {
> @@ -1347,13 +1330,13 @@ void __init tegra20_clock_init(struct device_node *np)
>  			clks[i] = ERR_PTR(-EINVAL);
>  	}
>  
> -	tegra_init_dup_clks(tegra_clk_duplicates, clks, clk_max);
> +	tegra_init_dup_clks(tegra_clk_duplicates, clks, TEGRA20_CLK_MAX);
>  
>  	clk_data.clks = clks;
>  	clk_data.clk_num = ARRAY_SIZE(clks);
>  	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
>  
> -	tegra_init_from_table(init_table, clks, clk_max);
> +	tegra_init_from_table(init_table, clks, TEGRA20_CLK_MAX);
>  
>  	tegra_cpu_car_ops = &tegra20_cpu_car_ops;
>  }
> 

