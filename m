Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3KYFqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 00:46:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:35217 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab3KYFqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 00:46:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,765,1378882800"; 
   d="scan'208";a="440963788"
Date: Mon, 25 Nov 2013 13:47:15 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: John Fastabend <john.r.fastabend@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: WARNING at net/core/dev.c:netdev_all_upper_get_next_dev_rcu()
Message-ID: <20131125054715.GW9991@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

We got the following warning:
  [   25.040056] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
  [   25.047312] EDD information not available.
  [   25.637680] ------------[ cut here ]------------
  [   25.643383] WARNING: CPU: 10 PID: 1 at /c/kernel-tests/src/x86_64/net/core/dev.c:4503 netdev_all_upper_get_next_dev_rcu+0x40/0x84()
  [   25.657508] Modules linked in:
  [   25.661515] CPU: 10 PID: 1 Comm: swapper/0 Not tainted 3.12.0-11530-g873cd59 #1751
  [   25.670889] Hardware name: Intel Corporation LH Pass/S4600LH...., BIOS SE5C600.86B.99.02.1047.032320122259 03/23/2012
  [   25.683647]  0000000000000001 ffff880427c9bc68 ffffffff81a4168e 0000000000000000
  [   25.693182]  ffff880427c9bca0 ffffffff810c5530 ffffffff81934918 ffff880427c9bce8
  [   25.702742]  ffff880818e98000 0000000000000000 0000000000000040 ffff880427c9bcb0
  [   25.712306] Call Trace:
  [   25.715532]  [<ffffffff81a4168e>] dump_stack+0x4d/0x66
  [   25.721770]  [<ffffffff810c5530>] warn_slowpath_common+0x7f/0x98
  [   25.728974]  [<ffffffff81934918>] ? netdev_all_upper_get_next_dev_rcu+0x40/0x84
  [   25.738020]  [<ffffffff810c55f7>] warn_slowpath_null+0x1a/0x1c
  [   25.745022]  [<ffffffff81934918>] netdev_all_upper_get_next_dev_rcu+0x40/0x84
  [   25.753517]  [<ffffffff81792a5f>] ixgbe_configure+0x74f/0x786
  [   25.760431]  [<ffffffff81793f24>] ixgbe_open+0x18e/0x409
  [   25.766895]  [<ffffffff810e6f94>] ? raw_notifier_call_chain+0x14/0x16
  [   25.774608]  [<ffffffff81933f6d>] ? call_netdevice_notifiers_info+0x52/0x59
  [   25.782914]  [<ffffffff81939560>] __dev_open+0x90/0xd0
  [   25.789174]  [<ffffffff819397db>] __dev_change_flags+0xa9/0x14b
  [   25.796279]  [<ffffffff819398a3>] dev_change_flags+0x26/0x59
  [   25.803136]  [<ffffffff82590a73>] ip_auto_config+0x204/0xe82
  [   25.809974]  [<ffffffff811012bf>] ? lock_release_holdtime.part.7+0xcc/0xd9
  [   25.818181]  [<ffffffff81979cef>] ? tcp_set_default_congestion_control+0xb4/0xb9
  [   25.827349]  [<ffffffff81a4cb6c>] ? _raw_spin_unlock+0x27/0x32
  [   25.834353]  [<ffffffff8259086f>] ? root_nfs_parse_addr+0xaf/0xaf
  [   25.841668]  [<ffffffff810002ba>] do_one_initcall+0xa4/0x13a
  [   25.848495]  [<ffffffff810e192e>] ? parse_args+0x261/0x33f
  [   25.855127]  [<ffffffff82533faf>] kernel_init_freeable+0x1d9/0x25f
  [   25.862516]  [<ffffffff82533785>] ? do_early_param+0x88/0x88
  [   25.869348]  [<ffffffff81a305f9>] ? rest_init+0xcd/0xcd
  [   25.875669]  [<ffffffff81a30607>] kernel_init+0xe/0x109
  [   25.882011]  [<ffffffff81a548fc>] ret_from_fork+0x7c/0xb0
  [   25.888535]  [<ffffffff81a305f9>] ? rest_init+0xcd/0xcd
  [   25.894850] ---[ end trace 083c1411a531ab55 ]---
  [   25.904421] pps pps0: new PPS source ptp0
  [   25.909429] ixgbe 0000:06:00.0: registered PHC device on eth0
  [   26.321643] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready

