Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbbAFCMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:12:09 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16053 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbbAFCME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:12:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 05 Jan 2015 18:04:58 -0800
Message-ID: <54AB445D.7010303@nvidia.com>
Date: Tue, 6 Jan 2015 10:11:41 +0800
From: Vince Hsu <vinceh@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Lucas Stach <dev@lynxeye.de>, <swarren@wwwdotorg.org>, <gnurou@gmail.com>,
        <bskeggs@redhat.com>, <martin.peres@free.fr>,
        <seven@nimrod-online.com>, <samuel.pitoiset@gmail.com>,
        <nouveau@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com> <1419331204-26679-2-git-send-email-vinceh@nvidia.com> <1419426990.2179.7.camel@lynxeye.de> <549B7638.2010405@nvidia.com> <20150105150932.GG12010@ulmo.nvidia.com>
In-Reply-To: <20150105150932.GG12010@ulmo.nvidia.com>
X-Originating-IP: [10.19.108.126]
X-ClientProxiedBy: HKMAIL103.nvidia.com (10.18.16.12) To
 HKMAIL101.nvidia.com (10.18.16.10)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/05/2015 11:09 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Thu, Dec 25, 2014 at 10:28:08AM +0800, Vince Hsu wrote:
>> On 12/24/2014 09:16 PM, Lucas Stach wrote:
>>> Am Dienstag, den 23.12.2014, 18:39 +0800 schrieb Vince Hsu:
>>>> The Tegra124 and later Tegra SoCs have a sepatate rail gating register
>>>> to enable/disable the clamp. The original function
>>>> tegra_powergate_remove_clamping() is not sufficient for the enable
>>>> function. So add a new function which is dedicated to the GPU rail
>>>> gating. Also don't refer to the powergate ID since the GPU ID makes no
>>>> sense here.
>>>>
>>>> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
>>> To be honest I don't see the point of this patch.
>>> You are bloating the PMC interface by introducing another exported
>>> function that does nothing different than what the current function
>>> already does.
>>>
>>> If you need a way to assert the clamp I would have expected you to
>>> introduce a common function to do this for all power partitions.
>> I thought about adding an tegra_powergate_assert_clamping(), but that
>> doesn't make sense to all the power partitions except GPU. Note the
>> difference in TRM. Any suggestion for the common function?
> I don't think extending the powergate API is useful at this point. We've
> long had an open TODO item to replace this with a generic API. I did
> some prototyping a while ago to use generic power domains for this, that
> way all the details and dependencies between the partitions could be
> properly modeled.
>
> Can you take a look at my staging/powergate branch here:
>
> 	https://github.com/thierryreding/linux/commits/staging/powergate
>
> and see if you can use that instead? The idea is to completely hide the
> details of power partitions from drivers and use runtime PM instead.
You generic power domains work is exactly what we want for powergate 
eventually. :) I recall we used your prototyping in somewhere internal 
tree. We have to add more to complete it though, e.g. power domain 
dependency, mc flush, and clamping register difference like this patch 
does.

But I have a question here. Since the GK20A is not powered on/off by the 
PMC except the clamping control, and GK20A has its own power rail, do we 
really want to hide the power sequence in the generic powergate code? We 
still have to control the voltage level in the GK20A driver through the 
regulator framework. It seems weird to me if we put the 
regulator_{enable|disable} somewhere other than the GK20A driver.

Thanks,
Vince

>
> Also adding Peter whom I had discussed this with earlier. Can we finally
> get this converted? I'd rather not keep complicating this custom API to
> avoid making the conversion even more difficult.
>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1

