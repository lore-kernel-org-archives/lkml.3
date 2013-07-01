Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab3GAWeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:34:21 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:33395 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab3GAWeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:34:19 -0400
MIME-Version: 1.0
In-Reply-To: <CANiYik6PbwRkH1vK4B4cFhY0MEJAoF=MBggkvgBYGfyCw2ny-w@mail.gmail.com>
References: <CANiYik6PbwRkH1vK4B4cFhY0MEJAoF=MBggkvgBYGfyCw2ny-w@mail.gmail.com>
From: Alexander Lam <azl@google.com>
Date: Mon, 1 Jul 2013 15:33:58 -0700
Message-ID: <CANiYik6h0_xnUYqCRHZU75az9YS=ySUHaqgMayW-Ffj5Jey6_g@mail.gmail.com>
Subject: Fwd: [draft] Tracing multibuffer support concurrency issues
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Lam <lambchop468@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I noticed that a695cb58 "tracing: Prevent deleting instances when they
are being read" [1] still leaves open the possibility of the
trace_array being deleted before the reference counter is incremented.

Thread A creates a new instance "foo", then tries to open "foo/trace"
for writing, which invokes tracing_open() and __tracing_open()
Thread B removes the "foo" instance. Since Thread A has not
incremented the reference counter for the trace_array representing
"foo," its trace_array and associated structures are freed in
instance_delete().
Thread A now attempts to dereference the trace_cpu pointer it has to
obtain the now deleted trace_array. By now, both the trace_cpu and
trace_array are deleted.

Here's a short bash script to run on a kernel to make it crash like this:
   $ cd /sys/kernel/debug/tracing/instances/
   $ ( while true; do mkdir foo; rmdir foo; done ) &
   $ ( while true; do cat foo/trace &> /dev/null; done) &

To fix this we could go through the ftrace_trace_arrays list and use
addresses to check if a particular pointer to a trace_array is still
valid, but this is vulnerable to the ABA problem if a trace_array is
freed and another is reallocated at the same address. This method is
used by subsystem_open() in trace_events.c

An ugly way to get around the ABA issue is to use a monotonically
increasing ID # for each trace_array instance. Those IDs could be used
instead of pointers when creating debugfs files.

Is there a better way to fix this problem?

Also unaddressed are all of the other files which use a trace_array,
trace_cpu, or ftrace_event_file in their operation - these would need
the same fix.

- Alex

[1] https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/kernel/trace/trace.c?id=a695cb5816228f86576f5f5c6809fdf8ed382ece
