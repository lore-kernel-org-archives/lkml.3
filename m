Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934499Ab3FSLbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:31:11 -0400
Received: from smtp-out-221.synserver.de ([212.40.185.221]:1069 "EHLO
	smtp-out-221.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934175Ab3FSLbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:31:07 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29272
Message-ID: <51C19682.2070304@metafoo.de>
Date: Wed, 19 Jun 2013 13:31:14 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Akhil Goyal <akhil.goyal@freescale.com>
CC: Arnd Bergmann <arnd@arndb.de>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, pankaj.chauhan@freescale.com
Subject: Re: [PATCH 1/5] drivers/misc: Support for RF interface device framework
References: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com> <1371456566-4934-2-git-send-email-akhil.goyal@freescale.com> <201306172328.26430.arnd@arndb.de> <51C00FC0.90105@freescale.com>
In-Reply-To: <51C00FC0.90105@freescale.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 09:44 AM, Akhil Goyal wrote:
[...]
>>> +    /*
>>> +     * Spin_locks are changed to mutexes if PREEMPT_RT is enabled,
>>> +     * i.e they can sleep. This fact is problem for us because
>>> +     * add_wait_queue()/wake_up_all() takes wait queue spin lock.
>>> +     * Since spin lock can sleep with PREEMPT_RT, wake_up_all() can not be
>>> +     * called from rf_notify_dl_tti (which is called in interrupt context).
>>> +     * As a workaround, wait_q_lock is used for protecting the wait_q and
>>> +     * add_wait_queue_locked()/ wake_up_locked() functions of wait queues
>>> +     * are used.
>>> +     */
>>> +    raw_spin_lock_irqsave(&rf_dev->wait_q_lock, flags);
>>> +    __add_wait_queue_tail_exclusive(&rf_dev->wait_q,&wait);
>>> +    raw_spin_unlock_irqrestore(&rf_dev->wait_q_lock, flags);
>>> +    set_current_state(TASK_INTERRUPTIBLE);
>>> +    /*Now wait here, tti notificaion will wake us up*/
>>> +    schedule();
>>> +    set_current_state(TASK_RUNNING);
>>> +    raw_spin_lock_irqsave(&rf_dev->wait_q_lock, flags);
>>> +    __remove_wait_queue(&rf_dev->wait_q,&wait);
>>> +    raw_spin_unlock_irqrestore(&rf_dev->wait_q_lock, flags);
>>
>> This is not a proper method of waiting for an event. Why can't you
>> use wait_event() here?
> wait_event() is internally calling spin_lock_irqsave() and this function
> will be called in hard IRQ context with PREEMPT_RT enabled(IRQF_NODELAY
> set). So wait_event cannot be used.
> This problem can be solved if we can get the following patch applied on the
> tree.
> https://patchwork.kernel.org/patch/2161261/
> 
>>
>> The explanation about the interrupt handler seems incorrect, since PREEMPT_RT
>> also turns interrupt handlers into threads.
> The interrupt handler has real time requirement and thus running in HARDIRQ
> context with flag IRQF_NODELAY. We get this interrupt in every millisecond.

But if you are running in HARDIRQ context the whole sequence doesn't make
much sense at all, since you won't be able to sleep and wait for the event.

- Lars
