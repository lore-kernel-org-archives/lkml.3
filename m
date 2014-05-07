Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbaEGPgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:36:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233AbaEGPfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:35:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, ak@linux.intel.com,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/5] x86, nmi: Add boot line option 'panic_on_unrecovered_nmi' and 'panic_on_io_nmi'
Date: Wed,  7 May 2014 11:34:40 -0400
Message-Id: <1399476883-98970-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
References: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These options are accessable through /proc/sys/kernel but not on the command
line.  The main use is for on board controllers (iLO, DRAC, BMC) to be able
to issue an external NMI to bring down a hung box.

This just makes configuring a box a little easier.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 Documentation/kernel-parameters.txt |    9 +++++++++
 arch/x86/kernel/nmi.c               |   14 ++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda..c9da1a7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2313,6 +2313,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			timeout < 0: reboot immediately
 			Format: <timeout>
 
+	panic_on_unrecovered_nmi [X86]
+			Force a machine to panic if an unrecoverable NMI is
+			unclaimed.  This covers SERR or UNKONWN NMI cases.
+
+	panic_on_io_nmi [X86]
+			Force a machine to panic if an IO NMI is unclaimed.
+			This covers external NMIs with no handlers associated
+			with them.
+
 	parkbd.port=	[HW] Parallel port number the keyboard adapter is
 			connected to, default is 0.
 			Format: <parport#>
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 72fcff7..f3f4c43 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -87,6 +87,20 @@ static int __init setup_unknown_nmi_panic(char *str)
 }
 __setup("unknown_nmi_panic", setup_unknown_nmi_panic);
 
+static int __init setup_panic_on_unrecovered_nmi(char *str)
+{
+	panic_on_unrecovered_nmi = 1;
+	return 1;
+}
+__setup("panic_on_unrecovered_nmi", setup_panic_on_unrecovered_nmi);
+
+static int __init setup_panic_on_io_nmi(char *str)
+{
+	panic_on_io_nmi = 1;
+	return 1;
+}
+__setup("panic_on_io_nmi", setup_panic_on_io_nmi);
+
 #define nmi_to_desc(type) (&nmi_desc[type])
 
 static u64 nmi_longest_ns = 1 * NSEC_PER_MSEC;
-- 
1.7.1

