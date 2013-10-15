Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293Ab3JONRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:17:19 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40105 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758739Ab3JONRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:17:17 -0400
Date: Tue, 15 Oct 2013 09:17:10 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131015131710.GB19861@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <87siw4xy9i.fsf@tassilo.jf.intel.com>
 <20131014074900.GA20095@gmail.com>
 <1381784868.2045.10.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1381784868.2045.10.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 02:07:48PM -0700, Eric Dumazet wrote:
> On Mon, 2013-10-14 at 09:49 +0200, Ingo Molnar wrote:
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > Neil Horman <nhorman@tuxdriver.com> writes:
> > > 
> > > > Sébastien Dugué reported to me that devices implementing ipoib (which 
> > > > don't have checksum offload hardware were spending a significant 
> > > > amount of time computing
> > > 
> > > Must be an odd workload, most TCP/UDP workloads do copy-checksum 
> > > anyways. I would rather investigate why that doesn't work.
> > 
> > There's a fair amount of csum_partial()-only workloads, a packet does not 
> > need to hit user-space to be a significant portion of the system's 
> > workload.
> > 
> > That said, it would indeed be nice to hear which particular code path was 
> > hit in this case, if nothing else then for education purposes.
> 
> Many NIC do not provide a CHECKSUM_COMPLETE information for encapsulated
> frames, meaning we have to fallback to software csum to validate
> TCP frames, once tunnel header is pulled.
> 
> So to reproduce the issue, all you need is to setup a GRE tunnel between
> two hosts, and use any tcp stream workload.
> 
> Then receiver profile looks like :
> 
> 11.45%	[kernel]	 [k] csum_partial
>  3.08%	[kernel]	 [k] _raw_spin_lock
>  3.04%	[kernel]	 [k] intel_idle
>  2.73%	[kernel]	 [k] ipt_do_table
>  2.57%	[kernel]	 [k] __netif_receive_skb_core
>  2.15%	[kernel]	 [k] copy_user_generic_string
>  2.05%	[kernel]	 [k] __hrtimer_start_range_ns
>  1.42%	[kernel]	 [k] ip_rcv
>  1.39%	[kernel]	 [k] kmem_cache_free
>  1.36%	[kernel]	 [k] _raw_spin_unlock_irqrestore
>  1.24%	[kernel]	 [k] __schedule
>  1.13%	[bnx2x] 	 [k] bnx2x_rx_int
>  1.12%	[bnx2x] 	 [k] bnx2x_start_xmit
>  1.11%	[kernel]	 [k] fib_table_lookup
>  0.99%	[ip_tunnel]  [k] ip_tunnel_lookup
>  0.91%	[ip_tunnel]  [k] ip_tunnel_rcv
>  0.90%	[kernel]	 [k] check_leaf.isra.7
>  0.89%	[kernel]	 [k] nf_iterate
> 
As I noted previously the workload that this got reported on was ipoib, which
has a simmilar profile, since infiniband cards tend to not be able to do
checksum offload for ip frames.

Neil

