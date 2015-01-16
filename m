Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbbAPTNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:13:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbbAPTNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:13:12 -0500
Message-ID: <54B9629C.9090800@redhat.com>
Date: Fri, 16 Jan 2015 20:12:28 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?windows-1252?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 4/4] ARM: mvebu: Armada 385 GP: Add regulators to the
 SATA port
References: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com> <1421330978-9694-5-git-send-email-gregory.clement@free-electrons.com> <54B8C933.7020502@redhat.com> <54B8D97B.3090908@free-electrons.com> <54B8E38A.6020709@redhat.com> <20150116123705.GM3043@sirena.org.uk>
In-Reply-To: <20150116123705.GM3043@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16-01-15 13:37, Mark Brown wrote:
> On Fri, Jan 16, 2015 at 11:10:18AM +0100, Hans de Goede wrote:
>> On 16-01-15 10:27, Gregory CLEMENT wrote:
>
>>>>> +	reg_sata0: pwr-sata0 {
>>>>> +		compatible = "regulator-fixed";
>>>>> +		regulator-name = "pwr_en_sata0";
>>>>> +		enable-active-high;
>>>>> +		regulator-always-on;
>
>>>> done, but we're not using a power on delay anyways.
>
>>> But if regulator-always-on prevent to switch it off in
>>> suspend then yes using regulator-boot-on is better.
>
>> AFAIK regulator-always-on means exactly that and thus likely
>> is not what you want. As for using regulator-off-in-suspend
>> that is not necessary as the suspend method for the acpi
>> driver will already turn it off.
>
> regulator-always-on is a bit fuzzy for suspend, if the regulator has
> suspend control it'll kick in - it's really about the Linux refcounting
> while it's running.  What's more concerning here is that the quick
> sample of the regulators flagged as always on like the above that I
> looked at in the patch don't seem to have any enable control in the DT
> so this will have absolutely no effect.
>
>> It is probably a good idea to use regulator-boot-on and
>> then test things this way, and if that works use
>> regulator-boot-on.
>
> No, it's unlikely that boot-on makes sense here - it's there for cases
> where we can't read back the hardware state at power on.

Which we cannot here since we've a gpio driven regulator, with the pin
in output mode, so we cannot read it back. Or at least the current kernel
implementation relies on regulator-boot-on rather then reading the
state back from the hardware.

If we do not specify regulator-boot-on then drivers/regulator/fixed.c :
of_get_fixed_voltage_config() will set the cfg.ena_gpio_flags
GPIOF_OUT_INIT_HIGH / GPIOF_OUT_INIT_LOW flags such that the regulator
will get turned off when registered (*) and then it will get turned back
on when the ahci driver loads causing the disk to powercycle while
spinning seriously deteriorating its live time, so regulator nodes
for supplies which power spinning disks definitely need
regulator-boot-on.

An alternative would be using regulator-always-on, but using
regulator-always-on here is wrong because it removes all of control from
the driver, making e.g. runtime pm for unused disks or empty drive-bays
impossible.

*) It will turn it off as soon as it requests the gpio.

> Generally
> drivers should work regardless of the initial state of the regulator
> (and modular drivers will actually break if they try to rely on boot-on
> since we clean up unused regulators at boot).

This is not about drivers, the driver will work fine, the problem is
that power-cycling disks which have already been spun-up by the bootloader
is very bad for those disks.

While we're discussing this I would also like to advocate to change the
behavior for regulator-boot-on to be the same as always-on when it comes
to regulator_init_complete(), iow regulator-boot-on regulators should
not be touched by regulator_init_complete(). It makes no sense to have
different behavior for build in versus module drivers here.

For build-in the regulator is left on (or turned on even) as soon as the
regulator registers, and then stays that way until explicitly turned off
by a driver,

I believe we should still leave these on once userspace starts running,
there is a reason they are marked as regulator-boot-on and the fact that
we're ready to start running userspace does not take away that reason, to
me regulator-boot-on means "do not turn off until explicitly told so by
a driver which (hopefully) knows wtf it is doing".

Regards,

Hans
