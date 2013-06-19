Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964912Ab3FSSur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:50:47 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:43780 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964843Ab3FSSuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:50:44 -0400
Message-ID: <51C1FD7F.9090606@gmail.com>
Date: Wed, 19 Jun 2013 12:50:39 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing/perf: perf_trace_buf/perf_xxx hacks.
References: <20130618192147.GA19443@redhat.com> <20130619121039.GA19225@twins.programming.kicks-ass.net> <20130619152844.GA9176@redhat.com> <20130619175139.GA20454@redhat.com>
In-Reply-To: <20130619175139.GA20454@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/13 11:51 AM, Oleg Nesterov wrote:
> On 06/19, Oleg Nesterov wrote:
>>
>> On 06/19, Peter Zijlstra wrote:
>>>
>>> I'm probably missing something obviuos, but what are we trying to do?
>>
>> Say, "perf record -e sched:sched_switch -p1".
>>
>> Every task except /sbin/init will do perf_trace_sched_switch() and
>> perf_trace_buf_prepare() + perf_trace_buf_submit for no reason(),
>> it doesn't have a counter.
>
> I did some testing under kvm, not sure these numbers actually mean
> something, but still.
>
> So, the test-case:
>
> 	int pipe1[2], pipe2[2];
>
> 	void *tfunc(void *arg)
> 	{
> 		for (;;) {
> 			char c;
> 			assert(read(pipe1[0], &c, 1) == 1);
> 			assert(write(pipe2[1], &c, 1) == 1);
> 		}
> 	}
>
> 	int main(void)
> 	{
> 		pthread_t thr;
> 		int nr;
>
> 		assert(pipe(pipe1) == 0);
> 		assert(pipe(pipe2) == 0);
>
> 		assert(pthread_create(&thr, NULL, tfunc, NULL) == 0);
>
> 		for (nr = 0; nr < 1000 * 1000; ++nr) {
> 			char c;
>
> 			assert(write(pipe1[1], &c, 1) == 1);
> 			assert(read(pipe2[0], &c, 1) == 1);
> 		}
>
> 		return 0;
> 	}

Same as "perf bench sched pipe"

David


>
> Idle machine, "/usr/bin/time -f "%e %S %U" taskset 1 ./pf" 3 times:
>
> 	20.73 20.05 0.66
> 	20.68 20.04 0.63
> 	20.68 20.02 0.65
>
> Now with "perf record -e sched:sched_switch -p1" running,
>
> before 3/3:
>
> 	21.59 20.77 0.80
> 	21.40 20.70 0.68
> 	21.50 20.72 0.78
>
> after 3/3:
>
> 	21.00 20.23 0.76
> 	20.89 20.19 0.69
> 	20.94 20.26 0.66
>
> Oleg.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

