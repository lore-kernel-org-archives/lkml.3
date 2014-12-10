Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbaLJOku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:40:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993AbaLJOks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:40:48 -0500
Date: Wed, 10 Dec 2014 15:40:19 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: brouer@redhat.com, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 0/3] Faster than SLAB caching of SKBs with qmempool
 (backed by alf_queue)
Message-ID: <20141210154019.598da6d8@redhat.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CA0A193@AcuExch.aculab.com>
References: <20141210033902.2114.68658.stgit@ahduyck-vm-fedora20>
	<20141210141332.31779.56391.stgit@dragon>
	<063D6719AE5E284EB5DD2968C1650D6D1CA0A193@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014 14:22:22 +0000
David Laight <David.Laight@ACULAB.COM> wrote:

> From: Jesper Dangaard Brouer
> > The network stack have some use-cases that puts some extreme demands
> > on the memory allocator.  One use-case, 10Gbit/s wirespeed at smallest
> > packet size[1], requires handling a packet every 67.2 ns (nanosec).
> > 
> > Micro benchmarking[2] the SLUB allocator (with skb size 256bytes
> > elements), show "fast-path" instant reuse only costs 19 ns, but a
> > closer to network usage pattern show the cost rise to 45 ns.
> > 
> > This patchset introduce a quick mempool (qmempool), which when used
> > in-front of the SKB (sk_buff) kmem_cache, saves 12 ns on "fast-path"
> > drop in iptables "raw" table, but more importantly saves 40 ns with
> > IP-forwarding, which were hitting the slower SLUB use-case.
> > 
> > 
> > One of the building blocks for achieving this speedup is a cmpxchg
> > based Lock-Free queue that supports bulking, named alf_queue for
> > Array-based Lock-Free queue.  By bulking elements (pointers) from the
> > queue, the cost of the cmpxchg (approx 8 ns) is amortized over several
> > elements.
> 
> It seems to me that these improvements could be added to the
> underlying allocator itself.
> Nesting allocators doesn't really seem right to me.

Yes, I would very much like to see these ideas integrated into the
underlying allocators (hence addressing the mm-list).

This patchset demonstrates that it is possible to do something faster
than the existing SLUB allocator.  Which the network stack have a need
for.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