And the first bad commit is:

  commit 2a47fa45d4dfbc54659d28de311a1f764b296a3c
  Author: John Fastabend <john.r.fastabend@intel.com>
  Date:   Wed Nov 6 09:54:52 2013 -0800
  
      ixgbe: enable l2 forwarding acceleration for macvlans
      
      Now that l2 acceleration ops are in place from the prior patch,
      enable ixgbe to take advantage of these operations.  Allow it to
      allocate queues for a macvlan so that when we transmit a frame,
      we can do the switching in hardware inside the ixgbe card, rather
      than in software.
      
      Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
      Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
      CC: Andy Gospodarek <andy@greyhouse.net>
      CC: "David S. Miller" <davem@davemloft.net>
      Signed-off-by: David S. Miller <davem@davemloft.net>
  
  :040000 040000 6407c4e5932446e035cfd57b786845e49746948f 60c62718a990436d6d4589b8124affaa0412aa14 M	drivers
  bisect run success
  
  # bad: [873cd59de3c0e84596ee1790fb3047df45d0da43] Merge 'drm-exynos/exynos-drm-fixes' into devel-hourly-2013112214
  # good: [5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52] Linux 3.12
  git bisect start '873cd59de3c0e84596ee1790fb3047df45d0da43' '5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52' '--'
  # good: [5cbb3d216e2041700231bcfc383ee5f8b7fc8b74] Merge branch 'akpm' (patches from Andrew Morton)
  git bisect good 5cbb3d216e2041700231bcfc383ee5f8b7fc8b74
  # bad: [3aeb58ab6216d864821e8dafb248e8d77403f3e9] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
  git bisect bad 3aeb58ab6216d864821e8dafb248e8d77403f3e9
  # bad: [dcd607718385d02ce3741de225927a57f528f93b] inet: fix a UFO regression
  git bisect bad dcd607718385d02ce3741de225927a57f528f93b
  # good: [3ba405db1c1b05d157474c71e559393f7ea436ad] gianfar: Simplify MQ polling to avoid soft lockup
  git bisect good 3ba405db1c1b05d157474c71e559393f7ea436ad
  # good: [ba275241030cfe87b87d6592345c7e7ebd9b6fba] virtio-net: coalesce rx frags when possible during rx
  git bisect good ba275241030cfe87b87d6592345c7e7ebd9b6fba
  # good: [a72e25f78134cc0c1ef2adc99d6c3680ebd80e35] Merge branch 'for-linville' of git://github.com/kvalo/ath
  git bisect good a72e25f78134cc0c1ef2adc99d6c3680ebd80e35
  # good: [53c5a099b8fd45632f4021f0a908b43aabe883fc] rt2x00: rt2800lib: autodetect 5GHz band support
  git bisect good 53c5a099b8fd45632f4021f0a908b43aabe883fc
  # good: [01925efdf7e03b4b803b5c9f985163d687f7f017] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless
  git bisect good 01925efdf7e03b4b803b5c9f985163d687f7f017
  # good: [95ed40196f965177ee0d044ab304e5cab3aee9c1] Merge branch 'tipc_fragmentation'
  git bisect good 95ed40196f965177ee0d044ab304e5cab3aee9c1
  # bad: [3cdcf1334cd76bbcabd0f273ee9a13e4cc7816bc] Merge branch 'macvlan_hwaccel'
  git bisect bad 3cdcf1334cd76bbcabd0f273ee9a13e4cc7816bc
  # good: [78032f9b3eae3a43da9468d8ce30caa6be84f89d] 6lowpan: release device on error path
  git bisect good 78032f9b3eae3a43da9468d8ce30caa6be84f89d
  # good: [1ec4864b10171b0691ee196d7006ae56d2c153f2] net/mlx4_en: Fixed crash when port type is changed
  git bisect good 1ec4864b10171b0691ee196d7006ae56d2c153f2
  # bad: [2a47fa45d4dfbc54659d28de311a1f764b296a3c] ixgbe: enable l2 forwarding acceleration for macvlans
  git bisect bad 2a47fa45d4dfbc54659d28de311a1f764b296a3c
  # good: [a6cc0cfa72e0b6d9f2c8fd858aacc32313c4f272] net: Add layer 2 hardware acceleration operations for macvlan devices
  git bisect good a6cc0cfa72e0b6d9f2c8fd858aacc32313c4f272
  # first bad commit: [2a47fa45d4dfbc54659d28de311a1f764b296a3c] ixgbe: enable l2 forwarding acceleration for macvlans


Thanks.

	--yliu
