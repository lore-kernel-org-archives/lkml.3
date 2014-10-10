Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaJJVsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 17:48:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:3740 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaJJVsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:48:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,695,1406617200"; 
   d="scan'208";a="603614777"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, rostedt@goodmis.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/4] Add trace decoding script to add MSR names to MSR trace
Date: Fri, 10 Oct 2014 14:47:53 -0700
Message-Id: <1412977673-13500-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412977673-13500-1-git-send-email-andi@firstfloor.org>
References: <1412977673-13500-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add the MSR names from msr-index.h to a trace including read/write_msr
events.  This makes the output much easier to read.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/trace/postprocess/decode_msr.py | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100755 Documentation/trace/postprocess/decode_msr.py

diff --git a/Documentation/trace/postprocess/decode_msr.py b/Documentation/trace/postprocess/decode_msr.py
new file mode 100755
index 0000000..e3aa832
--- /dev/null
+++ b/Documentation/trace/postprocess/decode_msr.py
@@ -0,0 +1,22 @@
+#!/usr/bin/python
+# add symbolic names to read_msr / write_msr events in trace
+# decode_msr $kernel/arch/x86/include/uapi/asm/msr-index.h < trace
+
+import sys
+import re
+
+msrs = dict()
+
+with open(sys.argv[1], "r") as f:
+	for j in f:
+		m = re.match(r'#define (MSR_\w+)\s+(0x[0-9a-fA-F]+)', j)
+		if m:
+			msrs[int(m.group(2), 16)] = m.group(1)
+
+for j in sys.stdin:
+	m = re.search(r'(read|write)_msr: ([0-9a-f]+)', j)
+	if m and int(m.group(2), 16) in msrs:
+		j = j.replace(" " + m.group(2), " " + msrs[int(m.group(2), 16)])
+	print j,
+
+
-- 
1.9.3

