Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab3G3JrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:47:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53210 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab3G3JdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tan Xiaojun <tanxiaojun@huawei.com>,
        Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 060/106] dummy: fix oops when loading the dummy failed
Date: Tue, 30 Jul 2013 10:31:19 +0100
Message-Id: <1375176725-5825-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: dingtianhong <dingtianhong@huawei.com>

commit 2c8a01894a12665d8059fad8f0a293c98a264121 upstream.

We rename the dummy in modprobe.conf like this:

install dummy0 /sbin/modprobe -o dummy0 --ignore-install dummy
install dummy1 /sbin/modprobe -o dummy1 --ignore-install dummy

We got oops when we run the command:

modprobe dummy0
modprobe dummy1

------------[ cut here ]------------

[ 3302.187584] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[ 3302.195411] IP: [<ffffffff813fe62a>] __rtnl_link_unregister+0x9a/0xd0
[ 3302.201844] PGD 85c94a067 PUD 8517bd067 PMD 0
[ 3302.206305] Oops: 0002 [#1] SMP
[ 3302.299737] task: ffff88105ccea300 ti: ffff880eba4a0000 task.ti: ffff880eba4a0000
[ 3302.307186] RIP: 0010:[<ffffffff813fe62a>]  [<ffffffff813fe62a>] __rtnl_link_unregister+0x9a/0xd0
[ 3302.316044] RSP: 0018:ffff880eba4a1dd8  EFLAGS: 00010246
[ 3302.321332] RAX: 0000000000000000 RBX: ffffffff81a9d738 RCX: 0000000000000002
[ 3302.328436] RDX: 0000000000000000 RSI: ffffffffa04d602c RDI: ffff880eba4a1dd8
[ 3302.335541] RBP: ffff880eba4a1e18 R08: dead000000200200 R09: dead000000100100
[ 3302.342644] R10: 0000000000000080 R11: 0000000000000003 R12: ffffffff81a9d788
[ 3302.349748] R13: ffffffffa04d7020 R14: ffffffff81a9d670 R15: ffff880eba4a1dd8
[ 3302.364910] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3302.370630] CR2: 0000000000000008 CR3: 000000085e15e000 CR4: 00000000000427e0
[ 3302.377734] DR0: 0000000000000003 DR1: 00000000000000b0 DR2: 0000000000000001
[ 3302.384838] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3302.391940] Stack:
[ 3302.393944]  ffff880eba4a1dd8 ffff880eba4a1dd8 ffff880eba4a1e18 ffffffffa04d70c0
[ 3302.401350]  00000000ffffffef ffffffffa01a8000 0000000000000000 ffffffff816111c8
[ 3302.408758]  ffff880eba4a1e48 ffffffffa01a80be ffff880eba4a1e48 ffffffffa04d70c0
[ 3302.416164] Call Trace:
[ 3302.418605]  [<ffffffffa01a8000>] ? 0xffffffffa01a7fff
[ 3302.423727]  [<ffffffffa01a80be>] dummy_init_module+0xbe/0x1000 [dummy0]
[ 3302.430405]  [<ffffffffa01a8000>] ? 0xffffffffa01a7fff
[ 3302.435535]  [<ffffffff81000322>] do_one_initcall+0x152/0x1b0
[ 3302.441263]  [<ffffffff810ab24b>] do_init_module+0x7b/0x200
[ 3302.446824]  [<ffffffff810ad3d2>] load_module+0x4e2/0x530
[ 3302.452215]  [<ffffffff8127ae40>] ? ddebug_dyndbg_boot_param_cb+0x60/0x60
[ 3302.458979]  [<ffffffff810ad5f1>] SyS_init_module+0xd1/0x130
[ 3302.464627]  [<ffffffff814b9652>] system_call_fastpath+0x16/0x1b
[ 3302.490090] RIP  [<ffffffff813fe62a>] __rtnl_link_unregister+0x9a/0xd0
[ 3302.496607]  RSP <ffff880eba4a1dd8>
[ 3302.500084] CR2: 0000000000000008
[ 3302.503466] ---[ end trace 8342d49cd49f78ed ]---

The reason is that when loading dummy, if __rtnl_link_register() return failed,
the init_module should return and avoid take the wrong path.

Signed-off-by: Tan Xiaojun <tanxiaojun@huawei.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/dummy.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index bab0158..b33ad12 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -186,6 +186,8 @@ static int __init dummy_init_module(void)
 
 	rtnl_lock();
 	err = __rtnl_link_register(&dummy_link_ops);
+	if (err < 0)
+		goto out;
 
 	for (i = 0; i < numdummies && !err; i++) {
 		err = dummy_init_one();
@@ -193,6 +195,8 @@ static int __init dummy_init_module(void)
 	}
 	if (err < 0)
 		__rtnl_link_unregister(&dummy_link_ops);
+
+out:
 	rtnl_unlock();
 
 	return err;
-- 
1.8.3.2

