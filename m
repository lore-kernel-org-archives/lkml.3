Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab3CPAh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 20:37:59 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:40488 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab3CPAh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 20:37:56 -0400
MIME-Version: 1.0
In-Reply-To: <51439846.9090201@metafoo.de>
References: <1363364801-23684-1-git-send-email-ch.naveen@samsung.com>
	<51439846.9090201@metafoo.de>
Date: Fri, 15 Mar 2013 17:37:54 -0700
X-Google-Sender-Auth: WK-yGy-OCcAelOjF-uG84VabQrI
Message-ID: <CAD=FV=V+-DwCjGoookySCazazBBYOoRO+=G5Q_WXAw+SrXNc-A@mail.gmail.com>
Subject: Re: [RFC: PATCH 2/2] iio: adc: exynos_adc: Handle timeout and race conditions
From: Doug Anderson <dianders@chromium.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 2:53 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> What exactly is the spinlock protecting against here? Concurrent runs of
> exynos_adc_isr? This is probably not issue in the first place.
>
> What you want to protect against is that completion is completed between the
> call to INIT_COMPLETION() and the start of a new conversion. So the sections
> that need to be under the spinlock are the complete call here and the point
> from INIT_COMPLETION until the transfer is started in exynos_read_raw(). Make
> sure to use spin_lock_irq there.

...and at that point I _think_ you won't also need the mutex.

A reasonable way to test to see if you've got this all correct would be to:

* Start two processes that are reading from different ADCs that will
report very different values (maybe add a device tree node for adc1 or
adc7 and use those since they're not really connected to
thermistors?).

* Have your two processes read as fast as they can.  This could just
be "while true; do cat /sys/class/hwmon/hwmon0/device/temp1_input;
done"

* Decrease your timeout and maybe(?) sprinkle some random udelays in
the irq handler so that the timeouts happen sometimes but not others.

* Periodically cancel one of the readers with Ctrl-C

If all is working well then you should always get back the right value
from the right reader (and get no crashes).

-Doug
