Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3KCNdr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 08:33:47 -0500
Received: from imap.thunk.org ([74.207.234.97]:53769 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab3KCNdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 08:33:18 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 0/4] random: improve entropy pool initialization at boot time
Date: Sun,  3 Nov 2013 08:33:11 -0500
Message-Id: <1383485595-2020-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches improve how /dev/random initializes its entropy pool
during the kernel boot sequence.  With these changes, using an x86 test
kernel run under KVM, the urandom pool gets initialized before the init
scripts start running, and of the kernel users of get_random_bytes(), a
debugging printk found only two users of get_random_bytes() before the
nonblocking pool could be fully initialized:

rc80211_minstrel_ht_init+0x2b/0x6a called get_random_bytes with 22 bits of entropy available
neigh_hash_alloc+0x82/0x94 called get_random_bytes with 31 bits of entropy available

Both of these calls were in a subsys_initcall(); and the first one I'm
fairly certain could be replaced by the use of prandom_u32().

Note: I've cc'ed these patches to linux-crypto so hopefully more people
will review these patches.

              	       	     		    	- Ted

Theodore Ts'o (4):
  random: use device attach events for entropy
  random: make add_timer_randomness() fill the nonblocking pool first
  random: printk notifications for urandom pool initialization
  random: don't zap entropy count in rand_initialize()

 drivers/base/core.c    |  3 +++
 drivers/char/random.c  | 42 +++++++++++++++++++++++++++++++-----------
 include/linux/random.h |  2 ++
 3 files changed, 36 insertions(+), 11 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b

