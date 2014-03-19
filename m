Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaCSTIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:08:39 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:37632 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaCSTIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:08:05 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        =?UTF-8?q?Kristian=20H=C3=B8gsberg?= <krh@bitplanet.net>,
        john.stultz@linaro.org, Greg Kroah-Hartman <greg@kroah.com>,
        Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH man-pages 6/6] memfd_create.2: add memfd_create() man-page
Date: Wed, 19 Mar 2014 20:06:51 +0100
Message-Id: <1395256011-2423-7-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memfd_create() syscall creates anonymous files similar to O_TMPFILE
but does not require an active mount-point.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 man2/memfd_create.2 | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)
 create mode 100644 man2/memfd_create.2

diff --git a/man2/memfd_create.2 b/man2/memfd_create.2
new file mode 100644
index 0000000..3e362e0
--- /dev/null
+++ b/man2/memfd_create.2
@@ -0,0 +1,110 @@
+.\" Copyright (C) 2014 David Herrmann <dh.herrmann@gmail.com>
+.\" starting from a version by Michael Kerrisk <mtk.manpages@gmail.com>
+.\"
+.\" %%%LICENSE_START(GPLv2+_SW_3_PARA)
+.\" This program is free software; you can redistribute it and/or modify
+.\" it under the terms of the GNU General Public License as published by
+.\" the Free Software Foundation; either version 2 of the License, or
+.\" (at your option) any later version.
+.\"
+.\" This program is distributed in the hope that it will be useful,
+.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\" GNU General Public License for more details.
+.\"
+.\" You should have received a copy of the GNU General Public
+.\" License along with this manual; if not, see
+.\" <http://www.gnu.org/licenses/>.
+.\" %%%LICENSE_END
+.\"
+.TH MEMFD_CREATE 2 2014-03-18 Linux "Linux Programmer's Manual"
+.SH NAME
+memfd_create \- create an anonymous file
+.SH SYNOPSIS
+.B #include <sys/memfd.h>
+.sp
+.BI "int memfd_create(const char *" name ", u64 " size ", u64 " flags ");"
+.SH DESCRIPTION
+.BR memfd_create ()
+creates an anonymous file and returns a file-descriptor to it. The file behaves
+like regular files, thus can be modified, truncated, memory-mapped and more.
+However, unlike regular files it lives in main memory and has no non-volatile
+backing storage. Once all references to the file are dropped, it is
+automatically released. Like all shmem-based files, memfd files support
+.BR SHMEM
+sealing parameters. See
+.BR SHMEM_SET_SEALS " with " fcntl (2)
+for more information.
+
+The initial size of the file is set to
+.IR size ". " name
+is used as internal file-name and will occur as such in
+.IR /proc/self/fd/ .
+The name is always prefixed with
+.BR memfd:
+and serves only debugging purposes.
+
+The following values may be bitwise ORed in
+.IR flags
+to change the behaviour of
+.BR memfd_create ():
+.TP
+.BR MFD_CLOEXEC
+Set the close-on-exec
+.RB ( FD_CLOEXEC )
+flag on the new file descriptor.
+See the description of the
+.B O_CLOEXEC
+flag in
+.BR open (2)
+for reasons why this may be useful.
+.PP
+Unused bits must be cleared to 0.
+
+As its return value,
+.BR memfd_create ()
+returns a new file descriptor that can be used to refer to the file.
+A copy of the file descriptor created by
+.BR memfd_create ()
+is inherited by the child produced by
+.BR fork (2).
+The duplicate file descriptor is associated with the same file.
+File descriptors created by
+.BR memfd_create ()
+are preserved across
+.BR execve (2),
+unless the close-on-exec flag has been set.
+.SH RETURN VALUE
+On success,
+.BR memfd_create ()
+returns a new file descriptor.
+On error, \-1 is returned and
+.I errno
+is set to indicate the error.
+.SH ERRORS
+.TP
+.B EINVAL
+An unsupported value was specified in one of the arguments.
+.TP
+.B EMFILE
+The per-process limit on open file descriptors has been reached.
+.TP
+.B ENFILE
+The system-wide limit on the total number of open files has been
+reached.
+.TP
+.B EFAULT
+The name given in
+.IR name
+points to invalid memory.
+.TP
+.B ENOMEM
+There was insufficient memory to create a new anonymous file.
+.SH VERSIONS
+to-be-defined
+.SH CONFORMING TO
+.BR memfd_create ()
+is Linux-specific.
+.SH SEE ALSO
+.BR shmget (2),
+.BR fcntl (2),
-- 
1.9.0

