Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaECNdm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 09:33:42 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:47773 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaECNdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 09:33:37 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: libc-alpha@sourceware.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Rich Felker <dalias@libc.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Stefan Metzmacher <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>,
        Boaz Harrosh <bharrosh@panasas.com>, "Alfred M. Szmidt" <ams@gnu.org>
Subject: [glibc PATCH v4 resend] fcntl-linux.h: add new definitions and manual updates for open file description locks
Date: Sat,  3 May 2014 09:33:24 -0400
Message-Id: <1399124004-5535-1-git-send-email-jlayton@poochiereds.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398348589-16096-1-git-send-email-jlayton@redhat.com>
References: <1398348589-16096-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Open file description locks have been merged into the Linux kernel for
v3.15.  Add the appropriate command-value definitions and an update to
the manual that describes their usage.

ChangeLog:

2014-04-24  Jeff Layton  <jlayton@poochiereds.net>

	[BZ#16839]
	* manual/llio.texi: add section about open file description locks

	* sysdeps/unix/sysv/linux/bits/fcntl-linux.h:
	  (F_OFD_GETLK, F_OFD_SETLK, F_OFD_SETLKW): New macros.
---
 manual/examples/ofdlocks.c                 |  77 +++++++++
 manual/llio.texi                           | 241 ++++++++++++++++++++++++++++-
 sysdeps/unix/sysv/linux/bits/fcntl-linux.h |  17 ++
 3 files changed, 332 insertions(+), 3 deletions(-)
 create mode 100644 manual/examples/ofdlocks.c

diff --git a/manual/examples/ofdlocks.c b/manual/examples/ofdlocks.c
new file mode 100644
index 000000000000..85e193cdabe6
--- /dev/null
+++ b/manual/examples/ofdlocks.c
@@ -0,0 +1,77 @@
+/* Open File Description Locks Usage Example
+   Copyright (C) 1991-2014 Free Software Foundation, Inc.
+
+   This program is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License
+   as published by the Free Software Foundation; either version 2
+   of the License, or (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, see <http://www.gnu.org/licenses/>.
+*/
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <pthread.h>
+
+#define FILENAME	"/tmp/foo"
+#define NUM_THREADS	3
+#define ITERATIONS	5
+
+void *
+thread_start (void *arg)
+{
+  int i, fd, len;
+  long tid = (long) arg;
+  char buf[256];
+  struct flock lck = {
+    .l_whence = SEEK_SET,
+    .l_start = 0,
+    .l_len = 1,
+  };
+
+  fd = open ("/tmp/foo", O_RDWR | O_CREAT, 0666);
+
+  for (i = 0; i < ITERATIONS; i++)
+    {
+      lck.l_type = F_WRLCK;
+      fcntl (fd, F_OFD_SETLKW, &lck);
+
+      len = sprintf (buf, "%d: tid=%ld fd=%d\n", i, tid, fd);
+
+      lseek (fd, 0, SEEK_END);
+      write (fd, buf, len);
+      fsync (fd);
+
+      lck.l_type = F_UNLCK;
+      fcntl (fd, F_OFD_SETLK, &lck);
+
+      /* sleep to ensure lock is yielded to another thread */
+      usleep (1);
+    }
+  pthread_exit (NULL);
+}
+
+int
+main (int argc, char **argv)
+{
+  long i;
+  pthread_t threads[NUM_THREADS];
+
+  truncate (FILENAME, 0);
+
+  for (i = 0; i < NUM_THREADS; i++)
+    pthread_create (&threads[i], NULL, thread_start, (void *) i);
+
+  pthread_exit (NULL);
+  return 0;
+}
diff --git a/manual/llio.texi b/manual/llio.texi
index 6f8adfc607d7..864060dc7140 100644
--- a/manual/llio.texi
+++ b/manual/llio.texi
@@ -57,6 +57,10 @@ directly.)
                                          flags associated with open files.
 * File Locks::                          Fcntl commands for implementing
                                          file locking.
