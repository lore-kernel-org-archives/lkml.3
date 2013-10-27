Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3J0Xq2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 19:46:28 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33669 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3J0Xq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 19:46:27 -0400
Date: Sun, 27 Oct 2013 16:46:22 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org, "Kim, Milo" <Milo.Kim@ti.com>,
        Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rhyland Klein <rklein@nvidia.com>
Subject: Re: [PATCH 1/7] power_supply: Add charger control properties
Message-ID: <20131027234535.GA23523@teo>
References: <1379959445-28207-1-git-send-email-jenny.tc@intel.com>
 <1379959445-28207-2-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1379959445-28207-2-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jenny,

Thanks a lot for your work on this!

On Mon, Sep 23, 2013 at 11:33:59PM +0530, Jenny TC wrote:
> The battery charger needs to have control path along
> with the reporting charger properties. In existing solutions
> this is implemented using regulator framework. A regulator
> framework doesn't fit a charger driver requirement because of the
> following reason
>

General note:

Please always Cc as many relevant developers as possible, not just me. For
me it takes months to review patches, and you surely want to get at least
a preliminary review from other power supply folks. By Cc'ing just me you
are slowing yourself down.

If you get some Acks/Reviews from other developers on your patches that
shows that the feature is surely in demand and makes sense in general.

"git shortlog -s -n -e drivers/power/*charg*" is a good start to see whom
you'd better Cc in this case.

(Unrelated to these patches, but just FYI, having a chain of

Reviewed-by: Somebody1 <...@same_company.foo>
Reviewed-by: Somebody2 <...@same_company.foo>
...
Reviewed-by: SomebodyN <...@same_company.foo>

Works in opposite direction, it makes me suspicious. :)

> and charging (charger to battery).Disabling the charging path alone
> (eg over battery temperature) will allow the platform to work with
> power from charger without discharging the battery. And the charger
> may need to be disabled completely based on the charger temperature
> or the platform temperature.
> Charger has more than one pair of voltage/current to control (CC,CV,INLMT)
> These features will not directly fit in the regulator framework
> 
> Since the charger driver sits in the power supply subsystem it make sense
> to add the properties to control the charger.

Looking into the patches, it seems that we are putting a lot of
charger-specific knobs into the power supply class, but the primary idea
of power supply subsystem is to monitor the power supplies of the system
itself and system's devices like mouse/keyboard's batteries.

The border of what we define as power supply class object is blurry, so
there is a lot of confusion indeed. For example, some chargers register
TYPE_MAINS or TYPE_USB power_supply objects, but they do it since the
charger chip itself is responsible for monitoring these supplies, so it is
fine, and it does not affect the power supply class itself.

But do we really want to control the chargers through the power_supply's
user-visible interface? It makes the whole power supply thing so
complicated that I'm already losing track of it. Right now I think I would
prefer to move all the charger logic out of the psy class.

More specifically, this code:

> @@ -561,6 +575,11 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
>       if (rc)
>               goto create_triggers_failed;
>
> +     if (psy_is_charger(psy))
> +             rc = power_supply_register_charger(psy);
> +     if (rc)
> +             pr_debug("device: '%s': power_supply_register_charger failed\n",
> +                             dev_name(dev));

I have a weird feeling about the fact that the power_supply_register()
registers a charger. OK, we have thermal stuff registration there, but it
is completely different. We have the cooling device registration there as
well, and this stuff would be really nice to move out to some "chargers
subsystem".

So, Jenny, the question is: can we separate chargers logic from the power
supply? So that we don't have "charger enable"/"charger disable" knobs in
the psy class itself. It is still fine if you need to have some interface
to the psy class so that the chargers subsystem would interface with it,
though. But I think that charger drivers have to register itself with two
subsystems: chargers and power_supply (optionally).

Thanks,

Anton

> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> 
> Change-Id: Id91dbbd8f34499afa97b7d8f11ecf5467847f6a8
> ---
>  Documentation/power/power_supply_class.txt |   16 ++++++++++++++++
>  drivers/power/power_supply_sysfs.c         |    8 ++++++++
>  include/linux/power_supply.h               |    8 ++++++++
>  3 files changed, 32 insertions(+)
> 
> diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
> index 3f10b39..5a5e7fa 100644
> --- a/Documentation/power/power_supply_class.txt
> +++ b/Documentation/power/power_supply_class.txt
> @@ -118,6 +118,10 @@ relative, time-based measurements.
>  CONSTANT_CHARGE_CURRENT - constant charge current programmed by charger.
>  CONSTANT_CHARGE_CURRENT_MAX - maximum charge current supported by the
>  power supply object.
> +INPUT_CURRENT_LIMIT - input current limit programmed by charger. Indicates
> +the current drawn from a charging source.
> +CHARGE_TERM_CUR - Charge termination current used to detect the end of charge
> +condition
>  
>  CONSTANT_CHARGE_VOLTAGE - constant charge voltage programmed by charger.
>  CONSTANT_CHARGE_VOLTAGE_MAX - maximum charge voltage supported by the
> @@ -140,12 +144,24 @@ TEMP_ALERT_MAX - maximum battery temperature alert value in milli centigrade.
>  TEMP_AMBIENT - ambient temperature.
>  TEMP_AMBIENT_ALERT_MIN - minimum ambient temperature alert value in milli centigrade.
>  TEMP_AMBIENT_ALERT_MAX - maximum ambient temperature alert value in milli centigrade.
> +MIN_TEMP - minimum operatable temperature
> +MAX_TEMP - maximum operatable temperature

TEMP_MAX, TEMP_MIN. Be consistent with the rest of the properties...
