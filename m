Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbaGQLnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:43:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbaGQLnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:43:14 -0400
Message-ID: <53C7B6B5.4050602@redhat.com>
Date: Thu, 17 Jul 2014 13:42:45 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mikko Perttunen <mperttunen@nvidia.com>, swarren@wwwdotorg.org,
        tj@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v4 1/8] of: Add NVIDIA Tegra SATA controller binding
References: <1405500863-19696-2-git-send-email-mperttunen@nvidia.com> <1405510814-31928-1-git-send-email-mperttunen@nvidia.com> <53C666E5.6030009@redhat.com> <20140716131306.GB23384@ulmo> <53C6908A.2050200@redhat.com> <20140716195136.GB5212@mithrandir> <53C77263.7050903@redhat.com> <20140717073956.GA18640@ulmo> <53C7A433.4070404@redhat.com> <20140717105244.GG17877@ulmo>
In-Reply-To: <20140717105244.GG17877@ulmo>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/17/2014 12:52 PM, Thierry Reding wrote:
> On Thu, Jul 17, 2014 at 12:23:47PM +0200, Hans de Goede wrote:

<snip>

>> The libahci_platform.c code / ahci_platform.c code is also used for
>> devices going way back who may not yet be using the new clk framework,
>> so where we need to use clk_get(dev, NULL); quoting from libahci_platform.c :
>>
>>         for (i = 0; i < AHCI_MAX_CLKS; i++) {
>>                 /*
>>                  * For now we must use clk_get(dev, NULL) for the first clock,
>>                  * because some platforms (da850, spear13xx) are not yet
>>                  * converted to use devicetree for clocks.  For new platforms
>>                  * this is equivalent to of_clk_get(dev->of_node, 0).
>>                  */
>>                 if (i == 0)
>>                         clk = clk_get(dev, NULL);
>>                 else
>>                         clk = of_clk_get(dev->of_node, i);
>>
>>                 if (IS_ERR(clk)) {
>>                         rc = PTR_ERR(clk);
>>                         if (rc == -EPROBE_DEFER)
>>                                 goto err_out;
>>                         break;
>>                 }
>>                 hpriv->clks[i] = clk;
>>         }
>>
>> And there is no devm variant of that, nor is there one to get clocks by index.
>> Note that we also need ahci_platform_put_resources for runtime pm support, so
>> that one is going to stay around anyways and thus there is not that much value
>> in fixing this.
>>
>> So although I like Thierry's idea, if we go this way (which sounds good), we
>> should add support for taking a NULL ahci_platform_resources argument and in
>> that case behave as before, esp. because of the platforms needing the old
>> style clock handling. An advantage of doing this, is that we can simply patch
>> all existing users to pass NULL.
> 
> Isn't the "legacy" case really just this:
> 
> 	static const char *const legacy_ahci_clocks[] = {
> 		NULL
> 	};
> 
> 	static const struct ahci_platform_resources legacy_ahci_resources = {
> 		.num_clocks = ARRAY_SIZE(legacy_ahci_clocks),
> 		.clocks = legacy_ahci_clocks,
> 	};
> 
> ?

Ah yes that would work for the really legacy ones, as well as less legacy
(full dts) ones with only one clk, we need to check if there are current
users which use more then one clk (yes there are which is why MAX_CLKS
was 3) and fixup those to pass in a correct ahci_platform_resources struct
then.

The checking + fixing up will be a bit of extra work, but I think the end result
will be quite nice. so I'm all in favor of this.

>>> 	static const char *const tegra_ahci_clocks[] = {
>>> 		"sata-oob", "cml1", pll_e",
>>> 	};
>>
>> Note you could also put the "sata" clock here, since then you will
>> know its index, and can use hpriv->clks to access it. Not putting
>> it here has the advantage of not doing the double enable / disable
>> (and the disadvantage of needing to the clk_get yourself).
> 
> Right, the intention here was that we wouldn't have it managed by the
> ahci_platform library because it needs special handling anyway. Having
> it in this table would therefore be redundant.

Ack.

Regards,

Hans
