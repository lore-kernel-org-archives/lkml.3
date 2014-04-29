Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbaD2SvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:51:22 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:38342 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbaD2SvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:51:21 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH man-pages v1] fcntl.2: update manpage with verbiage about open file description locks
Date: Tue, 29 Apr 2014 14:51:14 -0400
Message-Id: <1398797474-744-1-git-send-email-jlayton@poochiereds.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@poochiereds.net>
---
 man2/fcntl.2 | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 109 insertions(+), 3 deletions(-)

diff --git a/man2/fcntl.2 b/man2/fcntl.2
index d0154a6d9f42..8d119dfec24c 100644
--- a/man2/fcntl.2
+++ b/man2/fcntl.2
@@ -191,6 +191,9 @@ and
 .BR O_SYNC
 flags; see BUGS, below.
 .SS Advisory locking
+This section describes traditional POSIX record locks. Also see the section on
+open file description locks below.
+.PP
 .BR F_SETLK ,
 .BR F_SETLKW ,
 and
@@ -213,7 +216,8 @@ struct flock {
     off_t l_start;   /* Starting offset for lock */
     off_t l_len;     /* Number of bytes to lock */
     pid_t l_pid;     /* PID of process blocking our lock
-                        (F_GETLK only) */
+                        (returned for F_GETLK and F_OFD_GETLK only. Set
+                         to 0 for open file description locks) */
     ...
 };
 .fi
@@ -349,9 +353,13 @@ returns details about one of these locks in the
 .IR l_type ", " l_whence ", " l_start ", and " l_len
 fields of
 .I lock
-and sets
+.
+If the conflicting lock is a traditional POSIX lock, then the
+.I l_pid
+to be the PID of the process holding that lock. If the
+conflicting lock is an open file description lock, then the
 .I l_pid
-to be the PID of the process holding that lock.
+will be set to \-1.
 Note that the information returned by
 .BR F_GETLK
 may already be out of date by the time the caller inspects it.
@@ -394,6 +402,104 @@ should be avoided; use
 and
 .BR write (2)
 instead.
+.SS Open file description locks (non-POSIX)
+.BR F_OFD_GETLK ", " F_OFD_SETLK " and  " F_OFD_SETLKW
+are used to acquire, release and test open file description record locks.
+These are byte-range locks that work identically to the traditional advisory
+record locks described above, but are associated with the open file description
+on which they were acquired rather than the process, much like locks acquired
+with
+.BR flock (2)
+.
+.PP
+Unlike traditional advisory record locks, these locks are inherited
+across
+.BR fork (2)
+and
+.BR clone (2)
+with
+.BR CLONE_FILES
+and are only released on the last close of the open file description instead
+of being released on any close of the file.
+.PP
+Open file description locks always conflict with traditional record locks,
+even when they are acquired by the same process on the same file descriptor.
+They only conflict with each other when they are acquired on different
+open file descriptions.
+.PP
+Note that in contrast to traditional record locks, the
+.I flock
+structure passed in as an argument to the open file description lock commands
+must have the
+.I l_pid
+value set to 0.
+.TP
+.BR F_OFD_SETLK " (\fIstruct flock *\fP)"
+Acquire an open file description lock (when
+.I l_type
+is
+.B F_RDLCK
+or
+.BR F_WRLCK )
+or release an open file description lock (when
+.I l_type
+is
+.BR F_UNLCK )
+on the bytes specified by the
+.IR l_whence ", " l_start ", and " l_len
+fields of
+.IR lock .
+If a conflicting lock is held by another process,
+this call returns \-1 and sets
+.I errno
+to
+.B EACCES
+or
+.BR EAGAIN .
+.TP
+.BR F_OFD_SETLKW " (\fIstruct flock *\fP)"
+As for
+.BR F_OFD_SETLK ,
+but if a conflicting lock is held on the file, then wait for that lock to be
+released. If a signal is caught while waiting, then the call is interrupted
+and (after the signal handler has returned) returns immediately (with return
+value \-1 and
+.I errno
+set to
+.BR EINTR ;
+see
+.BR signal (7)).
+.TP
+.BR F_OFD_GETLK " (\fIstruct flock *\fP)"
+On input to this call,
+.I lock
+describes an open file description lock we would like to place on the file.
+If the lock could be placed,
+.BR fcntl ()
+does not actually place it, but returns
+.B F_UNLCK
+in the
+.I l_type
+field of
+.I lock
+and leaves the other fields of the structure unchanged.
+If one or more incompatible locks would prevent
+this lock being placed, then
+.BR fcntl ()
+returns details about one of these locks in the
+.IR l_type ", " l_whence ", " l_start ", and " l_len
+fields of
+.I lock
+.
+If the conflicting lock is a process-associated record lock, then the
+.I l_pid
+will be set to the PID of the process holding that lock. If the
+conflicting lock is an open file description lock, then the
+.I l_pid
+will be set to -1 to indicate that it is not associated with a process.
+Note that the information returned by
+.BR F_OFD_GETLK
+may already be out of date by the time the caller inspects it.
 .SS Mandatory locking
 (Non-POSIX.)
 The above record locks may be either advisory or mandatory,
-- 
1.9.0

