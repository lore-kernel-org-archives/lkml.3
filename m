Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaGNL7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:59:44 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60803 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaGNL7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:59:38 -0400
Message-ID: <53C3C611.3020804@gmail.com>
Date: Mon, 14 Jul 2014 19:59:13 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: bergwolf@gmail.com, andreas.dilger@intel.com, standby24x7@gmail.com,
        oleg.drokin@intel.com, Andriy_Skulysh@xyratex.com,
        denis.pithon@gmail.com, paf@cray.com, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] drivers: staging: lustre: Use 'force_die' instead of 'die'
 to avoid compiling issue
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of architectures have already defined 'die' as macro, so can not
use it as declaration or definition in other modules, or it will cause
compiling issue.

So use more precise name 'force_die' (like 'wrap_bulk') instead of. And
the related error (with allmodconfig under score):

    CC [M]  drivers/staging/lustre/lustre/ptlrpc/sec.o
  drivers/staging/lustre/lustre/ptlrpc/sec.c: In function 'sptlrpc_cli_ctx_expire':
  drivers/staging/lustre/lustre/ptlrpc/sec.c:309:13: error: 'struct ptlrpc_ctx_ops' has no member named '__die'
    ctx->cc_ops->die(ctx, 0);
               ^
  drivers/staging/lustre/lustre/ptlrpc/sec.c: In function 'ctx_refresh_timeout':
  drivers/staging/lustre/lustre/ptlrpc/sec.c:594:26: error: 'struct ptlrpc_ctx_ops' has no member named '__die'
     req->rq_cli_ctx->cc_ops->die(req->rq_cli_ctx, 0);
                            ^
  make[5]: *** [drivers/staging/lustre/lustre/ptlrpc/sec.o] Error 1
  make[4]: *** [drivers/staging/lustre/lustre/ptlrpc] Error 2
  make[3]: *** [drivers/staging/lustre/lustre] Error 2
  make[2]: *** [drivers/staging/lustre] Error 2
  make[1]: *** [drivers/staging] Error 2
  make: *** [drivers] Error 2


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/staging/lustre/lustre/include/lustre_sec.h | 2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c         | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_sec.h b/drivers/staging/lustre/lustre/include/lustre_sec.h
index bf3ee39..1b8ec11 100644
--- a/drivers/staging/lustre/lustre/include/lustre_sec.h
+++ b/drivers/staging/lustre/lustre/include/lustre_sec.h
@@ -387,7 +387,7 @@ struct ptlrpc_ctx_ops {
 	/**
 	 * Force the \a ctx to die.
 	 */
-	void    (*die)	 (struct ptlrpc_cli_ctx *ctx,
+	void    (*force_die)   (struct ptlrpc_cli_ctx *ctx,
 				int grace);
 	int     (*display)     (struct ptlrpc_cli_ctx *ctx,
 				char *buf, int bufsize);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index 28ac824..bb5b4b6 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -305,8 +305,8 @@ EXPORT_SYMBOL(sptlrpc_cli_ctx_put);
  */
 void sptlrpc_cli_ctx_expire(struct ptlrpc_cli_ctx *ctx)
 {
-	LASSERT(ctx->cc_ops->die);
-	ctx->cc_ops->die(ctx, 0);
+	LASSERT(ctx->cc_ops->force_die);
+	ctx->cc_ops->force_die(ctx, 0);
 }
 EXPORT_SYMBOL(sptlrpc_cli_ctx_expire);
 
@@ -591,7 +591,7 @@ int ctx_refresh_timeout(void *data)
 	 * later than the context refresh expire time.
 	 */
 	if (rc == 0)
-		req->rq_cli_ctx->cc_ops->die(req->rq_cli_ctx, 0);
+		req->rq_cli_ctx->cc_ops->force_die(req->rq_cli_ctx, 0);
 	return rc;
 }
 
-- 
1.7.11.7
