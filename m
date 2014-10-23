Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbaJWQzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:55:31 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36089 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbaJWQz2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:55:28 -0400
MIME-Version: 1.0
In-Reply-To: <1522951.uUd1Gprpbn@diego>
References: <1413913655-22351-1-git-send-email-dianders@chromium.org>
	<1522951.uUd1Gprpbn@diego>
Date: Thu, 23 Oct 2014 09:55:27 -0700
X-Google-Sender-Auth: zGCd-Q4cqeVZDYYDuAEhQw5Nc7o
Message-ID: <CAD=FV=X5T0z9QhPsxBtQ8ffS+x90TZ9kYAvNcmU0uNsx1+2wNA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] pinctrl: rockchip: Set wake_enabled
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Zhong <zyw@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Thu, Oct 23, 2014 at 9:43 AM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Dienstag, 21. Oktober 2014, 10:47:32 schrieb Doug Anderson:
>> The rockchip pinctrl driver uses irq_gc_set_wake() but doesn't setup
>> the .wake_enabled member.  That means that we can never actually use a
>> pin for wakeup.  When "irq_set_irq_wake()" tries to call through it
>> will always get a failure from set_irq_wake_real() and will then set
>> wake_depth to 0.  Assuming you can resume you'll later get an error
>> message about "Unbalanced IRQ x wake disable".
>
> The change itself looks reasonable. But now being able to read the docs for
> it, it doesn't look like all gpios are able to wake the system.
>
> On the rk3288 it seems to be only the pins from gpio0 that can do this
> (similar for different banks on the other Rockchip SoCs) - see PMU_WAKEUP_CFG0
> and PMU_WAKEUP_CFG1[1].
>
> So I guess we'll need something more eloquent to handle this.

I think long term we're going to need something more elegant, yes.
...but it turns out that as long as you're not in the low, low power
state that all pins can wake up the system.

Check out "Table 4-5 Power Domain Status Summary in all Work Mode".
In Mode 3 (called "sleep") all GPIOs can wake the system up.  This is
the mode that Chris's current suspend/resume patch uses (actually, it
doesn't quite get all the way to that mode yet, but that's the
target).  It would be ideal if we could get to Mode 4 (called
"poweroff"), but when I talked to Rockchip they were a little hesitant
about promising that it would work.

For one thing: I'm also not 100% certain that today's boards are
designed to handle Mode 4.  You need to make sure that anything
connected to a pin other that GPIO0 can handle whatever state the CPU
leaves those pins in mode 4.  You also need to make extra certain that
all wakeup pins are on GPIO0 (wasn't the case with the first board I
worked with).

Also: I think you're supposed to turn off VDD_LOG in mode 4.  See the
line that says "The power off mode turns off the power of all VD_LOGIC
externally."  On the schematic I'm looking at right now (based on
rk808 EVB) I think there is no way to turn off VDD_LOG (without
killing RAM).


...my thought was to take this simple patch and eventually work something out.


NOTE: One unresolved thing with the current series (this series +
Chris's) is that pretty much any interrupt can wake up the system.
Even typing on the UART seems to do it.  Somehow we're not masking
interrupts in a way that prevents this, but I haven't tracked it down
yet.  I don't think it's related to this patch.
