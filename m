Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab3FRQ1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:27:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129Ab3FRQRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:17:53 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 21/48] memcg: dont initialize kmem-cache destroying work for root caches
Date: Tue, 18 Jun 2013 09:17:47 -0700
Message-Id: <20130618161728.984004719@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vagin <avagin@openvz.org>

commit f101a9464bfbda42730b54a66f926d75ed2cd31e upstream.

struct memcg_cache_params has a union.  Different parts of this union
are used for root and non-root caches.  A part with destroying work is
used only for non-root caches.

  BUG: unable to handle kernel paging request at 0000000fffffffe0
  IP: kmem_cache_alloc+0x41/0x1f0
  Modules linked in: netlink_diag af_packet_diag udp_diag tcp_diag inet_diag unix_diag ip6table_filter ip6_tables i2c_piix4 virtio_net virtio_balloon microcode i2c_core pcspkr floppy
  CPU: 0 PID: 1929 Comm: lt-vzctl Tainted: G      D      3.10.0-rc1+ #2
  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  RIP: kmem_cache_alloc+0x41/0x1f0
  Call Trace:
   getname_flags.part.34+0x30/0x140
   getname+0x38/0x60
   do_sys_open+0xc5/0x1e0
   SyS_open+0x22/0x30
   system_call_fastpath+0x16/0x1b
  Code: f4 53 48 83 ec 18 8b 05 8e 53 b7 00 4c 8b 4d 08 21 f0 a8 10 74 0d 4c 89 4d c0 e8 1b 76 4a 00 4c 8b 4d c0 e9 92 00 00 00 4d 89 f5 <4d> 8b 45 00 65 4c 03 04 25 48 cd 00 00 49 8b 50 08 4d 8b 38 49
  RIP  [<ffffffff8116b641>] kmem_cache_alloc+0x41/0x1f0

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3033,8 +3033,6 @@ int memcg_update_cache_size(struct kmem_
 			return -ENOMEM;
 		}
 
-		INIT_WORK(&s->memcg_params->destroy,
-				kmem_cache_destroy_work_func);
 		s->memcg_params->is_root_cache = true;
 
 		/*


