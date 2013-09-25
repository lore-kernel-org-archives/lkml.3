Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab3IYBXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:23:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3IYAP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:15:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 005/110] powerpc: Handle unaligned ldbrx/stdbrx
Date: Tue, 24 Sep 2013 17:14:03 -0700
Message-Id: <20130925001323.976535713@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/align.c |   10 ++++++++++
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


