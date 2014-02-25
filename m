Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaBYJNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:13:40 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:59516 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaBYJNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:13:36 -0500
MIME-Version: 1.0
In-Reply-To: <5306E599.7020605@wwwdotorg.org>
References: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1392900697-27577-3-git-send-email-heikki.krogerus@linux.intel.com>
	<53062F97.3050407@wwwdotorg.org>
	<CAGb2v66-tDZhrm9dnXe+PdQTaLZbw20sw3uYzLor2eXpVWmPMA@mail.gmail.com>
	<5306E599.7020605@wwwdotorg.org>
Date: Tue, 25 Feb 2014 10:13:35 +0100
Message-ID: <CACRpkdZBvKU31EDX=6=wVLXaQDAqD6VHtaE_mGnFLr1UYQAH9g@mail.gmail.com>
Subject: Re: [PATCH 2/4] net: rfkill: gpio: remove gpio names
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Rhyland Klein <rklein@nvidia.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Mark Gross <mark.gross@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 6:35 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 02/20/2014 06:55 PM, Chen-Yu Tsai wrote:

>> That's correct. However using con_id to pass this results in different
>> behavior across DT and ACPI. A better way is to export the labeling
>> function so consumers can set meaningful labels themselves.
>
> But this code is the consumer of those GPIOs. IF the parameter to
> devm_gpiod_get_index() isn't intended to be used, why does it exist?

Kerneldoc says:

/**
 * gpiod_get_index - obtain a GPIO from a multi-index GPIO function
 * @dev:        GPIO consumer, can be NULL for system-global GPIOs
 * @con_id:     function within the GPIO consumer
 * @idx:        index of the GPIO to obtain in the consumer
 *

Basically it is just exposing the fact that of_find_gpio() and
acpi_find_gpio() both take a con_id as argument.

If we drill into this, we find that it is used to conjure the
arbitrary string before the gpios in the DT case, like:

foo-gpios = <...>;

As in tegra30-beaver.dts...

    sdhci@78000000 {
            status = "okay";
            cd-gpios = <&gpio TEGRA_GPIO(I, 5) GPIO_ACTIVE_LOW>;
            wp-gpios = <&gpio TEGRA_GPIO(T, 3) GPIO_ACTIVE_HIGH>;
            power-gpios = <&gpio TEGRA_GPIO(D, 7) GPIO_ACTIVE_HIGH>;
            bus-width = <4>;
    };

Instead of passing the GPIOs as index 0,1,2 they are named
and I do admit this has a nice "things are under control" aspect
to it.

In the ACPI case the con_id is not used for anything.

So it is basically there to satisfy the habit in some device
tree bindings to name gpio arrays instead of just passing gpios = <...>;
(The latter should be encouraged going forward.)

As DT is ABI we need to keep this forever, and driver may need to
look for foo-gpios=<> and gpios=<> alike for backward compatibility
if we'd change it, sweet isn't it? :-)

I don't quite like this, as it is adding stupid nonsens arguments for
ACPI GPIO producers (which only take an index AFAICT), but it is a
first sacrifice on the altar of trying to mask the differences between DT
and ACPI probe paths about which I have mixed feelings.

Yours,
LInus Walleij
