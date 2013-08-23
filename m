Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3HWBIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 21:08:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24740 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab3HWBId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 21:08:33 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=2pwTbst9ur4A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6iCyjPme-SgA:10 a=i0EeH86SAAAA:8 a=jlHVOTUqsIPh_se549QA:9 a=CjuIK1q_8ugA:10 a=hPjdaMEvmhQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 22 Aug 2013 21:08:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a
 ring buffer
Message-ID: <20130822210830.784fac63@gandalf.local.home>
In-Reply-To: <5216A55B.4030400@huawei.com>
References: <1376037909-17797-1-git-send-email-namhyung@kernel.org>
	<1376037909-17797-11-git-send-email-namhyung@kernel.org>
	<5204BCE6.2070102@hitachi.com>
	<20130822124212.328c09c7@gandalf.local.home>
	<5216A55B.4030400@huawei.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013 07:57:15 +0800
"zhangwei(Jovi)" <jovi.zhangwei@huawei.com> wrote:


> > 
> > What about creating a per cpu buffer when uprobes are registered, and
> > delete them when they are finished? Basically what trace_printk() does
> > if it detects that there are users of trace_printk() in the kernel.
> > Note, it does not deallocate them when finished, as it is never
> > finished until reboot ;-)
> > 
> > -- Steve
> >
> I also thought out this approach, but the issue is we cannot fetch user
> memory into per-cpu buffer, because use per-cpu buffer should under
> preempt disabled, and fetching user memory could sleep.

Actually, we could create a per_cpu mutex to match the per_cpu buffers.
This is not unlike what we do in -rt.

	int cpu;
	struct mutex *mutex;
	void *buf;


	/*
	 * Use per cpu buffers for fastest access, but we might migrate
	 * So the mutex makes sure we have sole access to it.
	 */

	cpu = raw_smp_processor_id();
	mutex = per_cpu(uprobe_cpu_mutex, cpu);
	buf = per_cpu(uprobe_cpu_buffer, cpu);

	mutex_lock(mutex);
	store_trace_args(..., buf,...);
	mutex_unlock(mutex);

-- Steve
