Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaG3PqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:46:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbaG3PqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:46:18 -0400
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v3 net-next 3/3] samples: bpf: eBPF dropmon example in C
References: <1406000723-4872-1-git-send-email-ast@plumgrid.com>
	<1406000723-4872-4-git-send-email-ast@plumgrid.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 30 Jul 2014 11:45:28 -0400
In-Reply-To: <1406000723-4872-4-git-send-email-ast@plumgrid.com> (Alexei Starovoitov's message of "Mon, 21 Jul 2014 20:45:23 -0700")
Message-ID: <y0m1tt226lj.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ast wrote earlier:

> [...]
> dtrace/systemtap/ktap approach is to use one script file that should provide
> all desired functionality. That architectural decision overcomplicated their
> implementations.
>
> eBPF follows split model: everything that needs to process millions of events
> per second needs to run in kernel and needs to be short and deterministic,
> all other things like aggregation and nice graphs should run in user space.
> [...]

For the record, this is not entirely accurate as to dtrace.  dtrace
delegates aggregation and most reporting to userspace.  Also,
systemtap is "short and deterministic" even for aggregations & nice
graphs, but since it limits its storage & cpu consumption, its
arrays/reports cannot get super large.


> [...]
> +SEC("events/skb/kfree_skb")
> +int bpf_prog2(struct bpf_context *ctx)
> +{
> +[...]
> +	value = bpf_map_lookup_elem(&my_map, &loc);
> +	if (value)
> +		(*(long *) value) += 1;
> +	else
> +		bpf_map_update_elem(&my_map, &loc, &init_val);
> +	return 0;
> +}

What kind of locking/serialization is provided by the ebpf runtime
over shared variables such as my_map?


- FChE
