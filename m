Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaILWeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:34:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:38576 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbaILWeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:34:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,515,1406617200"; 
   d="scan'208";a="477217885"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>,
        Vince Weaver <vincent.weaver@maine.edu>, jolsa@redhat.com
Subject: [PATCH] Add some documentation on the perf sysfs ABI interface
Date: Fri, 12 Sep 2014 15:34:19 -0700
Message-Id: <1410561259-523-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Initial attempt of documenting the perf sysfs interface as
an ABI. I also added some additional pointers hopefully useful
to the users. Comments welcome.

Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: jolsa@redhat.com
v2: Various fixes. Fix cmask/inv (Stephane) Fixes from Randy Dunlap.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/ABI/stable/sysfs-devices-perf | 98 +++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)
 create mode 100644 Documentation/ABI/stable/sysfs-devices-perf

diff --git a/Documentation/ABI/stable/sysfs-devices-perf b/Documentation/ABI/stable/sysfs-devices-perf
new file mode 100644
index 0000000..3fd9bc6
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-devices-perf
@@ -0,0 +1,98 @@
+Perf events enumeration in sysfs
+
+The perf events subsystem exports the format of hardware performance
+counter events supported by perf events. The events can be accessed
+using the perf_event_open() syscall. Each perf directory in devices
+represents a distinct PMU (Performance Monitoring Unit), but not all
+directories in this file are perf directories.
+
+What: /sys/devices/*/format/*
+Description:
+
+Each file in format describes how to fill in an event attribute on the
+current CPU for the perf_event_open syscall.  Multiple event
+attributes may be overlapping and only be valid for some combination
+of attributes (for example only for some event/umask combinations).
+Most attributes are optional.
+
+Each field may have the following contents:
+
+CONFIG:START-END      Field consists of bits START-END in the perf_event_attr
+		      CONFIG field
+CONFIG:BIT	      Field consists of a single bit with index BIT in
+		      CONFIG field
+
+Valid CONFIG fields are config, config1, config2. These map to the respective
+64bit words in struct perf_event_attr.
+
+Typical attributes on a x86 platform
+
+event		Set the 8 bit event code (required)
+umask		Set the 8 bit umask. Event code and umask together select a
+		hardware event.
+cmask		Set the 8 bit counter Mask. Only increment counters when at
+		least cmask events happen during the same cycle.
+inv		(1bit flag) Invert the cmask condition. Only valid with
+		cmask>0.
+edge		(1bit flag) Only increment the event when the condition
+		changes (starts happening)
+any		(1bit flag) Count on both threads of a core
+pc		(1bit flag) Toggle the PMi pins when the condition happens
+
+Attributes available on some x86 platforms:
+
+in_tx		(1bit flag) Only count in a hardware transaction.
+in_tx_cp	(1bit flag) Undo counts inside transaction when the
+		transaction aborts.
+ldlat		Set the load-use latency threshold for sampling loads.
+		Note this is a load-use latency so includes pipeline delays.
+offcore_rsp     Set an extra mask qualifying the type of offcore access.
+		Only with OFFCORE_RESPONSE events. The actual mask is CPU model
+		specific.
+
+For more details on the x86 attributes on Intel platforms please see
+http://www.intel.com/sdm Volume 3, Chapter 18 and 19.  For more
+details on the perf_event_attr struct please see the perf_event_open
+manpage and include/uapi/linux/perf_event.h.
+
+What: /sys/devices/*/events/*
+Description:
+
+Describe predefined events available in the CPU. Each file describes an event.
+The format is attr=0xHEXNUM{,attr=0xHEXNUM}. Each attr is described in a config
+file. Together all the attributes can be used to set up a valid event for the
+perf_event_open syscall.
+
+Typically only a small subset of the CPU events is described in sysfs.
+Some more events are available through predefined classes in perf_event_attr.
+Even more events require filling in CPU specific values. The libraries referenced
+below provide larger event lists.
+
+What: /sys/devices/*/type
+Description:
+
+Decimal number: The PMU type to fill into perf_event_attr in the
+type field to select the correct PMU.
+
+What: /sys/devices/*/perf_event_mux_interval_ms
+Description:
+
+Decimal number: Set the counter multiplexing interval in ms. When more
+events are active than the hardware directly supports perf events
+multiplexes the event. By default (value 0) this is done on timer interrupts
+(depending on the CONFIG_HZ setting) and not done while idle. This
+allows to set a different frequency. Note that setting this to non 0
+may impact idle time, as the event switches will wake up the CPUs now.
+
+What: /sys/devices/*/rdpmc
+Description:
+
+[x86] Decimal number: When 1, allow the RDPMC instruction in user space
+to read performance events that have been set up with perf. When 0
+ring 3 RDPMC access is disallowed.
+
+Users: perf (tools/perf/*)
+The following libraries provide more user friendly interfaces:
+       PAPI (http://icl.cs.utk.edu/papi/)
+       libpfm4 (http://perfmon2.sourceforge.net/)
+       jevents (http://github.com/andikleen/pmu-tools)
-- 
1.9.3

