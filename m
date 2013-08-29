Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab3H2IMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 04:12:49 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45914 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3H2IMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 04:12:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAJxxZ0O77bgP8_rkRm-EgjAJ45SY2Pd3AGVSMhFxbsfNUmiqGg@mail.gmail.com>
References: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com>
	<52150AD9.3040808@wwwdotorg.org>
	<CAJxxZ0O77bgP8_rkRm-EgjAJ45SY2Pd3AGVSMhFxbsfNUmiqGg@mail.gmail.com>
Date: Thu, 29 Aug 2013 10:12:45 +0200
Message-ID: <CACRpkdYF4bD2ho=mLokdPfd0hKnNvGKbGRiiM5=UZv_e7+AY4g@mail.gmail.com>
Subject: Re: [PATCH 1/3 v3] pinctrl: ADI PIN control driver for the GPIO
 controller on bf54x and bf60x.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 9:07 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> There are 6 to 9 GPIO HW blocks in one Blackfin SoC. Function
> pinmux_enable_setting() in current pinctrl framework assumes the
> function mux setting of one peripheral pin group is configured in one
> pinctrl device. But, the function mux setting of one blackfin
> peripheral may be done among different GPIO HW blocks. So, I have to
> separate the pinctrl driver from the GPIO block driver add the ranges
> of all GPIO blocks into one pinctrl device for Blackfin.

This is similar to the situation in the pinctrl-nomadik.c driver,
where the pinctrl portions wait for the GPIO devices to instantiate
before proceeding to probe "on top" of the GPIO blocks, using
the latter to get to the registers.

I am not sure we have found the best way to sort out this
type of system, let's see what we can come up with.

One way I was contemplating was to have just one fat node
in the device tree containing all the register ranges, and one
fat probe function, so all these ranges associated with a
single struct device, but that does not well work with
clocking and interrupts (the GPIO ranges needed one
clock and interrupt each) so I gave up on that idea.

My latest idea was to to to break the subsystems apart a
bit by letting GPIO devices probe without the underlying
pin controller being in place, so I queued up the operations
until the pin controller arrived, but unfortunately this creates
other problems :-(

Still this creates a fuzz when trying to refactor stuff so we
need to find a solution.

Yours,
Linus Walleij
