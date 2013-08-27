Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3H0IHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:07:22 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57417 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab3H0IHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:07:20 -0400
X-AuditID: 9c930197-b7b44ae00000347f-1b-521c5e3331b9
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a ring buffer
References: <1376037909-17797-1-git-send-email-namhyung@kernel.org>
	<1376037909-17797-11-git-send-email-namhyung@kernel.org>
	<5204BCE6.2070102@hitachi.com>
	<20130822124212.328c09c7@gandalf.local.home>
	<5216A55B.4030400@huawei.com>
	<20130822210830.784fac63@gandalf.local.home>
Date: Tue, 27 Aug 2013 17:07:15 +0900
In-Reply-To: <20130822210830.784fac63@gandalf.local.home> (Steven Rostedt's
	message of "Thu, 22 Aug 2013 21:08:30 -0400")
Message-ID: <87mwo3v9os.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Thu, 22 Aug 2013 21:08:30 -0400, Steven Rostedt wrote:
> On Fri, 23 Aug 2013 07:57:15 +0800
> "zhangwei(Jovi)" <jovi.zhangwei@huawei.com> wrote:
>
>
>> > 
>> > What about creating a per cpu buffer when uprobes are registered, and
>> > delete them when they are finished? Basically what trace_printk() does
>> > if it detects that there are users of trace_printk() in the kernel.
>> > Note, it does not deallocate them when finished, as it is never
>> > finished until reboot ;-)
>> > 
>> > -- Steve
>> >
>> I also thought out this approach, but the issue is we cannot fetch user
>> memory into per-cpu buffer, because use per-cpu buffer should under
>> preempt disabled, and fetching user memory could sleep.
>
> Actually, we could create a per_cpu mutex to match the per_cpu buffers.
> This is not unlike what we do in -rt.
>
> 	int cpu;
> 	struct mutex *mutex;
> 	void *buf;
>
>
> 	/*
> 	 * Use per cpu buffers for fastest access, but we might migrate
> 	 * So the mutex makes sure we have sole access to it.
> 	 */
>
> 	cpu = raw_smp_processor_id();
> 	mutex = per_cpu(uprobe_cpu_mutex, cpu);
> 	buf = per_cpu(uprobe_cpu_buffer, cpu);
>
> 	mutex_lock(mutex);
> 	store_trace_args(..., buf,...);
> 	mutex_unlock(mutex);
>

Great!  I'll go with this approach.  Is it OK to you, Masami?

Thanks,
Namhyung
