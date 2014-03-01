Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaCACRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:17:34 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42636 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbaCACRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:33 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Ann Koehler <amk@cray.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 15/17] lustre/osc: Don't flush active extents.
Date: Fri, 28 Feb 2014 21:16:44 -0500
Message-Id: <1393640206-20286-16-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ann Koehler <amk@cray.com>

The extent is active so we need to abort and let the caller
re-dirty the page. If we continued on here, and we were the
one making the extent active, we could deadlock waiting for
the page writeback to clear but it won't because the extent
is active and won't be written out.

Signed-off-by: Ann Koehler <amk@cray.com>
Reviewed-on: http://review.whamcloud.com/8278
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4253
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Alexey Lyashkov <alexey_lyashkov@xyratex.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/osc/osc_cache.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/lustre/lustre/osc/osc_cache.c b/drivers/staging/lustre/lustre/osc/osc_cache.c
index b92a02e..af25c19 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c
+++ b/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -2394,6 +2394,12 @@ int osc_flush_async_page(const struct lu_env *env, struct cl_io *io,
 		 * really sending the RPC. */
 	case OES_TRUNC:
 		/* race with truncate, page will be redirtied */
+	case OES_ACTIVE:
+		/* The extent is active so we need to abort and let the caller
+		 * re-dirty the page. If we continued on here, and we were the
+		 * one making the extent active, we could deadlock waiting for
+		 * the page writeback to clear but it won't because the extent
+		 * is active and won't be written out. */
 		GOTO(out, rc = -EAGAIN);
 	default:
 		break;
-- 
1.8.5.3

