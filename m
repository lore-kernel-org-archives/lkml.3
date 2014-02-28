Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaB1UyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:54:07 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60868 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbaB1UyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:54:04 -0500
Date: Fri, 28 Feb 2014 14:51:19 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, ulf.hansson@linaro.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v9 3/3] mmc: sdhci-msm: Add platform_execute_tunning
 implementation
Message-ID: <20140228205119.GJ7308@joshc.qualcomm.com>
References: <1393586675-14628-1-git-send-email-gdjakov@mm-sol.com>
 <1393586675-14628-4-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393586675-14628-4-git-send-email-gdjakov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 01:24:35PM +0200, Georgi Djakov wrote:
> This patch adds implementation for platform specific tuning in order to support
> HS200 bus speed mode on Qualcomm SDHCI controller.
> 
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
>  drivers/mmc/host/sdhci-msm.c |  424 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 418 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> index b4490a2..69f6887 100644
> --- a/drivers/mmc/host/sdhci-msm.c
> +++ b/drivers/mmc/host/sdhci-msm.c
[..]
> +int sdhci_msm_execute_tuning(struct sdhci_host *host, u32 opcode)
> +{
> +	int tuning_seq_cnt = 3;
> +	u8 phase, *data_buf, tuned_phases[16], tuned_phase_cnt = 0;
> +	const u32 *tuning_block_pattern = tuning_block_64;
> +	int size = sizeof(tuning_block_64);	/* Pattern size in bytes */
> +	int rc;
> +	struct mmc_host *mmc = host->mmc;
> +	struct mmc_ios ios = host->mmc->ios;
> +
> +	/*
> +	 * Tuning is required for SDR104, HS200 and HS400 cards and
> +	 * if clock frequency is greater than 100MHz in these modes.
> +	 */
> +	if (host->clock <= 100 * 1000 * 1000 ||
> +	    !((ios.timing == MMC_TIMING_MMC_HS200) ||
> +	      (ios.timing == MMC_TIMING_UHS_SDR104)))
> +		return 0;
> +
> +	if ((opcode == MMC_SEND_TUNING_BLOCK_HS200) &&
> +	    (mmc->ios.bus_width == MMC_BUS_WIDTH_8)) {
> +		tuning_block_pattern = tuning_block_128;
> +		size = sizeof(tuning_block_128);
> +	}
> +
> +	data_buf = kmalloc(size, GFP_KERNEL);
> +	if (!data_buf)
> +		return -ENOMEM;
> +
> +retry:
> +	/* First of all reset the tuning block */
> +	rc = msm_init_cm_dll(host);
> +	if (rc)
> +		goto out;
> +
> +	phase = 0;
> +	do {
> +		struct mmc_command cmd = { 0 };
> +		struct mmc_data data = { 0 };
> +		struct mmc_request mrq = {
> +			.cmd = &cmd,
> +			.data = &data
> +		};
> +		struct scatterlist sg;
> +
> +		/* Set the phase in delay line hw block */
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
> +		data.timeout_ns = NSEC_PER_SEC;	/* 1 second */
> +
> +		data.sg = &sg;
> +		data.sg_len = 1;
> +		sg_init_one(&sg, data_buf, sizeof(data_buf));
> +		memset(data_buf, 0, sizeof(data_buf));
> +		mmc_wait_for_req(mmc, &mrq);
> +
> +		if (!cmd.error && !data.error &&
> +		    !memcmp(data_buf, tuning_block_pattern, sizeof(data_buf))) {

This memcmp is broken, sizeof(data_buf) is likely not what you want,
maybe you want 'size'?  Same thing for sg_init_one()/memset() above.

>From sparse:

drivers/mmc/host/sdhci-msm.c: In function ‘sdhci_msm_execute_tuning’:
drivers/mmc/host/sdhci-msm.c:461:53: warning: argument to ‘sizeof’ in ‘memcmp’ call is the same expression as the first source; did you mean to provide an explicit length? [-Wsizeof-pointer-memaccess]
       !memcmp(data_buf, tuning_block_pattern, sizeof(data_buf))) {

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
