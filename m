Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbaESVlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:41:20 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:34664 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaESVlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:41:19 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Masanari Iida <standby24x7@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: ptlrpc: sec_config.c:  Fix for possible null pointer dereference
Date: Mon, 19 May 2014 23:42:08 +0200
Message-Id: <1400535728-6106-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
index bf56120..231656e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
@@ -745,11 +745,13 @@ void sptlrpc_conf_log_update_begin(const char *logname)
 	mutex_lock(&sptlrpc_conf_lock);
 
 	conf = sptlrpc_conf_get(fsname, 0);
-	if (conf && conf->sc_local) {
-		LASSERT(conf->sc_updated == 0);
-		sptlrpc_conf_free_rsets(conf);
+	if (conf) {
+		if(conf->sc_local) {
+			LASSERT(conf->sc_updated == 0);
+			sptlrpc_conf_free_rsets(conf);
+		}
+		conf->sc_modified = 0;
 	}
-	conf->sc_modified = 0;
 
 	mutex_unlock(&sptlrpc_conf_lock);
 }
-- 
1.7.10.4

