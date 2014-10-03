Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbaJCWOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:14:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757817AbaJCWNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Benjamin LaHaise <bcrl@kvack.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.16 351/357] aio: block exit_aio() until all context requests are completed
Date: Fri,  3 Oct 2014 14:32:17 -0700
Message-Id: <20141003212944.003662008@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gu Zheng <guz.fnst@cn.fujitsu.com>

commit 6098b45b32e6baeacc04790773ced9340601d511 upstream.

It seems that exit_aio() also needs to wait for all iocbs to complete (like
io_destroy), but we missed the wait step in current implemention, so fix
it in the same way as we did in io_destroy.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

---
 fs/aio.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -797,6 +797,9 @@ void exit_aio(struct mm_struct *mm)
 	unsigned i = 0;
 
 	while (1) {
+		struct completion requests_done =
+			COMPLETION_INITIALIZER_ONSTACK(requests_done);
+
 		rcu_read_lock();
 		table = rcu_dereference(mm->ioctx_table);
 
@@ -824,7 +827,10 @@ void exit_aio(struct mm_struct *mm)
 		 */
 		ctx->mmap_size = 0;
 
-		kill_ioctx(mm, ctx, NULL);
+		kill_ioctx(mm, ctx, &requests_done);
+
+		/* Wait until all IO for the context are done. */
+		wait_for_completion(&requests_done);
 	}
 }
 


