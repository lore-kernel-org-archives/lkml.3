Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbaJUJVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:21:15 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35462 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJUJVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:21:14 -0400
Message-ID: <54462581.4050505@hitachi.com>
Date: Tue, 21 Oct 2014 18:21:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ftracetest: add kprobes on ftrace testcase
References: <1413802323-5297-1-git-send-email-heiko.carstens@de.ibm.com> <1413802323-5297-2-git-send-email-heiko.carstens@de.ibm.com>
In-Reply-To: <1413802323-5297-2-git-send-email-heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/20 19:52), Heiko Carstens wrote:
> Add a kprobes on ftrace testcase. The testcase verifies that
> - enabling and disabling function tracing works on a function which
>   already contains a dynamic kprobe
> - adding and removing a dynamic kprobe works on a function which is
>   already enabled for function tracing
> 

Looks good to me.

> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> ---
>  .../ftrace/test.d/kprobe/kprobe_ftrace.tc          | 55 ++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
>  create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
> 
> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
> new file mode 100644
> index 000000000000..ab41d2b29841
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
> @@ -0,0 +1,55 @@
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

I like this technique :)

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


