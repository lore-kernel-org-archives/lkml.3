Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3JROMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:12:46 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:50466 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755388Ab3JROMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:12:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAPrCYkcFBL5Rxf9z9L5PHULk_oSZX9ANBaG8dxyzGD_xhMeGpw@mail.gmail.com>
References: <1382090789-18177-1-git-send-email-vkale@apm.com>
	<20131018103117.GA3296@mudshark.cambridge.arm.com>
	<CAPrCYkcFBL5Rxf9z9L5PHULk_oSZX9ANBaG8dxyzGD_xhMeGpw@mail.gmail.com>
Date: Fri, 18 Oct 2013 19:42:44 +0530
Message-ID: <CAPrCYkcwG62tE6g5p79mYbiCgJoFz_GkqUc0VA97_M1jKwS84g@mail.gmail.com>
Subject: Re: [PATCH] genirq: error reporting for non-percpu interrupt in request_percpu_irq()
From: Vinayak Kale <vkale@apm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 4:33 PM, Vinayak Kale <vkale@apm.com> wrote:
> Hi Will,
>
>
> On Fri, Oct 18, 2013 at 4:01 PM, Will Deacon <will.deacon@arm.com> wrote:
>> On Fri, Oct 18, 2013 at 11:06:29AM +0100, Vinayak Kale wrote:
>>> Return a separate error code when a non-percpu interrupt is passed to
>>> request_percpu_irq().
>>>
>>> Suggested-by: Will Deacon <will.deacon@arm.com>
>>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>>> ---
>>>  kernel/irq/manage.c |    6 ++++--
>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
>>> index 514bcfd..c2713ae 100644
>>> --- a/kernel/irq/manage.c
>>> +++ b/kernel/irq/manage.c
>>> @@ -1671,10 +1671,12 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
>>>               return -EINVAL;
>>>
>>>       desc = irq_to_desc(irq);
>>> -     if (!desc || !irq_settings_can_request(desc) ||
>>> -         !irq_settings_is_per_cpu_devid(desc))
>>> +     if (!desc || !irq_settings_can_request(desc))
>>>               return -EINVAL;
>>>
>>> +     if (!irq_settings_is_per_cpu_devid(desc))
>>> +             return -EPERM;
>>
>> <bikeshedding> I reckon -ENODEV is clearer here. </bikeshedding>
>
> I looked at the issue as "operation not allowed since interrupt is
> non-percpu" and I found below comment for EPERM in
> 'include/uapi/asm-generic/errno-base.h' . So thought this error code
> could be more fitting.
>
> #define EPERM            1      /* Operation not permitted */
>
>>
>> Also, there's a counterpart to this code in request_threaded_irq, where I
>> think we should do something similar.
>
> So in request_threaded_irq, we would still keep the WARN_ON for percpu
> interrupt and return a different error code. Is my understanding
> correct?

Please ignore my this comment.
If we do something similar in request_threaded_irq then we will have
to remove WARN_ON for percpu interrupt.
