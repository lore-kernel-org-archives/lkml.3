Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaHTMM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:12:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58874 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752472AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 010/104] memcg: oom_notify use-after-free fix
Date: Wed, 20 Aug 2014 13:42:33 +0200
Message-Id: <5f24f2a63160e8bc5f12bc2d786048d5ce2f49cb.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2bcf2e92c3918ce62ab4e934256e47e9a16d19c3 upstream.

Paul Furtado has reported the following GPF:

  general protection fault: 0000 [#1] SMP
  Modules linked in: ipv6 dm_mod xen_netfront coretemp hwmon x86_pkg_temp_thermal crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 microcode pcspkr ext4 jbd2 mbcache raid0 xen_blkfront
  CPU: 3 PID: 3062 Comm: java Not tainted 3.16.0-rc5 #1
  task: ffff8801cfe8f170 ti: ffff8801d2ec4000 task.ti: ffff8801d2ec4000
  RIP: e030:mem_cgroup_oom_synchronize+0x140/0x240
  RSP: e02b:ffff8801d2ec7d48  EFLAGS: 00010283
  RAX: 0000000000000001 RBX: ffff88009d633800 RCX: 000000000000000e
  RDX: fffffffffffffffe RSI: ffff88009d630200 RDI: ffff88009d630200
  RBP: ffff8801d2ec7da8 R08: 0000000000000012 R09: 00000000fffffffe
  R10: 0000000000000000 R11: 0000000000000000 R12: ffff88009d633800
  R13: ffff8801d2ec7d48 R14: dead000000100100 R15: ffff88009d633a30
  FS:  00007f1748bb4700(0000) GS:ffff8801def80000(0000) knlGS:0000000000000000
  CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: 00007f4110300308 CR3: 00000000c05f7000 CR4: 0000000000002660
  Call Trace:
    pagefault_out_of_memory+0x18/0x90
    mm_fault_error+0xa9/0x1a0
    __do_page_fault+0x478/0x4c0
    do_page_fault+0x2c/0x40
    page_fault+0x28/0x30
  Code: 44 00 00 48 89 df e8 40 ca ff ff 48 85 c0 49 89 c4 74 35 4c 8b b0 30 02 00 00 4c 8d b8 30 02 00 00 4d 39 fe 74 1b 0f 1f 44 00 00 <49> 8b 7e 10 be 01 00 00 00 e8 42 d2 04 00 4d 8b 36 4d 39 fe 75
  RIP  mem_cgroup_oom_synchronize+0x140/0x240

Commit fb2a6fc56be6 ("mm: memcg: rework and document OOM waiting and
wakeup") has moved mem_cgroup_oom_notify outside of memcg_oom_lock
assuming it is protected by the hierarchical OOM-lock.

Although this is true for the notification part the protection doesn't
cover unregistration of event which can happen in parallel now so
mem_cgroup_oom_notify can see already unlinked and/or freed
mem_cgroup_eventfd_list.

Fix this by using memcg_oom_lock also in mem_cgroup_oom_notify.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=80881

Fixes: fb2a6fc56be6 (mm: memcg: rework and document OOM waiting and wakeup)
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Paul Furtado <paulfurtado91@gmail.com>
Tested-by: Paul Furtado <paulfurtado91@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/memcontrol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 213d1b4aafd7..4e705ed74b81 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5648,8 +5648,12 @@ static int mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_eventfd_list *ev;
 
+	spin_lock(&memcg_oom_lock);
+
 	list_for_each_entry(ev, &memcg->oom_notify, list)
 		eventfd_signal(ev->eventfd, 1);
+
+	spin_unlock(&memcg_oom_lock);
 	return 0;
 }
 
-- 
2.0.4

