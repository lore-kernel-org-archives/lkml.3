Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3BFQ6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:58:33 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49809 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3BFQ6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:58:30 -0500
Message-ID: <51128B7D.4050703@ti.com>
Date: Wed, 6 Feb 2013 18:57:33 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [RFC PATCH] Input: gpio_keys: Fix suspend/resume press event
 lost
References: <1358774114-8281-1-git-send-email-ivan.khoronzhuk@ti.com> <20130121235718.GB16638@core.coreip.homeip.net> <20130122162434.5bcf3e14@notabene.brown> <5106A39A.5010402@ti.com> <20130129055122.2dcb9dd9@notabene.brown> <510A70D7.8060109@ti.com> <20130205094033.7ab830fb@notabene.brown>
In-Reply-To: <20130205094033.7ab830fb@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.128]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 12:40 AM, NeilBrown wrote:
> On Thu, 31 Jan 2013 15:25:43 +0200 "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
> wrote:
>
>> On 01/28/2013 08:51 PM, NeilBrown wrote:
>>> On Mon, 28 Jan 2013 18:13:14 +0200 "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
>>> wrote:
>>>
>>>> On 01/22/2013 07:24 AM, NeilBrown wrote:
>>>>> On Mon, 21 Jan 2013 15:57:18 -0800 Dmitry Torokhov
>>>>> <dmitry.torokhov@gmail.com> wrote:
>>>>>
>>>>>> Hi Ivan,
>>>>>>
>>>>>> On Mon, Jan 21, 2013 at 03:15:14PM +0200, Ivan Khoronzhuk wrote:
>>>>>>> Rebased on linux_omap/master.
>>>>>>>
>>>>>>> During suspend/resume the key press can be lost if time of resume
>>>>>>> sequence is significant.
>>>>>>>
>>>>>>> If press event cannot be remembered then the driver can read the
>>>>>>> current button state only in time of interrupt handling. But in some
>>>>>>> cases when time between IRQ and IRQ handler is significant we can
>>>>>>> read incorrect state. As a particular case, when device is in suspend
>>>>>>> we press wakupable key and up it back in a jiffy, the interrupt
>>>>>>> handler read the state of up but the interrupt source is press indeed.
>>>>>>> As a result, in a OS like android, we resume then suspend right away
>>>>>>> because the key state is not changed.
>>>>>>>
>>>>>>> This patch add to gpio_keys framework opportunity to recover lost of
>>>>>>> press key event at resuming. The variable "key_pressed" from
>>>>>>> gpio_button_data structure is not used for gpio keys, it is only used
>>>>>>> for gpio irq keys, so it is logically used to remember press lost
>>>>>>> while resuming.
>>>>>> The same could happen if you delay processing of interrupt long enough
>>>>>> during normal operation. If key is released by the time you get around
>>>>>> to reading it you will not see a key press.
>>>>>>
>>>>>> To me this sounds like you need to speed up your resume process so that
>>>>>> you can start serving interrupts quicker.
>>>>>>
>>>>> Agreed.  When I was looking at this I found that any genuine button press
>>>>> would have at least 70msec between press and release, while the device could
>>>>> wake up to the point of being able to handle interrupts in about 14msec.
>>>>> That is enough of a gap to make it pointless to try to 'fix' the code.
>>>>>
>>>>> With enough verbose debugging enabled that 14msec can easily grow to
>>>>> hundreds, but then if  you have debugging enabled to can discipline yourself
>>>>> to hold the button for longer.
>>>>>
>>>>> Ivan: What sort of delay are you seeing between the button press and the
>>>>> interrupt routine running?  And can you measure how long the button is
>>>>> typically down for?
>>>>>
>>>>> NeilBrown
>>>> In my case I have the delay between the button press and the ISR
>>>> about 145ms. If the button down for 120ms the IRQ press event is
>>>> lost and if 160ms event is captured. I cannot speed up resume
>>>> process enough to guarantee correct work, so I wrote this fix.
>>>>
>>> 145ms does sound like a long time.
>>> You should be able to get precise timings by putting a printk in various
>>> parts of the code and ensuring the kernel logs are getting precise timestamps.
>>>
>>> Then you could see if the delay is between resume starting and the ISR
>>> running, or between the ISR and the gpio_work_func getting scheduled.
>>>
>>> I assume that you don't have ->debounce_interval set....
>>>
>>> If the ISR is running soon enough, it might be possible to read the GPIO from
>>> the ISR - I think that would be a cleaner solution.
>>>
>>> If not, then you will need something that interpolates an extra key press.
>>> In that case I would suggest my original patch - it seems simpler than yours
>>> and doesn't make a special case out of suspend.  As Dmitry said, any delay
>>> could cause a problem.
>>> My patch simply ensures that there is at least one button event for each
>>> interrupt by generating an extra event for the inverse of the current button
>>> position.  If that state had already been noticed, the input subsystem will
>>> filter the extra event out so it won't be visible elsewhere.
>>>
>>> For reference, my original patch is below.
>>>
>>> NeilBrown
>>>
>>> [PATCH] Input: gpio_keys - ensure we don't miss key-presses during resume.
>>>
>>> If the latency of resume means we don't poll the key status until
>>> after it has been released, we can lose the keypress which woke the
>>> device.
>>>
>>> So on each interrupt, record that a press is pending, and in that
>>> case, report both the up and down event, ordered such that the second
>>> event is that one that reflects the current state.
>>>
>>> One event will normally be swallowed by the input layer if there was
>>> no change, but the result will be that every interrupt will produce at
>>> least one event.
>>>
>>> Signed-off-by: NeilBrown <neilb@suse.de>
>>>
>>> diff --git a/drivers/input/keyboard/gpio_keys.c
>>> b/drivers/input/keyboard/gpio_keys.c index 62bfce4..961e5e1 100644
>>> --- a/drivers/input/keyboard/gpio_keys.c
>>> +++ b/drivers/input/keyboard/gpio_keys.c
>>> @@ -40,6 +40,7 @@ struct gpio_button_data {
>>>    	spinlock_t lock;
>>>    	bool disabled;
>>>    	bool key_pressed;
>>> +	bool pending;
>>>    };
>>>    
>>>    struct gpio_keys_drvdata {
>>> @@ -335,6 +336,14 @@ static void gpio_keys_gpio_report_event(struct gpio_button_data *bdata) if (state)
>>>    			input_event(input, type, button->code, button->value); } else {
>>> +		if (type == EV_KEY && bdata->pending) {
>>> +			/* Before reporting the observed state, report the
>>> +			 * alternate to be sure that a change is seen.
>>> +			 */
>>> +			bdata->pending = 0;
>>> +			input_event(input, type, button->code, !state);
>>> +			input_sync(input);
>>> +		}
>>>    		input_event(input, type, button->code, !!state);
>>>    	}Yes it si
>>>    	input_sync(input);
>>> @@ -361,6 +370,7 @@ static irqreturn_t gpio_keys_gpio_isr(int irq, void *dev_id)
>>>    	BUG_ON(irq != bdata->irq);
>>>    
>>> +	bdata->pending = true;
>>>    	if (bdata->timer_debounce)
>>>    		mod_timer(&bdata->timer,
>>>    			jiffies + msecs_to_jiffies(bdata->timer_debounce));
>> The delay is between resume starting and the ISR running,
>> It is measured with oscilloscope between signal on button pin and
>> before irq enabling. And I doubly checked it by printk() right in
>> the ISR. So I cannot read the button state right in the ISR.
> Wow.  That is a big delay then.
>
>> Your patch is simpler but it doesn't take into account one situation.
>> It is unlikely but what if the event is lost at 16:00 and reproduced
>> at 17:30, in some cases it is better to lose the event than recover it
>> out of time.
> Is that at all a realistic scenario?  Interrupts disabled for 90 minutes!  If
> that happened you would have more to worry about than one stray button press
> (which is still a valid button press, but is a bit late).
>
> I think you are over-complicating things.  Just keep it simple:  Generate at
> least one button event on every interrupt.
>
> NeilBrown
You are right I over-complicated a little. But this is slightly not
I mean. The interrupts are enabled always, we don't suspend, we just
lost interrupt completely for some reason (for instance, up event).
And then we press key later on, as an example in 1 hour. In that
case we reproduce the lost (up) event in 1 hour that is not needed any
more.

Any way the problem is more in resume latency than in gpio-keys.
When latency is normal the situation is very rarely and is not so
major.

In my case it is enough to use your patch.

Thanks for your comments and the interesting approach.

-- 
Regards,
Ivan Khoronzhuk

