Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3EQSYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 14:24:21 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24403 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab3EQSYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 14:24:19 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: koverstreet@google.com, akpm@linux-foundation.org
Cc: tytso@mit.edu, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] fs: aio: use correct integer overflow checks when creation aio ctx
Date: Fri, 17 May 2013 14:23:54 -0400
Message-Id: <1368815034-844-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.2.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "aio: percpu reqs_available" added some math to the nr_requests
calculation, but didn't correct the overflow calculations to handle that.

This means that this:

	#include <linux/aio_abi.h>
	void main(void)
	{
	        aio_context_t ctx_idp;
	        io_setup(0x80000001, &ctx_idp);
	}

Would trigger the newly added BUG() couple of lines after the overflow
checks.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/aio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 5b7ed78..0ae450a 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -411,7 +411,8 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 	/* Prevent overflows */
 	if ((nr_events > (0x10000000U / sizeof(struct io_event))) ||
-	    (nr_events > (0x10000000U / sizeof(struct kiocb)))) {
+	    (nr_events > (0x10000000U / sizeof(struct kiocb))) ||
+	    (nr_events < num_possible_cpus() * 4)) {
 		pr_debug("ENOMEM: nr_events too high\n");
 		return ERR_PTR(-EINVAL);
 	}
-- 
1.8.2.1

