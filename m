Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbaBHDXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 22:23:20 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52849 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaBHDXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 22:23:17 -0500
Date: Fri, 7 Feb 2014 19:23:15 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v8 3/3] mmc: sdhci-msm: Add platform_execute_tunning
 implementation
Message-ID: <20140208032315.GB10784@codeaurora.org>
References: <1391107507-17321-1-git-send-email-gdjakov@mm-sol.com>
 <1391107507-17321-4-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391107507-17321-4-git-send-email-gdjakov@mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30, Georgi Djakov wrote:
> @@ -75,17 +110,389 @@ struct sdhci_msm_host {
>  };
>  
>  /* MSM platform specific tuning */
> -int sdhci_msm_execute_tuning(struct sdhci_host *host, u32 opcode)
> +static inline int msm_dll_poll_ck_out_en(struct sdhci_host *host, u8 poll)
> +{
> +	u32 wait_cnt = 50;
> +	u8 ck_out_en = 0;

Looks like a useless assignment.

> +	struct mmc_host *mmc = host->mmc;
> +
> +	/* poll for CK_OUT_EN bit.  max. poll time = 50us */
> +	ck_out_en = !!(readl_relaxed(host->ioaddr + CORE_DLL_CONFIG) &
> +			CORE_CK_OUT_EN);
> +
> +	while (ck_out_en != poll) {
> +		if (--wait_cnt == 0) {
> +			dev_err(mmc_dev(mmc), "%s: CK_OUT_EN bit is not %d\n",
> +			       mmc_hostname(mmc), poll);
> +			return -ETIMEDOUT;
> +		}
> +		udelay(1);
> +
> +		ck_out_en = !!(readl_relaxed(host->ioaddr + CORE_DLL_CONFIG) &
> +				CORE_CK_OUT_EN);
> +	}
> +
> +	return 0;
> +}
> +
> +static int msm_config_cm_dll_phase(struct sdhci_host *host, u8 phase)
> +{
> +	int rc = 0;

Looks like a useless assignment.

> +	u8 grey_coded_phase_table[] = {
> +		0x0, 0x1, 0x3, 0x2, 0x6, 0x7, 0x5, 0x4,
> +		0xc, 0xd, 0xf, 0xe, 0xa, 0xb, 0x9, 0x8
> +	};

This could be static const?

> +	unsigned long flags;
> +	u32 config;
> +	struct mmc_host *mmc = host->mmc;
> +
> +	spin_lock_irqsave(&host->lock, flags);
> +
> +	config = readl_relaxed(host->ioaddr + CORE_DLL_CONFIG);
> +	config &= ~(CORE_CDR_EN | CORE_CK_OUT_EN);
> +	config |= (CORE_CDR_EXT_EN | CORE_DLL_EN);
> +	writel_relaxed(config, host->ioaddr + CORE_DLL_CONFIG);
> +
> +	/* Wait until CK_OUT_EN bit of DLL_CONFIG register becomes '0' */
> +	rc = msm_dll_poll_ck_out_en(host, 0);
> +	if (rc)
> +		goto err_out;
> +
> +	/*
> +	 * Write the selected DLL clock output phase (0 ... 15)
> +	 * to CDR_SELEXT bit field of DLL_CONFIG register.
> +	 */
> +	writel_relaxed(((readl_relaxed(host->ioaddr + CORE_DLL_CONFIG)
> +			 & ~(0xF << 20))
> +			| (grey_coded_phase_table[phase] << 20)),
> +		       host->ioaddr + CORE_DLL_CONFIG);

Wow this is complicated. Can we please break this up into
multiple lines? What does 0xf << 20 mean?

> +
> +	/* Set CK_OUT_EN bit of DLL_CONFIG register to 1. */
> +	writel_relaxed((readl_relaxed(host->ioaddr + CORE_DLL_CONFIG)
> +			| CORE_CK_OUT_EN), host->ioaddr + CORE_DLL_CONFIG);
> +
[...]
> +}
> +
> +static int msm_find_most_appropriate_phase(struct sdhci_host *host,
> +					   u8 *phase_table, u8 total_phases)
> +{
[...]
> +
> +	for (cnt = 0; cnt <= row_index; cnt++) {
> +		if (phases_per_row[cnt] > curr_max) {
> +			curr_max = phases_per_row[cnt];
> +			selected_row_index = cnt;
> +		}
> +	}
> +
> +	i = ((curr_max * 3) / 4);

Unnecessary extra parentheses here.

> +	if (i)
> +		i--;
> +
> +	ret = (int)ranges[selected_row_index][i];

Is this cast necessary?

> +
> +	if (ret >= MAX_PHASES) {
> +		ret = -EINVAL;
> +		dev_err(mmc_dev(mmc), "%s: invalid phase selected=%d\n",
> +		       mmc_hostname(mmc), ret);
> +	}
> +
> +	return ret;
> +}
> +
> +static inline void msm_cm_dll_set_freq(struct sdhci_host *host)
> +{
> +	u32 mclk_freq = 0;
> +
> +	/* Program the MCLK value to MCLK_FREQ bit field */
> +	if (host->clock <= 112000000)
> +		mclk_freq = 0;
> +	else if (host->clock <= 125000000)
> +		mclk_freq = 1;
> +	else if (host->clock <= 137000000)
> +		mclk_freq = 2;
> +	else if (host->clock <= 150000000)
> +		mclk_freq = 3;
> +	else if (host->clock <= 162000000)
> +		mclk_freq = 4;
> +	else if (host->clock <= 175000000)
> +		mclk_freq = 5;
> +	else if (host->clock <= 187000000)
> +		mclk_freq = 6;
> +	else if (host->clock <= 200000000)
> +		mclk_freq = 7;

This could be a case statement but I'm not sure it's any clearer.
At least the range is specified.

	switch (host->clock) {
	case 0 ... 112000000:
		mclk_freq = 0;
		break;
	case 112000001 ...  125000000:
		mclk_freq = 1;
		break;
	...

> +
> +	writel_relaxed(((readl_relaxed(host->ioaddr + CORE_DLL_CONFIG)
> +			 & ~(7 << 24)) | (mclk_freq << 24)),
> +		       host->ioaddr + CORE_DLL_CONFIG);

This is also complicated. Can you split this up into multiple lines?

> +int sdhci_msm_execute_tuning(struct sdhci_host *host, u32 opcode)
> +{
[...]
> +	do {
> +		struct mmc_command cmd = { 0 };
> +		struct mmc_data data = { 0 };
> +		struct mmc_request mrq = {
> +			.cmd = &cmd,
> +			.data = &data
> +		};
> +		struct scatterlist sg;
> +
> +		/* set the phase in delay line hw block */
> +		rc = msm_config_cm_dll_phase(host, phase);
> +		if (rc)
> +			goto out;
> +
> +		cmd.opcode = opcode;
> +		cmd.flags = MMC_RSP_R1 | MMC_CMD_ADTC;
> +
> +		data.blksz = size;
> +		data.blocks = 1;
> +		data.flags = MMC_DATA_READ;
> +		data.timeout_ns = 1000 * 1000 * 1000;	/* 1 sec */

NSEC_PER_SEC?

> +
> +		data.sg = &sg;
> +		data.sg_len = 1;
> +		sg_init_one(&sg, data_buf, sizeof(data_buf));
> +		memset(data_buf, 0, sizeof(data_buf));
> +		mmc_wait_for_req(mmc, &mrq);
> +
> +		if (!cmd.error && !data.error &&
> +		    !memcmp(data_buf, tuning_block_pattern, sizeof(data_buf))) {
> +			/* tuning is successful at this tuning point */
> +			tuned_phases[tuned_phase_cnt++] = phase;
> +			dev_dbg(mmc_dev(mmc), "%s: found good phase = %d\n",
> +				 mmc_hostname(mmc), phase);
> +		}
> +	} while (++phase < 16);

++phase < ARRAY_SIZE(tuned_phases) ?

> +
> +	if (tuned_phase_cnt) {
> +		rc = msm_find_most_appropriate_phase(host, tuned_phases,
> +						     tuned_phase_cnt);
> +		if (rc < 0)
> +			goto out;
> +		else
> +			phase = (u8) rc;

Unnecessary cast?

> +
> +		/*
> +		 * Finally set the selected phase in delay
> +		 * line hw block.
> +		 */
> +		rc = msm_config_cm_dll_phase(host, phase);
> +		if (rc)
> +			goto out;
> +		dev_dbg(mmc_dev(mmc), "%s: setting the tuning phase to %d\n",
> +			 mmc_hostname(mmc), phase);
> +	} else {
> +		if (--tuning_seq_cnt)
> +			goto retry;
> +		/* tuning failed */
> +		dev_dbg(mmc_dev(mmc), "%s: no tuning point found\n",
> +		       mmc_hostname(mmc));
> +		rc = -EIO;
> +	}
> +
> +out:
> +	kfree(data_buf);
> +	return rc;
> +}
> +
>  #define MAX_PROP_SIZE 32
>  static int sdhci_msm_dt_parse_vreg_info(struct device *dev,
>  			struct sdhci_msm_reg_data *vreg, const char *vreg_name)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
