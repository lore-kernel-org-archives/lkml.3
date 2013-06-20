Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267Ab3FTKsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:48:25 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:37151
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754713Ab3FTKsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:48:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Message-ID: <51C2DDDE.2080402@freescale.com>
Date: Thu, 20 Jun 2013 16:17:58 +0530
From: pankaj chauhan <pankaj.chauhan@freescale.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Goyal Akhil-B35197 <B35197@freescale.com>, Arnd Bergmann <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chauhan Pankaj-B32944 <B32944@freescale.com>
Subject: Re: [PATCH 1/5] drivers/misc: Support for RF interface device framework
References: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com> <1371456566-4934-2-git-send-email-akhil.goyal@freescale.com> <201306172328.26430.arnd@arndb.de> <51C00FC0.90105@freescale.com> <51C19682.2070304@metafoo.de>
In-Reply-To: <51C19682.2070304@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/2013 5:01 PM, Lars-Peter Clausen wrote:
> On 06/18/2013 09:44 AM, Akhil Goyal wrote:
> [...]
>>>> +    /*
>>>> +     * Spin_locks are changed to mutexes if PREEMPT_RT is enabled,
>>>> +     * i.e they can sleep. This fact is problem for us because
>>>> +     * add_wait_queue()/wake_up_all() takes wait queue spin lock.
>>>> +     * Since spin lock can sleep with PREEMPT_RT, wake_up_all() can not be
>>>> +     * called from rf_notify_dl_tti (which is called in interrupt context).
>>>> +     * As a workaround, wait_q_lock is used for protecting the wait_q and
>>>> +     * add_wait_queue_locked()/ wake_up_locked() functions of wait queues
>>>> +     * are used.
>>>> +     */
>>>> +    raw_spin_lock_irqsave(&rf_dev->wait_q_lock, flags);
>>>> +    __add_wait_queue_tail_exclusive(&rf_dev->wait_q,&wait);
>>>> +    raw_spin_unlock_irqrestore(&rf_dev->wait_q_lock, flags);
>>>> +    set_current_state(TASK_INTERRUPTIBLE);
>>>> +    /*Now wait here, tti notificaion will wake us up*/
>>>> +    schedule();
>>>> +    set_current_state(TASK_RUNNING);
>>>> +    raw_spin_lock_irqsave(&rf_dev->wait_q_lock, flags);
>>>> +    __remove_wait_queue(&rf_dev->wait_q,&wait);
>>>> +    raw_spin_unlock_irqrestore(&rf_dev->wait_q_lock, flags);
>>>
>>> This is not a proper method of waiting for an event. Why can't you
>>> use wait_event() here?
>> wait_event() is internally calling spin_lock_irqsave() and this function
>> will be called in hard IRQ context with PREEMPT_RT enabled(IRQF_NODELAY
>> set). So wait_event cannot be used.
>> This problem can be solved if we can get the following patch applied on the
>> tree.
>> https://patchwork.kernel.org/patch/2161261/
>>
>>>
>>> The explanation about the interrupt handler seems incorrect, since PREEMPT_RT
>>> also turns interrupt handlers into threads.
>> The interrupt handler has real time requirement and thus running in HARDIRQ
>> context with flag IRQF_NODELAY. We get this interrupt in every millisecond.
>
> But if you are running in HARDIRQ context the whole sequence doesn't make
> much sense at all, since you won't be able to sleep and wait for the event.
>

This function for adding process to rf_dev->wait_q runs in process 
context, but the function (dl_notify_tti())which wakes process up from 
this queue runs in HARDIRQ context, that's why we could not use 
wait_event() or spin_lock() here.

thanks,
pankaj



