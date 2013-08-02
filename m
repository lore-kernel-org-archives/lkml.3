Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3HBOrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:47:55 -0400
Received: from mail-gh0-f172.google.com ([209.85.160.172]:36843 "EHLO
	mail-gh0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3HBOry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:47:54 -0400
Date: Fri, 2 Aug 2013 10:47:34 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: zheng.z.yan@intel.com, mccalpin@tacc.utexas.edu,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf: fix intel QPI uncore event definitions
Message-ID: <alpine.DEB.2.10.1308021037280.26119@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


John McCalpin reports that the "drs_data" and "ncb_data" QPI uncore
events are missing the "extra bit" and always return zero values unless
the bit is properly set.

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
 
