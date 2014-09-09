Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaIITBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:01:36 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:44875 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaIITBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:01:34 -0400
MIME-Version: 1.0
In-Reply-To: <1410283953-16822-1-git-send-email-andi@firstfloor.org>
References: <1410283953-16822-1-git-send-email-andi@firstfloor.org>
Date: Tue, 9 Sep 2014 21:01:34 +0200
Message-ID: <CABPqkBSy4ov9+=-iEKe=r7EWGL8Rd6vWgoLewD6tkFoKimrY5A@mail.gmail.com>
Subject: Re: [PATCH] Add some documentation on the perf sysfs ABI interface
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <ak@linux.intel.com>,
        Vince Weaver <vincent.weaver@maine.edu>, Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 7:32 PM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Initial attempt of documenting the perf sysfs interface as
> an ABI. I also added some additional pointers hopefully useful
> to the users. Comments welcome.
>
> Cc: Vince Weaver <vincent.weaver@maine.edu>
> Cc: jolsa@redhat.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Documentation/ABI/stable/sysfs-devices-perf | 87 +++++++++++++++++++++++++++++
>  1 file changed, 87 insertions(+)
>  create mode 100644 Documentation/ABI/stable/sysfs-devices-perf
>
> diff --git a/Documentation/ABI/stable/sysfs-devices-perf b/Documentation/ABI/stable/sysfs-devices-perf
> new file mode 100644
> index 0000000..0b00c7c
> --- /dev/null
> +++ b/Documentation/ABI/stable/sysfs-devices-perf
> @@ -0,0 +1,87 @@
> +Perf events enumeration in sysfs
> +
> +The perf events subsystem exports the format of hardware performance
> +counter events supported by perf events. The events can be accessed
> +using the perf_event_open() syscall. Each directory represents
> +a PMU (Performance Monitoring Unit)
> +
> +What: /sys/devices/*/format/*
> +Description:
> +
> +Each file in format describes how to fill in an event attribute on the
> +current CPU for the perf_event_open syscall.  Multiple event
> +attributes may be overlapping and only be valid for some combination
> +of attributes (for example only for some event/umask combinations).
> +Most attributes are optional.
> +
> +Each field may have the following contents:
> +
> +CONFIG:START-END      Field contains of bits START-END in the perf_event_attr CONFIG field
> +CONFIG:BIT           Field consists of a single bit with index BIT in CONFIG field
> +
> +Valid CONFIG fields are config, config1, config2. These map to the respective 64bit words
> +in the struct perf_event_attr.
> +
> +Typical attributes on a x86 platform
> +
> +event          Set the 8 bit event code (required)
> +umask          Set the 8 bit umask. Event code and umask together select an hardware event.
> +cmask          Set the 8 bit counter Mask. Only increment counters when more than cmask
> +               events happen at the same time.

This is the wrong description for cmask. Here is a better one.

If cmask=N, then counts the number of core cycles in which the event
occurs at least N times (>= N).

> +inv            (1bit flag) Invert the event condition

Wrong description.

Only valid with cmask>=1. Invert the cmask condition. If cmask=N, then
counts the number of
core cycles in which the event occurs strictly less than N times (<N).

> +edge           (1bit flag) Only increment the event when the condition changes (starts happening)
> +any            (1bit flag) Count on both threads of a core
> +pc             (1bit flag) Toggle the PMi pins when the condition happens
> +
> +Attributes available on some x86 platforms:
> +
> +in_tx          (1bit flag) Only count in a hardware transaction.
> +in_tx_cp       (1bit flag) Undo counts inside transaction when transaction aborts.
> +ldlat          Set the load-use latency threshold for sampling loads.
> +               Note this is a load-use latency so includes pipeline delays.
> +offcore_rsp     Set an extra mask qualifying the type of offcore access.
> +               Only with OFFCORE_RESPONSE events
> +
> +For more details on the x86 attributes on Intel platforms please see
> +http://www.intel.com/sdm Volume 3, Chapter 18 and 19.  For more
> +details on the perf_event_attr struct please see the perf_event_open
> +manpage.
> +
> +What: /sys/devices/*/events/*
> +Description:
> +
> +Describe predefined events available in the CPU. Each file describes an event.
> +The format is attr=0xHEXNUM{,attr=0xHEXNUM}. Each attr is described in a config
> +file. Together all the attributes can be used to set up a valid event for the
> +perf_event_open syscall.
> +
> +Note typically only a small subset of the CPU events are described
> +Some more events are available through predefined classes in perf_event_attr.
> +
> +What: /sys/devices/*/type
> +Description:
> +
> +Contains a decimal number. The PMU type to fill into perf_event_attr in the
> +type field to select the correct PMU.
> +
> +What: /sys/devices/*/perf_event_mux_interval_ms
> +Description:
> +
> +Decimal number. Set the counter multiplexing interval in ms. When more
> +events are active than the hardware directly supports perf events
> +multiplexes the event. By default this is done on timer interrupts
> +(depending on the CONFIG_HZ setting) and not done while idle. This
> +allows to set a different frequency. Note that setting this may impact
> +idle time, as the event switches will wake up the CPUs now.
> +
> +What: /sys/devices/*/rdpmc
> +Description:
> +
> +[x86] When 1, allow the RDPMC instruction in user space to read performance
> +events that have been set up with perf.
> +
> +Users: perf (tools/perf/*)
> +The following libraries provide more user friendly interfaces:
> +       PAPI (http://icl.cs.utk.edu/papi/)
> +       libpfm4 (http://perfmon2.sourceforge.net/)
> +       jevents (http://github.com/andikleen/pmu-tools)
> --
> 1.9.3
>
