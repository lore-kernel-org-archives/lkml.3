Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3JUIvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:51:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39405 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113Ab3JUIvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Anton Blanchard" <anton@samba.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.730769455@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 024/149] powerpc: Handle unaligned ldbrx/stdbrx
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/align.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

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

