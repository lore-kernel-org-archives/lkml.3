Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbbAURV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:21:26 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:51265 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753002AbbAURVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:21:03 -0500
Message-Id: <20150121171953.823177070@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 21 Jan 2015 12:19:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 0/5] tracing: Add new file system tracefs
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There has been complaints that tracing is tied too much to debugfs,
as there are systems that would like to perform tracing, but do
not mount debugfs for security reasons. That is because any subsystem
may use debugfs for debugging, and these interfaces are not always
tested for security.

Creating a new tracefs that the tracing directory will now be attached
to allows system admins the ability to access the tracing directory
without the need to mount debugfs.

Another advantage is that debugfs does not support the system calls
for mkdir and rmdir. Tracing uses these system calls to create new
instances for sub buffers. This was done by a hack that hijacked the
dentry ops from the "instances" debugfs dentry, and replacing it with
one that could work.

Instead of using this hack, tracefs can provide a proper interface to
allow the tracing system to have a mkdir and rmdir feature.

To maintain backward compatibility with older tools that expect that
the tracing directory is mounted with debugfs, the tracing directory
is still created under debugfs and tracefs is automatically mounted
there.

Finally, a new directory is created when tracefs is enabled called
/sys/kernel/tracing. This will be the new location that system admins
may mount tracefs if they are not using debugfs.


Steven Rostedt (Red Hat) (5):
      tracefs: Add new tracefs file system
      tracing: Convert the tracing facility over to use tracefs
      tracing: Automatically mount tracefs on debugfs/tracing
      tracing: Have mkdir and rmdir be part of tracefs
      tracefs: Add directory /sys/kernel/tracing

----
 fs/Makefile                          |   1 +
 fs/tracefs/Makefile                  |   4 +
 fs/tracefs/inode.c                   | 649 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/magic.h           |   2 +
 kernel/trace/ftrace.c                |  22 +-
 kernel/trace/trace.c                 | 178 +++++-----
 kernel/trace/trace.h                 |   2 +-
 kernel/trace/trace_events.c          |  32 +-
 kernel/trace/trace_functions_graph.c |   7 +-
 kernel/trace/trace_kprobe.c          |  10 +-
 kernel/trace/trace_probe.h           |   2 +-
 kernel/trace/trace_stat.c            |  10 +-
 scripts/tags.sh                      |   2 +-
 13 files changed, 789 insertions(+), 132 deletions(-)
