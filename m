Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab3HEKCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 06:02:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46875 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab3HEKCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 06:02:46 -0400
Date: Mon, 5 Aug 2013 03:01:23 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-c9601247f8f3fdc18aed7ed7e490e8dfcd07f122@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, mccalpin@tacc.utexas.edu, acme@ghostprotocols.net,
        peterz@infradead.org, vincent.weaver@maine.edu, stable@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, mccalpin@tacc.utexas.edu,
        peterz@infradead.org, acme@ghostprotocols.net,
        vincent.weaver@maine.edu, stable@kernel.org, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1308021037280.26119@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1308021037280.26119@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86:
  Fix intel QPI uncore event definitions
Git-Commit-ID: c9601247f8f3fdc18aed7ed7e490e8dfcd07f122
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 05 Aug 2013 03:01:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9601247f8f3fdc18aed7ed7e490e8dfcd07f122
Gitweb:     http://git.kernel.org/tip/c9601247f8f3fdc18aed7ed7e490e8dfcd07f122
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Fri, 2 Aug 2013 10:47:34 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 5 Aug 2013 11:32:08 +0200

perf/x86: Fix intel QPI uncore event definitions

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
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1308021037280.26119@vincent-weaver-1.um.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index cad791d..1fb6c72 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -314,8 +314,8 @@ static struct uncore_event_desc snbep_uncore_imc_events[] = {
 static struct uncore_event_desc snbep_uncore_qpi_events[] = {
 	INTEL_UNCORE_EVENT_DESC(clockticks,       "event=0x14"),
 	INTEL_UNCORE_EVENT_DESC(txl_flits_active, "event=0x00,umask=0x06"),
-	INTEL_UNCORE_EVENT_DESC(drs_data,         "event=0x02,umask=0x08"),
-	INTEL_UNCORE_EVENT_DESC(ncb_data,         "event=0x03,umask=0x04"),
+	INTEL_UNCORE_EVENT_DESC(drs_data,         "event=0x102,umask=0x08"),
+	INTEL_UNCORE_EVENT_DESC(ncb_data,         "event=0x103,umask=0x04"),
 	{ /* end: all zeroes */ },
 };
 
