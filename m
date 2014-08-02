Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaHBJr7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 05:47:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:55343 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbaHBJry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 05:47:54 -0400
From: Thomas Graf <tgraf@suug.ch>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kaber@trash.net, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org, challa@noironetworks.com, walpole@cs.pdx.edu,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org,
        nikolay@redhat.com
Subject: [PATCH net-next v5 0/3] Lockless netlink_lookup() with new concurrent hash table
Date: Sat,  2 Aug 2014 11:47:43 +0200
Message-Id: <cover.1406971567.git.tgraf@suug.ch>
X-Mailer: git-send-email 1.9.3
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@suug.ch> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netlink sockets are maintained in a hash table to allow efficient lookup
via the port ID for unicast messages. However, lookups currently require
a read lock to be taken. This series adds a new generic, resizable,
scalable, concurrent hash table based on the paper referenced in the first
patch. It then makes use of the new data type to implement lockless
netlink_lookup().

Patch 3/3 to convert nft_hash is included for reference but should be
merged via the netfilter tree. Inclusion in this series is to provide
context for the suggested API.

Against net-next since the initial user of the new hash table is in net/

Changes:
v4-v5:
 - use GFP_KERNEL to alloc Netlink buckets as suggested by Nikolay
   Aleksandrov
 - free nft hash element on removal as spotted by Nikolay Aleksandrov
   and Patrick McHardy
v3-v4:
 - fixed wrong shift assignment placement as spotted by Nikolay Aleksandrov
 - reverted default size of nft_hash to 4 as requested by Patrick McHardy,
   default size for other hash tables remains at 64 if no hint is given
 - fixed copyright as requested by Patrick McHardy
v2-v3:
 - fixed typo in nft_hash_destroy() when passing rhashtable handle
v1-v2:
 - fixed traversal off-by-one as spotted by Tobias Klauser
 - removed unlikely() from BUG_ON() as spotted by Josh Triplett
 - new 3rd patch to convert nft_hash to rhashtable
 - make rhashtable_insert() return void
 - nl_sk_hash_lock must be a mutex
 - fixed wrong name of rht_shrink_below_30()
 - exported symbols rht_grow_above_75() and rht_shrink_below_30()
 - allow table freeing with RCU callback

Thomas Graf (3):
  lib: Resizable, Scalable, Concurrent Hash Table
  netlink: Convert netlink_lookup() to use RCU protected hash table
  nftables: Convert nft_hash to use generic rhashtable

 include/linux/rhashtable.h | 213 ++++++++++++
 lib/Kconfig.debug          |   8 +
 lib/Makefile               |   2 +-
 lib/rhashtable.c           | 797 +++++++++++++++++++++++++++++++++++++++++++++
 net/netfilter/nft_hash.c   | 291 ++++-------------
 net/netlink/af_netlink.c   | 285 ++++++----------
 net/netlink/af_netlink.h   |  18 +-
 net/netlink/diag.c         |  11 +-
 8 files changed, 1193 insertions(+), 432 deletions(-)
 create mode 100644 include/linux/rhashtable.h
 create mode 100644 lib/rhashtable.c

-- 
1.9.3

