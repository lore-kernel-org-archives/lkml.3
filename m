Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3E3Oxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:53:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22721 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab3E3OxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:53:24 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=f73XcKl29joA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=y5CGMQcehd0A:10 a=oCcaPWc0AAAA:8 a=rezNVQXxIapar52AQ-8A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369925602.26799.5.camel@gandalf.local.home>
Subject: Re: [PATCH] RFC: Set irq thread to RT priority on creation
From: Steven Rostedt <rostedt@goodmis.org>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: RT <linux-rt-users@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 30 May 2013 10:53:22 -0400
In-Reply-To: <1369915975-28797-1-git-send-email-meltedpianoman@gmail.com>
References: <1369915975-28797-1-git-send-email-meltedpianoman@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-30 at 14:12 +0200, Ivo Sieben wrote:

>  kernel/irq/manage.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index fa17855..0ffe37b 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -950,6 +950,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  	 */
>  	if (new->thread_fn && !nested) {
>  		struct task_struct *t;
> +		static const struct sched_param param = {
> +			.sched_priority = MAX_USER_RT_PRIO/2,
> +		};
>  
>  		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
>  				   new->name);
> @@ -957,6 +960,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  			ret = PTR_ERR(t);
>  			goto out_mput;
>  		}
> +
> +		sched_setscheduler(t, SCHED_FIFO, &param);
> +

If you are adding this here, might as well remove the
sched_set_scheduler() from irq_thread() as well. No need to do it twice.

-- Steve

>  		/*
>  		 * We keep the reference to the task struct even if
>  		 * the thread dies to avoid that the interrupt code


