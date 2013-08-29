Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3H2OL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:11:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58811 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab3H2OL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:11:26 -0400
Message-ID: <521F5684.3090703@ti.com>
Date: Thu, 29 Aug 2013 19:41:16 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Nikolay Balandin <n.a.balandin@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] gpio: pcf857x: cleanup irq_demux_work and use threaded
 irq
References: <1377599455-9379-1-git-send-email-george.cherian@ti.com> <CACRpkdbME_M8_X=5OttSFKDknqVEKSZc+7u=VLM-T-g3c_uv6Q@mail.gmail.com>
In-Reply-To: <CACRpkdbME_M8_X=5OttSFKDknqVEKSZc+7u=VLM-T-g3c_uv6Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Thanks for the review. I will split it and send v2.

On 8/29/2013 6:27 PM, Linus Walleij wrote:
> On Tue, Aug 27, 2013 at 12:30 PM, George Cherian <george.cherian@ti.com> wrote:
>
>> This patch
>>          - removes the irq_demux_work
>>          - Uses devm_request_threaded_irq
>>          - Call the user handler iff gpio_to_irq is done.
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
> Can you please split this up? It seems like three different patches,
> and now they block each other. The threading patch is fine and
> I could apply it unless this was mixed up with other stuff.
>
> I'd like Kuninoro and/or Nikolay to have a look at this, so please
> CC them on subsequent iterations.
okay
> NB: I really like that you move the irq handling to a thread, good
> job.
>
>>   static const struct i2c_device_id pcf857x_id[] = {
>> @@ -89,12 +89,12 @@ struct pcf857x {
>>          struct gpio_chip        chip;
>>          struct i2c_client       *client;
>>          struct mutex            lock;           /* protect 'out' */
>> -       struct work_struct      work;           /* irq demux work */
>>          struct irq_domain       *irq_domain;    /* for irq demux  */
>>          spinlock_t              slock;          /* protect irq demux */
>>          unsigned                out;            /* software latch */
>>          unsigned                status;         /* current status */
>>          int                     irq;            /* real irq number */
>> +       int                     irq_mapped;     /* mapped gpio irqs  */
> This seems like an u32 or atleast unsigned, and state that its one
> bit flag per IRQ. How many GPIO lines are there?
pcf857x driver supports expanders with 8 and 16 gpio lines.
>> -static void pcf857x_irq_demux_work(struct work_struct *work)
>> +static irqreturn_t pcf857x_irq(int irq, void *data)
>>   {
>> -       struct pcf857x *gpio = container_of(work,
>> -                                              struct pcf857x,
>> -                                              work);
>> +       struct pcf857x  *gpio = data;
>>          unsigned long change, i, status, flags;
>>
>>          status = gpio->read(gpio->client);
>>
>>          spin_lock_irqsave(&gpio->slock, flags);
>> +
>> +       /*
>> +        * call the interrupt handler iff gpio is used as
>> +        * interrupt source, just to avoid bad irqs
>> +        */
>>
>> -       change = gpio->status ^ status;
>> +       change = ((gpio->status ^ status) & gpio->irq_mapped);
> I don't know if that is right.
>
> If this happens you are getting what we call a "spurious IRQ"
> and this shall be reported to the IRQ core by returning
> IRQ_NONE and handled from there.
While testing I got prints like bad irq and no handler installed.
Now I notice its mostly when the n_latch is not passed properly.
>
>> @@ -226,9 +223,13 @@ static irqreturn_t pcf857x_irq_demux(int irq, void *data)
>>   static int pcf857x_irq_domain_map(struct irq_domain *domain, unsigned int virq,
>>                                   irq_hw_number_t hw)
>>   {
>> +       struct pcf857x  *gpio = domain->host_data;
>>          irq_set_chip_and_handler(virq,
>>                                   &dummy_irq_chip,
>>                                   handle_level_irq);
>> +       set_irq_flags(virq, IRQF_VALID);
>> +       gpio->irq_mapped |= (1 << hw);
> I'm a bit uneasy about this. It feels like its the irqdomain's
> responsibility to keep track of whether an IRQ is mapped
> or not.
Mainly these expanders dont have an ier sort of registers and if at all 
the initial value is not set proper
then it gives bad irq prints only once per changed bit for which there 
is no handler.
Should I drop this in v2?

>
> Maybe Grant should have a look at this.
>
> Yours,
> Linus Walleij


-- 
-George

