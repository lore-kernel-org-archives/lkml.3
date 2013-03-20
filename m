Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab3CTSwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:52:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35881 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3CTSwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:52:22 -0400
Message-ID: <514A0562.6080307@wwwdotorg.org>
Date: Wed, 20 Mar 2013 12:52:18 -0600
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
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com> <5148C1DC.1020903@wwwdotorg.org> <D958900912E20642BCBC71664EFECE3E6E5092FFE2@BGMAIL02.nvidia.com> <5149F394.4070600@wwwdotorg.org>
In-Reply-To: <5149F394.4070600@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 11:36 AM, Stephen Warren wrote:
> On 03/20/2013 06:12 AM, Venu Byravarasu wrote:
>> Venu Byravarasu wrote at Wednesday, March 20, 2013 11:30 AM:
>>> Stephen Warren wrote at Wednesday, March 20, 2013 1:22 AM:
>>>> On 03/18/2013 06:29 AM, Venu Byravarasu wrote:
>>>>> As part of this series, apart from patch containing changes to register
>>>> TEGRA
>>>>> USB PHY driver as platform driver, prepared below patches:
>>>>> 1. Re-arranging & adding new DT properties.
>>>>> 2. Getting various params from DT properties added.
>>>>> 3. code clean up.
>>>>
>>>> Venu, I'm curious whether these patches were tested at all. I have found
>>>> at least two significant problems with trivial testing:
>>>
>>> Stephen,
>>> Initially started testing after applying each and every patch.
>>> Like that tested till first 5 patches.
>>> As did not see any issues till then, applied rest 2 patches at once and tested
>>> with that.
>>> Though did not see mouse getting vbus on the 1st boot, Vbus was coming
>>> fine after disconnect and connect.
>>> Hence did not test thereafter.
>>>
>>> After checking your current mail, tried now and observed that there seems to
>>> be some real issue with patch#7 only. (As tried now after applying till patch#
>>> 6 and did not see this issue).
>>> Will debug further on patch#7 and update with proper fix after addressing
>>> your other comments.
>>
>> Debugged further and found that the issue is because of http://marc.info/?l=linux-arm-kernel&m=135890098024987&w=2 
>> On reverting that patch and applying it on top of patch#7, able to see  enumeration working fine.
>>
>> Anyhow, will take care of your other comments and merge this change with patch#7 and resend
>> for review.
> 
> Venu, we already discussed this downstream, and I pointed out that patch
> is /extremely/ unlikely to cause any issue.

OK, so I found that reverting that patch does "solve" the issue, but
it's got nothing to do with that patch being wrong. There is some memory
corruption issue in your patches that is hidden if that patch is reverted.

In other words, on both Springbank (which you don't have, and has an EMC
scaling table so that the EMC frequency probably varies with CPU load)
and Ventana (which is what I assume you're testing on, and has no EMC
table, so the EMC clock frequency is fixed):

1) Tegra's for-next branch: Works fine.

2) (1) plus your patches: Broken as I described above.

3) (2) plus revert 9304512 "usb: host: tegra: don't touch EMC clock":
works fine on Ventana, somewhat works on Seaboard; lots of "can't
enumerate USB bus" messages, but eventually succeeds.

The really interesting thing is that if I take (2) above plus *just* the
following patch:

> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 772fa29..7499240 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -44,6 +44,7 @@ struct tegra_ehci_hcd {
>         struct ehci_hcd *ehci;
>         struct tegra_usb_phy *phy;
>         struct clk *clk;
> +       struct clk *emc_clk;
>         struct usb_phy *transceiver;
>         int host_resumed;
>         int port_resuming;

Then it works fine on both Ventana and Seaboard.

To me, this says that there's nothing at all wrong with 9304512 "usb:
host: tegra: don't touch EMC clock", but rather there is some memory
corruption going on in your patches series, and adding that extra field
in the struct just hides the effect of the memory corruption.

Please debug and fix that. Thanks.
