Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3KZJfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 04:35:17 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36558 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab3KZJfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 04:35:12 -0500
Message-ID: <52946B42.40603@hitachi.com>
Date: Tue, 26 Nov 2013 18:34:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] tracing: Teach FETCH_MTD_{symbol,deref} to handle
 per-cpu data
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com> <20131125172206.GD14516@redhat.com>
In-Reply-To: <20131125172206.GD14516@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/26 2:22), Oleg Nesterov wrote:
> @symbol can't be used to dump the per-cpu variables. The same is
> true for +offset(something) if "something" results in __percpu
> pointer.
>
> With this patch parse_probe_offset() treats "~" before the numeric
> offset as "per cpu" mark and stores it in the lowest bit,
> calc_probe_offset() simply adds per_cpu_offset(smp_processor_id())
> if this bit is set.

IMHO, if the symbol is a per-cpu symbol, it is meaningless to
access the symbol itself. For the symbol(static) percpu, maybe
we can use is_kernel_percpu_address() to check. If the symbol is
percpu, it should be automatically translated to something like
FETCH_percpu, instead of such additional expression.

For the dynamic allocated per-cpu things, it is also good to give
a straight operation, like +10(percpu(%rdi)).

> We could turn {dprm,sc}->offset into the "struct probe_offset" which
> holds offset + is_percpu, but this hack looks simple enough and I hope
> that LONG_MAX/2 is enough for the numeric offset.

Also, please do not be afraid to add fetch operation, such kind of
is_percpu flag is not dynamically changed. Then we can use another
fetch function.

Thank you,



-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


