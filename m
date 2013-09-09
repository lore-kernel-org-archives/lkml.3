Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3IISqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:46:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57117 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab3IISpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chen Gang <gang.chen@asianux.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 11/24] powerpc/pseries/lparcfg: Fix possible overflow are more than 1026
Date: Mon,  9 Sep 2013 11:45:01 -0700
Message-Id: <1378752314-2416-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

commit 5676005acf26ab7e924a8438ea4746e47d405762 upstream.

need set '\0' for 'local_buffer'.

SPLPAR_MAXLENGTH is 1026, RTAS_DATA_BUF_SIZE is 4096. so the contents of
rtas_data_buf may truncated in memcpy.

if contents are really truncated.
  the splpar_strlen is more than 1026. the next while loop checking will
  not find the end of buffer. that will cause memory access violation.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/kernel/lparcfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index 801a757..d92f387 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -299,6 +299,7 @@ static void parse_system_parameter_string(struct seq_file *m)
 				__pa(rtas_data_buf),
 				RTAS_DATA_BUF_SIZE);
 	memcpy(local_buffer, rtas_data_buf, SPLPAR_MAXLENGTH);
+	local_buffer[SPLPAR_MAXLENGTH - 1] = '\0';
 	spin_unlock(&rtas_data_buf_lock);
 
 	if (call_status != 0) {
-- 
1.8.1.2

