Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706Ab3DCRQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:16:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38211 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762172Ab3DCRQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:16:38 -0400
Message-ID: <515C63F3.5070401@wwwdotorg.org>
Date: Wed, 03 Apr 2013 11:16:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Bibek Basu <bbasu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pritesh Raithatha <praithatha@nvidia.com>
Subject: Re: [PATCH] pinctrl: tegra: add suspend-resume support
References: <1364490685-21831-1-git-send-email-bbasu@nvidia.com> <5154827B.8010701@wwwdotorg.org> <CACRpkdYLSVkfAxVBMBnkyePujaoQQqB27UiG+-r2APkEDrfLrA@mail.gmail.com>
In-Reply-To: <CACRpkdYLSVkfAxVBMBnkyePujaoQQqB27UiG+-r2APkEDrfLrA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 08:09 AM, Linus Walleij wrote:
> On Thu, Mar 28, 2013 at 6:48 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> Why can't we just use the device suspend/resume functions rather than
>> global (syscore) suspend/resume functions? Presumably this is to ensure
>> that all other drivers suspend first, then the pinctrl driver does, and
>> the reverse for resume. Can't we rely on deferred probe to ensure that
>> instead?
>>
>> To make that work, we might need every affected driver to define a dummy
>> pinmux state in DT that references the pinctrl driver, to make sure they
>> all get probed after the pinctrl driver.
> 
> Hm that reminds me of that policy change I suggested a while back to
> do this instead of using hogs where possible.
> 
> It has the nice side-effect that when we inspect the debugfs info
> all pins will be properly owned by respective consuming device.

True, in theory that would also work.

However, in practice with Tegra's pinmux, it has to all be set up at
once to avoid any conflicts, so hogging is really the only practical way
to use it in most cases.

This is because in many cases, a single controller could have its
signals routed out to many different pins (or sets of pins), rather than
just having one possible location where each controller could be routed
to. In other words, the pinmux is m:n rather than m:1.

It's possible program the registers so that the same signal is connected
to (or from depending on signal direction) multiple pins at once. If
this is done, the behaviour is unspecified; who knows which pin will
actually receive (or provide) that signal?

This can easily happen if the whole pinmux is not initialized fully in
one pass, i.e. through hogs. For example, the HW default may be for e.g.
UART1 to get routed to pins A, and B, whereas a particular board may
assume that UART1 is routed to pins X, Y. So, SW must program pins X, Y
to mux in UART1. However, if pins A, B aren't also re-programmed away
from the UART1 option, then UART 1 on X, Y may not actually work. In
this case, we can't rely on some other driver having
acquire/re-programmed pins A, B, unless it's the hog of the pin
controller itself. Hence, the only sensible solution is for the pin
controller to hog absolutely everything.

The only exception would be for dynamic pin-muxing (e.g. pinctrl-based
I2C muxing), where hopefully everything is chosen carefully to avoid
this kind of issue.
