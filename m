Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab3HPWij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:38:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51519 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab3HPWig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:38:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vince Weaver <vincent.weaver@maine.edu>, zheng.z.yan@intel.com,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 115/133] perf/x86: Fix intel QPI uncore event definitions
Date: Fri, 16 Aug 2013 15:34:17 -0700
Message-Id: <1376692475-28413-116-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vince Weaver <vincent.weaver@maine.edu>

commit c9601247f8f3fdc18aed7ed7e490e8dfcd07f122 upstream.

John McCalpin reports that the "drs_data" and "ncb_data" QPI
uncore events are missing the "extra bit" and always return zero
values unless the bit is properly set.

More details from him:

 According to the Xeon E5-2600 Product Family Uncore Performance
 Monitoring Guide, Table 2-94, about 1/2 of the QPI Link Layer events
 (including the ones that "perf" calls "drs_data" and "ncb_data") require
 that the "extra bit" be set.

 This was confusing for a while -- a note at the bottom of page 94 says
 that the "extra bit" is bit 16 of the control register.
 Unfortunately, Table 2-86 clearly says that bit 16 is reserved and must
 be zero.  Looking around a bit, I found that bit 21 appears to be the
 correct "extra bit", and further investigation shows that "perf" actually
 agrees with me:
	[root@c560-003.stampede]# cat /sys/bus/event_source/devices/uncore_qpi_0/format/event
	config:0-7,21

 So the command
	# perf -e "uncore_qpi_0/event=drs_data/"
 Is the same as
	# perf -e "uncore_qpi_0/event=0x02,umask=0x08/"
 While it should be
	# perf -e "uncore_qpi_0/event=0x102,umask=0x08/"

 I confirmed that this last version gives results that agree with the
 amount of data that I expected the STREAM benchmark to move across the QPI
 link in the second (cross-chip) test of the original script.

Reported-by: John McCalpin <mccalpin@tacc.utexas.edu>
Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: zheng.z.yan@intel.com
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Paul Mackerras <paulus@samba.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1308021037280.26119@vincent-weaver-1.um.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 3e091f0..99e70d45 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -315,8 +315,8 @@ static struct uncore_event_desc snbep_uncore_imc_events[] = {
 static struct uncore_event_desc snbep_uncore_qpi_events[] = {
 	INTEL_UNCORE_EVENT_DESC(clockticks,       "event=0x14"),
 	INTEL_UNCORE_EVENT_DESC(txl_flits_active, "event=0x00,umask=0x06"),
-	INTEL_UNCORE_EVENT_DESC(drs_data,         "event=0x02,umask=0x08"),
-	INTEL_UNCORE_EVENT_DESC(ncb_data,         "event=0x03,umask=0x04"),
+	INTEL_UNCORE_EVENT_DESC(drs_data,         "event=0x102,umask=0x08"),
+	INTEL_UNCORE_EVENT_DESC(ncb_data,         "event=0x103,umask=0x04"),
 	{ /* end: all zeroes */ },
 };
 
-- 
1.8.1.2

