Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbaJ2XxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:53:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:53225 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757289AbaJ2XxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:53:14 -0400
Date: Wed, 29 Oct 2014 19:53:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Florian Westphal <fw@strlen.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [RFA][PATCH 2/8] netfilter: Remove return values for
 print_conntrack callbacks
Message-ID: <20141029195300.52ae0fe6@gandalf.local.home>
In-Reply-To: <20141029221601.GB10069@breakpoint.cc>
References: <20141029215602.535533597@goodmis.org>
	<20141029220107.465008329@goodmis.org>
	<20141029221601.GB10069@breakpoint.cc>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014 23:16:01 +0100
Florian Westphal <fw@strlen.de> wrote:

> Steven Rostedt <rostedt@goodmis.org> wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > [ REQUEST FOR ACKS ]
> > 
> > The seq_printf() and friends are having their return values removed.
> > The print_conntrack() returns the result of seq_printf(), which is
> > meaningless when seq_printf() returns void. Might as well remove the
> > return values of print_conntrack() as well.
> [..]
> 
> > diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
> > index 4c48e434bb1f..91f207c2cb69 100644
> > --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
> > +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
> > @@ -147,7 +147,10 @@ static int ct_seq_show(struct seq_file *s, void *v)
> >  		      ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
> >  		goto release;
> >  
> > -	if (l4proto->print_conntrack && l4proto->print_conntrack(s, ct))
> > +	if (l4proto->print_conntrack)
> > +		l4proto->print_conntrack(s, ct);
> > +
> > +	if (seq_has_overflowed(s))
> >  		goto release;
> 
> Its not obvious to me why nf_conntrack_l3proto_ipv4_compat now calls
> seq_has_overflowed ...
> 
> > > diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> > index cf65a1e040dd..348aa3602787 100644
> > --- a/net/netfilter/nf_conntrack_standalone.c
> > +++ b/net/netfilter/nf_conntrack_standalone.c
> > @@ -199,8 +199,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
> >  		       ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
> >  		goto release;
> >  
> > -	if (l4proto->print_conntrack && l4proto->print_conntrack(s, ct))
> > -		goto release;
> > +	if (l4proto->print_conntrack)
> > +		l4proto->print_conntrack(s, ct);
> >  
> >  	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
> >  			l3proto, l4proto))
> 
> ... while nf_conntrack_standalone does not.

Because I did those two changes separately at different times ;-)

I can add it here too to be consistent. The goto release logic is not
that critical, as it's really a micro optimization for a slow path.

If we were to remove all the goto release calls, what would happen is
if the buffer were to fill up, the rest of the code would be done in
vain, because it would do the work but the result will be thrown away.
The seq_file code would throw away the buffer completely (does this
regardless of the goto release call when the buffer fills up), and
would allocate a new buffer, and then run the code again. This time it
would hopefully have enough buffer space to hold the entire content,
otherwise, wash rinse repeat.

As this is to output text from a proc file, and the user will most
likely never notice this delay. It's probably done as more of a good
feeling that we didn't waste computer cycles and burn more green house
gasses than necessary, then anything that is remotely noticeable.
Although, I haven't run benchmarks to see what the difference is.

I'll make the change for consistency.

Thanks!

-- Steve
