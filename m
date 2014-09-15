Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbaIOVB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:01:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbaIOT1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.16 072/158] MIPS: Malta: Improve system memory detection for {e, }memsize >= 2G
Date: Mon, 15 Sep 2014 12:25:11 -0700
Message-Id: <20140915192545.061315267@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit 64615682658373516863b5b5971ff1d922d0ae7b upstream.

Using kstrtol to parse the "{e,}memsize" variables was wrong because this
parses signed long numbers. In case of '{e,}memsize' >= 2G, the top bit
is set, resulting to -ERANGE errors and possibly random system memory
boundaries. We fix this by replacing "kstrtol" with "kstrtoul".
We also improve the code to check the kstrtoul return value and
print a warning if an error was returned.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/7543/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mti-malta/malta-memory.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/arch/mips/mti-malta/malta-memory.c
+++ b/arch/mips/mti-malta/malta-memory.c
@@ -34,13 +34,19 @@ fw_memblock_t * __init fw_getmdesc(int e
 	/* otherwise look in the environment */
 
 	memsize_str = fw_getenv("memsize");
-	if (memsize_str)
-		tmp = kstrtol(memsize_str, 0, &memsize);
+	if (memsize_str) {
+		tmp = kstrtoul(memsize_str, 0, &memsize);
+		if (tmp)
+			pr_warn("Failed to read the 'memsize' env variable.\n");
+	}
 	if (eva) {
 	/* Look for ememsize for EVA */
 		ememsize_str = fw_getenv("ememsize");
-		if (ememsize_str)
-			tmp = kstrtol(ememsize_str, 0, &ememsize);
+		if (ememsize_str) {
+			tmp = kstrtoul(ememsize_str, 0, &ememsize);
+			if (tmp)
+				pr_warn("Failed to read the 'ememsize' env variable.\n");
+		}
 	}
 	if (!memsize && !ememsize) {
 		pr_warn("memsize not set in YAMON, set to default (32Mb)\n");


