Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab3EaIsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:48:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35690 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3EaIsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:08 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 00/16] perf, persistent: Kernel updates for perf tool integration
Date: Fri, 31 May 2013 10:47:20 +0200
Message-Id: <1369990056-10310-1-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

This patch set implements out of the box support of perf tools for
persistent events. For this the kernel must provide necessary
information about existing persistent events via sysfs to userland.
Persistent events are provided by the kernel with readonly event
buffers. To allow the independent usage of the event buffers by any
process without limiting other processes, multiple users of a single
event must be handled too.

The basic concept is to use a pmu as an event container for persistent
events. The pmu registers events in sysfs and provides format and
event information for the userland. The persistent event framework
requires to add events to the pmu dynamically.

With the information in sysfs userland knows about how to setup the
perf_event attribute of a persistent event. Since a persistent event
always has the persistent flag set, a way is needed to express this in
sysfs. A new syntax is used for this. With 'attr<num>:<mask>' any bit
in the attribute structure may be set in a similar way as using
'config<num>', but <num> is an index that points to the u64 value to
change within the attribute.

For persistent events the persistent flag (bit 23 of flag field in
struct perf_event_attr) needs to be set which is expressed in sysfs
with "attr5:23". E.g. the mce_record event is described in sysfs as
follows:

 /sys/bus/event_source/devices/persistent/events/mce_record:persistent,config=106
 /sys/bus/event_source/devices/persistent/format/persistent:attr5:23

Note that perf tools need to support the 'attr<num>' syntax that is
added in a separate patch set. With it we are able to run perf tool
commands to read persistent events, e.g.:

 # perf record -e persistent/mce_record/ sleep 10
 # perf top -e persistent/mce_record/

In general the new syntax is flexible to describe with sysfs any event
to be setup by perf tools.

First patches contain also fixes and reworks made after reviewing
code. Could be applied separately.

Patches base on Boris' patches which I have rebased to latest
tip/perf/core. All patches can be found here:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git persistent

-Robert



Robert Richter (16):
  perf, persistent: Fix build error for no-tracepoints configs
  perf, persistent: Fix attr size
  perf, persistent: Setting default buffer size to 512k as in perf tools
  perf, persistent: Print error code on failure when adding events
  perf, persistent: Return resonable error code
  perf, persistent: Return -EACCES if mapped buffers must be readonly
  perf, persistent: Rework struct pers_event_desc
  perf, persistent: Remove rb_put()
  perf, persistent: Introduce get_persistent_event()
  perf, persistent: Reworking perf_get_persistent_event_fd()
  perf, persistent: Protect event lists with mutex
  perf, persistent: Avoid adding identical events
  perf, persistent: Implementing a persistent pmu
  perf, persistent: Name each persistent event
  perf, persistent: Exposing persistent events using sysfs
  perf, persistent: Allow multiple users for an event

 arch/x86/kernel/cpu/mcheck/mce.c |   7 +-
 include/linux/perf_event.h       |  11 +-
 kernel/events/core.c             |   6 +-
 kernel/events/internal.h         |   1 -
 kernel/events/persistent.c       | 292 +++++++++++++++++++++++++++++----------
 5 files changed, 229 insertions(+), 88 deletions(-)

-- 
1.8.1.1

