Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3FRCth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:49:37 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36380 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3FRCtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:49:36 -0400
Message-ID: <51BFCAB8.20008@hitachi.com>
Date: Tue, 18 Jun 2013 11:49:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 2/3] tracing/kprobes: Kill probe_enable_lock
References: <20130616172149.GA8540@redhat.com> <51BE97C0.1070203@hitachi.com> <20130617151841.GA32267@redhat.com>
In-Reply-To: <20130617151841.GA32267@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/18 0:18), Oleg Nesterov wrote:
> On 06/17, Masami Hiramatsu wrote:
>>
>> (2013/06/17 2:21), Oleg Nesterov wrote:
>>> enable_trace_probe() and disable_trace_probe() should not worry about
>>> serialization, the caller (perf_trace_init or __ftrace_set_clr_event)
>>> holds event_mutex.
>>>
>>> They are also called by kprobe_trace_self_tests_init(), but this __init
>>> function can't race with itself or trace_events.c
>>
>> Right,
>> For safety, we should comment this at the caller side,
> 
> Which caller do you mean?

I meant the caller was kprobe_test_self_tests_init().
Since that function calls enable/disable_trace_probe()
without holding event_mutex, we need to notice that
(this is safe because there is no race) at the calling
places :)

Thank you,

> 
> The patch adds
> 
> 	/*
> 	 * This and enable_trace_probe/disable_trace_probe rely on event_mutex
> 	 * held by the caller, __ftrace_set_clr_event().
> 	 */
> 
> above trace_probe_nr_files() but the next patch removes this function
> with the comment...
> 
> Will you agree with this patch if I add something like
> 
> 	/*
> 	 * called by perf_trace_init() or __ftrace_set_clr_event() under event_mutex
> 	 */
> 
> above kprobe_register() ? Perhaps it makes sense to add
> lockdep_assert_held(&event_mutex) into the body?
> 
> And:
> 
>> because
>> those calls are the reason why I have introduced this lock.
> 
> Please do not hesitate to nack this patch if you think that we should
> keep probe_enable_lock for safety even if it is not currently needed.
> In this case I'd suggest to move lock/unlock into kprobe_register()
> but this is minor.
> 
> Oleg.
> 
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


