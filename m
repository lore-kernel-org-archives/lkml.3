Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab3JNKWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:22:46 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63561 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab3JNKWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:22:44 -0400
From: Majunath Goudar <csmanjuvijay@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nataraja.km@lge.com, Majunath Goudar <manju.goudar@lge.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: CCI : Fix implicit declaration of function error
Date: Mon, 14 Oct 2013 15:52:27 +0530
Message-Id: <1381746147-13830-1-git-send-email-manju.goudar@lge.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a inline dummy implementations of_find_matching_node()
in "#ifdef CONFIG_OF" else part. Without this patch,build system can
lead to issues. This was discovered during randconfig testing,in which
ARM_CCI was enabled w/o CONFIG_OF being enabled,leading to the following error:

CC      drivers/bus/arm-cci.o
drivers/bus/arm-cci.c: In function ‘cci_probe’:
drivers/bus/arm-cci.c:971:2: error: implicit declaration of function
‘of_find_matching_node’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [drivers/bus/arm-cci.o] Error 1
make[1]: *** [drivers/bus] Error 2
make: *** [drivers] Error 2

Signed-off-by: Manjunath Goudar <manju.goudar@lge.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/of.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index f95aee3..2c57aa2 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -340,6 +340,13 @@ int of_device_is_stdout_path(struct device_node *dn);
 
 #else /* CONFIG_OF */
 
+static inline struct device_node *of_find_matching_node(
+	struct device_node *from,
+	const struct of_device_id *matches)
+{
+	return NULL;
+}
+
 static inline const char* of_node_full_name(struct device_node *np)
 {
 	return "<no-node>";
-- 
1.7.9.5

