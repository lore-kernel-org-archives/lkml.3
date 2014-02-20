Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbaBUBCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:02:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbaBTXuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:50:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.10 15/66] s390: fix kernel crash due to linkage stack instructions
Date: Thu, 20 Feb 2014 15:51:14 -0800
Message-Id: <20140220234909.918387148@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/head64.S |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/s390/kernel/head64.S
+++ b/arch/s390/kernel/head64.S
@@ -59,7 +59,7 @@ ENTRY(startup_continue)
 	.quad	0			# cr12: tracing off
 	.quad	0			# cr13: home space segment table
 	.quad	0xc0000000		# cr14: machine check handling off
-	.quad	0			# cr15: linkage stack operations
+	.quad	.Llinkage_stack		# cr15: linkage stack operations
 .Lpcmsk:.quad	0x0000000180000000
 .L4malign:.quad 0xffffffffffc00000
 .Lscan2g:.quad	0x80000000 + 0x20000 - 8	# 2GB + 128K - 8
@@ -67,12 +67,15 @@ ENTRY(startup_continue)
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
 


