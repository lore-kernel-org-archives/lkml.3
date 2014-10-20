Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaJTIme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:42:34 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:24701 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbaJTImc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:42:32 -0400
From: Markos Chandras <markos.chandras@imgtec.com>
To: <linux-mips@linux-mips.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation: ptp: Fix build failure on MIPS cross builds
Date: Mon, 20 Oct 2014 09:42:18 +0100
Message-ID: <1413794538-28465-1-git-send-email-markos.chandras@imgtec.com>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.141]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MIPS system calls are defined based on the -mabi gcc option.
However, the testptp is built on the host using the unistd header
from the kernel sources which were built for the MIPS architecture
thus guarded with the __MIPS_SIM_{ABI64, ABI32, NABI32} definitions
leading to the following build problem:

Documentation/ptp/testptp.c: In function 'clock_adjtime':
Documentation/ptp/testptp.c:55: error: '__NR_clock_adjtime'
undeclared (first use in this function)
Documentation/ptp/testptp.c:55: error: (Each undeclared identifier is reported
only once Documentation/ptp/testptp.c:55: error: for each function it appears in.)

This fix is similar to e9107f88c985bcda ("samples/seccomp/Makefile: do not build
tests if cross-compiling for MIPS")

Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: netdev@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
---
 Documentation/ptp/Makefile | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/ptp/Makefile b/Documentation/ptp/Makefile
index 293d6c09a11f..397c1cd2eda7 100644
--- a/Documentation/ptp/Makefile
+++ b/Documentation/ptp/Makefile
@@ -1,5 +1,15 @@
 # List of programs to build
+ifndef CROSS_COMPILE
 hostprogs-y := testptp
+else
+# MIPS system calls are defined based on the -mabi that is passed
+# to the toolchain which may or may not be a valid option
+# for the host toolchain. So disable testptp if target architecture
+# is MIPS but the host isn't.
+ifndef CONFIG_MIPS
+hostprogs-y := testptp
+endif
+endif
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
-- 
2.1.2

