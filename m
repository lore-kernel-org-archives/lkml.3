Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbbA2BwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:52:19 -0500
Received: from mail.kernel.org ([198.145.29.136]:49761 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973AbbA2BwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:52:13 -0500
Date: Wed, 28 Jan 2015 13:24:15 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 linux-trace 4/8] samples: bpf: simple tracing example
 in C
Message-ID: <20150128162415.GO7220@kernel.org>
References: <1422417973-10195-1-git-send-email-ast@plumgrid.com>
 <1422417973-10195-5-git-send-email-ast@plumgrid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422417973-10195-5-git-send-email-ast@plumgrid.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 27, 2015 at 08:06:09PM -0800, Alexei Starovoitov escreveu:
> diff --git a/samples/bpf/tracex1_kern.c b/samples/bpf/tracex1_kern.c
> new file mode 100644
> index 000000000000..7849ceb4bce6
> --- /dev/null
> +++ b/samples/bpf/tracex1_kern.c
> @@ -0,0 +1,28 @@
> +#include <linux/skbuff.h>
> +#include <linux/netdevice.h>
> +#include <uapi/linux/bpf.h>
> +#include <trace/bpf_trace.h>
> +#include "bpf_helpers.h"
> +
> +SEC("events/net/netif_receive_skb")
> +int bpf_prog1(struct bpf_context *ctx)
> +{
> +	/*
> +	 * attaches to /sys/kernel/debug/tracing/events/net/netif_receive_skb
> +	 * prints events for loobpack device only
> +	 */
> +	char devname[] = "lo";
> +	struct net_device *dev;
> +	struct sk_buff *skb = 0;
> +
> +	skb = (struct sk_buff *) ctx->arg1;
> +	dev = bpf_fetch_ptr(&skb->dev);
> +	if (bpf_memcmp(dev->name, devname, 2) == 0)

I'm only starting to look at all this, so bear with me... But why do we
need to have it as "bpf_memcmp"? Can't we simply use it as "memcmp" and
have it use the right function?

Less typing, perhaps we would need to have a:

#define memcmp bpf_memcmp(s1, s2, n) bpf_memcmp(s1, s2, n)

in bpf_helpers.h to have it work?

- Arnaldo

> +		/* print event using default tracepoint format */
> +		return 1;
> +
> +	/* drop event */
> +	return 0;
> +}
