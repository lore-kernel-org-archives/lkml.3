Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab3HRUfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:35:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab3HRUe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:34:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John McCalpin <mccalpin@tacc.utexas.edu>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        zheng.z.yan@intel.com
Subject: [ 01/45] perf/x86: Fix intel QPI uncore event definitions
Date: Sun, 18 Aug 2013 13:35:50 -0700
Message-Id: <20130818203621.098555466@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -314,8 +314,8 @@ static struct uncore_event_desc snbep_un
 static struct uncore_event_desc snbep_uncore_qpi_events[] = {
 	INTEL_UNCORE_EVENT_DESC(clockticks,       "event=0x14"),
 	INTEL_UNCORE_EVENT_DESC(txl_flits_active, "event=0x00,umask=0x06"),
-	INTEL_UNCORE_EVENT_DESC(drs_data,         "event=0x02,umask=0x08"),
-	INTEL_UNCORE_EVENT_DESC(ncb_data,         "event=0x03,umask=0x04"),
+	INTEL_UNCORE_EVENT_DESC(drs_data,         "event=0x102,umask=0x08"),
+	INTEL_UNCORE_EVENT_DESC(ncb_data,         "event=0x103,umask=0x04"),
 	{ /* end: all zeroes */ },
 };
 


