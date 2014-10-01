Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaJAUZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:25:12 -0400
Received: from mail.kernel.org ([198.145.19.201]:49167 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaJAUZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:25:09 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: "jinkun.hong" <jinkun.hong@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v2 0/3] ARM: rk3288 : Add PM Domain support
References: <1411899774-8484-1-git-send-email-jinkun.hong@rock-chips.com>
	<7hoatvvimd.fsf@deeprootsystems.com>
	<CAD=FV=VPT5qiyY==nJbb4DqKMBnj0i-_MhLRVG0ikar2qtP4=A@mail.gmail.com>
Date: Wed, 01 Oct 2014 13:25:06 -0700
In-Reply-To: <CAD=FV=VPT5qiyY==nJbb4DqKMBnj0i-_MhLRVG0ikar2qtP4=A@mail.gmail.com>
	(Doug Anderson's message of "Wed, 1 Oct 2014 13:07:50 -0700")
Message-ID: <7h38b7v8pp.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson <dianders@chromium.org> writes:

> Kevin,
>
> On Wed, Oct 1, 2014 at 9:51 AM, Kevin Hilman <khilman@kernel.org> wrote:
>> +Geert, Ulf
>>
>> "jinkun.hong" <jinkun.hong@rock-chips.com> writes:
>>
>>> From: "jinkun.hong" <jinkun.hong@rock-chips.com>
>>>
>>> Use PM Domain framework to manage the clock.
>>
>> Which clock?  This changelog needs a more thorough description.
>
>
> I think what he meant was:
>
> Use the generic PM Domain framework for Rockchip
>
> ...but I agree that he could describe it more.
>
>
>> Also,
>> with this series alone, it's not clear how the power-domain transitions
>> ever happen, since I don't see any devices hooked up to your power
>> domains, or do I see your platform using runtime PM.  In order for this
>> to be reviewed properely, it's important for reviewers to be able to see
>> how this PM domain support will be used.
>
> I noticed that too.  As the patchset currently stands it only ever disables...
>
>
>> Also, remember that the DT is supposed to reflect the hardware, not the
>> design choices of linux drivers.  Because of that, it's a little
>> surprising to see clocks as properties of a power domain because clocks
>> are usually properties of devices.
>
> I haven't dug all the way into the hardware to figure out why (or if
> this is really necessary), but right now the rockchip power domain
> driver only leaves these clocks on during the powering on and powering
> off of the power domain.  In other words to turn on the power domain:
>
> 1. Turn on all clocks
> 2. Flip the bit that sets the power domain on
> 3. Wait until hardware says power domain is on.
> 4. Turn off all the clocks.
>
> ...and to turn off:
>
> 1. Turn on all clocks
> 2. Flip the bit that sets the power domain off
> 3. Wait until hardware says power domain is off.
> 2. Turn off all the clocks.
>
> ...if the above is actually necessary when turning on and off power
> domains then it seems like it is actually describing the hardware.

Yes, I understand. The need to have some *device* clocks enabled when
powering on/off the power-domain itself is quite common across many
SoCs.

My point is that these clocks are actually properties of *devices*, not
the power-domain itself.  In the shmobile example I pointed to, the
clocks are properties of the devices in DT, and the devices are attached
to the powerdomain.  When the devices are connected to the power-domain,
the custom attach function looks up all the *device* clocks and and
addes them to the power-domain using pm_clk_add.

Since the clocks are properties of devices, then the pm_clk
infrastructure can be used (as the shmobile example shows) so that the
SoC specific pm-domain doesn't have to manually walk all the clocks, but
instead can just use pm_clk_suspend/pm_clk_resume.

Kevin






