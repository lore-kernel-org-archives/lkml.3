Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaELCMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:12:48 -0400
Received: from 1wt.eu ([62.212.114.60]:34469 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbaELBmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:08 -0400
Message-Id: <20140512003206.523346891@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 140/143] s390: fix kernel crash due to linkage stack instructions
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 8d7f6690cedb83456edd41c9bd583783f0703bf0 upstream

The kernel currently crashes with a low-address-protection exception
if a user space process executes an instruction that tries to use the
linkage stack. Set the base-ASTE origin and the subspace-ASTE origin
of the dispatchable-unit-control-table to point to a dummy ASTE.
Set up control register 15 to point to an empty linkage stack with no
room left.

A user space process with a linkage stack instruction will still crash
but with a different exception which is correctly translated to a
segmentation fault instead of a kernel oops.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/s390/kernel/head64.S | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/head64.S b/arch/s390/kernel/head64.S
index d984a2a..5b27ed0 100644
--- a/arch/s390/kernel/head64.S
+++ b/arch/s390/kernel/head64.S
@@ -124,7 +124,7 @@ startup_continue:
 	.quad	0			# cr12: tracing off
 	.quad	0			# cr13: home space segment table
 	.quad	0xc0000000		# cr14: machine check handling off
-	.quad	0			# cr15: linkage stack operations
+	.quad	.Llinkage_stack		# cr15: linkage stack operations
 .Lpcmsk:.quad	0x0000000180000000
 .L4malign:.quad 0xffffffffffc00000
 .Lscan2g:.quad	0x80000000 + 0x20000 - 8	# 2GB + 128K - 8
@@ -139,12 +139,15 @@ startup_continue:
 .Lparmaddr:
 	.quad	PARMAREA
 	.align	64
-.Lduct: .long	0,0,0,0,.Lduald,0,0,0
+.Lduct: .long	0,.Laste,.Laste,0,.Lduald,0,0,0
 	.long	0,0,0,0,0,0,0,0
+.Laste:	.quad	0,0xffffffffffffffff,0,0,0,0,0,0
 	.align	128
 .Lduald:.rept	8
 	.long	0x80000000,0,0,0	# invalid access-list entries
 	.endr
+.Llinkage_stack:
+	.long	0,0,0x89000000,0,0,0,0x8a000000,0
 
 	.org	0x12000
 	.globl	_ehead
-- 
1.7.12.2.21.g234cd45.dirty



