Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab3CTRgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:36:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55609 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3CTRgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:36:23 -0400
Message-ID: <5149F394.4070600@wwwdotorg.org>
Date: Wed, 20 Mar 2013 11:36:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 0/7] USB: PHY: Tegra: registering TEGRA USB PHY as platform
 driver
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com> <5148C1DC.1020903@wwwdotorg.org> <D958900912E20642BCBC71664EFECE3E6E5092FFE2@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6E5092FFE2@BGMAIL02.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 06:12 AM, Venu Byravarasu wrote:
>> -----Original Message-----
>> From: Venu Byravarasu
>> Sent: Wednesday, March 20, 2013 11:30 AM
>> To: 'Stephen Warren'
>> Cc: gregkh@linuxfoundation.org; stern@rowland.harvard.edu;
>> balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linux-tegra@vger.kernel.org; devicetree-discuss@lists.ozlabs.org
>> Subject: RE: [PATCH 0/7] USB: PHY: Tegra: registering TEGRA USB PHY as
>> platform driver
>>
>>> -----Original Message-----
>>> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
>>> Sent: Wednesday, March 20, 2013 1:22 AM
>>> To: Venu Byravarasu
>>> Cc: gregkh@linuxfoundation.org; stern@rowland.harvard.edu;
>>> balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
>>> linux-tegra@vger.kernel.org; devicetree-discuss@lists.ozlabs.org
>>> Subject: Re: [PATCH 0/7] USB: PHY: Tegra: registering TEGRA USB PHY as
>>> platform driver
>>>
>>> On 03/18/2013 06:29 AM, Venu Byravarasu wrote:
>>>> As part of this series, apart from patch containing changes to register
>>> TEGRA
>>>> USB PHY driver as platform driver, prepared below patches:
>>>> 1. Re-arranging & adding new DT properties.
>>>> 2. Getting various params from DT properties added.
>>>> 3. code clean up.
>>>
>>> Venu, I'm curious whether these patches were tested at all. I have found
>>> at least two significant problems with trivial testing:
>>
>> Stephen,
>> Initially started testing after applying each and every patch.
>> Like that tested till first 5 patches.
>> As did not see any issues till then, applied rest 2 patches at once and tested
>> with that.
>> Though did not see mouse getting vbus on the 1st boot, Vbus was coming
>> fine after disconnect and connect.
>> Hence did not test thereafter.
>>
>> After checking your current mail, tried now and observed that there seems to
>> be some real issue with patch#7 only. (As tried now after applying till patch#
>> 6 and did not see this issue).
>> Will debug further on patch#7 and update with proper fix after addressing
>> your other comments.
> 
> Debugged further and found that the issue is because of http://marc.info/?l=linux-arm-kernel&m=135890098024987&w=2 
> On reverting that patch and applying it on top of patch#7, able to see  enumeration working fine.
> 
> Anyhow, will take care of your other comments and merge this change with patch#7 and resend
> for review.

Venu, we already discussed this downstream, and I pointed out that patch
is /extremely/ unlikely to cause any issue.

The clk_set_rate() call returns an error since the requested clock rate
is not supported. The clk_prepare_enable() shouldn't have any effect
because if it did, the only possible meaning is that the clock is
otherwise turned off because it has no users, and that would prevent far
more than USB from operating correctly.

Please fully debug this problem and root-cause it. I'm not reverting
that EMC clock patch without a complete explanation. There's little
point reposting the patches until you've found the problem.

If we did have to revert that patch, then we would need to redefine the
DT bindings for Tegra USB to add that clock into the list of required
clocks, since otherwise it could not clk_get(dev, "emc"). But the USB
driver shouldn't be touching non-USB clocks.
