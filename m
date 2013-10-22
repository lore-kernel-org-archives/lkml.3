Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3JVQFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:05:30 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39074 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3JVQF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:05:29 -0400
Date: Tue, 22 Oct 2013 17:05:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: fix spin lock and reg_cache
Message-ID: <20131022160523.GB24024@lee--X1>
References: <1375729845-6992-1-git-send-email-zubair.lutfullah@gmail.com>
 <20130807084054.GA18668@lee--X1>
 <52667A6C.6000301@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52667A6C.6000301@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Oct 2013, Sebastian Andrzej Siewior wrote:

> On 08/07/2013 10:40 AM, Lee Jones wrote:
> > On Mon, 05 Aug 2013, Zubair Lutfullah wrote:
> > 
> >> Reg_cache variable is used to lock step enable register
> >> from being accessed and written by both TSC and ADC
> >> at the same time.
> >> However, it isn't updated anywhere in the code at all.
> >>
> >> If both TSC and ADC are used, eventually 1FFFF is always
> >> written enabling all 16 steps uselessly causing a mess.
> >>
> >> Patch fixes it by correcting the locks and updates the
> >> variable by reading the step enable register
> >>
> >> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> >> ---
> >>  drivers/mfd/ti_am335x_tscadc.c |    4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > Better that it comes from somewhere.
> 
> I don't understand. All three functions are used before the patch has
> been applied:
> 
> $ git grep -l am335x_tsc_se_set
> drivers/iio/adc/ti_am335x_adc.c
> drivers/input/touchscreen/ti_am335x_tsc.c
> drivers/mfd/ti_am335x_tscadc.c
> 
> $ git grep -l am335x_tsc_se_clr
> drivers/iio/adc/ti_am335x_adc.c
> drivers/input/touchscreen/ti_am335x_tsc.c
> drivers/mfd/ti_am335x_tscadc.c
> 
> $ git grep -l am335x_tsc_se_update
> drivers/iio/adc/ti_am335x_adc.c
> drivers/input/touchscreen/ti_am335x_tsc.c
> drivers/mfd/ti_am335x_tscadc.c
> include/linux/mfd/ti_am335x_tscadc.h
> 
> It has been initialized to 0 by time the mfd part was loaded and
> updated via …_set() from both parts (TSC & ADC). The lock ensured that
> we never lose or add bits due to a race. So I don't understand why we
> end up with 0x1FFFF.
> Could some please explain to me how this can happen?
> 
> I added reg_se_cache to cache the content of REG_SE once and
> synchronize it among TSC & ADC access. REG_SE is set to 0 by the HW
> after "work" has been done. So you need to know the old value or TSC may
> disable ADC and the other way around.

Yep, it's initialised as '0'.

12.5.1.15 STEPENABLE Register (offset = 54h) [reset = 0h]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
