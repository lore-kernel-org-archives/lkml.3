Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab3K0KBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 05:01:46 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41760 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab3K0KBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:01:43 -0500
Message-ID: <5295C304.1050702@hitachi.com>
Date: Wed, 27 Nov 2013 19:01:40 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH 0/2] tracing: Teach FETCH_MTD_symbol to handle per-cpu
 data
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com> <20131125172206.GD14516@redhat.com> <52946B42.40603@hitachi.com> <20131126174355.GB14028@redhat.com>
In-Reply-To: <20131126174355.GB14028@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/27 2:43), Oleg Nesterov wrote:
> On 11/26, Masami Hiramatsu wrote:
>>
>> (2013/11/26 2:22), Oleg Nesterov wrote:
>>> @symbol can't be used to dump the per-cpu variables. The same is
>>> true for +offset(something) if "something" results in __percpu
>>> pointer.
>>>
>>> With this patch parse_probe_offset() treats "~" before the numeric
>>> offset as "per cpu" mark and stores it in the lowest bit,
>>> calc_probe_offset() simply adds per_cpu_offset(smp_processor_id())
>>> if this bit is set.
>>
>> IMHO, if the symbol is a per-cpu symbol, it is meaningless to
>> access the symbol itself. For the symbol(static) percpu, maybe
>> we can use is_kernel_percpu_address() to check.
> 
> No, we can't use is_kernel_percpu_address(), this is another thing.
> is_kernel_percpu_address(&my_pcpu_var) == F. It is true for
> &per_cpu(my_pcpu_var), this is not what we need.

Ah OK.

> 
>> If the symbol is
>> percpu, it should be automatically translated to something like
>> FETCH_percpu, instead of such additional expression.
> 
> OK. Probably yes, it should be automatically translated, please
> see the patches.
> 
> This doesn't allow to read the data from other CPUs, but at least
> the changes are simple and this_cpu_ is better than the reading
> from the obviously wrong address.

Yeah, usually per_cpu variable is used in current cpu context.

>> For the dynamic allocated per-cpu things, it is also good to give
>> a straight operation, like +10(percpu(%rdi)).
> 
> Probably yes, but this needs more changes and I am still not sure
> this is really useful. And if we do this, we probably also need
> to allow to read from other CPUs...

No, it is enough to provide "percpu(FETCHARG)" which just returns
current cpu's percpu variable address. (Note that kprobes handler
runs in interrupt)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


