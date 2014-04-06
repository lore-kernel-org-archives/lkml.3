Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbaDFXlO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:41:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59446 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689AbaDFXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:39:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Martin Schwidefsky" <schwidefsky@de.ibm.com>
Date: Mon, 07 Apr 2014 00:35:48 +0100
Message-ID: <lsq.1396827348.584142523@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 18/18] s390: fix kernel crash due to linkage stack
 instructions
In-Reply-To: <lsq.1396827347.462803115@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.57-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 8d7f6690cedb83456edd41c9bd583783f0703bf0 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/kernel/head64.S | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/s390/kernel/head64.S
+++ b/arch/s390/kernel/head64.S
@@ -61,7 +61,7 @@ ENTRY(startup_continue)
 	.quad	0			# cr12: tracing off
 	.quad	0			# cr13: home space segment table
 	.quad	0xc0000000		# cr14: machine check handling off
-	.quad	0			# cr15: linkage stack operations
+	.quad	.Llinkage_stack		# cr15: linkage stack operations
 .Lpcmsk:.quad	0x0000000180000000
 .L4malign:.quad 0xffffffffffc00000
 .Lscan2g:.quad	0x80000000 + 0x20000 - 8	# 2GB + 128K - 8
@@ -69,12 +69,15 @@ ENTRY(startup_continue)
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
 
 ENTRY(_ehead)
 

