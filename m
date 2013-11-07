Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab3KGEjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:39:14 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:46073 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab3KGEjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:39:13 -0500
From: Andrey Vagin <avagin@openvz.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] net: x86: bpf: don't forget to free sk_filter (v2)
Date: Thu,  7 Nov 2013 08:35:12 +0400
Message-Id: <1383798912-10832-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sk_filter isn't freed if bpf_func is equal to sk_run_filter.

This memory leak was introduced by v3.12-rc3-224-gd45ed4a4
"net: fix unsafe set_memory_rw from softirq".

Before this patch sk_filter was freed in sk_filter_release_rcu,
now it should be freed in bpf_jit_free.

Here is output of kmemleak:
unreferenced object 0xffff8800b774eab0 (size 128):
  comm "systemd", pid 1, jiffies 4294669014 (age 124.062s)
  hex dump (first 32 bytes):
    00 00 00 00 0b 00 00 00 20 63 7f b7 00 88 ff ff  ........ c......
    60 d4 55 81 ff ff ff ff 30 d9 55 81 ff ff ff ff  `.U.....0.U.....
  backtrace:
    [<ffffffff816444be>] kmemleak_alloc+0x4e/0xb0
    [<ffffffff811845af>] __kmalloc+0xef/0x260
    [<ffffffff81534028>] sock_kmalloc+0x38/0x60
    [<ffffffff8155d4dd>] sk_attach_filter+0x5d/0x190
    [<ffffffff815378a1>] sock_setsockopt+0x991/0x9e0
    [<ffffffff81531bd6>] SyS_setsockopt+0xb6/0xd0
    [<ffffffff8165f3e9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

v2: add extra { } after else

Fixes: d45ed4a4e33a ("net: fix unsafe set_memory_rw from softirq")
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 arch/x86/net/bpf_jit_comp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 516593e..26328e8 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -788,5 +788,7 @@ void bpf_jit_free(struct sk_filter *fp)
 	if (fp->bpf_func != sk_run_filter) {
 		INIT_WORK(&fp->work, bpf_jit_free_deferred);
 		schedule_work(&fp->work);
+	} else {
+		kfree(fp);
 	}
 }
-- 
1.8.3.1

