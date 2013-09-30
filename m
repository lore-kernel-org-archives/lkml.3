Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab3I3K0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:26:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab3I3KMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 057/104] powerpc: Handle unaligned ldbrx/stdbrx
Date: Mon, 30 Sep 2013 11:10:34 +0100
Message-Id: <1380535881-9239-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 230aef7a6a23b6166bd4003bfff5af23c9bd381f upstream.

Normally when we haven't implemented an alignment handler for
a load or store instruction the process will be terminated.

The alignment handler uses the DSISR (or a pseudo one) to locate
the right handler. Unfortunately ldbrx and stdbrx overlap lfs and
stfs so we incorrectly think ldbrx is an lfs and stdbrx is an
stfs.

This bug is particularly nasty - instead of terminating the
process we apply an incorrect fixup and continue on.

With more and more overlapping instructions we should stop
creating a pseudo DSISR and index using the instruction directly,
but for now add a special case to catch ldbrx/stdbrx.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/align.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/powerpc/kernel/align.c b/arch/powerpc/kernel/align.c
index ee5b690..52e5758 100644
--- a/arch/powerpc/kernel/align.c
+++ b/arch/powerpc/kernel/align.c
@@ -764,6 +764,16 @@ int fix_alignment(struct pt_regs *regs)
 	nb = aligninfo[instr].len;
 	flags = aligninfo[instr].flags;
 
+	/* ldbrx/stdbrx overlap lfs/stfs in the DSISR unfortunately */
+	if (IS_XFORM(instruction) && ((instruction >> 1) & 0x3ff) == 532) {
+		nb = 8;
+		flags = LD+SW;
+	} else if (IS_XFORM(instruction) &&
+		   ((instruction >> 1) & 0x3ff) == 660) {
+		nb = 8;
+		flags = ST+SW;
+	}
+
 	/* Byteswap little endian loads and stores */
 	swiz = 0;
 	if (regs->msr & MSR_LE) {
-- 
1.8.3.2

