Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab3JNVHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:07:51 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39643 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab3JNVHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:07:50 -0400
Message-ID: <1381784868.2045.10.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Date: Mon, 14 Oct 2013 14:07:48 -0700
In-Reply-To: <20131014074900.GA20095@gmail.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <87siw4xy9i.fsf@tassilo.jf.intel.com> <20131014074900.GA20095@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 09:49 +0200, Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Neil Horman <nhorman@tuxdriver.com> writes:
> > 
> > > Sébastien Dugué reported to me that devices implementing ipoib (which 
> > > don't have checksum offload hardware were spending a significant 
> > > amount of time computing
> > 
> > Must be an odd workload, most TCP/UDP workloads do copy-checksum 
> > anyways. I would rather investigate why that doesn't work.
> 
> There's a fair amount of csum_partial()-only workloads, a packet does not 
> need to hit user-space to be a significant portion of the system's 
> workload.
> 
> That said, it would indeed be nice to hear which particular code path was 
> hit in this case, if nothing else then for education purposes.

Many NIC do not provide a CHECKSUM_COMPLETE information for encapsulated
frames, meaning we have to fallback to software csum to validate
TCP frames, once tunnel header is pulled.

So to reproduce the issue, all you need is to setup a GRE tunnel between
two hosts, and use any tcp stream workload.

Then receiver profile looks like :

11.45%	[kernel]	 [k] csum_partial
 3.08%	[kernel]	 [k] _raw_spin_lock
 3.04%	[kernel]	 [k] intel_idle
 2.73%	[kernel]	 [k] ipt_do_table
 2.57%	[kernel]	 [k] __netif_receive_skb_core
 2.15%	[kernel]	 [k] copy_user_generic_string
 2.05%	[kernel]	 [k] __hrtimer_start_range_ns
 1.42%	[kernel]	 [k] ip_rcv
 1.39%	[kernel]	 [k] kmem_cache_free
 1.36%	[kernel]	 [k] _raw_spin_unlock_irqrestore
 1.24%	[kernel]	 [k] __schedule
 1.13%	[bnx2x] 	 [k] bnx2x_rx_int
 1.12%	[bnx2x] 	 [k] bnx2x_start_xmit
 1.11%	[kernel]	 [k] fib_table_lookup
 0.99%	[ip_tunnel]  [k] ip_tunnel_lookup
 0.91%	[ip_tunnel]  [k] ip_tunnel_rcv
 0.90%	[kernel]	 [k] check_leaf.isra.7
 0.89%	[kernel]	 [k] nf_iterate