+* Open File Description Locks::         Fcntl commands for implementing
+                                         open file description locking.
+* Open File Description Locks Example:: An example of open file description lock
+                                         usage
 * Interrupt Input::                     Getting an asynchronous signal when
                                          input arrives.
 * IOCTLs::                              Generic I/O Control operations.
@@ -2890,7 +2894,7 @@ Get flags associated with the open file.  @xref{File Status Flags}.
 Set flags associated with the open file.  @xref{File Status Flags}.
 
 @item F_GETLK
-Get a file lock.  @xref{File Locks}.
+Test a file lock.  @xref{File Locks}.
 
 @item F_SETLK
 Set or clear a file lock.  @xref{File Locks}.
@@ -2898,6 +2902,18 @@ Set or clear a file lock.  @xref{File Locks}.
 @item F_SETLKW
 Like @code{F_SETLK}, but wait for completion.  @xref{File Locks}.
 
+@item F_OFD_GETLK
+Test an open file description lock.  @xref{Open File Description Locks}.
+Specific to Linux.
+
+@item F_OFD_SETLK
+Set or clear an open file description lock.  @xref{Open File Description Locks}.
+Specific to Linux.
+
+@item F_OFD_SETLKW
+Like @code{F_OFD_SETLK}, but block until lock is acquired.
+@xref{Open File Description Locks}.  Specific to Linux.
+
 @item F_GETOWN
 Get process or process group ID to receive @code{SIGIO} signals.
 @xref{Interrupt Input}.
@@ -3576,6 +3592,10 @@ set_nonblock_flag (int desc, int value)
 
 @cindex file locks
 @cindex record locking
+This section describes record locks that are associated with the process.
+There is also a different type of record lock that is associated with the
+open file description instead of the process.  @xref{Open File Description Locks}.
+
 The remaining @code{fcntl} commands are used to support @dfn{record
 locking}, which permits multiple cooperating programs to prevent each
 other from simultaneously accessing parts of a file in error-prone
@@ -3641,7 +3661,10 @@ the file.
 @item pid_t l_pid
 This field is the process ID (@pxref{Process Creation Concepts}) of the
 process holding the lock.  It is filled in by calling @code{fcntl} with
-the @code{F_GETLK} command, but is ignored when making a lock.
+the @code{F_GETLK} command, but is ignored when making a lock.  If the
+conflicting lock is an open file description lock
+(@pxref{Open File Description Locks}), then this field will be set to
+@math{-1}.
 @end table
 @end deftp
 
@@ -3813,10 +3836,222 @@ that part of the file for writing.
 
 @c ??? This section could use an example program.
 
-Remember that file locks are only a @emph{voluntary} protocol for
+Remember that file locks are only an @emph{advisory} protocol for
 controlling access to a file.  There is still potential for access to
 the file by programs that don't use the lock protocol.
 
