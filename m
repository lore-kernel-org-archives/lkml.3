Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbaAIOXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:23:38 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:48551 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502AbaAIOXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:23:15 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-man@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC] fcntl.2: update manpage with verbiage about file-private locks
Date: Thu,  9 Jan 2014 09:23:07 -0500
Message-Id: <1389277387-18530-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't merge this yet, as the kernel patches are still a work in
progress...

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 man2/fcntl.2 | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 94 insertions(+), 3 deletions(-)

diff --git a/man2/fcntl.2 b/man2/fcntl.2
index 72dcd7b..74c67b6 100644
--- a/man2/fcntl.2
+++ b/man2/fcntl.2
@@ -208,7 +208,7 @@ struct flock {
     off_t l_start;   /* Starting offset for lock */
     off_t l_len;     /* Number of bytes to lock */
     pid_t l_pid;     /* PID of process blocking our lock
-                        (F_GETLK only) */
+                        (F_GETLK and F_GETLKP only) */
     ...
 };
 .fi
@@ -344,9 +344,13 @@ returns details about one of these locks in the
 .IR l_type ", " l_whence ", " l_start ", and " l_len
 fields of
 .I lock
-and sets
+.
+If the conflicting lock is a traditional POSIX lock, then the
 .I l_pid
-to be the PID of the process holding that lock.
+will be set to the PID of the process holding that lock. If the
+conflicting lock is a file-private lock, then the
+.I l_pid
+will be set to -1.
 .P
 In order to place a read lock,
 .I fd
@@ -386,6 +390,93 @@ should be avoided; use
 and
 .BR write (2)
 instead.
+.SS File-private locking
+(Currently non-POSIX, but being proposed)
+.PP
+.BR F_GETLKP ", " F_SETLKP " and  " F_SETLKPW
+are used to acquire, release and test file-private record locks. These
+are byte-range locks that work identically to the traditional advisory
+record locks described above, but are associated with the open file on
+which they were acquired rather than the process, much like locks
+acquired with
+.BR flock (2)
+.
+.PP
+Unlike traditional advisory record locks, these locks are inherited
+across
+.BR fork (2) ", " dup (2) " and " dup2 (2)
+and are only released on the last close of the open file instead of being
+released on any close of the file.
+.PP
+File-private locks always conflict with traditional record locks, even
+when they are acquired by the same process on the same file descriptor.
+They only conflict with each other when they are acquired on different
+open file descriptors.
+.TP
+.BR F_SETLKP " (\fIstruct flock *\fP)"
+Acquire a lock (when
+.I l_type
+is
+.B F_RDLCK
+or
+.BR F_WRLCK )
+or release a lock (when
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
+.BR F_SETLKPW " (\fIstruct flock *\fP)"
+As for
+.BR F_SETLKP ,
+but if a conflicting lock is held on the file, then wait for that
+lock to be released.
+If a signal is caught while waiting, then the call is interrupted
+and (after the signal handler has returned)
+returns immediately (with return value \-1 and
+.I errno
+set to
+.BR EINTR ;
+see
+.BR signal (7)).
+.TP
+.BR F_GETLKP " (\fIstruct flock *\fP)"
+On input to this call,
+.I lock
+describes a lock we would like to place on the file.
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
+If the conflicting lock is a traditional POSIX lock, then the
+.I l_pid
+will be set to the PID of the process holding that lock. If the
+conflicting lock is a file-private lock, then the
+.I l_pid
+will be set to -1.
 .SS Mandatory locking
 (Non-POSIX.)
 The above record locks may be either advisory or mandatory,
-- 
1.8.4.2

