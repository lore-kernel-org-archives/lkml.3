Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827Ab3LFWk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:40:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758952Ab3LFVw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 3.12 05/83] net: x86: bpf: dont forget to free sk_filter (v2)
Date: Fri,  6 Dec 2013 13:50:55 -0800
Message-Id: <20131206214640.578168115@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vagin <avagin@openvz.org>

[ Upstream commit 98bbc06aabac5a2dcc46580d20c59baf8ebe479f ]

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
Acked-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/net/bpf_jit_comp.c |    2 ++
 1 file changed, 2 insertions(+)

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


