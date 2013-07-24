Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3GXLz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 07:55:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42011 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3GXLz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 07:55:57 -0400
Message-ID: <51EFC072.9070702@ti.com>
Date: Wed, 24 Jul 2013 14:54:26 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Kevin Hilman <khilman@linaro.org>,
        Graeme Gregory <gg@slimlogic.co.uk>, <linux-omap@vger.kernel.org>,
        Ruslan Bilovol <ruslan.bilovol@ti.com>, <linux-kernel@vger.kernel.org>,
        Naga Venkata Srikanth V <vnv.srikanth@samsung.com>,
        Oleg_Kosheliev <oleg.kosheliev@ti.com>
Subject: Re: [PATCH 1/4] mfd: twl6030-irq: migrate to IRQ threaded handler
References: <1374595624-15054-1-git-send-email-grygorii.strashko@ti.com> <1374595624-15054-2-git-send-email-grygorii.strashko@ti.com> <20130724104945.GH26801@laptop>
In-Reply-To: <20130724104945.GH26801@laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 01:49 PM, Lee Jones wrote:
> On Tue, 23 Jul 2013, Grygorii Strashko wrote:
>
>> From: Naga Venkata Srikanth V <vnv.srikanth@samsung.com>
>>
>> 1) Removed request_irq() and replaced it with request_threaded_irq().
>>
>> 2) Removed generic_handle_irq() and replaced it with
>> handle_nested_irq().
>>    Handling of these interrupts is nested, as we are handling an
>> interrupt (for e.g rtc, mmc1) when we are still servicing TWL irq.
>>
>> 3) Removed I2C read-retry logic for the case when twl_i2c_read() is
>> failed inside IRQ handler - there is no sense to do that, so just report
>> an error and return.
>>
>> Signed-off-by: Naga Venkata Srikanth V <vnv.srikanth@samsung.com>
>> Signed-off-by: Oleg_Kosheliev <oleg.kosheliev@ti.com>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   drivers/mfd/twl6030-irq.c |  146 +++++++++++++++------------------------------
>>   1 file changed, 49 insertions(+), 97 deletions(-)
>
> Besides the points I mention below I like the way this patch is
> going.
>
>> diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
>> index 277a8db..b6030d9 100644
>> --- a/drivers/mfd/twl6030-irq.c
>> +++ b/drivers/mfd/twl6030-irq.c
>> @@ -90,7 +90,6 @@ static unsigned twl6030_irq_base;
>>   static int twl_irq;
>>   static bool twl_irq_wake_enabled;
>>
>> -static struct completion irq_event;
>>   static atomic_t twl6030_wakeirqs = ATOMIC_INIT(0);
>>
>>   static int twl6030_irq_pm_notifier(struct notifier_block *notifier,
>> @@ -131,95 +130,57 @@ static struct notifier_block twl6030_irq_pm_notifier_block = {
>>   };
>>
>>   /*
>> - * This thread processes interrupts reported by the Primary Interrupt Handler.
>> - */
>> -static int twl6030_irq_thread(void *data)
>> +* Threaded irq handler for the twl6030 interrupt.
>> +* We query the interrupt controller in the twl6030 to determine
>> +* which module is generating the interrupt request and call
>> +* handle_nested_irq for that module.
>> +*/
>> +static irqreturn_t twl6030_irq_thread(int irq, void *data)
>>   {
>> -	long irq = (long)data;
>> -	static unsigned i2c_errors;
>> -	static const unsigned max_i2c_errors = 100;
>> -	int ret;
>> -
>> -	while (!kthread_should_stop()) {
>> -		int i;
>> -		union {
>> +	int i, ret;
>> +	union {
>>   		u8 bytes[4];
>>   		u32 int_sts;
>> -		} sts;
>> -
>> -		/* Wait for IRQ, then read PIH irq status (also blocking) */
>> -		wait_for_completion_interruptible(&irq_event);
>> -
>> -		/* read INT_STS_A, B and C in one shot using a burst read */
>> -		ret = twl_i2c_read(TWL_MODULE_PIH, sts.bytes,
>> -				REG_INT_STS_A, 3);
>> -		if (ret) {
>> -			pr_warning("twl6030: I2C error %d reading PIH ISR\n",
>> -					ret);
>> -			if (++i2c_errors >= max_i2c_errors) {
>> -				printk(KERN_ERR "Maximum I2C error count"
>> -						" exceeded.  Terminating %s.\n",
>> -						__func__);
>> -				break;
>> -			}
>> -			complete(&irq_event);
>> -			continue;
>> -		}
>> -
>> +	} sts;
>>
>> +	/* read INT_STS_A, B and C in one shot using a burst read */
>> +	ret = twl_i2c_read(TWL_MODULE_PIH, sts.bytes, REG_INT_STS_A, 3);

sts.int_sts - is filled here

>> +	if (ret) {
>> +		pr_warn("%s: I2C error %d reading PIH ISR\n", __func__, ret);
>
> Does the user really care which function we're returning from.
>
> Would it be better if you replace '__func__' with the device name?

This module hasn't been converted to the device yet:(
(I mean "interrupt-controller").
But I'm thinking about it as the next step :) and then It will be 
absolutely reasonable change to replace pr_*() with dev_*() and remove 
__func__.

Now, the pointer on "dev" (in our case "twl-core" device) isn't passed
in IRQ handler, so It can't be used here.

Of course it can be done, but would it make code better?
My opinion - no.

>
>> +		return IRQ_HANDLED;
>> +	}
>>
>> -		sts.bytes[3] = 0; /* Only 24 bits are valid*/
>> +	sts.bytes[3] = 0; /* Only 24 bits are valid*/
>>
>> -		/*
>> -		 * Since VBUS status bit is not reliable for VBUS disconnect
>> -		 * use CHARGER VBUS detection status bit instead.
>> -		 */
>> -		if (sts.bytes[2] & 0x10)
>> -			sts.bytes[2] |= 0x08;
>> +	/*
>> +	 * Since VBUS status bit is not reliable for VBUS disconnect
>> +	 * use CHARGER VBUS detection status bit instead.
>> +	 */
>> +	if (sts.bytes[2] & 0x10)
>> +		sts.bytes[2] |= 0x08;
>>
>> -		for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++) {
>> -			local_irq_disable();
>> -			if (sts.int_sts & 0x1) {
>> -				int module_irq = twl6030_irq_base +
>> +	for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++)
>> +		if (sts.int_sts & 0x1) {
>
> I'm a little confused by this. Where does sts.int_sts come from?

See my comment above, pls

>
>> +			int module_irq = twl6030_irq_base +
>>   					twl6030_interrupt_mapping[i];
>> -				generic_handle_irq(module_irq);
>> -
>> -			}
>> -		local_irq_enable();
>> +			handle_nested_irq(module_irq);
>> +			pr_debug("%s: PIH ISR %u, virq%u\n",
>> +				 __func__, i, module_irq);
>>   		}
>>
>> -		/*
>> -		 * NOTE:
>> -		 * Simulation confirms that documentation is wrong w.r.t the
>> -		 * interrupt status clear operation. A single *byte* write to
>> -		 * any one of STS_A to STS_C register results in all three
>> -		 * STS registers being reset. Since it does not matter which
>> -		 * value is written, all three registers are cleared on a
>> -		 * single byte write, so we just use 0x0 to clear.
>> -		 */
>> -		ret = twl_i2c_write_u8(TWL_MODULE_PIH, 0x00, REG_INT_STS_A);
>> -		if (ret)
>> -			pr_warning("twl6030: I2C error in clearing PIH ISR\n");
>> -
>> -		enable_irq(irq);
>> -	}
>> -
>> -	return 0;
>> -}
>> +	/*
>> +	 * NOTE:
>> +	 * Simulation confirms that documentation is wrong w.r.t the
>> +	 * interrupt status clear operation. A single *byte* write to
>> +	 * any one of STS_A to STS_C register results in all three
>> +	 * STS registers being reset. Since it does not matter which
>> +	 * value is written, all three registers are cleared on a
>> +	 * single byte write, so we just use 0x0 to clear.
>> +	 */
>> +	ret = twl_i2c_write_u8(TWL_MODULE_PIH, 0x00, REG_INT_STS_A);
>> +	if (ret)
>> +		pr_warn("twl6030: I2C error in clearing PIH ISR\n");
>>
>> -/*
>> - * handle_twl6030_int() is the desc->handle method for the twl6030 interrupt.
>> - * This is a chained interrupt, so there is no desc->action method for it.
>> - * Now we need to query the interrupt controller in the twl6030 to determine
>> - * which module is generating the interrupt request.  However, we can't do i2c
>> - * transactions in interrupt context, so we must defer that work to a kernel
>> - * thread.  All we do here is acknowledge and mask the interrupt and wakeup
>> - * the kernel thread.
>> - */
>> -static irqreturn_t handle_twl6030_pih(int irq, void *devid)
>> -{
>> -	disable_irq_nosync(irq);
>> -	complete(devid);
>>   	return IRQ_HANDLED;
>>   }
>>
>> @@ -351,7 +312,6 @@ int twl6030_init_irq(struct device *dev, int irq_num)
>>   {
>>   	struct			device_node *node = dev->of_node;
>>   	int			nr_irqs, irq_base, irq_end;
>> -	struct task_struct	*task;
>>   	static struct irq_chip  twl6030_irq_chip;
>>   	int			status = 0;
>>   	int			i;
>> @@ -396,36 +356,25 @@ int twl6030_init_irq(struct device *dev, int irq_num)
>>   		irq_set_chip_and_handler(i, &twl6030_irq_chip,
>>   					 handle_simple_irq);
>>   		irq_set_chip_data(i, (void *)irq_num);
>> +		irq_set_nested_thread(i, true);
>>   		activate_irq(i);
>>   	}
>>
>> -	dev_info(dev, "PIH (irq %d) chaining IRQs %d..%d\n",
>> -			irq_num, irq_base, irq_end);
>> +	dev_info(dev, "PIH (irq %d) nested IRQs %d..%d\n",
>> +		 irq_num, irq_base, irq_end);
>>
>>   	/* install an irq handler to demultiplex the TWL6030 interrupt */
>> -	init_completion(&irq_event);
>> -
>> -	status = request_irq(irq_num, handle_twl6030_pih, 0, "TWL6030-PIH",
>> -			     &irq_event);
>> +	status = request_threaded_irq(irq_num, NULL, twl6030_irq_thread,
>> +				      IRQF_ONESHOT, "TWL6030-PIH", NULL);
>>   	if (status < 0) {
>>   		dev_err(dev, "could not claim irq %d: %d\n", irq_num, status);
>>   		goto fail_irq;
>>   	}
>>
>> -	task = kthread_run(twl6030_irq_thread, (void *)irq_num, "twl6030-irq");
>> -	if (IS_ERR(task)) {
>> -		dev_err(dev, "could not create irq %d thread!\n", irq_num);
>> -		status = PTR_ERR(task);
>> -		goto fail_kthread;
>> -	}
>> -
>>   	twl_irq = irq_num;
>>   	register_pm_notifier(&twl6030_irq_pm_notifier_block);
>>   	return irq_base;
>>
>> -fail_kthread:
>> -	free_irq(irq_num, &irq_event);
>> -
>>   fail_irq:
>>   	for (i = irq_base; i < irq_end; i++)
>>   		irq_set_chip_and_handler(i, NULL, NULL);
>> @@ -437,10 +386,13 @@ int twl6030_exit_irq(void)
>>   {
>>   	unregister_pm_notifier(&twl6030_irq_pm_notifier_block);
>>
>> -	if (twl6030_irq_base) {
>> +	if (!twl6030_irq_base) {
>>   		pr_err("twl6030: can't yet clean up IRQs?\n");
>>   		return -ENOSYS;
>>   	}
>> +
>> +	free_irq(twl_irq, NULL);
>> +
>
> If request_threaded_irq() fails, isn't there a chance that
> twl6030_irq_base will be allocated, but twl_irq will still be
> undefined?

Yes. A mess is here (historically:), thanks. Will use twl_irq instead of 
twl6030_irq_base (I did it, actually, in patch [3]:).

>
>>   	return 0;
>>   }
>>
>

Thanks for review.

Regards,
- grygorii
