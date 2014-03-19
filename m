Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaCSTIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:08:37 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:46259 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaCSTIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:08:04 -0400
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
Subject: [PATCH man-pages 5/6] fcntl.2: document SHMEM_SET/GET_SEALS commands
Date: Wed, 19 Mar 2014 20:06:50 +0100
Message-Id: <1395256011-2423-6-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SHMEM_GET_SEALS and SHMEM_SET_SEALS commands allow retrieving and
modifying the active set of seals on a file. They're only supported on
selected file-systems (currently shmfs) and are linux-only.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 man2/fcntl.2 | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/man2/fcntl.2 b/man2/fcntl.2
index c010a49..53d55a5 100644
--- a/man2/fcntl.2
+++ b/man2/fcntl.2
@@ -57,6 +57,8 @@
 .\"     Document F_SETOWN_EX and F_GETOWN_EX
 .\" 2010-06-17, Michael Kerrisk
 .\"	Document F_SETPIPE_SZ and F_GETPIPE_SZ.
+.\" 2014-03-19, David Herrmann <dh.herrmann@gmail.com>
+.\"	Document SHMEM_SET_SEALS and SHMEM_GET_SEALS
 .\"
 .TH FCNTL 2 2014-02-20 "Linux" "Linux Programmer's Manual"
 .SH NAME
@@ -1064,6 +1066,94 @@ of buffer space currently used to store data produces the error
 .BR F_GETPIPE_SZ " (\fIvoid\fP; since Linux 2.6.35)"
 Return (as the function result) the capacity of the pipe referred to by
 .IR fd .
+.SS File Sealing
+Sealing files limits the set of allowed operations on a given file. For each
+seal that is set on a file, a specific set of operations will fail with
+.B EPERM
+on this file from now on. The file is said to be sealed. A file does not have
+any seals set by default. Moreover, most filesystems do not support sealing
+(only shmfs implements it right now). The following seals are available:
+.RS
+.TP
+.BR SHMEM_SEAL_SHRINK
+If this seal is set, the file in question cannot be reduced in size. This
+affects
+.BR open (2)
+with the
+.B O_TRUNC
+flag and
+.BR ftruncate (2).
+They will fail with
+.B EPERM
+if you try to shrink the file in question. Increasing the file size is still
+possible.
+.TP
+.BR SHMEM_SEAL_GROW
+If this seal is set, the size of the file in question cannot be increased. This
+affects
+.BR write (2)
+if you write across size boundaries,
+.BR ftruncate (2)
+and
+.BR fallocate (2).
+These calls will fail with
+.B EPERM
+if you use them to increase the file size or write beyond size boundaries. If
+you keep the size or shrink it, those calls still work as expected.
+.TP
+.BR SHMEM_SEAL_WRITE
+If this seal is set, you cannot modify data contents of the file. Note that
+shrinking or growing the size of the file is still possible and allowed. Thus,
+this seal is normally used in combination with one of the other seals. This seal
+affects
+.BR write (2)
+and
+.BR fallocate (2)
+(only in combination with the
+.B FALLOC_FL_PUNCH_HOLE
+flag). Those calls will fail with
+.B EPERM
+if this seal is set. Furthermore, trying to create new memory-mappings via
+.BR mmap (2)
+in combination with
+.B MAP_SHARED
+will also fail with
+.BR EPERM .
+.RE
+.TP
+.BR SHMEM_SET_SEALS " (\fIint\fP; since Linux TBD)"
+Change the set of seals of the file referred to by
+.I fd
+to
+.IR arg .
+You are required to own an exclusive reference to the file in question in order
+to modify the seals. Otherwise, this call will fail with
+.BR EPERM .
+There is one exception: If no seals are set, this restriction does not apply and
+you can set seals even if you don't own an exclusive reference. However, in any
+case there may not exist any shared writable mapping or this call will always
+fail with
+.BR EPERM .
+These semantics guarantee that once you verified a specific set of seals is set
+on a given file, nobody besides you (in case you own an exclusive reference) can
+modify the seals, anymore.
+
+You own an exclusive reference to a file if, and only if, the file-descriptor
+passed to
+.BR fcntl (2)
+is the only reference to the underlying inode. There must not be any duplicates
+of this file-descriptor, no other open files to the same underlying inode, no
+hard-links or any active memory mappings.
+.TP
+.BR SHMEM_GET_SEALS " (\fIvoid\fP; since Linux TBD)"
+Return (as the function result) the current set of seals of the file referred to
+by
+.IR fd .
+If no seals are set, 0 is returned. If the file does not support sealing, -1 is
+returned and
+.I errno
+is set to
+.BR EINVAL .
 .SH RETURN VALUE
 For a successful call, the return value depends on the operation:
 .TP 0.9i
-- 
1.9.0

