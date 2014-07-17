Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbaGQKYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:24:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695AbaGQKYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:24:17 -0400
Message-ID: <53C7A433.4070404@redhat.com>
Date: Thu, 17 Jul 2014 12:23:47 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mikko Perttunen <mperttunen@nvidia.com>, swarren@wwwdotorg.org,
        tj@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v4 1/8] of: Add NVIDIA Tegra SATA controller binding
References: <1405500863-19696-2-git-send-email-mperttunen@nvidia.com> <1405510814-31928-1-git-send-email-mperttunen@nvidia.com> <53C666E5.6030009@redhat.com> <20140716131306.GB23384@ulmo> <53C6908A.2050200@redhat.com> <20140716195136.GB5212@mithrandir> <53C77263.7050903@redhat.com> <20140717073956.GA18640@ulmo>
In-Reply-To: <20140717073956.GA18640@ulmo>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/17/2014 09:39 AM, Thierry Reding wrote:
> On Thu, Jul 17, 2014 at 08:51:15AM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 07/16/2014 09:51 PM, Thierry Reding wrote:
>>> On Wed, Jul 16, 2014 at 04:47:38PM +0200, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 07/16/2014 03:13 PM, Thierry Reding wrote:
>>>>> On Wed, Jul 16, 2014 at 01:49:57PM +0200, Hans de Goede wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 07/16/2014 01:40 PM, Mikko Perttunen wrote:
>>>>>>> This patch adds device tree binding documentation for the SATA
>>>>>>> controller found on NVIDIA Tegra SoCs.
>>>>>>>
>>>>>>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>>>>>>> ---
>>>>>>> v4: clarify mandatory clock order
>>>>>>
>>>>>> Thanks this and the new v4 of "ata: Add support for the Tegra124 SATA controller"
>>>>>> both look good to me. So these 2 + v3 for the rest of the series are:
>>>>>>
>>>>>> Acked-by: Hans de Goede <hdegoede@redhat.com>
>>>>>
>>>>> Like I said in my reply to PATCH v3 7/8, I think this mandatory clock
>>>>> order is a mistake.
>>>>
>>>> We've plenty of other dt bindings where things need to be specified in
>>>> a certain order, e.g. registers. So I don't really see what the problem
>>>> is here.
>>>
>>> Like I said, the clock-names exists so that drivers can request a clock
>>> by name. Therefore the order in which they are listed doesn't matter.
>>> The only thing that matters is that the entries in clocks and
>>> clock-names match up.
>>
>> Ok so I've been think about this, and about the unbalance I've noticed
>> between tegra_ahci_power_on which does everything DIY and tegra_ahci_power_off
>> which uses ahci_platform_disable_resources() in v3 and later.
>>
>> Really only the "sata" clock needs special handling, so I think the following
>> solution is best:
>>
>> 1) Drop the clock ordering requirement and the clk enum
>>
>> 2) Make ahci_tegra.c do a devm_clk_get(dev, "sata"), so that it gets its
>> own handle to the sata-clk (store this in tegra_ahci_priv). no need to
>> get all the other clks which need no special handling
>>
>> 3) Start using ahci_platform_enable_resources() in tegra_ahci_power_on,
>> so it would look something like this:
>>
>> static int tegra_ahci_power_on(struct ahci_host_priv *hpriv)
>> {
>> 	struct tegra_ahci_priv *tegra = hpriv->plat_data;
>> 	int ret;
>>
>> 	ret = regulator_bulk_enable(ARRAY_SIZE(tegra->supplies),
>> 				    tegra->supplies);
>> 	if (ret)
>> 		return ret;
>>
>> 	ret = tegra_powergate_sequence_power_up(TEGRA_POWERGATE_SATA,
>> 						tegra->sata_clk,
>> 						tegra->sata_rst);
>> 	if (ret)
>> 		goto disable_regulators;
>>
>> 	reset_control_deassert(tegra->sata_cold_rst);
>> 	reset_control_deassert(tegra->sata_oob_rst);
>>
>> 	ret = ahci_platform_enable_resources(hpriv);
>> 	if (ret)
>> 		goto powergate_sequence_power_off;
>>
>> 	return 0;
>> ...
>>
>> This will make tegra_ahci_power_on and tegra_ahci_power_off symmetrical
>> which is something I always like to see in functions like this.
>>
>> I realize that this changes the reset-deassert vs clock enabling ordering,
>> if this is an issue please add reset support to libahci-platform.c I believe
>> that is something which we will need to do soonish anyways (reset controllers
>> are popping up everywhere in newer SoCs).
> 
> I think we could safely move the reset deassert after the call to
> ahci_platform_enable_resources().

Will the resets not interfere with the phy_init / power_on which is done from
ahci_platform_enable_resources().

>> This will nicely reduce the amount of code and also greatly simplify the error
>> return path of tegra_ahci_power_on.
> 
> Agreed, htat sounds like it could work.
> 
>> This means that the sata_clk will get enabled twice, but that is harmless
>> as long as we disable it twice too. This means that we need to add an
>> extra disable to tegra_ahci_power_off because tegra_powergate_power_off
>> seems to not do this (unlike power-on, which is rather unsymmetrical
>> it would be nice to fix this).
> 
> We've never had a need for it because the exact power down sequence
> isn't nearly as important. But I guess we could add a new function
> tegra_powergate_sequence_power_down() that takes care of disabling the
> clock and asserting the reset.

Ok, no need to add it for my sake, I was just wondering about the non
symmetry of the API.

> One other thing that I've been thinking about is whether it would make
> sense to make the ahci_platform library use a list of clock names that
> it should request. This would better mirror the clock bindings
> convention and allow drivers (such as the Tegra one) to take ownership
> of clocks that need special handling while at the same time leaving it
> to the helpers to do the bulk of the work.
> 
> One way I can think of to handle this would be by adding a struct
> ahci_platform_resources * parameter to ahci_platform_get_resources(),
> sowewhat like this:
> 
> 	struct ahci_platform_resources {
> 		const char *const *clocks;
> 		unsigned int num_clocks;
> 
> 		const char *const *resets;
> 		unsigned int num_resets;
> 	};
> 
> 	struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
> 							   const struct ahci_platform_resources *res)
> 	{
> 		...
> 
> 		for (i = 0; i < res->num_clocks; i++) {
> 			clk = clk_get(&pdev->dev, res->clocks[i]);
> 			...
> 		}
> 
> 		...
> 
> 		for (i = 0; i < res->num_resets; i++) {
> 			rst = reset_control_get(&pdev->dev, res->resets[i]);
> 			...
> 		}
> 
> 		...
> 	}

