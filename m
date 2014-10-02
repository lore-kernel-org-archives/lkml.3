Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaJBJut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:50:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38795 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaJBJuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:50:46 -0400
Message-ID: <542D1F1B.8040501@ti.com>
Date: Thu, 2 Oct 2014 12:47:07 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Kevin Hilman <khilman@kernel.org>, Doug Anderson <dianders@chromium.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Heiko Stuebner <heiko@sntech.de>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-rockchip@lists.infradead.org>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/3] ARM: rk3288 : Add PM Domain support
References: <1411899774-8484-1-git-send-email-jinkun.hong@rock-chips.com> <7hoatvvimd.fsf@deeprootsystems.com> <CAD=FV=VPT5qiyY==nJbb4DqKMBnj0i-_MhLRVG0ikar2qtP4=A@mail.gmail.com> <7h38b7v8pp.fsf@deeprootsystems.com>
In-Reply-To: <7h38b7v8pp.fsf@deeprootsystems.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/01/2014 11:25 PM, Kevin Hilman wrote:
> Doug Anderson <dianders@chromium.org> writes:
> 
>>
>> On Wed, Oct 1, 2014 at 9:51 AM, Kevin Hilman <khilman@kernel.org> wrote:
>>> +Geert, Ulf
>>>
>>> "jinkun.hong" <jinkun.hong@rock-chips.com> writes:
>>>
>>>> From: "jinkun.hong" <jinkun.hong@rock-chips.com>
>>>>
>>>> Use PM Domain framework to manage the clock.
>>>
>>> Which clock?  This changelog needs a more thorough description.
>>
>>
>> I think what he meant was:
>>
>> Use the generic PM Domain framework for Rockchip
>>
>> ...but I agree that he could describe it more.
>>
>>
>>> Also,
>>> with this series alone, it's not clear how the power-domain transitions
>>> ever happen, since I don't see any devices hooked up to your power
>>> domains, or do I see your platform using runtime PM.  In order for this
>>> to be reviewed properely, it's important for reviewers to be able to see
>>> how this PM domain support will be used.
>>
>> I noticed that too.  As the patchset currently stands it only ever disables...
>>
>>
>>> Also, remember that the DT is supposed to reflect the hardware, not the
>>> design choices of linux drivers.  Because of that, it's a little
>>> surprising to see clocks as properties of a power domain because clocks
>>> are usually properties of devices.
>>
>> I haven't dug all the way into the hardware to figure out why (or if
>> this is really necessary), but right now the rockchip power domain
>> driver only leaves these clocks on during the powering on and powering
>> off of the power domain.  In other words to turn on the power domain:
>>
>> 1. Turn on all clocks
>> 2. Flip the bit that sets the power domain on
>> 3. Wait until hardware says power domain is on.
>> 4. Turn off all the clocks.
>>
>> ...and to turn off:
>>
>> 1. Turn on all clocks
>> 2. Flip the bit that sets the power domain off
>> 3. Wait until hardware says power domain is off.
>> 2. Turn off all the clocks.
>>
>> ...if the above is actually necessary when turning on and off power
>> domains then it seems like it is actually describing the hardware.
> 
> Yes, I understand. The need to have some *device* clocks enabled when
> powering on/off the power-domain itself is quite common across many
> SoCs.
> 
> My point is that these clocks are actually properties of *devices*, not
> the power-domain itself.  In the shmobile example I pointed to, the
> clocks are properties of the devices in DT, and the devices are attached
> to the powerdomain.  When the devices are connected to the power-domain,
> the custom attach function looks up all the *device* clocks and and
> addes them to the power-domain using pm_clk_add.

Sorry, but this is not quite right :(
Patches from Geert will add only first clock for device and not all
of them. The right way to add all clocks for device from DT using 
generic PM domain represented in my series:
 
 ARM: keystone: pm: switch to use generic pm domains
 http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg735601.html

> 
> Since the clocks are properties of devices, then the pm_clk
> infrastructure can be used (as the shmobile example shows) so that the
> SoC specific pm-domain doesn't have to manually walk all the clocks, but
> instead can just use pm_clk_suspend/pm_clk_resume.

This might not work if more then one device connected to PM domain.
Then some clocks might be part of GPD if they needed to power on/off it.
But Kevin is right and even in this case, pm_clk infrastructure can still be used,
because RK PM domain is Platform device and clocks can be attached to it
using pm_clk API. I did it in my RFC series https://lkml.org/lkml/2014/9/25/365
- all clacks attached to PM domain in .probe
- then pm_clk_suspend/pm_clk_resume used in .power_off/.power_on callbacks

Benefits: there is no need to implement custom lists of clocks
struct rockchip_pm_domain {
	struct clk			**clks;

Regards,
-grygorii

