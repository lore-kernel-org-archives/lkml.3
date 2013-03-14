Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab3CNSjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 14:39:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab3CNSjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 14:39:08 -0400
Date: Thu, 14 Mar 2013 15:38:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-edac@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        "Mark A. Grondona" <mgrondona@llnl.gov>
Subject: [ANNOUNCE] rasdaemon userspace tool v.0.1
Message-ID: <20130314153844.158d817c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Kernel 3.5 we've started to address the long-discussed need of having a
better way to handle platform Reliability, Availability and Serviceability
(RAS).

Basically, a tracepoint event that handles memory errors called ras:mc_event
was added there, together with HERM/EDAC version 3.0 patches.

In Kernel 3.8, a new event was added, to handle PCIe AER events (ras:aer_event)
[1].

On kernel 3.9, a new driver was added to report hardware memory errors that
comes from the BIOS via ras:mc_event (the new ghes_edac driver).

It is still on my TODO list to add a RAS trace event for non-memory related
errors that come via the MCA machine check handler (mcelog).

While progress made was made at Kernel infrastructure, the needed userspace
tools were still lacking. So, I decided to start materializing the userspace
counterpart for what it was informally named as rasdaemon on some discussions.

The rasdaemon tool is available	at: 
	http://git.infradead.org/users/mchehab/rasdaemon.git

The current version is on very early stages, and it has a copy on it of
the library that Steven Rostedt's is writing for trace-cmd tool. The plan
is to use the trace-cmd library, when it starts to packaged as a separate
library. I'd like to thanks Steven for the help he gave me to write this 
initial version.

The current version of the tool enables the ras:mc_event log, and reads
it via the raw trace debugfs node:
	/sys/kernel/debug/tracing/per_cpu/cpu*/trace_pipe_raw

It also has a code that allows recording the errors via an sqlite3 database.

The long term plan is to provide a tool that will catch and handle all
ras:* error events that comes from the Kernel tracing infrastructure,
logging them and providing tools to report it, being able to detect burst
errors (like the ones caused by a solar storm at memories) or sparsed errors,
in a way that would provide a glue to the users about the root cause of the
error.

Of course, there are much to do there.

It is a natural evolution of the tool to add support there for the 
ras:aer_event traces that can come from PCIe AER.

While it currently works with current Kernels since kernel 3.5, there are a
number of interesting changes at tracing that are planned to be merged for
Kernel 3.10:
	- poll() support for per_cpu trace_pipe_raw;
	- a timestamp that could more easily associated with machine's
	  uptime;
	- support for a separate ringbuffer for RAS.

So, it is planned the minimal requirement for the final version (v1.0)
would be kernel 3.10.

This is currently on very early staging. Help is needed ;)

So, please send us suggestions, patches etc to the EDAC mailing list:
	linux-edac@vger.kernel.org

Thanks!
Mauro

-

[1] Currently, ras:mc_event is at include/ras/. It is on my todo list
to move it to be together with ras:aer_event, at include/trace/events/ras.h.
