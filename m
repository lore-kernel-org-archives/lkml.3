Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbaLJOPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:15:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199AbaLJOPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:15:51 -0500
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [RFC PATCH 0/3] Faster than SLAB caching of SKBs with qmempool
	(backed by alf_queue)
To: Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>
Cc: linux-api@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 10 Dec 2014 15:15:07 +0100
Message-ID: <20141210141332.31779.56391.stgit@dragon>
In-Reply-To: <20141210033902.2114.68658.stgit@ahduyck-vm-fedora20>
References: <20141210033902.2114.68658.stgit@ahduyck-vm-fedora20>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The network stack have some use-cases that puts some extreme demands
on the memory allocator.  One use-case, 10Gbit/s wirespeed at smallest
packet size[1], requires handling a packet every 67.2 ns (nanosec).

Micro benchmarking[2] the SLUB allocator (with skb size 256bytes
elements), show "fast-path" instant reuse only costs 19 ns, but a
closer to network usage pattern show the cost rise to 45 ns.

This patchset introduce a quick mempool (qmempool), which when used
in-front of the SKB (sk_buff) kmem_cache, saves 12 ns on "fast-path"
drop in iptables "raw" table, but more importantly saves 40 ns with
IP-forwarding, which were hitting the slower SLUB use-case.


One of the building blocks for achieving this speedup is a cmpxchg
based Lock-Free queue that supports bulking, named alf_queue for
Array-based Lock-Free queue.  By bulking elements (pointers) from the
queue, the cost of the cmpxchg (approx 8 ns) is amortized over several
elements.

 Patch1: alf_queue (Lock-Free queue)

 Patch2: qmempool using alf_queue

 Patch3: usage of qmempool for SKB caching


Notice, this patchset depend on introduction of napi_alloc_skb(),
which is part of Alexander Duyck's work patchset [3].

Different correctness tests and micro benchmarks are avail via my
github repo "prototype-kernel"[4], where the alf_queue and qmempool is
also kept in sync with this patchset.

Links:
 [1]: http://netoptimizer.blogspot.dk/2014/05/the-calculations-10gbits-wirespeed.html
 [2]: https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/mm/qmempool_bench.c
 [3]: http://thread.gmane.org/gmane.linux.network/342347
 [4]: https://github.com/netoptimizer/prototype-kernel

---

Jesper Dangaard Brouer (3):
      net: use qmempool in-front of sk_buff kmem_cache
      mm: qmempool - quick queue based memory pool
      lib: adding an Array-based Lock-Free (ALF) queue


 include/linux/alf_queue.h |  303 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/qmempool.h  |  205 +++++++++++++++++++++++++++++
 include/linux/skbuff.h    |    4 -
 lib/Kconfig               |   13 ++
 lib/Makefile              |    2 
 lib/alf_queue.c           |   47 +++++++
 mm/Kconfig                |   12 ++
 mm/Makefile               |    1 
 mm/qmempool.c             |  322 +++++++++++++++++++++++++++++++++++++++++++++
 net/core/dev.c            |    5 +
 net/core/skbuff.c         |   43 +++++-
 11 files changed, 950 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/alf_queue.h
 create mode 100644 include/linux/qmempool.h
 create mode 100644 lib/alf_queue.c
 create mode 100644 mm/qmempool.c

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer

