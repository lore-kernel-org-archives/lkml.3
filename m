Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbbA2Bud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:50:33 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10078 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbbA2Bu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:50:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 28 Jan 2015 08:29:22 -0800
Message-ID: <54C90E97.2010104@nvidia.com>
Date: Wed, 28 Jan 2015 11:30:15 -0500
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <pkunapuli@nvidia.com>
Subject: Re: [PATCH] mmc: tegra: Write xfer_mode, CMD regs in together
References: <1422379410-7127-1-git-send-email-rklein@nvidia.com> <CAAVeFuJKxY36BpA_dYhNnhH0v8ERaRYK9Be_hQNtG0H898U8EQ@mail.gmail.com>
In-Reply-To: <CAAVeFuJKxY36BpA_dYhNnhH0v8ERaRYK9Be_hQNtG0H898U8EQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/28/2015 1:06 AM, Alexandre Courbot wrote:
> On Wed, Jan 28, 2015 at 2:23 AM, Rhyland Klein <rklein@nvidia.com> wrote:
>> From: Pavan Kunapuli <pkunapuli@nvidia.com>
>>
>> If there is a gap between xfer mode and command register writes,
>> tegra SDMMC controller can sometimes issue a spurious command before
>> the CMD register is written. To avoid this, these two registers need
>> to be written together in a single write operation.
>>
>> Signed-off-by: Pavan Kunapuli <pkunapuli@nvidia.com>
>> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
>> ---
>>  drivers/mmc/host/sdhci-tegra.c |   31 ++++++++++++++++++++++++++++++-
>>  1 file changed, 30 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
>> index 59797106af93..3d34de47e57e 100644
>> --- a/drivers/mmc/host/sdhci-tegra.c
>> +++ b/drivers/mmc/host/sdhci-tegra.c
>> @@ -41,6 +41,7 @@
>>  #define NVQUIRK_DISABLE_SDR50          BIT(3)
>>  #define NVQUIRK_DISABLE_SDR104         BIT(4)
>>  #define NVQUIRK_DISABLE_DDR50          BIT(5)
>> +#define NVQUIRK_SHADOW_XFER_MODE_REG   BIT(6)
>>
>>  struct sdhci_tegra_soc_data {
>>         const struct sdhci_pltfm_data *pdata;
>> @@ -67,6 +68,32 @@ static u16 tegra_sdhci_readw(struct sdhci_host *host, int reg)
>>         return readw(host->ioaddr + reg);
>>  }
>>
>> +static void tegra_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
>> +{
>> +       struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>> +       struct sdhci_tegra *tegra_host = pltfm_host->priv;
>> +       const struct sdhci_tegra_soc_data *soc_data = tegra_host->soc_data;
>> +
>> +       if (soc_data->nvquirks * NVQUIRK_SHADOW_XFER_MODE_REG) {
> 
> Isn't the '*' supposed to be a '&' here?

Yah .. not sure how that happened, but it should be '&' good catch.

> 
>> +               switch (reg) {
>> +               case SDHCI_TRANSFER_MODE:
>> +                       /*
>> +                        * Postpone this write, we must do it together with a
>> +                        * command write that is down below.
>> +                        */
>> +                       pltfm_host->xfer_mode_shadow = val;
>> +                       return;
>> +               case SDHCI_COMMAND:
>> +                       writel((val << 16) | pltfm_host->xfer_mode_shadow,
>> +                               host->ioaddr + SDHCI_TRANSFER_MODE);
>> +                       pltfm_host->xfer_mode_shadow = 0;
> 
> That last line is probably not needed and could actually be harmful -
> if we try to write SDHCI_COMMAND twice in a raw without a write to
> SDHCI_TRANSFER_MODE in between, the zero will overwrite the previous
> value of SDHCI_TRANSFER_MODE.

True, will remove it.

> 
>> +                       return;
>> +               }
>> +       }
>> +
>> +       writew(val, host->ioaddr + reg);
>> +}
>> +
>>  static void tegra_sdhci_writel(struct sdhci_host *host, u32 val, int reg)
>>  {
>>         struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>> @@ -147,6 +174,7 @@ static void tegra_sdhci_set_bus_width(struct sdhci_host *host, int bus_width)
>>  static const struct sdhci_ops tegra_sdhci_ops = {
>>         .get_ro     = tegra_sdhci_get_ro,
>>         .read_w     = tegra_sdhci_readw,
>> +       .write_w    = tegra_sdhci_writew,
>>         .write_l    = tegra_sdhci_writel,
>>         .set_clock  = sdhci_set_clock,
>>         .set_bus_width = tegra_sdhci_set_bus_width,
>> @@ -201,7 +229,8 @@ static struct sdhci_tegra_soc_data soc_data_tegra114 = {
>>         .pdata = &sdhci_tegra114_pdata,
>>         .nvquirks = NVQUIRK_DISABLE_SDR50 |
>>                     NVQUIRK_DISABLE_DDR50 |
>> -                   NVQUIRK_DISABLE_SDR104,
>> +                   NVQUIRK_DISABLE_SDR104 |
>> +                   NVQUIRK_SHADOW_XFER_MODE_REG,
>>  };
> 
> Since this only applies to Tegra114 (?), I wonder whether it would not
> be better to have a dedicated tegra114_sdhci_ops that implements
> tegra_sdhci_writew, and use it only in tegra_sdhci_writew. That way
> you could get rid of the NVQUIRK_SHADOW_XFER_MODE_REG and the test for
> it in tegra_sdhci_writew(), and chips prior to Tegra114 will not have
> to needlessly check for it every time they write a register.

The reason I did it this way, is that this doesn't explicitly just apply
to T114. It actually applies to T114, T124 and T132. In that case, I
think it makes sense to keep the QUIRK and I can update the commit
description to reflect that.

Thanks!
-rhyland

> 


-- 
nvpublic
