Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab3FSGAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 02:00:44 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:25971
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756445Ab3FSGAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 02:00:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Message-ID: <51C148F5.5050304@freescale.com>
Date: Wed, 19 Jun 2013 11:30:21 +0530
From: Akhil Goyal <akhil.goyal@freescale.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.26) Gecko/20120129 Thunderbird/3.1.18
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <pankaj.chauhan@freescale.com>
Subject: Re: [PATCH 1/5] drivers/misc: Support for RF interface device framework
References: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com> <201306172328.26430.arnd@arndb.de> <51C00FC0.90105@freescale.com> <201306181540.45454.arnd@arndb.de>
In-Reply-To: <201306181540.45454.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/2013 7:10 PM, Arnd Bergmann wrote:
> On Tuesday 18 June 2013, Akhil Goyal wrote:
>> On 6/18/2013 2:58 AM, Arnd Bergmann wrote:
>>>> +	/*
>>>> +	 * Spin_locks are changed to mutexes if PREEMPT_RT is enabled,
>>>> +	 * i.e they can sleep. This fact is problem for us because
>>>> +	 * add_wait_queue()/wake_up_all() takes wait queue spin lock.
>>>> +	 * Since spin lock can sleep with PREEMPT_RT, wake_up_all() can not be
>>>> +	 * called from rf_notify_dl_tti (which is called in interrupt context).
>>>> +	 * As a workaround, wait_q_lock is used for protecting the wait_q and
>>>> +	 * add_wait_queue_locked()/ wake_up_locked() functions of wait queues
>>>> +	 * are used.
>>>> +	 */
>>>> +	raw_spin_lock_irqsave(&rf_dev->wait_q_lock, flags);
>>>> +	__add_wait_queue_tail_exclusive(&rf_dev->wait_q,&wait);
>>>> +	raw_spin_unlock_irqrestore(&rf_dev->wait_q_lock, flags);
>>>> +	set_current_state(TASK_INTERRUPTIBLE);
>>>> +	/*Now wait here, tti notificaion will wake us up*/
>>>> +	schedule();
>>>> +	set_current_state(TASK_RUNNING);
>>>> +	raw_spin_lock_irqsave(&rf_dev->wait_q_lock, flags);
>>>> +	__remove_wait_queue(&rf_dev->wait_q,&wait);
>>>> +	raw_spin_unlock_irqrestore(&rf_dev->wait_q_lock, flags);
>>>
>>> This is not a proper method of waiting for an event. Why can't you
>>> use wait_event() here?
>> wait_event() is internally calling spin_lock_irqsave() and this function
>> will be called in hard IRQ context with PREEMPT_RT enabled(IRQF_NODELAY
>> set). So wait_event cannot be used.
>> This problem can be solved if we can get the following patch applied on
>> the tree.
>> https://patchwork.kernel.org/patch/2161261/
>
> I see. How about using wait_event here then and adding a comment about
> the RT kernel?
We can change it to wait_event but the problem is that, the ISR in 
Antenna Controller driver will always run in HARDIRQ context because of 
its latency requirements. In that case we will always get warning for 
"Trying to sleep in interrupt context".

Since we always require PREEMPT_RT patch while working with Antenna 
Controller Driver and there is no use case for running it in non-RT 
kernel. May be we can add dependency on CONFIG_PREEMPT_RT in the Kconfig 
of this framework/driver.

If the patch "Simple waitqueue implementation" from Steven Rostedt 
<rostedt@goodmis.org> gets mainlined then we can use simple wait queues 
to make a clean up here.
>
>>> The explanation about the interrupt handler seems incorrect, since PREEMPT_RT
>>> also turns interrupt handlers into threads.
>> The interrupt handler has real time requirement and thus running in
>> HARDIRQ context with flag IRQF_NODELAY. We get this interrupt in every
>> millisecond.
>
> Ok. So there would be no problem without the RT patch set.
This driver always require PREEMPT_RT enabled. As mentioned above I can 
add dependency on CONFIG_PREEMPT_RT.
>
> IRQF_NODELAY is specific to the RT kernel, so you can change the wait_event
> function to something else in the same patch that adds this flag.



