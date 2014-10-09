Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbaJIO1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:27:50 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:53917 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaJIO1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:27:43 -0400
Message-ID: <54369B59.8000509@collabora.co.uk>
Date: Thu, 09 Oct 2014 16:27:37 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 5/5] ARM: dts: Add initial regulator mode on exynos Peach
 boards
References: <20141008195112.GI4609@sirena.org.uk>
In-Reply-To: <20141008195112.GI4609@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 10/08/2014 09:51 PM, Mark Brown wrote:
> On Wed, Oct 08, 2014 at 06:25:00PM +0200, Javier Martinez Canillas
>> What this series tried to solve is when you have to set a opmode on
>> boot to change how the physical suspend is managed by the PMIC.
> 
> Think about the consequences of what's being said here.  The goal is to
> set the mode in system suspend which will presumably be a minimal power
> consumption mode where minimal load is expected.  What's being said is
> that in order to implement this we want to set the default mode used
> while the system is running to this mode.  This will mean that we'll be
> in this low power mode while running full speed.  That in turn not only
> means that the DT says something other than what we're trying to do and
> hence looks like it's buggy but most likely also means that the system
> won't run stably under load since the regulators are in power saving
> mode.
>

No, while system is running the regulator won't be in low power mode even
after changing the mode. The mode only affects what the PMIC will do with
the regulator when the system enters to and exit from sleep mode and the
AP signals the PMIC about it.

Maybe you already got it from my previous email but I'll summarize how the
hardware works just to be sure we are on the same page:

* The PMIC allows the AP to power up and down voltage rails via a PWRREQ
  pin to signal when it enters and exit from sleep mode.

* Each regulator control register has a 2-bit field called OPMODE in the
  data-sheet that allows to set 4 different operating modes. For most
  regulators, the modes are the following:

  0x0: Output OFF (regardless of PWRREQ)
  0x1: Output ON/OFF controlled by PWRREQ
       PWRREQ = HIGH (1): Output ON in Normal Mode
       PWRREQ = LOW (0): Output OFF
  0x2: Output ON with Low Power Mode controlled by PWRREQ
       PWRREQ = HIGH (1): Output ON in Low Power Mode
       PWRREQ = LOW (0): Output OFF
  0x3: Output ON in Normal Mode (regardless of PWRREQ)

* Not all regulators have the same modes, for example 0x1 in some LDOs
  means "Output ON in Low Power Mode regardless of PWRREQ" and so on.

Since PWRREQ is HIGH when the AP is in normal mode, there are only two
modes that most regulators can be on runtime: ON and OFF.
 
> As has been said previously please try to think about things in terms of
> abstractions and what the actual goal is, don't try to shoehorn things
> into places they happen to solve the immediate problem without regard to
> the bigger picture or comprehensibility.
>

I could had proposed a DT property that would be specific to the max77802
regulator driver but instead I really tried to not only care about my
particular use case and come up with a solution that could be generic and
useful for others.

As Krzysztof said in other thread, this feature is common to many Maxim
PMICs and AFAIK the Rockchip RK808 PMIC has a similar feature to choose
between two modes: Output ON vs Output ON/OFF controlled by a SLEEP pin.

But maybe trying to make it generic was my mistake and a device-specific
DT binding is the proper solution here...
 
>> > This appears to set the supply which is labelled as VDD_ARM into standby
>> > mode by default (from a first glance the change appears to set all
>> > supplies into standby mode) and of course we currently have no way of
>> > changing the mode at runtime in DT systems.  Are you *really* sure this
>> > is a good idea of which an electrical engineer would approve, CPU cores
>> > are typically one of the most demanding workloads available for a
>> > regulator?
> 
>> Well, the standby mode for this regulator is actually:
> 
>> Output ON/OFF Controlled by PWRREQ
>> 	PWRREQ=HIGH (1): Output ON in Normal Mode
>> 	PWRREQ=LOW (0): Output OFF
> 
> This isn't a mode at all.  This is an enable control and hence it
> should not be implemented as a mode.  It should be adequately documented
> but for the avoidance of doubt a regulation mode should control the
> quality and efficiency of regulation, if something can cause the
> regulator to be disabled (except perhaps as a consequence of handling a
> failure in regulation) then it shouldn't be a mode.
> 

I see, I thought that an operating mode could be anything that alter the
regulator behavior either during runtime or when the system is suspended.
But under your definition, it is true that most max77802 regulators have
only two modes: ON and OFF (and some of them have a third Low Power mode).

I think though that a generic way to configure this enable control feature
is needed. Maybe adding a new pair of .{get,set}_suspend_control function
pointers to struct regulator_ops and an .initial_suspend_ctrl field to the
struct regulation_constraints?

That way the core could parse a generic DT property and call the function
handlers but each driver can document in their own DT bindings what their
control values are and how those affects the regulators during suspend?

Best regards,
Javier
