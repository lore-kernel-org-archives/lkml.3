Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbbABWAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 17:00:33 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:39252 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbbABWAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 17:00:32 -0500
From: Thomas Graf <tgraf@suug.ch>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, paulmck@linux.vnet.ibm.com,
        edumazet@google.com, john.r.fastabend@intel.com, josh@joshtriplett.org
Subject: [PATCH 0/9 net-next v2] rhashtable: Per bucket locks & deferred table resizing
Date: Fri,  2 Jan 2015 23:00:13 +0100
Message-Id: <cover.1420230585.git.tgraf@suug.ch>
X-Mailer: git-send-email 1.9.3
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@suug.ch> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepares for and introduces per bucket spinlocks and deferred table
resizing. This allows for parallel table mutations in different hash
buckets from atomic context. The resizing occurs in the background
in a separate worker thread while lookups, inserts, and removals can
continue.

Also modified the chain linked list to be terminated with a special
nulls marker to allow entries to move between multiple lists.

Last but not least, reintroduces lockless netlink_lookup() with
deferred Netlink socket destruction to avoid the side effect of
increased netlink_release() runtime.

Thomas Graf (9):
  rhashtable: Do hashing inside of rhashtable_lookup_compare()
  rhashtable: Use rht_obj() instead of manual offset calculation
  rhashtable: Convert bucket iterators to take table and index
  rhashtable: Factor out bucket_tail() function
  nft_hash: Remove rhashtable_remove_pprev()
  spinlock: Add spin_lock_bh_nested()
  rhashtable: Per bucket locks & deferred expansion/shrinking
  rhashtable: Supports for nulls marker
  netlink: Lockless lookup with RCU grace period in socket release

 include/linux/list_nulls.h       |   3 +-
 include/linux/rhashtable.h       | 258 ++++++++++++-----
 include/linux/spinlock.h         |   8 +
 include/linux/spinlock_api_smp.h |   2 +
 include/linux/spinlock_api_up.h  |   1 +
 kernel/locking/spinlock.c        |   8 +
 lib/rhashtable.c                 | 607 ++++++++++++++++++++++++++-------------
 net/netfilter/nft_hash.c         |  92 +++---
 net/netlink/af_netlink.c         |  64 ++---
 net/netlink/af_netlink.h         |   1 +
 net/netlink/diag.c               |   4 +-
 11 files changed, 693 insertions(+), 355 deletions(-)

-- 
1.9.3

