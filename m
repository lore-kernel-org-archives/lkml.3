Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbaJ2WQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:16:45 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37039 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756966AbaJ2WQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:16:43 -0400
Date: Wed, 29 Oct 2014 23:16:01 +0100
From: Florian Westphal <fw@strlen.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [RFA][PATCH 2/8] netfilter: Remove return values for
 print_conntrack callbacks
Message-ID: <20141029221601.GB10069@breakpoint.cc>
References: <20141029215602.535533597@goodmis.org>
 <20141029220107.465008329@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029220107.465008329@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> [ REQUEST FOR ACKS ]
> 
> The seq_printf() and friends are having their return values removed.
> The print_conntrack() returns the result of seq_printf(), which is
> meaningless when seq_printf() returns void. Might as well remove the
> return values of print_conntrack() as well.
[..]

> diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
> index 4c48e434bb1f..91f207c2cb69 100644
> --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
> +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
> @@ -147,7 +147,10 @@ static int ct_seq_show(struct seq_file *s, void *v)
>  		      ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
>  		goto release;
>  
> -	if (l4proto->print_conntrack && l4proto->print_conntrack(s, ct))
> +	if (l4proto->print_conntrack)
> +		l4proto->print_conntrack(s, ct);
> +
> +	if (seq_has_overflowed(s))
>  		goto release;

Its not obvious to me why nf_conntrack_l3proto_ipv4_compat now calls
seq_has_overflowed ...

> > diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index cf65a1e040dd..348aa3602787 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -199,8 +199,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
>  		       ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
>  		goto release;
>  
> -	if (l4proto->print_conntrack && l4proto->print_conntrack(s, ct))
> -		goto release;
> +	if (l4proto->print_conntrack)
> +		l4proto->print_conntrack(s, ct);
>  
>  	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
>  			l3proto, l4proto))

... while nf_conntrack_standalone does not.
