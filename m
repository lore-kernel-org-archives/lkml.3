Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaLOO7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:59:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38542 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbaLOO2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Jeffery <djeffery@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        =?UTF-8?q?Moritz=20M=C3=BChlenhoff?= <muehlenhoff@univention.de>,
        Kamal Mostafa <kamal@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 070/168] nfs: Don't busy-wait on SIGKILL in __nfs_iocounter_wait
Date: Mon, 15 Dec 2014 14:25:24 +0000
Message-Id: <1418653622-21105-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jeffery <djeffery@redhat.com>

commit 92a56555bd576c61b27a5cab9f38a33a1e9a1df5 upstream.

If a SIGKILL is sent to a task waiting in __nfs_iocounter_wait,
it will busy-wait or soft lockup in its while loop.
nfs_wait_bit_killable won't sleep, and the loop won't exit on
the error return.

Stop the busy-wait by breaking out of the loop when
nfs_wait_bit_killable returns an error.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
[ kamal: backport to 3.13-stable: context ]
Cc: Moritz Mühlenhoff <muehlenhoff@univention.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/pagelist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 3a9c34a0f898..54d049f930f7 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -116,7 +116,7 @@ __nfs_iocounter_wait(struct nfs_io_counter *c)
 		if (atomic_read(&c->io_count) == 0)
 			break;
 		ret = nfs_wait_bit_killable(&c->flags);
-	} while (atomic_read(&c->io_count) != 0);
+	} while (atomic_read(&c->io_count) != 0 && !ret);
 	finish_wait(wq, &q.wait);
 	return ret;
 }
-- 
2.1.3

