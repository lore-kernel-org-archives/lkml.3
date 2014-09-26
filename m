Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbaIZJrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:47:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876AbaIZJqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 141/142] aio: add missing smp_rmb() in read_events_ring
Date: Fri, 26 Sep 2014 11:45:52 +0200
Message-Id: <0fbdd4f77c9051e4f23b943aa8d373d151679f0d.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Moyer <jmoyer@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2ff396be602f10b5eab8e73b24f20348fa2de159 upstream.

We ran into a case on ppc64 running mariadb where io_getevents would
return zeroed out I/O events.  After adding instrumentation, it became
clear that there was some missing synchronization between reading the
tail pointer and the events themselves.  This small patch fixes the
problem in testing.

Thanks to Zach for helping to look into this, and suggesting the fix.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/aio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 6d68e01dc7ca..b732a9c32042 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1065,6 +1065,12 @@ static long aio_read_events_ring(struct kioctx *ctx,
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
2.1.0

