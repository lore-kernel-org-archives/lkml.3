Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab3G3ISh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:18:37 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16667 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075Ab3G3ISd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:18:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 30 Jul 2013 01:18:32 -0700
Message-ID: <51F776DB.3060104@nvidia.com>
Date: Tue, 30 Jul 2013 16:18:35 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "linux@roeck-us.net" <linux@roeck-us.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        sw-mobile-therm <sw-mobile-therm@exchange.nvidia.com>
Subject: Re: [PATCH v3 3/4] hwmon: (lm90) add support to handle IRQ
References: <1373615287-18502-1-git-send-email-wni@nvidia.com> <1373615287-18502-4-git-send-email-wni@nvidia.com> <20130718175822.62c358bf@endymion.delvare>	<51E8DFB2.9070701@nvidia.com> <20130727170212.29297696@endymion.delvare>	<51F640A0.4040809@nvidia.com> <20130729175835.795dba2b@endymion.delvare>
In-Reply-To: <20130729175835.795dba2b@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 11:58 PM, Jean Delvare wrote:
> Hi Wei,
> 
> On Mon, 29 Jul 2013 18:14:56 +0800, Wei Ni wrote:
>> On 07/27/2013 11:02 PM, Jean Delvare wrote:
>>> On Fri, 19 Jul 2013 14:41:54 +0800, Wei Ni wrote:
>>>> 2. The pin ALERT/THERM2 is configured as ALERT, and it is connected to
>>>> the interrupt line.
>>>
>>> Why don't you use the SMBus alert mechanism then? It is already
>>> implemented and allows you to reuse the interrupt of the SMBus
>>> controller.
>>>
>>> Of course this is a question for the hardware designers, not you... If
>>> the board uses a separate interrupt pin for the NCT1008's ALERT output,
>>> then the driver has to handle that interrupt explicitly, as done in your
>>> patch.
>>>
>>> One thing which worries me though is this explanation in the NCT1008
>>> datasheet:
>>>
>>> "The ALERT interrupt latch is not reset by reading the
>>> status register. It resets when the ALERT output has been
>>> serviced by the master reading the device address, provided
>>> the error condition has gone away and the status register flag
>>> bits are reset."
>>>
>>> This suggests that connecting the ALERT output to a separate interrupt
>>> pin will not work, as the ALERT output will never be de-asserted even
>>> if the fault conditions are gone and the status register was read. But
>>> as you say this is how your system is supposed to work, can you explain
>>> how it can work?
>>
>> Yes, we had met this problems, to fix this issue, we enabled one-shot
>> mode in the bottom half handler of nct interrupts to force a
>> conversion/comparison. This effectively stops repeated nct interrupts.
>> We will do following things in the IRQ thread:
>> 1. stand by the nct1008. (set configure register bit 6)
>> 2. update the limit value if needed.
>> 3. write to one-shot resister.
>> 4. give hardware necessary time to finish conversion
>> 5. run the nct1008 (clear configure register bit 6)
> 
> Doh, this is so ugly :(
> 
> Why don't you configure the pin as THERM2 instead of ALERT then? I'd
> expect this to make things easier.

If configure as THERM2, only the high temperature limits are relevant,
so when the temperature reduced, it will not trigger interrupt, and we
can't update the cooling state.

Or do you mean that we can configure the pin to THERM2 in the irq_thread
to avoid the repeated interrupt ? I tried it, but no help, the nct1008
will not run the conversion/comparison immediately, so the status
register will not be cleared.

> 
>> (...)
>> These trip-temps are not critical temperature, we used these temps to
>> update cooling states. For the critical-temp, we handle it like my
>> mentioned in #1.
> 
> I understand. But even if these interrupts are only used for managing
> cooling states, a misbehavior could still have annoying consequences,
> such as causing the thermal shutdown to trigger when this could have
> been avoided, or throttling to stay enabled even though the system has
> cooled down enough.

I think our driver are trying best to avoid these troubles. As I know in
our downstream codes, we didn't met these things.
I think since the lm90 support interrupt mode, then the driver should
have related interface to handle it, and it can call the callback
function to do what the platform driver want.

Thanks.
Wei.

> 
>> Yes, it's not safe to rely on the software, so on our tegra114, we will
>> have soc thermal, which can handle these trip-temps on hardware.
> 
> OK, good :)
> 
>> (...)
>> Yes, absolutely agree, we can't add any private codes to the generic driver.
>> I had talked about it with Durgadoss in his "[PATCH] Thermal Framework
>> Enhancements" series, and in his v3 series, it introduced threshold
>> concept, which used to set limit value, and the "framework is notified
>> about this interrupt to take appropriate action". But this function
>> still didn't be completed yet.
>> I think the thermal fw can expose callback like thermal_zone->alert, and
>> in the irq_thread, we can notify the thermal fw to call this alert
>> callback function, then the platform code can do anything in this callback.
> 
> I didn't follow the discussions closely, but something like this would
> be needed, yes.
> 

