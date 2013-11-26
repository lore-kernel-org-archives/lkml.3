Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3KZRmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:42:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab3KZRmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:42:52 -0500
Date: Tue, 26 Nov 2013 18:43:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [RFC PATCH 0/2] tracing: Teach FETCH_MTD_symbol to handle per-cpu
	data
Message-ID: <20131126174355.GB14028@redhat.com>
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com> <20131125172206.GD14516@redhat.com> <52946B42.40603@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52946B42.40603@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Masami Hiramatsu wrote:
>
> (2013/11/26 2:22), Oleg Nesterov wrote:
> > @symbol can't be used to dump the per-cpu variables. The same is
> > true for +offset(something) if "something" results in __percpu
> > pointer.
> >
> > With this patch parse_probe_offset() treats "~" before the numeric
> > offset as "per cpu" mark and stores it in the lowest bit,
> > calc_probe_offset() simply adds per_cpu_offset(smp_processor_id())
> > if this bit is set.
>
> IMHO, if the symbol is a per-cpu symbol, it is meaningless to
> access the symbol itself. For the symbol(static) percpu, maybe
> we can use is_kernel_percpu_address() to check.

No, we can't use is_kernel_percpu_address(), this is another thing.
is_kernel_percpu_address(&my_pcpu_var) == F. It is true for
&per_cpu(my_pcpu_var), this is not what we need.

> If the symbol is
> percpu, it should be automatically translated to something like
> FETCH_percpu, instead of such additional expression.

OK. Probably yes, it should be automatically translated, please
see the patches.

This doesn't allow to read the data from other CPUs, but at least
the changes are simple and this_cpu_ is better than the reading
from the obviously wrong address.

> For the dynamic allocated per-cpu things, it is also good to give
> a straight operation, like +10(percpu(%rdi)).

Probably yes, but this needs more changes and I am still not sure
this is really useful. And if we do this, we probably also need
to allow to read from other CPUs...

> Also, please do not be afraid to add fetch operation,

Well, this is what I am trying to avoid ;)

Oleg.

