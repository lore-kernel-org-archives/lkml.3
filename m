Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108AbaKYRuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:50:09 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:41541 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKYRuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:50:07 -0500
MIME-Version: 1.0
In-Reply-To: <5474B564.9080902@roeck-us.net>
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>
	<1416930423-12179-2-git-send-email-bgolaszewski@baylibre.com>
	<5474A72D.2000309@roeck-us.net>
	<CAMpxmJUrs-3oXwYyNh26EnuZRH9bpXrmBBLKM7tmKGx=gSwyuQ@mail.gmail.com>
	<5474B564.9080902@roeck-us.net>
Date: Tue, 25 Nov 2014 18:50:07 +0100
Message-ID: <CAMpxmJVGE444t3gE-=u8kuK_B9rJ=0fw9ZYVuYgQRPdswiPj7Q@mail.gmail.com>
Subject: Re: [PATCH 1/5] hwmon: ina2xx: bail-out from ina2xx_probe() in case
 of configuration errors
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-25 17:59 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> The new functions _might_ make a bit more sense if you would
> implement the necessary calculations in the functions, but you are
> not doing that. Instead, in the next patch, you introduce yet
> another function to do the calibration calculation, just to add it
> as parameter to the actual calibration function whenever you call it.

This wasn't my intention, but I'll keep that in mind for the next version.

> - I don't accept unnecessary ( ).
> - I don't accept unnecessary typecasts.
> - If you don't accept negative values, use kstrtoul().
> - kstrtol can at least in theory return other errors besides -EINVAL.

I'll fix those in the next version.

> - Locking should be done in the calling code. It is not needed during
>   probe and more appropriate in set functions.

I don't use locks in probe - they're used directly in
ina2xx_set_value() or indirectly in ina226_update_avg(), but these
functions are never called from probe.

> - Any reason for selecting "rshunt" as sysfs attribute name instead
>   of, say, shunt-resistor or maybe shunt_resistor ?

I'll change it to shunt_resistor for more readability.

> - Returning -ENODEV from a set function doesn't make much sense.

It does make sense in case of ACME (http://baylibre.com/acme/) - a
probe can be disconnected at run-time, which, even without these
patches, would cause ina2xx_update_device() to error out when called
by ina2xx_show_value():

231                         int rv = i2c_smbus_read_word_swapped(client, i);
232                         if (rv < 0) {
233                                 ret = ERR_PTR(rv);
234                                 goto abort;

I just reproduced this behavior in ina2xx_set_value().

> - We don't overwrite error codes except in probe functions.

I'll fix that too.

Bart