Interesting, I think this is a quite good idea. I do see some pitfalls though,
to answers Mikko's question from his followup :

On 07/17/2014 09:56 AM, Mikko Perttunen wrote:
> Also: is there a reason to not use the devm_* variants? I note that the helper code has not been able to prevent any of the ahci_platform drivers from messing up by not calling ahci_platform_put_resources.

The libahci_platform.c code / ahci_platform.c code is also used for
devices going way back who may not yet be using the new clk framework,
so where we need to use clk_get(dev, NULL); quoting from libahci_platform.c :

        for (i = 0; i < AHCI_MAX_CLKS; i++) {
                /*
                 * For now we must use clk_get(dev, NULL) for the first clock,
                 * because some platforms (da850, spear13xx) are not yet
                 * converted to use devicetree for clocks.  For new platforms
                 * this is equivalent to of_clk_get(dev->of_node, 0).
                 */
                if (i == 0)
                        clk = clk_get(dev, NULL);
                else
                        clk = of_clk_get(dev->of_node, i);

                if (IS_ERR(clk)) {
                        rc = PTR_ERR(clk);
                        if (rc == -EPROBE_DEFER)
                                goto err_out;
                        break;
                }
                hpriv->clks[i] = clk;
        }

And there is no devm variant of that, nor is there one to get clocks by index.
Note that we also need ahci_platform_put_resources for runtime pm support, so
that one is going to stay around anyways and thus there is not that much value
in fixing this.

So although I like Thierry's idea, if we go this way (which sounds good), we
should add support for taking a NULL ahci_platform_resources argument and in
that case behave as before, esp. because of the platforms needing the old
style clock handling. An advantage of doing this, is that we can simply patch
all existing users to pass NULL.

I guess we could have a default ahci_platform_resources struct which gets
used when the argument is NULL, then we only need to special case the clocks
stuff when the argument is NULL.

> And I guess the same could be done for regulators (and even phys). The
> Tegra driver for instance could then do this:

Ack.


> 	static const char *const tegra_ahci_clocks[] = {
> 		"sata-oob", "cml1", pll_e",
> 	};

Note you could also put the "sata" clock here, since then you will
know its index, and can use hpriv->clks to access it. Not putting
it here has the advantage of not doing the double enable / disable
(and the disadvantage of needing to the clk_get yourself).

> 	static const char *const tegra_ahci_resets[] = {
> 		"sata-oob", "sata-cold",
> 	};
> 
> 	static const struct ahci_platform_resources tegra_ahci_resources = {
> 		.num_clocks = ARRAY_SIZE(tegra_ahci_clocks),
> 		.clocks = tegra_ahci_clocks,
> 		.num_resets = ARRAY_SIZE(tegra_ahci_resets),
> 		.resets = tegra_ahci_resets,
> 	};
> 
> 	...
> 
> 	struct tegra_ahci {
> 		struct ahci_host_priv *host;
> 		struct reset_control *rst;
> 		struct clk *clk;
> 		...
> 	};
> 
> 	...
> 
> 	static int tegra_ahci_probe(struct platform_device *pdev)
> 	{
> 		struct tegra_ahci *ahci;
> 
> 		...
> 
> 		ahci = devm_kzalloc(&pdev->dev, sizeof(*ahci), GFP_KERNEL);
> 		if (!ahci)
> 			return -ENOMEM;
> 
> 		ahci->host = ahci_platform_get_resources(pdev, &tegra_ahci_resources);
> 		if (IS_ERR(ahci->host)) {
> 			...
> 		}
> 
> 		...
> 
> 		platform_set_drvdata(pdev, ahci);
> 	}
> 
> Does that sound reasonable?

Yep, sounds good to me (with the caveat of the back-compat stuff).

Regards,

Hans
