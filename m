Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3JUIxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:53:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39852 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754490Ab3JUIxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:16 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chen Gang" <gang.chen@asianux.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.352634067@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 127/149] powerpc/pseries/lparcfg: Fix possible
 overflow are more than 1026
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/lparcfg.c | 1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -375,6 +375,7 @@ static void parse_system_parameter_strin
 				__pa(rtas_data_buf),
 				RTAS_DATA_BUF_SIZE);
 	memcpy(local_buffer, rtas_data_buf, SPLPAR_MAXLENGTH);
+	local_buffer[SPLPAR_MAXLENGTH - 1] = '\0';
 	spin_unlock(&rtas_data_buf_lock);
 
 	if (call_status != 0) {

