Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3JVQ2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:28:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:54675 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3JVQ2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:28:18 -0400
Message-ID: <5266A79D.8020208@linutronix.de>
Date: Tue, 22 Oct 2013 18:28:13 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Zubair Lutfullah <zubair.lutfullah@gmail.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: fix spin lock and reg_cache
References: <1375729845-6992-1-git-send-email-zubair.lutfullah@gmail.com> <20130807084054.GA18668@lee--X1> <52667A6C.6000301@linutronix.de> <20131022154846.GA24024@lee--X1>
In-Reply-To: <20131022154846.GA24024@lee--X1>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 05:48 PM, Lee Jones wrote:
> On Tue, 22 Oct 2013, Sebastian Andrzej Siewior wrote:
> 
>> On 08/07/2013 10:40 AM, Lee Jones wrote:
>>> On Mon, 05 Aug 2013, Zubair Lutfullah wrote:
>>>
>>>> Reg_cache variable is used to lock step enable register
>>>> from being accessed and written by both TSC and ADC
>>>> at the same time.
>>>> However, it isn't updated anywhere in the code at all.
>>>>
>>>> If both TSC and ADC are used, eventually 1FFFF is always
>>>> written enabling all 16 steps uselessly causing a mess.
>>>>
>>>> Patch fixes it by correcting the locks and updates the
>>>> variable by reading the step enable register
>>>>
>>>> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
>>>> ---
>>>>  drivers/mfd/ti_am335x_tscadc.c |    4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> Better that it comes from somewhere.
>>
>> I don't understand. All three functions are used before the patch has
>> been applied:
>>
>> $ git grep -l am335x_tsc_se_set
>> drivers/iio/adc/ti_am335x_adc.c
>> drivers/input/touchscreen/ti_am335x_tsc.c
>> drivers/mfd/ti_am335x_tscadc.c
>>
>> $ git grep -l am335x_tsc_se_clr
>> drivers/iio/adc/ti_am335x_adc.c
>> drivers/input/touchscreen/ti_am335x_tsc.c
>> drivers/mfd/ti_am335x_tscadc.c
>>
>> $ git grep -l am335x_tsc_se_update
>> drivers/iio/adc/ti_am335x_adc.c
>> drivers/input/touchscreen/ti_am335x_tsc.c
>> drivers/mfd/ti_am335x_tscadc.c
>> include/linux/mfd/ti_am335x_tscadc.h
> 
> Okay. So what does this mean?

That means I don't understand the commit message. It says
"However, it isn't updated anywhere in the code at all." but as you see
all three functions (set, update) are used. You said "Better that it
comes from somewhere" so I assumed since two people were looking at
this I forgot something.

>> It has been initialized to 0 by time the mfd part was loaded and
>> updated via …_set() from both parts (TSC & ADC). 
>> The lock ensured that
>> we never lose or add bits due to a race. So I don't understand why we
>> end up with 0x1FFFF.
>> Could some please explain to me how this can happen?
> 
> I don't have any h/w to actually test this, so you two are going to
> have to fudge this out by yourselves.

This wasn't directed to you :)

> 
>> I added reg_se_cache to cache the content of REG_SE once and
>> synchronize it among TSC & ADC access. REG_SE is set to 0 by the HW
>> after "work" has been done. So you need to know the old value or TSC may
>> disable ADC and the other way around.
>>
>> In tree (staging-next) I see that reg_se_cache ended being pointless.
>> am335x_tsc_se_update() is no longer used from TSC or ADC. Only the
>> _set() and _clr() functions are used which (both) read back the content
>> of the REG_SE register before calling am335x_tsc_se_update().
> 
> Not sure I get this point.

The point is that reg_se_cache is (under the lock) set to the value
read from the HW, ORed by the value which is passed as an argument and
then written back to HW. This makes the reg_se_cache in the struct
pointless and a local variable would do the same job.

> 
>> That makes me think that we might cut of one part by accident. On the
>> other hand Zubair said that he tested using ADC & TSC at the same time
>> and it worked. So I have to double check if the HW really resets the
>> content back to zero or not; maybe there is another explanation :)
>>
>> One thing that is an issue is that now the _set() function is using the
>> lock without disabling interrupts and is called from non-IRQ
>> (tiadc_read_raw()) and IRQ (titsc_irq()) context which might lead to
>> deadlock. I'm going to send a patch for this.
> 
> I see the patch, but let's sort this out first, before I apply it.

Please apply the patch to fix the possible deadlock situation which we
will have in the next merge window. I didn't revert or made any other
changes just have this sorted out in time while the deadlock is gone.

Sebastian
