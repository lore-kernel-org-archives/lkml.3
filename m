Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbaCFArq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:47:46 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35593 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757666AbaCFApY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:45:24 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: linux-doc@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, rob@landley.net
Subject: [PATCH 1/2] perf Documentation: sysfs events/ interfaces
Date: Wed,  5 Mar 2014 16:44:14 -0800
Message-Id: <1394066658-16766-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394066658-16766-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1394066658-16766-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030600-0320-0000-0000-0000029DA743
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for the <event>, <event>.scale, and <event>.unit
files in sysfs.

<event>.scale and <event>.unit were undocumented.
<event> was previously documented only for specific powerpc pmu events.

I've added a restriction that event names cannot contain '.' characters
so we can avoid breaking the API when we (inevitably) add more
'event.????' files.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 .../testing/sysfs-bus-event_source-devices-events  | 59 ++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
index 3c1cc24..5393e1ed6 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
@@ -82,3 +82,62 @@ Description:	POWER-systems specific performance monitoring events
 		Further, multiple terms like 'event=0xNNNN' can be specified
 		and separated with comma. All available terms are defined in
 		the /sys/bus/event_source/devices/<dev>/format file.
+
+What: /sys/bus/event_source/devices/<pmu>/events/<event>
+Date: 2014/02/24
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Per-pmu performance monitoring events specific to the running system
+
+		Each file (with a name not containing a '.') in the 'events'
+		directory describes a single performance monitoring event
+		supported by the <pmu>. The name of the file is the name of the event.
+
+		File contents:
+
+			<term>[=<value>][,<term>[=<value>]]...
+
+		Where <term> is one of the terms listed under
+		/sys/bus/event_source/devices/<pmu>/format/ and <value> is
+		a number is base-16 format with a '0x' prefix (lowercase only).
+		If a <term> is specified alone (without an assigned value), it
+		is implied that 0x1 is assigned to that <term>.
+
+		Examples (each of these lines would be in a seperate file):
+
+			event=0x2abc
+			event=0x423,inv,cmask=0x3
+			domain=0x1,offset=0x8,starting_index=0xffff
+
+		Each of the assignments indicates a value to be assigned to a
+		particular set of bits (as defined by the format file
+		corresponding to the <term>) in the perf_event structure passed
+		to the perf_open syscall.
+
+What: /sys/bus/event_source/devices/<pmu>/events/<event>.unit
+Date: 2014/02/24
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Perf event units
+
+		A string specifying the English plural numerical unit that <event>
+		(once multiplied by <event>.scale) represents.
+
+		Example:
+
+			Joules
+
+What: /sys/bus/event_source/devices/<pmu>/events/<event>.scale
+Date: 2014/02/24
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Perf event scaling factors
+
+		A string representing a floating point value expressed in
+		scientific notation to be multiplied by the event count
+		recieved from the kernel to match the unit specified in the
+		<event>.unit file.
+
+		Example:
+
+			2.3283064365386962890625e-10
+
+		This is provided to avoid performing floating point arithmetic
+		in the kernel.
-- 
1.9.0

