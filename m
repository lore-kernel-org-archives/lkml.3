Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbaDQMo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 08:44:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53966 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaDQMo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 08:44:27 -0400
MIME-Version: 1.0
In-Reply-To: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
Date: Thu, 17 Apr 2014 14:44:26 +0200
Message-ID: <CAFrcx1=0TddfPS322728w3AsK5SzJ1sq-7VTbE=+Pb-EqcrncQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/16] perf, persistent: Add persistent events
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rric@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ping on this series. Are there some opinions or interest in this?

Regards,
Jean

On 7 April 2014 17:04, Jean Pihet <jean.pihet@linaro.org> wrote:
> Jean Pihet <jean.pihet@linaro.org>:
> - In order to restart the discussion on the topic, here is a rebased
>  version of Robert's latest patches (v3) on acme/perf/core.
>  It has been compiled and lightly tested on ARM64.
>
> - From the latest discussion on ML the ioctls are renamed from
>  PERF_EVENT_IOC_ATTACH/DETACH to PERF_EVENT_IOC_CLAIM/UNCLAIM.
>
>
> Robert Richter <rric@kernel.org>:
> This patch set implements the necessary kernel changes for persistent
> events.
>
> Persistent events run standalone in the system without the need of a
> controlling process that holds an event's file descriptor. The events
> are always enabled and collect data samples in a ring buffer.
> Processes may connect to existing persistent events using the
> perf_event_open() syscall. For this the syscall must be configured
> using the new PERF_TYPE_PERSISTENT event type and a unique event
> identifier specified in attr.config. The id is propagated in sysfs or
> using ioctl (see below).
>
> Persistent event buffers may be accessed with mmap() in the same way
> as for any other event. Since the buffers may be used by multiple
> processes at the same time, there is only read-only access to them.
> Currently there is only support for per-cpu events, thus root access
> is needed too.
>
> Persistent events are visible in sysfs. They are added or removed
> dynamically. With the information in sysfs userland knows about how to
> setup the perf_event attribute of a persistent event. Since a
> persistent event always has the persistent flag set, a way is needed
> to express this in sysfs. A new syntax is used for this. With
> 'attr<num>:<mask>' any bit in the attribute structure may be set in a
> similar way as using 'config<num>', but <num> is an index that points
> to the u64 value to change within the attribute.
>
> For persistent events the persistent flag (bit 24 of flag field in
> struct perf_event_attr) needs to be set which is expressed in sysfs
> with "attr5:24". E.g. the mce_record event is described in sysfs as
> follows:
>
>  /sys/bus/event_source/devices/persistent/events/mce_record:persistent,config=106
>  /sys/bus/event_source/devices/persistent/format/persistent:attr5:24
>
> Note that perf tools need to support the 'attr<num>' syntax that is
> added in a separate patch set. With it we are able to run perf tool
> commands to read persistent events, e.g.:
>
>  # perf record -e persistent/mce_record/ sleep 10
>  # perf top -e persistent/mce_record/
>
> In general the new syntax is flexible to describe with sysfs any event
> to be setup by perf tools.
>
> There are ioctl functions to control persistent events that can be
> used to detach or attach an event to or from a process. The
> PERF_EVENT_IOC_UNCLAIM ioctl call makes an event persistent. The
> perf_event_open() syscall can be used to re-open the event by any
> process. The PERF_EVENT_IOC_CLAIM ioctl attaches the event again so
> that it is removed after closing the event's fd.
>
> The patches base on the originally work from Borislav Petkov.
>
> This version 3 of the patch set is a complete rework of the code.
> There are the following major changes:
>
>  * new event type PERF_TYPE_PERSISTENT introduced,
>
>  * support for all type of events,
>
>  * unique event ids,
>
>  * improvements in reference counting and locking,
>
>  * ioctl functions are added to control persistency,
>
>  * the sysfs implementation now uses variable list size.
>
> This should address most issues discussed during last review of
> version 2. The following is unresolved yet and can be added later on
> top of this patches, if necessary:
>
>  * support for per-task events (also allowing non-root access),
>
>  * creation of persistent events for disabled cpus,
>
>  * make event persistent with already open (mmap'ed) buffers,
>
>  * make event persistent while creating it.
>
> First patches contain some rework of the perf mmap code to reuse it
> for persistent events.
>
> Also note that patch 12 (ioctl functions to control persistency) is
> RFC and untested. A perf tools implementation for this is missing and
> some ideas are needed how this could be integrated, esp. in something
> like perf trace or so.
>
> All v3 patches can be found here:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git persistent-v3
>
> Note: I will resent the perf tools patch necessary to use persistent
> events.
>
> -Robert
>
>
> Borislav Petkov (1):
>   mce, x86: Enable persistent events
>
> Robert Richter (15):
>   perf, mmap: Factor out ring_buffer_detach_all()
>   perf, mmap: Factor out try_get_event()/put_event()
>   perf, mmap: Factor out perf_alloc/free_rb()
>   perf, mmap: Factor out perf_get_fd()
>   perf: Add persistent events
>   perf, persistent: Implementing a persistent pmu
>   perf, persistent: Exposing persistent events using sysfs
>   perf, persistent: Use unique event ids
>   perf, persistent: Implement reference counter for events
>   perf, persistent: Dynamically resize list of sysfs entries
>   perf, persistent: ioctl functions to control persistency
>   perf tools: Rename flex conditions to avoid name conflicts
>   perf tools: Modify event parser to update event attribute by index
>   perf tools: Add attr<num> syntax to event parser
>   perf tools: Retry mapping buffers readonly on EACCES
>
>  .../testing/sysfs-bus-event_source-devices-format  |  43 +-
>  arch/x86/kernel/cpu/mcheck/mce.c                   |  19 +
>  include/linux/perf_event.h                         |  12 +-
>  include/uapi/linux/perf_event.h                    |   6 +-
>  kernel/events/Makefile                             |   2 +-
>  kernel/events/core.c                               | 214 +++++---
>  kernel/events/internal.h                           |  20 +
>  kernel/events/persistent.c                         | 563 +++++++++++++++++++++
>  tools/perf/builtin-record.c                        |  11 +-
>  tools/perf/builtin-top.c                           |   8 +-
>  tools/perf/perf.h                                  |   1 +
>  tools/perf/tests/parse-events.c                    |  12 +-
>  tools/perf/util/parse-events.c                     |  59 +--
>  tools/perf/util/parse-events.h                     |  12 +-
>  tools/perf/util/parse-events.l                     |  58 ++-
>  tools/perf/util/parse-events.y                     |  24 +-
>  tools/perf/util/pmu.c                              |  32 +-
>  tools/perf/util/pmu.h                              |   9 +-
>  tools/perf/util/pmu.l                              |   1 +
>  tools/perf/util/pmu.y                              |  18 +-
>  20 files changed, 911 insertions(+), 213 deletions(-)
>  create mode 100644 kernel/events/persistent.c
>
> --
> 1.7.11.7
>
