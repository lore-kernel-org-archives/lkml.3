Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaJMCq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:46:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbaJMC2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:28:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH 3.16 22/55] net: filter: fix possible use after free
Date: Mon, 13 Oct 2014 04:24:36 +0200
Message-Id: <20141013022444.677370329@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022443.729870634@linuxfoundation.org>
References: <20141013022443.729870634@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ No appicable upstream commit, this bug has been subsequently been
  fixed as a side effect of other changes. ]

If kmemdup() fails, we free fp->orig_prog and return -ENOMEM

sk_attach_filter()
 -> sk_filter_uncharge(sk, fp)
  -> sk_filter_release(fp)
   -> call_rcu(&fp->rcu, sk_filter_release_rcu)
    -> sk_filter_release_rcu()
     -> sk_release_orig_filter()
        fprog = fp->orig_prog; // not NULL, but points to freed memory
	  kfree(fprog->filter); // use after free, potential corruption
          kfree(fprog); // double free or corruption

Note: This was fixed in 3.17+ with commit 278571baca2a
("net: filter: simplify socket charging")

Found by AddressSanitizer

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: a3ea269b8bcdb ("net: filter: keep original BPF program around")
Acked-by: Alexei Starovoitov <ast@plumgrid.com>
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1318,6 +1318,7 @@ static int sk_store_orig_filter(struct s
 	fkprog->filter = kmemdup(fp->insns, fsize, GFP_KERNEL);
 	if (!fkprog->filter) {
 		kfree(fp->orig_prog);
+		fp->orig_prog = NULL;
 		return -ENOMEM;
 	}
 


