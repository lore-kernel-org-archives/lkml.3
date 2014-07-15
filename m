Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbaGOJDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:03:46 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6332 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144AbaGOJDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:03:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Jul 2014 01:52:30 -0700
Message-ID: <53C4EE6C.4010603@nvidia.com>
Date: Tue, 15 Jul 2014 12:03:40 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, Tejun Heo <tj@kernel.org>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v2 6/7] ata: Add support for the Tegra124 SATA controller
References: <1403101406-15439-1-git-send-email-mperttunen@nvidia.com> <1403101406-15439-7-git-send-email-mperttunen@nvidia.com> <20140708132216.GA4979@htj.dyndns.org> <53C3DCF0.3030001@redhat.com> <53C4D472.9010507@nvidia.com> <53C4EC81.1040304@redhat.com>
In-Reply-To: <53C4EC81.1040304@redhat.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/14 11:55, Hans de Goede wrote:
> Hi,
>
> On 07/15/2014 09:12 AM, Mikko Perttunen wrote:
>> Heh, what you are describing is the v1 of this series :)
>>
>> However,
>>
>> 17/06/14 Thierry Reding wrote:
>>> I would've preferred tegra_powergate_sequence_power_up() to be used
>>> consistently in all drivers. I'm still not convinced that using the
>>> platform AHCI driver this way is really the best option, since we're
>>> bending over backwards to fit into what this driver dictates. There
>>> shouldn't be a need for that.
>>
>> As you probably noticed, the issue is that on Tegra we want to use tegra_powergate_sequence_power_up to enable the SATA power rail. That function assumes that it gets a disabled clock and returns with the clock enabled. If we use ahci_platform's resource management functions,
>> this is not doable, since it wants to handle clocks by itself.
>
> Right, note I was not suggesting that you use ahci_platform_enable_resources /
> ahci_platform_disable_resources, that clearly won't work for your case.
>
> As I said "I can see there are good reasons for that though."
>
>> To be honest, I too would prefer handling the resources in the driver. The driver needs other resources than what ahci_platform currently manages (at least reset_controls and multiple regulators, later we might get more) and managing them in the driver allows the driver to do proper error handling and manage all resources consistently and in one place. Also, I don't think it is sensible to add support for loading every possible kind of DT resource to ahci_platform, since most drivers won't need them.
>
> Actually I have considered asking you to add support for reset controllers
> to libahci_platform too, since I see a pattern where more and more
> SOCs are starting to use those. I've refrained from asking that for now,
> but once a second ahci implementation needing those pops up we will likely
> go that route. So you might as well do it now :)
>
>> Other subsystems I've been in don't have this kind of helper library, so diverging here seems weird.
>
> Well the usb uhci-platform and ehci-platform drivers are doing the same,
> what we're trying to do here is avoid needless code duplication and
> if possible (for ehci and uhci it currently is) make it so that adding
> support for a new soc only requires adding dt stuff + a phy driver,
> without touching the ?hci code at all. Again I can see that this
> is not possible for the Tegra124.
>
>> That said, if you feel strongly about this, I can do what you described.
>
> I think you can safe a nice bit of code duplication (and if we ever find
> we have bugs there bug duplication) by switching to
> ahci_platform_get_resources, as described in my original mail.
>
> I can understand if you don't want to use any of the other ahci_platform_*
> functions, that makes total sense.
>
> I would not say this is something you must do, but I have a strong
> preference for you taking a shot at doing this. So can you please give
> this a try, and if it turns out to become ugly, just say so (with
> some explanation), and then you can keep things as is.
> Does that work for you?
>
> Regards,
>
> Hans
>

Sure, I'll have a go at it. I already sent one bugfix for 
libahci_platform anyway :)

Mikko
