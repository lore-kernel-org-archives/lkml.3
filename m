Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaJTCC5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 22:02:57 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48096 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaJTCC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 22:02:56 -0400
Message-ID: <54446D49.1030208@hitachi.com>
Date: Mon, 20 Oct 2014 11:02:49 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] s390 vs. kprobes on ftrace
References: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com> <543F5C84.7090005@hitachi.com> <20141017081921.GA18203@osiris>
In-Reply-To: <20141017081921.GA18203@osiris>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/17 17:19), Heiko Carstens wrote:
> On Thu, Oct 16, 2014 at 02:49:56PM +0900, Masami Hiramatsu wrote:
>> Hi Heiko,
>>
>> (2014/10/16 0:46), Heiko Carstens wrote:
>>> Hi all,
>>>
>>> we would like to implement an architecture specific variant of "kprobes
>>> on ftrace" without using the current HAVE_KPROBES_ON_FTRACE infrastructure
>>> which is currently only used by x86.
> 
> [...]
> 
>> I'm not sure about s390 nor have the machine, so it is very helpful if you
>> give us a command line level test and show us the result with this patch :)
>> Fortunately, we already have ftracetest under tools/tesitng/selftest/ftrace/.
>> You can add the testcase for checking co-existence of kprobes and ftrace on
>> an entry of a function.
> 
> So how about something like below?

Yes! :) And could you add the results before and after to patch 2/2,
so that we can see what it changes on s390 ?

Thank you!

> 
>>From e7ba7796bfc7179aad1c612571d330cae4c048b7 Mon Sep 17 00:00:00 2001
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date: Fri, 17 Oct 2014 10:01:03 +0200
> Subject: [PATCH] ftracetest: add kprobes on ftrace testcase
> 
> Add a kprobes on ftrace testcase. The testcase verifies that
> - enabling and disabling function tracing works on a function which
>   already contains a dynamic kprobe
> - adding and removing a dynamic kprobe works on a function which is
>   already enabled for function tracing
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  .../ftrace/test.d/kprobe/kprobe_ftrace.tc          | 56 ++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
>  create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
> 
> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
> new file mode 100644
> index 000000000000..4ddd18054fda
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
> @@ -0,0 +1,56 @@
> +#!/bin/sh
> +# description: Kprobe dynamic event with function tracer
> +
> +[ -f kprobe_events ] || exit_unsupported # this is configurable
> +grep function available_tracers || exit_unsupported # this is configurable
> +
> +# prepare
> +echo nop > current_tracer
> +echo do_fork > set_ftrace_filter
> +echo 0 > events/enable
> +echo > kprobe_events
> +echo 'p:testprobe do_fork' > kprobe_events
> +
> +# kprobe on / ftrace off
> +echo 1 > events/kprobes/testprobe/enable
> +echo > trace
> +( echo "forked")
> +grep testprobe trace
> +! grep 'do_fork <-' trace
> +
> +# kprobe on / ftrace on
> +echo function > current_tracer
> +echo > trace
> +( echo "forked")
> +grep testprobe trace
> +grep 'do_fork <-' trace
> +
> +# kprobe off / ftrace on
> +echo 0 > events/kprobes/testprobe/enable
> +echo > trace
> +( echo "forked")
> +! grep testprobe trace
> +grep 'do_fork <-' trace
> +
> +# kprobe on / ftrace on
> +echo 1 > events/kprobes/testprobe/enable
> +echo function > current_tracer
> +echo > trace
> +( echo "forked")
> +echo > trace
> +grep testprobe trace
> +grep 'do_fork <-' trace
> +
> +# kprobe on / ftrace off
> +echo nop > current_tracer
> +echo > trace
> +( echo "forked")
> +grep testprobe trace
> +! grep 'do_fork <-' trace
> +
> +# cleanup
> +echo nop > current_tracer
> +echo > set_ftrace_filter
> +echo 0 > events/kprobes/testprobe/enable
> +echo > kprobe_events
> +echo > trace
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


