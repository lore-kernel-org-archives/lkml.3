Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaLOPLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:11:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38347 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaLOO1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kevin Cernekee <cernekee@gmail.com>, Rob Herring <robh@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 038/168] of: Fix crash if an earlycon driver is not found
Date: Mon, 15 Dec 2014 14:24:52 +0000
Message-Id: <1418653622-21105-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Cernekee <cernekee@gmail.com>

commit ab74d00a39f70e1bc34a01322bb59f3750ca7a8c upstream.

__earlycon_of_table_sentinel.compatible is a char[128], not a pointer, so
it will never be NULL.  Checking it against NULL causes the match loop to
run past the end of the array, and eventually match a bogus entry, under
the following conditions:

 - Kernel command line specifies "earlycon" with no parameters
 - DT has a stdout-path pointing to a UART node
 - The UART driver doesn't use OF_EARLYCON_DECLARE (or maybe the console
   driver is compiled out)

Fix this by checking to see if match->compatible is a non-empty string.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/of/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 379ad4fa9665..f2da1750a597 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -773,7 +773,7 @@ int __init early_init_dt_scan_chosen_serial(void)
 	if (offset < 0)
 		return -ENODEV;
 
-	while (match->compatible) {
+	while (match->compatible[0]) {
 		unsigned long addr;
 		if (fdt_node_check_compatible(fdt, offset, match->compatible)) {
 			match++;
-- 
2.1.3

