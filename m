Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab3EOJrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:47:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:56304 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab3EOJro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:47:44 -0400
Date: Wed, 15 May 2013 11:47:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 07/15] clocksource: Provide unbind interface in sysfs
In-Reply-To: <517F1A27.3030206@linaro.org>
Message-ID: <alpine.LFD.2.02.1305151144550.1388@ionos>
References: <20130425142452.908423538@linutronix.de> <20130425143435.964218245@linutronix.de> <517F1A27.3030206@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013, John Stultz wrote:
> On 04/25/2013 01:31 PM, Thomas Gleixner wrote:
> > With the module refcount held for the current clocksource there is no
> > way to unload the module.
> > 
> > Provide a sysfs interface which allows to unbind the clocksource. One
> > could argue that the clocksource override could be (ab)used to do so,
> > but the clocksource override cannot be used from the kernel itself,
> > while an unbind function can be used to programmatically check whether
> > a clocksource can be shutdown or not.
> > 
> > The unbind functionality uses the new skip current feature of
> > clocksource_select and verifies that a fallback clocksource has been
> > installed. If the clocksource which should be unbound is the current
> > clocksource and no fallback can be found, unbind returns -EBUSY.
> > 
> > This does not support the unbinding of a clocksource which is used as
> > the watchdog clocksource. No point in fostering crappy hardware.
> 
> So.. if the clocksource you want to unbind is the highest rated continuous
> clocksource that doesn't need a watchdog (basically what's likely to be in-use
> and required to be unbinded), its likely to be selected as the watchdog
> already.
> 
> ie: on a system that has only HPET/ACPI_PM, you can't unbind HPET, since its a
> watchdog.

No. The thing is that I only prevent unbinding if it is used as the
watchdog. In the above HPET/PM scenario both are potential watchdogs,
but w/o a user it's valid to unbind one of them.

What I need to prevent is:

TSC is current clocksource and we only have ACPI_PM as watchdog and
its used. So now you try to unbind ACPI_PM then the TSC would be left
w/o a watchdog instance. That's what I'm preventing. Will reword the
changelog accordingly.

Thanks,

	tglx
