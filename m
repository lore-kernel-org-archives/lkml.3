Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab3CTQfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:35:40 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51058 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3CTQfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:35:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAEtk5gfd1CpPdaF4ufjzZzR2pZYKb9cvKUwsH15XUGcNCP+WFA@mail.gmail.com>
References: <CAEtk5gfd1CpPdaF4ufjzZzR2pZYKb9cvKUwsH15XUGcNCP+WFA@mail.gmail.com>
Date: Wed, 20 Mar 2013 22:05:37 +0530
Message-ID: <CAK7N6vputifZZEi92vayoq5JVoO8hZSKMp8vOzWCLcxdeCw+TQ@mail.gmail.com>
Subject: Re: Question pertaining to request_threaded_irq
From: anish singh <anish198519851985@gmail.com>
To: Vijay Dixit <thelonejoker@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vijay,

Below I will try my best to answer.

On Wed, Mar 20, 2013 at 8:23 PM, Vijay Dixit <thelonejoker@gmail.com> wrote:
>  Hello,
>
> I am new to the Kernel-Mailing list. I am not subscribed at the moment
> and would really appreciate it, if I can be CC'd for all the
> reply/responses for my question.
>
>
> I have searched all over the web but haven't found a convincing answer
> to a couple of related questions I have, with regard to the
> "request_threaded_irq" feature.
>
> QUESTION-1
> ****************
> Firstly, I was reading this article, regarding threaded IRQ's:
>
> http://lwn.net/Articles/302043/
>
> and there is this one line that isn't clear to me:
>
> "Converting an interrupt to threaded makes only sense when the handler
> code takes advantage of it by integrating tasklet/softirq
> functionality and simplifying the locking."
>
> I understand had we gone ahead with a "traditional", top half/bottom
> half approach, we would have needed either spin-locks or disable local
> IRQ to meddle with shared data. But, what I don't understand is, how
> would threaded interrupts simplify the need for locking by integrating
> tasklet/softirq functionality.
Some expert can help here.....
>
>
> QUESTION-2
> ****************
> Secondly, what advantage (if any), does a request_threaded_handler
> approach have over a work_queue based bottom half approach ? In both
> cases it seems, as though the "work" is deferred to a dedicated
> thread. So, what is the difference ?
In request_threaded_irq we have top half and bottom half.
a. If bottom half dies then your irq will not be re-triggered.This will
save you from a lot of problems.
b. There is one more advantage but I am not clear about it so I will leave
for some expert to answer that.
"*   @thread_fn. This split handler design is necessary to support
 *    shared interrupts."
kernel/irq/manage.c line no 1379 & 1380
>
>
> QUESTION-3
> ****************
> Lastly, in the following prototype:
>
> int request_threaded_irq(unsigned int irq, irq_handler_t handler,
> irq_handler_t thread_fn, unsigned long irqflags, const char *devname,
> void *dev_id)
>
> Is it possible that the "handler" part of the IRQ is continuously
> triggered by the relevant IRQ (say a UART receving characters at a
> high rate), even while the "thread_fn"(writing rx'd bytes to a
> circular buffer) part of the interrupt handler is busy processing
> IRQ's from previous wakeups ? So, wouldn't the handler be trying to
Yes it can happen but generally we prefer IRQS_ONESHOT along
with default primary handler set as irq_default_primary_handler().
As you would know, setting IRQS_ONESHOT flag means interrupt
is not reenabled after the hardirq handler finished and it is used by
Used by threaded interrupts which need to keep the irq line disabled
until the threaded handler has been run.

static irqreturn_t irq_default_primary_handler(int irq, void *dev_id)
{
       return IRQ_WAKE_THREAD;
}
So the problem described will not happen.There is one more code which
will avoid your said problem.

Whenever interrupt happens this function gets called and in the line
number 68 & 69 you can see that there is a check if the thread is currently
running or not.If running then this function will simply return.
RUNTHREAD bit is set when thread starts executing.

 54 static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 55 {
 56         /*
 57          * In case the thread crashed and was killed we just pretend that
 58          * we handled the interrupt. The hardirq handler has disabled the
 59          * device interrupt, so no irq storm is lurking.
 60          */
 61         if (action->thread->flags & PF_EXITING)
 62                 return;
 63
 64         /*
 65          * Wake up the handler thread for this action. If the
 66          * RUNTHREAD bit is already set, nothing to do.
 67          */
 68         if (test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
 69                 return;

> "wakeup" an already running "thread_fn" ? How would the running irq
> "thread_fn" behave in that case ?
>
> I would really appreciate if someone can help me understand this.
>
> Thanks,
> vj
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
