Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaHSBwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 21:52:44 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:38859 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaHSBwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 21:52:43 -0400
Date: Mon, 18 Aug 2014 18:52:37 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 7/8] mtd: nand: stm_nand_bch: add support for ST's BCH
 NAND controller
Message-ID: <20140819015237.GQ18411@ld-irv-0074>
References: <1408357919-19793-1-git-send-email-lee.jones@linaro.org>
 <1408357919-19793-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408357919-19793-8-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 11:31:58AM +0100, Lee Jones wrote:
...
> +/* Derive Hamming-FLEX timing register values from 'nand_sdr_timings' data */
> +static void flex_calc_timing_registers(const struct nand_sdr_timings *spec,
> +				       int tCLK, int relax,
> +				       uint32_t *ctl_timing,
> +				       uint32_t *wen_timing,
> +				       uint32_t *ren_timing)
> +{
> +	int tMAX_HOLD;
> +	int n_ctl_setup;
> +	int n_ctl_hold;
> +	int n_ctl_wb;
> +
> +	int tMAX_WEN_OFF;
> +	int n_wen_on;
> +	int n_wen_off;
> +
> +	int tMAX_REN_OFF;
> +	int n_ren_on;
> +	int n_ren_off;
> +
> +	/*
> +	 * CTL_TIMING
> +	 */
> +
> +	/*	- SETUP */
> +	n_ctl_setup = (PICO_TO_MILI(spec->tCLS_min - spec->tWP_min)
> +		       + tCLK - 1)/tCLK;

Can you add spaces around the '/'? It helps readability. (This is
repeated throughout.)

> +	if (n_ctl_setup < 1)
> +		n_ctl_setup = 1;
> +	n_ctl_setup += relax;

It's been discussed that many drivers probably want a simplified version
of struct nand_sdr_timings where some of these computations are done
already. As we haven't developed such a simplification yet, I'm fine
taking your computations as-is. If nothing else, they serve as a
reference for a later simplification. (Just FYI.)

> +
> +	/*	- HOLD */
> +	tMAX_HOLD = spec->tCLH_min;
> +	if (spec->tCH_min > tMAX_HOLD)
> +		tMAX_HOLD = spec->tCH_min;
> +	if (spec->tALH_min > tMAX_HOLD)
> +		tMAX_HOLD = spec->tALH_min;
> +	if (spec->tDH_min > tMAX_HOLD)
> +		tMAX_HOLD = spec->tDH_min;
> +	n_ctl_hold = (PICO_TO_MILI(tMAX_HOLD) + tCLK - 1)/tCLK + relax;
> +
> +	/*	- CE_deassert_hold = 0 */
> +
> +	/*	- WE_high_to_RBn_low */
> +	n_ctl_wb = (PICO_TO_MILI(spec->tWB_max) + tCLK - 1)/tCLK;
> +
> +	*ctl_timing = ((n_ctl_setup & 0xff) |
> +		       (n_ctl_hold & 0xff) << 8 |
> +		       (n_ctl_wb & 0xff) << 24);
> +
> +	/*
> +	 * WEN_TIMING
> +	 */
> +
> +	/*	- ON */
> +	n_wen_on = (PICO_TO_MILI(spec->tWH_min) + tCLK - 1)/tCLK + relax;
> +
> +	/*	- OFF */
> +	tMAX_WEN_OFF = spec->tWC_min - spec->tWH_min;
> +	if (spec->tWP_min > tMAX_WEN_OFF)
> +		tMAX_WEN_OFF = spec->tWP_min;
> +	n_wen_off = (PICO_TO_MILI(tMAX_WEN_OFF) + tCLK - 1)/tCLK + relax;
> +
> +	*wen_timing = ((n_wen_on & 0xff) |
> +		       (n_wen_off & 0xff) << 8);
> +
> +	/*
> +	 * REN_TIMING
> +	 */
> +
> +	/*	- ON */
> +	n_ren_on = (PICO_TO_MILI(spec->tREH_min) + tCLK - 1)/tCLK + relax;
> +
> +	/*	- OFF */
> +	tMAX_REN_OFF = spec->tRC_min - spec->tREH_min;
> +	if (spec->tRP_min > tMAX_REN_OFF)
> +		tMAX_REN_OFF = spec->tRP_min;
> +	if (spec->tREA_max > tMAX_REN_OFF)
> +		tMAX_REN_OFF = spec->tREA_max;
> +	n_ren_off = (PICO_TO_MILI(tMAX_REN_OFF) + tCLK - 1)/tCLK + 1 + relax;
> +
> +	*ren_timing = ((n_ren_on & 0xff) |
> +		       (n_ren_off & 0xff) << 8);
> +}
> +
> +/* Derive BCH timing register values from 'nand_sdr_timings' data */
> +static void bch_calc_timing_registers(const struct nand_sdr_timings *spec,
> +				      int tCLK, int relax,
> +				      uint32_t *ctl_timing,
> +				      uint32_t *wen_timing,
> +				      uint32_t *ren_timing)
> +{
> +	int tMAX_HOLD;
> +	int n_ctl_setup;
> +	int n_ctl_hold;
> +	int n_ctl_wb;
> +
> +	int n_wen_on;
> +	int n_wen_off;
> +	int wen_half_on;
> +	int wen_half_off;
> +
> +	int tMAX_REN_ON;
> +	int tMAX_CS_DEASSERT;
> +	int n_d_latch;
> +	int n_telqv;
> +	int n_ren_on;
> +	int n_ren_off;
> +
> +	/*
> +	 * CTL_TIMING
> +	 */
> +
> +	/*	- SETUP */
> +	if (spec->tCLS_min > spec->tWP_min)
> +		n_ctl_setup = (PICO_TO_MILI(spec->tCLS_min - spec->tWP_min)
> +			       + tCLK - 1)/tCLK;
> +	else
> +		n_ctl_setup = 0;
> +	n_ctl_setup += relax;
> +
> +	/*	- HOLD */
> +	tMAX_HOLD = spec->tCLH_min;
> +	if (spec->tCH_min > tMAX_HOLD)
> +		tMAX_HOLD = spec->tCH_min;
> +	if (spec->tALH_min > tMAX_HOLD)
> +		tMAX_HOLD = spec->tALH_min;
> +	if (spec->tDH_min > tMAX_HOLD)
> +		tMAX_HOLD = spec->tDH_min;
> +	n_ctl_hold = (PICO_TO_MILI(tMAX_HOLD) + tCLK - 1)/tCLK + relax;
> +	/*	- CE_deassert_hold = 0 */
> +
> +	/*	- WE_high_to_RBn_low */
> +	n_ctl_wb = (PICO_TO_MILI(spec->tWB_max) + tCLK - 1)/tCLK;
> +
> +	*ctl_timing = ((n_ctl_setup & 0xff) |
> +		       (n_ctl_hold & 0xff) << 8 |
> +		       (n_ctl_wb & 0xff) << 24);
> +
> +	/*
> +	 * WEN_TIMING
> +	 */
> +
> +	/*	- ON */
> +	n_wen_on = (2 * PICO_TO_MILI(spec->tWH_min) + tCLK - 1)/tCLK;
> +	wen_half_on = n_wen_on % 2;
> +	n_wen_on /= 2;
> +	n_wen_on += relax;
> +
> +	/*	- OFF */
> +	n_wen_off = (2 * PICO_TO_MILI(spec->tWP_min) + tCLK - 1)/tCLK;
> +	wen_half_off = n_wen_off % 2;
> +	n_wen_off /= 2;
> +	n_wen_off += relax;
> +
> +	*wen_timing = ((n_wen_on & 0xff) |
> +		       (n_wen_off & 0xff) << 8 |
> +		       (wen_half_on << 16) |
> +		       (wen_half_off << 17));
> +
> +	/*
> +	 * REN_TIMING
> +	 */
> +
> +	/*	- ON */
> +	tMAX_REN_ON = spec->tRC_min - spec->tRP_min;
> +	if (spec->tREH_min > tMAX_REN_ON)
> +		tMAX_REN_ON = spec->tREH_min;
> +
> +	n_ren_on = (2 * PICO_TO_MILI(tMAX_REN_ON) + tCLK - 1)/tCLK;
> +	n_ren_on /= 2;
> +	n_ren_on += relax;
> +
> +	/*	- OFF */
> +	n_ren_off = (2 * PICO_TO_MILI(spec->tREA_max) + tCLK - 1)/tCLK;
> +	n_ren_off /= 2;
> +	n_ren_off += relax;
> +
> +	/*	- DATA_LATCH */
> +	if (PICO_TO_MILI(spec->tREA_max) <=
> +	    (PICO_TO_MILI(spec->tRP_min) - (2 * tCLK)))
> +		n_d_latch = 0;
> +	else if (PICO_TO_MILI(spec->tREA_max) <=
> +		 (PICO_TO_MILI(spec->tRP_min) - tCLK))
> +		n_d_latch = 1;
> +	else if ((spec->tREA_max <= spec->tRP_min) &&
> +		 (PICO_TO_MILI(spec->tRHOH_min) >= 2 * tCLK))
> +		n_d_latch = 2;
> +	else
> +		n_d_latch = 3;
> +
> +	/*	- TELQV */
> +	tMAX_CS_DEASSERT = spec->tCOH_min;
> +	if (spec->tCHZ_max > tMAX_CS_DEASSERT)
> +		tMAX_CS_DEASSERT = spec->tCHZ_max;
> +
> +	n_telqv = (PICO_TO_MILI(tMAX_CS_DEASSERT) + tCLK - 1)/tCLK;
> +
> +	*ren_timing = ((n_ren_on & 0xff) |
> +		       (n_ren_off & 0xff) << 8 |
> +		       (n_d_latch & 0x3) << 16 |
> +		       (wen_half_on << 18) |
> +		       (wen_half_off << 19) |
> +		       (n_telqv & 0xff) << 24);
> +}
> +
[...]
> +static void *stm_bch_dt_get_ddata(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct stm_nand_bch_ddata *ddata;
> +	int ecc_strength;
> +	int ret;
> +
> +	ddata = devm_kzalloc(&pdev->dev, sizeof(*ddata), GFP_KERNEL);
> +	if (!ddata)
> +		return ERR_PTR(-ENOMEM);
> +
> +	of_property_read_u32(np, "nand-ecc-strength", &ecc_strength);

of_get_nand_ecc_strength()

> +	if (ecc_strength == 0)
> +		ddata->bch_ecc_cfg = BCH_NO_ECC;
> +	else if (ecc_strength == 18)
> +		ddata->bch_ecc_cfg = BCH_18BIT_ECC;
> +	else if (ecc_strength == 30)
> +		ddata->bch_ecc_cfg = BCH_30BIT_ECC;
> +	else
> +		ddata->bch_ecc_cfg = BCH_ECC_AUTO;
> +
> +	ret = stm_of_get_nand_banks(&pdev->dev, np, &ddata->bank);
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +
> +	return ddata;
> +}
> +
[...]

That's all for now. Maybe I'll take a fresh look at this later.

Brian
