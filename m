Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaI3Vkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:40:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33000 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaI3VjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Moyer <jmoyer@redhat.com>, Benjamin LaHaise <bcrl@kvack.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 101/103] aio: add missing smp_rmb() in read_events_ring
Date: Tue, 30 Sep 2014 14:31:46 -0700
Message-Id: <1412112708-27356-102-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Moyer <jmoyer@redhat.com>

commit 2ff396be602f10b5eab8e73b24f20348fa2de159 upstream.

We ran into a case on ppc64 running mariadb where io_getevents would
return zeroed out I/O events.  After adding instrumentation, it became
clear that there was some missing synchronization between reading the
tail pointer and the events themselves.  This small patch fixes the
problem in testing.

Thanks to Zach for helping to look into this, and suggesting the fix.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/aio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index a0d9e43..4555755 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1051,6 +1051,12 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	tail = ring->tail;
 	kunmap_atomic(ring);
 
+	/*
+	 * Ensure that once we've read the current tail pointer, that
+	 * we also see the events that were stored up to the tail.
+	 */
+	smp_rmb();
+
 	pr_debug("h%u t%u m%u\n", head, tail, ctx->nr_events);
 
 	if (head == tail)
-- 
1.9.1

