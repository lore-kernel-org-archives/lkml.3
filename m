Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbaGYKSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:18:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54660 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751395AbaGYKSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:18:07 -0400
Date: Fri, 25 Jul 2014 12:18:04 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: jiri.prchal@aksignal.cz
Cc: Bo Shen <voice.shen@atmel.com>, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: at91sam9x5: sets NPCS0 (PA14) back to GPIO
Message-ID: <20140725121804.18b05a5d@bbrezillon>
In-Reply-To: <53D22C26.4030208@aksignal.cz>
References: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>
	<53D10C50.50305@aksignal.cz>
	<20140724162645.4e19c26c@bbrezillon>
	<53D12103.3020103@aksignal.cz>
	<20140724175848.44f5da10@bbrezillon>
	<53D1F5D0.1080006@aksignal.cz>
	<20140725095319.16a8465c@bbrezillon>
	<53D214E1.4050105@aksignal.cz>
	<20140725104553.403921b1@bbrezillon>
	<53D21B3F.7060006@aksignal.cz>
	<20140725110124.3f0dce6c@bbrezillon>
	<53D21FCF.7010402@aksignal.cz>
	<20140725113110.70c4aa41@bbrezillon>
	<53D22C26.4030208@aksignal.cz>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014 12:06:30 +0200
Jiří Prchal <jiri.prchal@aksignal.cz> wrote:

> 
> 
> Dne 25.7.2014 v 11:31 Boris BREZILLON napsal(a):
> > On Fri, 25 Jul 2014 11:13:51 +0200
> > Jiří Prchal <jiri.prchal@aksignal.cz> wrote:
> >
> >
> >>>
> >>> Every thing seems in place.
> >>> Could you enable CONFIG_DEBUG_PINCTRL and grep on "enable pin" ?
> >> / # dmesg | grep "enable pin"
> >> [    0.968750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 101 as GPIO
> >> [    0.968750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 101 as PIOD5 0x20
> >> [    0.968750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 100 as GPIO
> >> [    0.968750] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 100 as PIOD4 0x10
> >> [    1.238281] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 23 as GPIO
> >> [    1.238281] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 23 as PIOA23 0x800000
> >> [    1.238281] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 22 as GPIO
> >> [    1.238281] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 22 as PIOA22 0x400000
> >> [    1.242187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 93 as GPIO
> >> [    1.242187] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 93 as PIOC29 0x20000000
> >> [    1.246093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 14 as GPIO
> >> [    1.246093] pinctrl-at91 ahb:apb:pinctrl@fffff400: enable pin 14 as PIOA14 0x4000
> >
> >
> > Okay, this cleary shows that PA14 pin is muxed as a GPIO (or at least
> > the driver think it is).
> >
> >
> > Could you launch these commands (you'll need the devmem tool) and
> > paste the results ?
> >
> > #devmem 0xfffff408
> > #devmem 0xfffff418
> > #devmem 0xfffff438
> > #devmem 0xfffff43c
> > #devmem 0xfffff458
> > #devmem 0xfffff468
> > #devmem 0xfffff470
> > #devmem 0xfffff474
> > #devmem 0xfffff498
> >
> / # devmem 0xfffff408
> 0xF0E04018
> / # devmem 0xfffff418
> 0xE0C04000
> / # devmem 0xfffff438
> 0x00C04000
> / # devmem 0xfffff43c
> 0x13FFD7FB
> / # devmem 0xfffff458
> 0x00000000
> / # devmem 0xfffff468
> 0xFF223B4E
> / # devmem 0xfffff470
> 0x0F000000
> / # devmem 0xfffff474
> 0x00000000
> / # devmem 0xfffff498
> 0xFFFFFFFF
> 
> I get thought if is possible that in time of probe fm25 (it's first) is not configured PA14 (it 's last)?

Oh, nice catch!
I think you've found the origin of this bug.
Indeed each device is instantiated sequentially and thus when the first
device is probed (CS0) the last one has not requested it's cs_gpio yet
(and PA14 is still assigned to periph A).

Declaring cs-pins and referencing them in pinctrl-0 solves the issue
because in this case all CS pins are requested during controller probe.

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
