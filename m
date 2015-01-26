Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbbAZPNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:13:48 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:41745 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752845AbbAZPKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:10:02 -0500
Message-Id: <20150126150913.653681560@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 26 Jan 2015 10:09:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/16 v3] tracing: Add new file system tracefs
X-RR-Connecting-IP: 107.14.168.118:25
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

Changes from v2:

 o Al Viro wrote a series of patches to create "debugfs_create_automount()"
   that gives us a safe way to modify the debugfs dentry to add
   automounting. tracefs now uses this function to automount itself
   on the debugfs/tracing directory.

Changes from v1:

 o Fixed all the posting problems (included files that were missing
   and removed changes that were not suppose to be there).

 o Changed the mkdir/rmdir logic. Instead of trying to keep the inode
   mutexes locked, which caused locking issues with other locks that
   were taken, the locks are still released. But this time, they are
   released by the tracefs system which has a bit more control.
   As the mkdir/rmdir methods for the tracing facility only need the
   new name of the instance, the tracefs mkdir/rmdir copies the name
   from the dentry, releases the locks, and passes in the copy to
   the tracing methods.


Al Viro (11):
      debugfs_{mkdir,create,link}(): get rid of redundant argument
      debugfs: split the beginning and the end of __create_file() off
      debugfs: kill __create_file()
      fold debugfs_link() into caller
      debugfs_mknod(): get rid useless arguments
      fold debugfs_mkdir() into caller
      fold debugfs_create() into caller
      fold debugfs_mknod() into callers
      debugfs: take mode-dependent parts of debugfs_get_inode() into callers
      debugfs: split end_creating() into success and failure cases
      new primitive: debugfs_create_automount()

Steven Rostedt (Red Hat) (5):
      tracefs: Add new tracefs file system
      tracing: Convert the tracing facility over to use tracefs
      tracing: Automatically mount tracefs on debugfs/tracing
      tracefs: Add directory /sys/kernel/tracing
      tracing: Have mkdir and rmdir be part of tracefs

----
 fs/Makefile                          |   1 +
 fs/debugfs/inode.c                   | 251 ++++++-------
 fs/tracefs/Makefile                  |   4 +
 fs/tracefs/inode.c                   | 658 +++++++++++++++++++++++++++++++++++
 include/linux/debugfs.h              |   5 +
 include/linux/tracefs.h              |  48 +++
 include/uapi/linux/magic.h           |   2 +
 kernel/trace/ftrace.c                |  22 +-
 kernel/trace/trace.c                 | 161 ++++-----
 kernel/trace/trace.h                 |   2 +-
 kernel/trace/trace_events.c          |  32 +-
 kernel/trace/trace_functions_graph.c |   7 +-
 kernel/trace/trace_kprobe.c          |  10 +-
 kernel/trace/trace_probe.h           |   2 +-
 kernel/trace/trace_stat.c            |  10 +-
 15 files changed, 962 insertions(+), 253 deletions(-)
