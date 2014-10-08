Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbaJHQZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:25:11 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:52653 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJHQZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:25:08 -0400
Message-ID: <5435655C.8090803@collabora.co.uk>
Date: Wed, 08 Oct 2014 18:25:00 +0200
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
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk> <1412775847-15213-6-git-send-email-javier.martinez@collabora.co.uk> <20141008145627.GD4609@sirena.org.uk>
In-Reply-To: <20141008145627.GD4609@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 04:56 PM, Mark Brown wrote:
> On Wed, Oct 08, 2014 at 03:44:07PM +0200, Javier Martinez Canillas wrote:
> 
>> The regulator core now has support to choose a default initial
>> operating mode for regulators from DT. Set the initial opmode
>> for the max77802 PMIC regulators with the same modes that are
>> used in the downstream ChromeOS kernel, in order to allow the
>> system to lower power at suspend time.
> 
> The stated goal of this change doesn't appear to correspond to what it
> actually does.  It's saying that we want to be able to set the regulator
> into low power modes on suspend which is a sensible and useful thing to
> want to do (especially for regulators which don't have physical suspend
> modes which we currently make any effort to handle) but what the change
> actually does is cause us to set the default state of supplies on boot.
> 

Well, setting a regulator into low power mode on suspend is something
that Chanwoo's series tried to address. At least on v3 since he removed
regulator-mode property for the regulator-state-{standby,mem,disk} on v4.

What this series tried to solve is when you have to set a opmode on boot
to change how the physical suspend is managed by the PMIC.

In the Maxim77802 PMIC is even trickier since not all the modes have the
semantics. That is the value 0x1 could have different meanings depending
of the regulator.

> The device tree should describe what it's trying to achieve, otherwise
> even if things happen to work right now it's going to be vulnerable to
> being broken by future kernel changes which take what it's saying at
> face value.
> 
>>  			buck2_reg: BUCK2 {
>> @@ -201,6 +203,7 @@
>>  				regulator-always-on;
>>  				regulator-boot-on;
>>  				regulator-ramp-delay = <12500>;
>> +				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
>>  			};
> 
> This appears to set the supply which is labelled as VDD_ARM into standby
> mode by default (from a first glance the change appears to set all
> supplies into standby mode) and of course we currently have no way of
> changing the mode at runtime in DT systems.  Are you *really* sure this
> is a good idea of which an electrical engineer would approve, CPU cores
> are typically one of the most demanding workloads available for a
> regulator?
> 

Well, the standby mode for this regulator is actually:

Output ON/OFF Controlled by PWRREQ
	PWRREQ=HIGH (1): Output ON in Normal Mode
	PWRREQ=LOW (0): Output OFF

this means that when the Soc enters into suspend mode a pin is toggled
and that pin is connected to the PWRREQ line in the PMIC to signal that
the SoC has entered in sleep mode so the regulator has to be OFF.

When the SoC leaves sleep mode and is resumed again, the pin is toggled
so the PMIC puts the regulator in ON again.

There is other mode that instead of turning off the regulator, keeps it
enabled but in low power mode.

Best regards,
Javier
