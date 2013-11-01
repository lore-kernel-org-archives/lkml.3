Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab3KAJA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:00:29 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49581 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAJA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:00:28 -0400
X-AuditID: 9c93016f-b7b28ae00000111e-83-52736da9d0cd
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a ring buffer
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
	<1383029621-7384-11-git-send-email-namhyung@kernel.org>
	<20131031181654.GA11208@redhat.com>
Date: Fri, 01 Nov 2013 18:00:25 +0900
In-Reply-To: <20131031181654.GA11208@redhat.com> (Oleg Nesterov's message of
	"Thu, 31 Oct 2013 19:16:54 +0100")
Message-ID: <878ux84hue.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

Thank you for reviewing this patchset!

On Thu, 31 Oct 2013 19:16:54 +0100, Oleg Nesterov wrote:
> On 10/29, Namhyung Kim wrote:
>>
>> @@ -630,6 +653,19 @@ probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
>>  	if (trace_probe_is_enabled(&tu->p))
>>  		return -EINTR;
>>  
>> +	if (atomic_inc_return(&uprobe_buffer_ref) == 1) {
>> +		int cpu;
>> +
>> +		uprobe_cpu_buffer = __alloc_percpu(PAGE_SIZE, PAGE_SIZE);
>> +		if (uprobe_cpu_buffer == NULL) {
>> +			atomic_dec(&uprobe_buffer_ref);
>> +			return -ENOMEM;
>> +		}
>> +
>> +		for_each_possible_cpu(cpu)
>> +			mutex_init(&per_cpu(uprobe_cpu_mutex, cpu));
>> +	}
>> +
>>  	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
>>  
>>  	tu->p.flags |= flag;
>> @@ -646,6 +682,11 @@ static void probe_event_disable(struct trace_uprobe *tu, int flag)
>>  	if (!trace_probe_is_enabled(&tu->p))
>>  		return;
>>  
>> +	if (atomic_dec_and_test(&uprobe_buffer_ref)) {
>> +		free_percpu(uprobe_cpu_buffer);
>> +		uprobe_cpu_buffer = NULL;
>> +	}
>> +
>>  	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
>
> Do we really need atomic_t? probe_event_enable/disable is called under
> event_mutex and we rely on this fact anyway.
>
> Otherwise this logic looks racy even with atomic_t, another thread could
> use the uninitialized uprobe_cpu_buffer/mutex if it registers another probe
> and the handler runs before we complete the initialization, no?

It seems you're right.  I really need to have some time to look at this
code carefully again. ;-)  So many works are going on these days...

Thanks,
Namhyung
