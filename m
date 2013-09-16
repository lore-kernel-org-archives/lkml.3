Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3IPMez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:34:55 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:29338 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3IPMev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:34:51 -0400
Date: Mon, 16 Sep 2013 14:34:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: linux@roeck-us.net, thierry.reding@gmail.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        sw-mobile-therm@exchange.nvidia.com
Subject: Re: [PATCH v3 3/4] hwmon: (lm90) add support to handle IRQ
Message-ID: <20130916143429.6b7537c2@endymion.delvare>
In-Reply-To: <51F776DB.3060104@nvidia.com>
References: <1373615287-18502-1-git-send-email-wni@nvidia.com>
	<1373615287-18502-4-git-send-email-wni@nvidia.com>
	<20130718175822.62c358bf@endymion.delvare>
	<51E8DFB2.9070701@nvidia.com>
	<20130727170212.29297696@endymion.delvare>
	<51F640A0.4040809@nvidia.com>
	<20130729175835.795dba2b@endymion.delvare>
	<51F776DB.3060104@nvidia.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

Sorry for the late reply, catching up with the discussions from before
my vacation...

On Tue, 30 Jul 2013 16:18:35 +0800, Wei Ni wrote:
> On 07/29/2013 11:58 PM, Jean Delvare wrote:
> > On Mon, 29 Jul 2013 18:14:56 +0800, Wei Ni wrote:
> >> Yes, we had met this problems, to fix this issue, we enabled one-shot
> >> mode in the bottom half handler of nct interrupts to force a
> >> conversion/comparison. This effectively stops repeated nct interrupts.
> >> We will do following things in the IRQ thread:
> >> 1. stand by the nct1008. (set configure register bit 6)
> >> 2. update the limit value if needed.
> >> 3. write to one-shot resister.
> >> 4. give hardware necessary time to finish conversion
> >> 5. run the nct1008 (clear configure register bit 6)
> > 
> > Doh, this is so ugly :(
> > 
> > Why don't you configure the pin as THERM2 instead of ALERT then? I'd
> > expect this to make things easier.
> 
> If configure as THERM2, only the high temperature limits are relevant,
> so when the temperature reduced, it will not trigger interrupt, and we
> can't update the cooling state.

Ah, indeed, I had not noticed this restriction.

> Or do you mean that we can configure the pin to THERM2 in the irq_thread
> to avoid the repeated interrupt ? I tried it, but no help, the nct1008
> will not run the conversion/comparison immediately, so the status
> register will not be cleared.

No, I didn't mean to suggest anything like that.

> >> (...)
> >> These trip-temps are not critical temperature, we used these temps to
> >> update cooling states. For the critical-temp, we handle it like my
> >> mentioned in #1.
> > 
> > I understand. But even if these interrupts are only used for managing
> > cooling states, a misbehavior could still have annoying consequences,
> > such as causing the thermal shutdown to trigger when this could have
> > been avoided, or throttling to stay enabled even though the system has
> > cooled down enough.
> 
> I think our driver are trying best to avoid these troubles. As I know in
> our downstream codes, we didn't met these things.
> I think since the lm90 support interrupt mode, then the driver should
> have related interface to handle it, and it can call the callback
> function to do what the platform driver want.

Yes, fair enough. I do not object to it, I was only trying to
understand how you were using it.

-- 
Jean Delvare
