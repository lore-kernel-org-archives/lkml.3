Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaGOAxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 20:53:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:58988 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753568AbaGOAxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 20:53:36 -0400
Date: Mon, 14 Jul 2014 20:53:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Corey Minyard <cminyard@mvista.com>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH RT 0/3] Linux 3.10.47-rt50-rc1
Message-ID: <20140714205333.6d28ed1f@gandalf.local.home>
In-Reply-To: <53C4714C.8000103@mvista.com>
References: <20140714200420.805309842@goodmis.org>
	<53C4714C.8000103@mvista.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014 19:09:48 -0500
Corey Minyard <cminyard@mvista.com> wrote:

> Can we get:
> 
> tracing-use-migrate_disable-to-prevent-beeing-pushed.patch

Sure except that patch is buggy:

-               preempt_disable();
+               migrate_disable();
                /* The update must run on the CPU that is being updated. */
                if (cpu_id == smp_processor_id() || !cpu_online(cpu_id))
                        rb_update_pages(cpu_buffer);
                else {
-                       /*
-                        * Can not disable preemption for schedule_work_on()
-                        * on PREEMPT_RT.
-                        */
-                       preempt_enable();
                        schedule_work_on(cpu_id,
                                         &cpu_buffer->update_pages_work);
                        wait_for_completion(&cpu_buffer->update_done);
-                       preempt_disable();
                }
-               preempt_enable();
+               migrate_enable();

migrate_disable() on non-PREEMPT_RT is preempt_disable(). You can't
call wait_or_completion with preemption disabled.

When that gets fixed in mainline -rt, I'll add it to the stable
branches too.

-- Steve



> 
> into 3.10, also?
> 
