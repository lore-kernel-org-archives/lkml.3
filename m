Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab3H2C4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 22:56:49 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58576 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3H2C4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 22:56:48 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-ac-521eb86e6602
From: Namhyung Kim <namhyung@kernel.org>
To: Jeremy Eder <jeder@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCHSET 00/17] perf tools: Introduce new 'ftrace' command (v4)
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
	<20130809102306.GA1045@krava.brq.redhat.com>
	<87r4dywcu3.fsf@sejong.aot.lge.com>
	<20130828145708.GA20153@jeder.rdu.redhat.com>
Date: Thu, 29 Aug 2013 11:56:46 +0900
In-Reply-To: <20130828145708.GA20153@jeder.rdu.redhat.com> (Jeremy Eder's
	message of "Wed, 28 Aug 2013 10:57:08 -0400")
Message-ID: <878uzlurv5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

On Wed, 28 Aug 2013 10:57:08 -0400, Jeremy Eder wrote:
> On 130813 11:20:52, Namhyung Kim wrote:
>> @@ -579,6 +587,8 @@ out:
>>  		pthread_cond_signal(&recorder_ready_cond);
>>  		pthread_mutex_unlock(&recorder_mutex);
>>  	}
>> +
>> +	pr_debug2("done with %ld bytes\n", (long)byte_written);
>>  	return fra;
>>  }
>>  
>
> Hmm, I already had hunk #3 in your git tree v4.

Oops, sorry about that.

>
>> @@ -1139,12 +1149,12 @@ retry:
>>  		return record;
>>  	}
>>  
>> -	munmap(fra->map, pevent_get_page_size(ftrace->pevent));
>> -	fra->map = NULL;
>> -
>>  	if (fra->done)
>>  		return NULL;
>>  
>> +	munmap(fra->map, pevent_get_page_size(ftrace->pevent));
>> +	fra->map = NULL;
>> +
>>  	fra->offset += pevent_get_page_size(ftrace->pevent);
>>  	if (fra->offset >= fra->size) {
>>  		/* EOF */
>
>
> After patching your tree with just the first 2 hunks, I'm able to
> get ftrace-style function graphing out of perf.
>
> # ./perf ftrace record df
> Filesystem           1K-blocks     Used Available Use% Mounted on
> <snip>...
>
> # ./perf --no-pager ftrace show | head -20
> overriding event (11) ftrace:funcgraph_entry with new print handler
> overriding event (10) ftrace:funcgraph_exit with new print handler
>   2)   0.686 us |  finish_task_switch();
>   2)   0.260 us |  finish_wait();
>   2)            |  mutex_lock() {
>   2)   0.211 us |    _cond_resched();
>   2)   1.170 us |  }
>   2)   0.319 us |  generic_pipe_buf_confirm();
>   2)   0.261 us |  generic_pipe_buf_map();
>   2)   0.129 us |  generic_pipe_buf_unmap();
>   2)   0.747 us |  anon_pipe_buf_release();
>   2)   0.138 us |  mutex_unlock();
>   2)            |  __wake_up_sync_key() {
>   2)   0.279 us |    _raw_spin_lock_irqsave();
>   2)   0.135 us |    __wake_up_common();
>   2)   0.133 us |    __lock_text_start();
>   2)   3.386 us |  }
>   2)            |  kill_fasync() {
>   2)            |  smp_reschedule_interrupt() {
>   2)   0.130 us |    kvm_guest_apic_eoi_write();
>
> Nice.

Glad to see this. :)

>
> Not sure if you intend to move all ftrace functionality over to
> perf ftrace, but the function graph timings is a great start and something sorely
> missing.
>
> Do you intend to add -e event support or -l function-specific options ?  In the real
> world, without filtering on events or functions, I've had systems hang, plus
> performance impact is too great.
>
> A common invocation of ftrace via trace-cmd is:
> # trace-cmd record -p function_graph -e irq:* -l do_IRQ ping -c1 www.redhat.com
>
> So possible perf equivalent?
> # ./perf ftrace record -e irq:* -e do_IRQ ping -c1 www.redhat.com

Yes I'm considering adding more features in trace-cmd to perf ftrace.
The function filtering is the one in the highest priority.  I also want
to add support for other events but it needs bit more thinking.

Thanks,
Namhyung
