Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3HVOOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:14:38 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:60185 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3HVOOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:14:36 -0400
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Robert Richter <rric@kernel.org>
Subject: [PATCH v3 00/12] perf, persistent: Add persistent events
Date: Thu, 22 Aug 2013 16:13:15 +0200
Message-Id: <1377180807-12758-1-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set implements the necessary kernel changes for persistent
events.

Persistent events run standalone in the system without the need of a
controlling process that holds an event's file descriptor. The events
are always enabled and collect data samples in a ring buffer.
Processes may connect to existing persistent events using the
perf_event_open() syscall. For this the syscall must be configured
using the new PERF_TYPE_PERSISTENT event type and a unique event
identifier specified in attr.config. The id is propagated in sysfs or
using ioctl (see below).

Persistent event buffers may be accessed with mmap() in the same way
as for any other event. Since the buffers may be used by multiple
processes at the same time, there is only read-only access to them.
Currently there is only support for per-cpu events, thus root access
is needed too.

Persistent events are visible in sysfs. They are added or removed
dynamically. With the information in sysfs userland knows about how to
setup the perf_event attribute of a persistent event. Since a
persistent event always has the persistent flag set, a way is needed
to express this in sysfs. A new syntax is used for this. With
'attr<num>:<mask>' any bit in the attribute structure may be set in a
similar way as using 'config<num>', but <num> is an index that points
to the u64 value to change within the attribute.

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

There are ioctl functions to control persistent events that can be
used to detach or attach an event to or from a process. The
PERF_EVENT_IOC_DETACH ioctl call makes an event persistent. The
perf_event_open() syscall can be used to re-open the event by any
process. The PERF_EVENT_IOC_ATTACH ioctl attaches the event again so
that it is removed after closing the event's fd.

The patches base on the originally work from Borislav Petkov.

This version 3 of the patch set is a complete rework of the code.
There are the following major changes:

 * new event type PERF_TYPE_PERSISTENT introduced,

 * support for all type of events,

 * unique event ids,

 * improvements in reference counting and locking,

 * ioctl functions are added to control persistency,

 * the sysfs implementation now uses variable list size.

This should address most issues discussed during last review of
version 2. The following is unresolved yet and can be added later on
top of this patches, if necessary:

 * support for per-task events (also allowing non-root access),

 * creation of persistent events for disabled cpus,

 * make event persistent with already open (mmap'ed) buffers,

 * make event persistent while creating it.

First patches contain some rework of the perf mmap code to reuse it
for persistent events.

Also note that patch 12 (ioctl functions to control persistency) is
RFC and untested. A perf tools implementation for this is missing and
some ideas are needed how this could be integrated, esp. in something
like perf trace or so.

All patches can be found here:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git persistent-v3

Note: I will resent the perf tools patch necessary to use persistent
events.

-Robert


Borislav Petkov (1):
  mce, x86: Enable persistent events

Robert Richter (11):
  perf, mmap: Factor out ring_buffer_detach_all()
  perf, mmap: Factor out try_get_event()/put_event()
  perf, mmap: Factor out perf_alloc/free_rb()
  perf, mmap: Factor out perf_get_fd()
  perf: Add persistent events
  perf, persistent: Implementing a persistent pmu
  perf, persistent: Exposing persistent events using sysfs
  perf, persistent: Use unique event ids
  perf, persistent: Implement reference counter for events
  perf, persistent: Dynamically resize list of sysfs entries
  [RFC] perf, persistent: ioctl functions to control persistency

 .../testing/sysfs-bus-event_source-devices-format  |  43 +-
 arch/x86/kernel/cpu/mcheck/mce.c                   |  19 +
 include/linux/perf_event.h                         |  12 +-
 include/uapi/linux/perf_event.h                    |   6 +-
 kernel/events/Makefile                             |   2 +-
 kernel/events/core.c                               | 210 +++++---
 kernel/events/internal.h                           |  20 +
 kernel/events/persistent.c                         | 563 +++++++++++++++++++++
 8 files changed, 779 insertions(+), 96 deletions(-)
 create mode 100644 kernel/events/persistent.c

-- 
1.8.3.2

