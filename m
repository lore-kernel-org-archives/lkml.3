Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab3FYNrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:47:12 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:50693 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326Ab3FYNrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:47:11 -0400
Message-ID: <51C99E33.4070009@st.com>
Date: Tue, 25 Jun 2013 14:42:11 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stuart Menefy <stuart.menefy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v6] clocksource:arm_global_timer: Add ARM global timer
 support.
References: <1372152678-29530-1-git-send-email-srinivas.kandagatla@st.com> <alpine.DEB.2.02.1306251459160.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306251459160.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the comments.
On 25/06/13 14:17, Thomas Gleixner wrote:
> On Tue, 25 Jun 2013, Srinivas KANDAGATLA wrote:
>> If its not too late can this patch be considered for 3.11 via clocksource tree?
> 
> Sure. No worry, though I noticed a little detail when reading through it
> again. See below.
> 
>> +/**
>> + * To ensure that updates to comparator value register do not set the
>> + * Interrupt Status Register proceed as follows:
>> + * 1. Clear the Comp Enable bit in the Timer Control Register.
>> + * 2. Write the lower 32-bit Comparator Value Register.
>> + * 3. Write the upper 32-bit Comparator Value Register.
>> + * 4. Set the Comp Enable bit and, if necessary, the IRQ enable bit.
>> + */
>> +static void gt_compare_set(unsigned long delta, int periodic)
>> +{
>> +	u64 counter = gt_counter_read();
>> +	unsigned long ctrl = readl(gt_base + GT_CONTROL);
> 
> Why are you reading the control register back over and over? All you
> need to preserve is the GT_CONTROL_TIMER_ENABLE bit. So you can spare
> that read out and just do
> 
> 	ctrl = GT_CONTROL_TIMER_ENABLE;
> 	writel(ctrl, gt_base + GT_CONTROL);

Logically you are right we could do as you suggested, However its not
implicit that which bits are going to be cleared. Its more to do with
readability of the code.
If you still insist I can change it.

> 
>> +static irqreturn_t gt_clockevent_interrupt(int irq, void *dev_id)
>> +{
>> +	struct clock_event_device *evt = dev_id;
>> +
>> +	if (readl_relaxed(gt_base + GT_INT_STATUS) &
>> +				GT_INT_STATUS_EVENT_FLAG) {
> 
> If you negate the check and return IRQ_NONE, you save one indent level
> for the real code.
> 
Am ok either way, I will do it in the next version.
>> +		/**
>> +		 * ERRATA 740657( Global Timer can send 2 interrupts for
>> +		 * the same event in single-shot mode)
>> +		 * Workaround:
>> +		 *	Either disable single-shot mode.
>> +		 *	Or
>> +		 *	Modify the Interrupt Handler to avoid the
>> +		 *	offending sequence. This is achieved by clearing
>> +		 *	the Global Timer flag _after_ having incremented
>> +		 *	the Comparator register	value to a higher value.
>> +		 */
>> +		if (!(readl_relaxed(gt_base + GT_CONTROL) &
>> +						GT_CONTROL_AUTO_INC))
> 
> Again, no need to read from the hardware.
> 
>        if (evt->mode == CLOCK_EVT_MODE_ONESHOT)
Yes, we can get it from evt->mode. I will do it in next version.

> 
> tells you what you need to know.
> 
> Thanks,
> 
> 	tglx
> 
> 