+@node Open File Description Locks
+@section Open File Description Locks
+
+In contrast to process-associated record locks (@pxref{File Locks}),
+open file description record locks are associated with an open file
+description rather than a process.
+
+Using @code{fcntl} to apply an open file description lock on a region that
+already has an existing open file description lock that was created via the
+same file descriptor will never cause a lock conflict.
+
+Open file description locks are also inherited by child processes across
+@code{fork}, or @code{clone} with @code{CLONE_FILES} set
+(@pxref{Creating a Process}), along with the file descriptor.
+
+It is important to distinguish between the open file @emph{description} (an
+instance of an open file, usually created by a call to @code{open}) and
+an open file @emph{descriptor}, which is a numeric value that refers to the
+open file description.  The locks described here are associated with the
+open file @emph{description} and not the open file @emph{descriptor}.
+
+Using @code{dup} (@pxref{Duplicating Descriptors}) to copy a file
+descriptor does not give you a new open file description, but rather copies a
+reference to an existing open file description and assigns it to a new
+file descriptor.  Thus, open file description locks set on a file
+descriptor cloned by @code{dup} will never conflict with open file
+description locks set on the original descriptor since they refer to the
+same open file description.  Depending on the range and type of lock
+involved, the original lock may be modified by a @code{F_OFD_SETLK} or
+@code{F_OFD_SETLKW} command in this situation however.
+
+Open file description locks always conflict with process-associated locks,
+even if acquired by the same process or on the same open file
+descriptor.
+
+Open file description locks use the same @code{struct flock} as
+process-associated locks as an argument (@pxref{File Locks}) and the
+macros for the @code{command} values are also declared in the header file
+@file{fcntl.h}. To use them, the macro @code{_GNU_SOURCE} must be
+defined prior to including any header file.
+
+In contrast to process-associated locks, any @code{struct flock} used as
+an argument to open file description lock commands must have the @code{l_pid}
+value set to @math{0}.  Also, when returning information about an
+open file description lock in a @code{F_GETLK} or @code{F_OFD_GETLK} request,
+the @code{l_pid} field in @code{struct flock} will be set to @math{-1}
+to indicate that the lock is not associated with a process.
+
+When the same @code{struct flock} is reused as an argument to a
+@code{F_OFD_SETLK} or @code{F_OFD_SETLKW} request after being used for an
+@code{F_OFD_GETLK} request, it is necessary to inspect and reset the
+@code{l_pid} field to @math{0}.
+
+@pindex fcntl.h.
+
+@deftypevr Macro int F_OFD_GETLK
+This macro is used as the @var{command} argument to @code{fcntl}, to
+specify that it should get information about a lock.  This command
+requires a third argument of type @w{@code{struct flock *}} to be passed
+to @code{fcntl}, so that the form of the call is:
+
+@smallexample
+fcntl (@var{filedes}, F_OFD_GETLK, @var{lockp})
+@end smallexample
+
+If there is a lock already in place that would block the lock described
+by the @var{lockp} argument, information about that lock is written to
+@code{*@var{lockp}}.  Existing locks are not reported if they are
+compatible with making a new lock as specified.  Thus, you should
+specify a lock type of @code{F_WRLCK} if you want to find out about both
+read and write locks, or @code{F_RDLCK} if you want to find out about
+write locks only.
+
+There might be more than one lock affecting the region specified by the
+@var{lockp} argument, but @code{fcntl} only returns information about
+one of them. Which lock is returned in this situation is undefined.
+
+The @code{l_whence} member of the @var{lockp} structure are set to
+@code{SEEK_SET} and the @code{l_start} and @code{l_len} fields are set
+to identify the locked region.
+
+If no conflicting lock exists, the only change to the @var{lockp} structure
+is to update the @code{l_type} field to the value @code{F_UNLCK}.
+
+The normal return value from @code{fcntl} with this command is either @math{0}
+on success or @math{-1}, which indicates an error. The following @code{errno}
+error conditions are defined for this command:
+
+@table @code
+@item EBADF
+The @var{filedes} argument is invalid.
+
+@item EINVAL
+Either the @var{lockp} argument doesn't specify valid lock information,
+the operating system kernel doesn't support open file description locks, or the file
+associated with @var{filedes} doesn't support locks.
+@end table
+@end deftypevr
+
+@comment fcntl.h
+@comment POSIX.1
+@deftypevr Macro int F_OFD_SETLK
+This macro is used as the @var{command} argument to @code{fcntl}, to
+specify that it should set or clear a lock.  This command requires a
+third argument of type @w{@code{struct flock *}} to be passed to
+@code{fcntl}, so that the form of the call is:
+
+@smallexample
+fcntl (@var{filedes}, F_OFD_SETLK, @var{lockp})
+@end smallexample
+
+If the open file already has a lock on any part of the
+region, the old lock on that part is replaced with the new lock.  You
+can remove a lock by specifying a lock type of @code{F_UNLCK}.
+
+If the lock cannot be set, @code{fcntl} returns immediately with a value
+of @math{-1}.  This command does not wait for other tasks
+to release locks.  If @code{fcntl} succeeds, it returns @math{0}.
+
+The following @code{errno} error conditions are defined for this
+command:
+
+@table @code
+@item EAGAIN
+The lock cannot be set because it is blocked by an existing lock on the
+file.
+
+@item EBADF
+Either: the @var{filedes} argument is invalid; you requested a read lock
+but the @var{filedes} is not open for read access; or, you requested a
+write lock but the @var{filedes} is not open for write access.
+
+@item EINVAL
+Either the @var{lockp} argument doesn't specify valid lock information,
+the operating system kernel doesn't support open file description locks, or the
+file associated with @var{filedes} doesn't support locks.
+
+@item ENOLCK
+The system has run out of file lock resources; there are already too
+many file locks in place.
+
+Well-designed file systems never report this error, because they have no
+limitation on the number of locks.  However, you must still take account
+of the possibility of this error, as it could result from network access
+to a file system on another machine.
+@end table
+@end deftypevr
+
+@comment fcntl.h
+@comment POSIX.1
+@deftypevr Macro int F_OFD_SETLKW
+This macro is used as the @var{command} argument to @code{fcntl}, to
+specify that it should set or clear a lock.  It is just like the
+@code{F_OFD_SETLK} command, but causes the process to wait until the request
+can be completed.
+
+This command requires a third argument of type @code{struct flock *}, as
+for the @code{F_OFD_SETLK} command.
+
+The @code{fcntl} return values and errors are the same as for the
+@code{F_OFD_SETLK} command, but these additional @code{errno} error conditions
+are defined for this command:
+
+@table @code
+@item EINTR
+The function was interrupted by a signal while it was waiting.
+@xref{Interrupted Primitives}.
+
+@end table
+@end deftypevr
+
+Open file description locks are useful in the same sorts of situations as
+process-associated locks. They can also be used to synchronize file
+access between threads within the same process by having each thread perform
+its own @code{open} of the file, to obtain its own open file description.
+
+Because open file description locks are automatically freed only upon
+closing the last file descriptor that refers to the open file
+description, this locking mechanism avoids the possibility that locks
+are inadvertently released due to a library routine opening and closing
+a file without the application being aware.
+
+As with process-associated locks, open file description locks are advisory.
+
+@node Open File Description Locks Example
+@section Open File Description Locks Example
+
+Here is an example of using open file description locks in a threaded
+program. If this program used process-associated locks, then it would be
+subject to data corruption because process-associated locks are shared
+by the threads inside a process, and thus cannot be used by one thread
+to lock out another thread in the same process.
+
+Proper error handling has been omitted in the following program for
+brevity.
+
+@smallexample
+@include ofdlocks.c.texi
+@end smallexample
+
+This example creates three threads each of which loops five times,
+appending to the file.  Access to the file is serialized via open file
+description locks. If we compile and run the above program, we'll end up
+with /tmp/foo that has 15 lines in it.
+
+If we, however, were to replace the @code{F_OFD_SETLK} and
+@code{F_OFD_SETLKW} commands with their process-associated lock
+equivalents, the locking essentially becomes a noop since it is all done
+within the context of the same process. That leads to data corruption
+(typically manifested as missing lines) as some threads race in and
+overwrite the data written by others.
+
 @node Interrupt Input
 @section Interrupt-Driven Input
 
diff --git a/sysdeps/unix/sysv/linux/bits/fcntl-linux.h b/sysdeps/unix/sysv/linux/bits/fcntl-linux.h
index 915eb3ede560..455389cd2c2a 100644
--- a/sysdeps/unix/sysv/linux/bits/fcntl-linux.h
+++ b/sysdeps/unix/sysv/linux/bits/fcntl-linux.h
@@ -117,6 +117,23 @@
 # define F_SETLKW64	14	/* Set record locking info (blocking).	*/
 #endif
 
+/* open file description locks.
+
+   Usually record locks held by a process are released on *any* close and are
+   not inherited across a fork.
+
+   These cmd values will set locks that conflict with process-associated record
+   locks, but are "owned" by the opened file description, not the process.
+   This means that they are inherited across fork or clone with CLONE_FILES
+   like BSD (flock) locks, and they are only released automatically when the
+   last reference to the the file description against which they were acquired
+   is put. */
+#if __USE_GNU
+# define F_OFD_GETLK	36
+# define F_OFD_SETLK	37
+# define F_OFD_SETLKW	38
+#endif
+
 #ifdef __USE_LARGEFILE64
 # define O_LARGEFILE __O_LARGEFILE
 #endif
-- 
1.9.0

