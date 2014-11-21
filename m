Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaKUK7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:59:55 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:46849 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaKUK7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:59:52 -0500
Date: Fri, 21 Nov 2014 11:59:51 +0100
From: Johan Hovold <johan@kernel.org>
To: Auto Configured <romain.perier@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>
Cc: heiko@sntech.de, grant.likely@linaro.org, robh@kernel.org,
        devicetree@vger.kernel.org, lgirdwood@gmail.com, broonie@kernel.org,
        johan@kernel.org, mark.rutland@arm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com
Subject: Re: [PATCH v4 1/2] of: Rename "poweroff-source" property to
 "system-power-controller"
Message-ID: <20141121105951.GA20679@localhost>
References: <1415885699-1465-1-git-send-email-user@radxa>
 <1415885699-1465-2-git-send-email-user@radxa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415885699-1465-2-git-send-email-user@radxa>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 01:34:58PM +0000, Auto Configured wrote:
> From: Romain Perier <romain.perier@gmail.com>
> 
> It reverts commit a4b4e0461ec5 ("of: Add standard property for poweroff capability").
> As discussed on the mailing list, it makes more sense to rename back to the
> old established property name, without the vendor prefix. Problem being that
> the word "source" usually tends to be used for inputs and that is out of control
> of the OS. The poweroff capability is an output which simply turns the
> system-power off. Also, this property might be used by drivers which power-off
> the system and power back on subsequent RTC alarms. This seems to suggest to
> remove "poweroff" from the property name and to choose "system-power-controller"
> as the more generic name. This patchs adds the required renaming changes and
> defines an helper function which is compatible with both properties, the old one
> which was only used by tps65910 and the new one without vendor-prefix.

Now this is a bit of a mess.

There's a commit in the mfd tree, 25f833c1171d ("mfd: tps65910: Convert
ti,system-power-controller DT property to poweroff-source"), which
breaks all dts using tps65910 since these are never updated to the now
retracted property name ("poweroff-source").

This one should simply be reverted ASAP.

> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  .../bindings/power/{poweroff.txt => power-controller.txt}        | 0
>  .../devicetree/bindings/regulator/act8865-regulator.txt          | 4 ++--
>  drivers/mfd/tps65910.c                                           | 9 ++++++++-
>  drivers/regulator/act8865-regulator.c                            | 2 +-
>  include/linux/of.h                                               | 6 +++---
>  5 files changed, 14 insertions(+), 7 deletions(-)

Romain, what tree is this patch against? The changes to the tps65910
driver appears not to even be in the regulator tree, yet you asked Mark
to merge this. And the MFD maintainer is not even on CC.

Let's fix the breakage by reverting the offending commit in mfd. Then the
new standard name can be introduced in regulator alone (e.g. this patch
without the tps65910 bits) as nothing outside of regulator should be
using the new power-off feature (or binding) for act8865. Then other
drivers and dts can be converted to use the new property name (while
retaining backwards compatibility) for 3.20.

[ We should probably also consider adding an "of_device_is_" prefix to
the helper name for consistency. ]

Johan
