Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964870AbaGPObX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:31:23 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:53730 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759416AbaGPObV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:31:21 -0400
Message-ID: <53C68CB5.4020002@mvista.com>
Date: Wed, 16 Jul 2014 09:31:17 -0500
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH RT 0/3] Linux 3.10.47-rt50-rc1
References: <20140714200420.805309842@goodmis.org>	<53C4714C.8000103@mvista.com> <20140714205333.6d28ed1f@gandalf.local.home>
In-Reply-To: <20140714205333.6d28ed1f@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 07:53 PM, Steven Rostedt wrote:
> On Mon, 14 Jul 2014 19:09:48 -0500
> Corey Minyard <cminyard@mvista.com> wrote:
>
>> Can we get:
>>
>> tracing-use-migrate_disable-to-prevent-beeing-pushed.patch
> Sure except that patch is buggy:
>
> -               preempt_disable();
> +               migrate_disable();
>                 /* The update must run on the CPU that is being updated. */
>                 if (cpu_id == smp_processor_id() || !cpu_online(cpu_id))
>                         rb_update_pages(cpu_buffer);
>                 else {
> -                       /*
> -                        * Can not disable preemption for schedule_work_on()
> -                        * on PREEMPT_RT.
> -                        */
> -                       preempt_enable();
>                         schedule_work_on(cpu_id,
>                                          &cpu_buffer->update_pages_work);
>                         wait_for_completion(&cpu_buffer->update_done);
> -                       preempt_disable();
>                 }
> -               preempt_enable();
> +               migrate_enable();
>
> migrate_disable() on non-PREEMPT_RT is preempt_disable(). You can't
> call wait_or_completion with preemption disabled.
>
> When that gets fixed in mainline -rt, I'll add it to the stable
> branches too.

I originally did a patch that just always did the else clause (the
schedule_work_on() and wait_for_completion()) on all CPUs.  That seemed
to work just fine and simplifies the code a bit and gets rid of all the
preempt/migrate calls.  You could try that approach, or I could submit
something if you liked.

-corey

>
> -- Steve
>
>
>
>> into 3.10, also?
>>

