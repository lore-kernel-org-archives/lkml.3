Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab3IKE7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab3IKE5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:04 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=V5-Cl3XU6PAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PtrBcnTPZLMA:10 a=QyXUC8HyAAAA:8 a=JfrnYn6hAAAA:8 a=h3sCQ_blAAAA:8 a=hGzw-44bAAAA:8 a=VwQbUJbxAAAA:8 a=P1XfEAuv8gZ3KnBmmygA:9 a=dGJ0OcVc7YAA:10 a=3Rfx1nUSh_UA:10 a=fNChW5oJl9MA:10 a=dowx1zmaLagA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042923.942480790@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: John McCalpin <mccalpin@tacc.utexas.edu>,
        Vince Weaver <vincent.weaver@maine.edu>, <zheng.z.yan@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, <stable@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [191/251] perf/x86: Fix intel QPI uncore event definitions
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0191-perf-x86-Fix-intel-QPI-uncore-event-definitions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Vince Weaver <vincent.weaver@maine.edu>

[ Upstream commit c9601247f8f3fdc18aed7ed7e490e8dfcd07f122 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 0c0957d..4e5f47a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -313,8 +313,8 @@ static struct uncore_event_desc snbep_uncore_imc_events[] = {
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
1.7.10.4


