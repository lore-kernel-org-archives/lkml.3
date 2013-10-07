Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3JGWwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:52:15 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40036 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3JGWwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:52:14 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH 0/4] Lockdep enablement for seqcount/seqlocks (v2)
Date: Mon,  7 Oct 2013 15:51:57 -0700
Message-Id: <1381186321-4906-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just wanted to send this out again for further feedback.

This patch series enables lockdep for seqcount/seqlock structures,
as well as provides the required cleanups to explicitly initialize
the seqcount structures on u64_stat_sync users.

In addition the last two patches in this provide fixes to
some of the issues the new lockdep infrastructure caught.

I'd greatly appreciate any thoughts or feedback on the series!
Particularly on how the u64_stats_sync initialization changes
should be merged.

thanks
-john


Changeslog:
v2:
* Took Eric Dumazet's suggestion for a better ipv6 deadlock fix
* Macro formatting improvements suggested by Ingo
* Minor commit message tweaks

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>

John Stultz (4):
  [RFC] net: Explicitly initialize u64_stats_sync structures for lockdep
  [RFC] seqcount: Add lockdep functionality to seqcount/seqlock
    structures
  [RFC] cpuset: Fix potential deadlock w/ set_mems_allowed
  [RFC] ipv6: Fix for possible ipv6 seqlock deadlock

 arch/x86/vdso/vclock_gettime.c                 |  8 +--
 drivers/net/dummy.c                            |  6 ++
 drivers/net/ethernet/emulex/benet/be_main.c    |  4 ++
 drivers/net/ethernet/intel/igb/igb_main.c      |  5 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  |  4 ++
 drivers/net/ethernet/marvell/mvneta.c          |  3 +
 drivers/net/ethernet/marvell/sky2.c            |  3 +
 drivers/net/ethernet/neterion/vxge/vxge-main.c |  4 ++
 drivers/net/ethernet/nvidia/forcedeth.c        |  2 +
 drivers/net/ethernet/realtek/8139too.c         |  3 +
 drivers/net/ethernet/tile/tilepro.c            |  2 +
 drivers/net/ethernet/via/via-rhine.c           |  3 +
 drivers/net/ifb.c                              |  5 ++
 drivers/net/loopback.c                         |  6 ++
 drivers/net/macvlan.c                          |  7 +++
 drivers/net/nlmon.c                            |  8 +++
 drivers/net/team/team.c                        |  6 ++
 drivers/net/team/team_mode_loadbalance.c       |  9 ++-
 drivers/net/veth.c                             |  8 +++
 drivers/net/virtio_net.c                       |  8 +++
 drivers/net/vxlan.c                            |  8 +++
 drivers/net/xen-netfront.c                     |  6 ++
 fs/dcache.c                                    |  4 +-
 fs/fs_struct.c                                 |  2 +-
 include/linux/cpuset.h                         |  4 ++
 include/linux/init_task.h                      |  8 +--
 include/linux/lockdep.h                        |  8 ++-
 include/linux/seqlock.h                        | 79 +++++++++++++++++++++++---
 include/linux/u64_stats_sync.h                 |  7 +++
 mm/filemap_xip.c                               |  2 +-
 net/8021q/vlan_dev.c                           |  9 ++-
 net/bridge/br_device.c                         |  7 +++
 net/ipv4/af_inet.c                             | 14 +++++
 net/ipv4/ip_tunnel.c                           |  8 ++-
 net/ipv6/addrconf.c                            | 14 +++++
 net/ipv6/af_inet6.c                            | 14 +++++
 net/ipv6/ip6_gre.c                             | 15 +++++
 net/ipv6/ip6_output.c                          |  2 +-
 net/ipv6/ip6_tunnel.c                          |  7 +++
 net/ipv6/sit.c                                 | 15 +++++
 net/netfilter/ipvs/ip_vs_ctl.c                 | 25 +++++++-
 net/openvswitch/datapath.c                     |  6 ++
 net/openvswitch/vport.c                        |  8 +++
 43 files changed, 348 insertions(+), 28 deletions(-)

-- 
1.8.1.2

