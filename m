Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaIGQXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 12:23:20 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:56959
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672AbaIGQW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 12:22:29 -0400
X-IronPort-AV: E=Sophos;i="5.04,483,1406584800"; 
   d="scan'208";a="78047706"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 5/7] staging: lustre: obdclass: expand double GOTO macros
Date: Sun,  7 Sep 2014 18:18:33 +0200
Message-Id: <1410106715-9573-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier lbl;
@@

if (...)
  GOTO(lbl,...);
+else
GOTO(lbl,...);

@@
identifier lbl;
expression e,e1,e2;
@@

if (e)
-  GOTO(lbl,e1);
-else GOTO(lbl,e2);
+  e1;
+else e2;
+goto lbl;

@@
identifier lbl1,lbl2;
expression e,e1,e2;
@@

+ e1=e2;
if (e)
-  GOTO(lbl1,e1=e2);
-GOTO(lbl2,e1=e2);
+  goto lbl1;
+goto lbl2;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/lustre/lustre/obdclass/dt_object.c |    6 ++++--
 drivers/staging/lustre/lustre/obdclass/llog.c      |    5 +++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/dt_object.c b/drivers/staging/lustre/lustre/obdclass/dt_object.c
index 130b8dd..4060173 100644
--- a/drivers/staging/lustre/lustre/obdclass/dt_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/dt_object.c
@@ -689,8 +689,10 @@ static int dt_index_page_build(const struct lu_env *env, union lu_page *lp,
 
 		if (nob < size) {
 			if (lip->lip_nr == 0)
-				GOTO(out, rc = -EINVAL);
-			GOTO(out, rc = 0);
+				rc = -EINVAL;
+			else
+				rc = 0;
+			goto out;
 		}
 
 		if ((ii->ii_flags & II_FL_NOHASH) == 0) {
diff --git a/drivers/staging/lustre/lustre/obdclass/llog.c b/drivers/staging/lustre/lustre/obdclass/llog.c
index ebdc42f..1cf604d 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog.c
@@ -336,9 +336,10 @@ repeat:
 
 			if (rec->lrh_index == 0) {
 				/* probably another rec just got added? */
+				rc = 0;
 				if (index <= loghandle->lgh_last_idx)
-					GOTO(repeat, rc = 0);
-				GOTO(out, rc = 0); /* no more records */
+					goto repeat;
+				goto out; /* no more records */
 			}
 			if (rec->lrh_len == 0 ||
 			    rec->lrh_len > LLOG_CHUNK_SIZE) {
