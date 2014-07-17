Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbaGQGvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:51:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbaGQGvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:51:45 -0400
Message-ID: <53C77263.7050903@redhat.com>
Date: Thu, 17 Jul 2014 08:51:15 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mikko Perttunen <mperttunen@nvidia.com>, swarren@wwwdotorg.org,
        tj@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v4 1/8] of: Add NVIDIA Tegra SATA controller binding
References: <1405500863-19696-2-git-send-email-mperttunen@nvidia.com> <1405510814-31928-1-git-send-email-mperttunen@nvidia.com> <53C666E5.6030009@redhat.com> <20140716131306.GB23384@ulmo> <53C6908A.2050200@redhat.com> <20140716195136.GB5212@mithrandir>
In-Reply-To: <20140716195136.GB5212@mithrandir>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/16/2014 09:51 PM, Thierry Reding wrote:
> On Wed, Jul 16, 2014 at 04:47:38PM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 07/16/2014 03:13 PM, Thierry Reding wrote:
>>> On Wed, Jul 16, 2014 at 01:49:57PM +0200, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 07/16/2014 01:40 PM, Mikko Perttunen wrote:
>>>>> This patch adds device tree binding documentation for the SATA
>>>>> controller found on NVIDIA Tegra SoCs.
>>>>>
>>>>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>>>>> ---
>>>>> v4: clarify mandatory clock order
>>>>
>>>> Thanks this and the new v4 of "ata: Add support for the Tegra124 SATA controller"
>>>> both look good to me. So these 2 + v3 for the rest of the series are:
>>>>
>>>> Acked-by: Hans de Goede <hdegoede@redhat.com>
>>>
>>> Like I said in my reply to PATCH v3 7/8, I think this mandatory clock
>>> order is a mistake.
>>
>> We've plenty of other dt bindings where things need to be specified in
>> a certain order, e.g. registers. So I don't really see what the problem
>> is here.
> 
> Like I said, the clock-names exists so that drivers can request a clock
> by name. Therefore the order in which they are listed doesn't matter.
> The only thing that matters is that the entries in clocks and
> clock-names match up.

Ok so I've been think about this, and about the unbalance I've noticed
between tegra_ahci_power_on which does everything DIY and tegra_ahci_power_off
which uses ahci_platform_disable_resources() in v3 and later.

Really only the "sata" clock needs special handling, so I think the following
solution is best:

1) Drop the clock ordering requirement and the clk enum

2) Make ahci_tegra.c do a devm_clk_get(dev, "sata"), so that it gets its
own handle to the sata-clk (store this in tegra_ahci_priv). no need to
get all the other clks which need no special handling

3) Start using ahci_platform_enable_resources() in tegra_ahci_power_on,
so it would look something like this:

static int tegra_ahci_power_on(struct ahci_host_priv *hpriv)
{
	struct tegra_ahci_priv *tegra = hpriv->plat_data;
	int ret;

	ret = regulator_bulk_enable(ARRAY_SIZE(tegra->supplies),
				    tegra->supplies);
	if (ret)
		return ret;

	ret = tegra_powergate_sequence_power_up(TEGRA_POWERGATE_SATA,
						tegra->sata_clk,
						tegra->sata_rst);
	if (ret)
		goto disable_regulators;

	reset_control_deassert(tegra->sata_cold_rst);
	reset_control_deassert(tegra->sata_oob_rst);

	ret = ahci_platform_enable_resources(hpriv);
	if (ret)
		goto powergate_sequence_power_off;

	return 0;
...

This will make tegra_ahci_power_on and tegra_ahci_power_off symmetrical
which is something I always like to see in functions like this.

I realize that this changes the reset-deassert vs clock enabling ordering,
if this is an issue please add reset support to libahci-platform.c I believe
that is something which we will need to do soonish anyways (reset controllers
are popping up everywhere in newer SoCs).

This will nicely reduce the amount of code and also greatly simplify the error
return path of tegra_ahci_power_on.

This means that the sata_clk will get enabled twice, but that is harmless
as long as we disable it twice too. This means that we need to add an
extra disable to tegra_ahci_power_off because tegra_powergate_power_off
seems to not do this (unlike power-on, which is rather unsymmetrical
it would be nice to fix this).

Regards,

Hans
