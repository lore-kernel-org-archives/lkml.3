Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbaD2NwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:52:00 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48751 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaD2Nv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:51:58 -0400
Message-ID: <535FAE78.5050404@gmail.com>
Date: Tue, 29 Apr 2014 15:51:52 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: mtk.manpages@gmail.com, Jan Kara <jack@suse.cz>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
Subject: fanotify man pages for review
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric (and all),

Heinrich Schuchardt has made a magnificent effort writing some man 
pages that extensively document the fanotify API that you added in 
Linux 2.6.36/37. Could I ask you (and anyone else who is interested)
to review them please for completeness and accuracy. I would
really like to get such a review before publishing the pages, in
order to minimize the chance of publishing errors

The pages are:

    fanotify.7:
	An overview of the fanotify API complete with an 
        example program, n

    fanotify_init.2
        Description of the fanotify_init() system call

    fanotify_mark.2
        Description of the fanotify_mark() system call

Cheers,

Michael



diff --git a/man2/fanotify_init.2 b/man2/fanotify_init.2
new file mode 100644
index 0000000..e54fe7e
--- /dev/null
+++ b/man2/fanotify_init.2
@@ -0,0 +1,206 @@
+.\" Copyright (C) 2013, Heinrich Schuchardt <xypron.glpk@gmx.de>
+.\"
+.\" %%%LICENSE_START(VERBATIM)
+.\" Permission is granted to make and distribute verbatim copies of this
+.\" manual provided the copyright notice and this permission notice are
+.\" preserved on all copies.
+.\"
+.\" Permission is granted to copy and distribute modified versions of
+.\" this manual under the conditions for verbatim copying, provided that
+.\" the entire resulting derived work is distributed under the terms of
+.\" a permission notice identical to this one.
+.\"
+.\" Since the Linux kernel and libraries are constantly changing, this
+.\" manual page may be incorrect or out-of-date.  The author(s) assume.
+.\" no responsibility for errors or omissions, or for damages resulting.
+.\" from the use of the information contained herein.  The author(s) may.
+.\" not have taken the same level of care in the production of this.
+.\" manual, which is licensed free of charge, as they might when working.
+.\" professionally.
+.\"
+.\" Formatted or processed versions of this manual, if unaccompanied by
+.\" the source, must acknowledge the copyright and authors of this work.
+.\" %%%LICENSE_END
+.TH FANOTIFY_INIT 2 2014-04-24 "Linux" "Linux Programmer's Manual"
+.SH NAME
+fanotify_init \- create and initialize fanotify group
+.SH SYNOPSIS
+.B #include <fcntl.h>
+.br
+.B #include <sys/fanotify.h>
+.sp
+.BI "int fanotify_init(unsigned int " flags ", unsigned int " event_f_flags );
+.SH DESCRIPTION
+For an overview of the fanotify API, see
+.BR fanotify (7).
+.PP
+.BR fanotify_init ()
+initializes a new fanotify group and returns a file descriptor for the event
+queue associated with the group.
+.PP
+The file descriptor is used in calls to
+.BR fanotify_mark (2)
+to specify the files, directories, and mounts for which fanotify events shall
+be created.
+These events are received by reading from the file descriptor.
+Some events are only informative, indicating that a file has been accessed.
+Other events can be used to determine whether
+another application is permitted to access a file or directory.
+Permission to access filesystem objects is granted by writing to the file
+descriptor.
+.PP
+Multiple programs may be using the fanotify interface at the same time to
+monitor the same files.
+.PP
+In the current implementation, the number of fanotify groups per user is
+limited to 128.
+This limit cannot be overridden.
+.PP
+Calling
+.BR fanotify_init ()
+requires the
+.B CAP_SYS_ADMIN
+capability.
+This constraint might be relaxed in future versions of the API.
+Therefore, certain additional capability checks have been implemented as
+indicated below.
+.PP
+The
+.I flags
+argument contains a multi-bit field defining the notification class of the
+listening application and further single bit fields specifying the behavior of
+the file descriptor.
+.PP
+If multiple listeners for permission events exist, the notification class is
+used to establish the sequence in which the listeners receive the events.
+.PP
+Only one of the following notification classes may be specified in
+.IR flags :
+.TP
+.B FAN_CLASS_PRE_CONTENT
+This value allows the receipt of events notifying that a file has been
+accessed and events for permission decisions if a file may be accessed.
+It is intended for event listeners that need to access files before they
+contain their final data.
+This notification class might be used by hierarchical storage managers, for
+example.
+.TP
+.B FAN_CLASS_CONTENT
+This value allows the receipt of events notifying that a file has been
+accessed and events for permission decisions if a file may be accessed.
+It is intended for event listeners that need to access files when they already
+contain their final content.
+This notification class might be used by malware detection programs, for
+example.
+.TP
+.B FAN_CLASS_NOTIF
+This is the default value.
+It does not need to be specified.
+This value only allows the receipt of events notifying that a file has been
+accessed.
+Permission decisions before the file is accessed are not possible.
+.PP
+Listeners with different notification classes will receive events in the
+order
+.BR FAN_CLASS_PRE_CONTENT ,
+.BR FAN_CLASS_CONTENT ,
+.BR FAN_CLASS_NOTIF .
+The order of notification for listeners of the same value is undefined.
+.PP
+The following bit mask values can be set additionally in
+.IR flags :
+.TP
+.B FAN_CLOEXEC
+This flag sets the close-on-exec flag
+.RB ( FD_CLOEXEC )
+on the new file descriptor.
+See the description of the
+.B O_CLOEXEC
+flag in
+.BR open (2).
+.TP
+.B FAN_NONBLOCK
+This flag enables the nonblocking flag
+.RB ( O_NONBLOCK )
+for the file descriptor.
+Reading from the file descriptor will not block.
+Instead, if no data is available,
+.BR read (2)
+will fail with the error
+.BR EAGAIN .
+.TP
+.B FAN_UNLIMITED_QUEUE
+This flag removes the limit of 16384 events for the event queue.
+It requires the
+.B CAP_SYS_ADMIN
+capability.
+.TP
+.B FAN_UNLIMITED_MARKS
+This flag removes the limit of 8192 marks.
+It requires the
+.B CAP_SYS_ADMIN
+capability.
+.PP
+The argument
+.I event_f_flags
+defines the file flags with which file descriptors for fanotify events shall
+be created.
+For explanations of possible values, see the argument
+.I flags
+of the
+.BR open (2)
+system call.
+Useful values are:
+.TP
+.B O_RDONLY
+This value allows only read access.
+.TP
+.B O_WRONLY
+This value allows only write access.
+.TP
+.B O_RDWR
+This value allows read and write access.
+.TP
+.B O_CLOEXEC
+This flag enables the close-on-exec flag for the file descriptor.
+.TP
+.B O_LARGEFILE
+This flag enables support for files exceeding 2 GB.
+Failing to set this flag will result in an
+.B EOVERFLOW
+error when trying to open a large file which is monitored by an fanotify group
+on a 32-bit system.
+.SH RETURN VALUE
+On success,
+.BR fanotify_init ()
+returns a new file descriptor.
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.SH ERRORS
+.TP
+.B EINVAL
+An invalid value was passed in
+.IR flags .
+.B FAN_ALL_INIT_FLAGS
+defines all allowable bits.
+.TP
+.B EMFILE
+The number of fanotify groups of the user exceeds 128.
+.TP
+.B ENOMEM
+The allocation of memory for the notification group failed.
+.TP
+.B EPERM
+The operation is not permitted because the caller lacks the
+.B CAP_SYS_ADMIN
+capability.
+.SH VERSIONS
+.BR fanotify_init ()
+was introduced in version 2.6.36 of the Linux kernel and enabled in version
+2.6.37.
+.SH "CONFORMING TO"
+This system call is Linux-specific.
+.SH "SEE ALSO"
+.BR fanotify_mark (2),
+.BR fanotify (7)
diff --git a/man2/fanotify_mark.2 b/man2/fanotify_mark.2
new file mode 100644
index 0000000..693eff8
--- /dev/null
+++ b/man2/fanotify_mark.2
@@ -0,0 +1,327 @@
+.\" Copyright (C) 2013,  Heinrich Schuchardt <xypron.glpk@gmx.de>
+.\"
+.\" %%%LICENSE_START(VERBATIM)
+.\" Permission is granted to make and distribute verbatim copies of this
+.\" manual provided the copyright notice and this permission notice are
+.\" preserved on all copies.
+.\"
+.\" Permission is granted to copy and distribute modified versions of
+.\" this manual under the conditions for verbatim copying, provided that
+.\" the entire resulting derived work is distributed under the terms of
+.\" a permission notice identical to this one.
+.\"
+.\" Since the Linux kernel and libraries are constantly changing, this
+.\" manual page may be incorrect or out-of-date.  The author(s) assume.
+.\" no responsibility for errors or omissions, or for damages resulting.
+.\" from the use of the information contained herein.  The author(s) may.
+.\" not have taken the same level of care in the production of this.
+.\" manual, which is licensed free of charge, as they might when working.
+.\" professionally.
+.\"
+.\" Formatted or processed versions of this manual, if unaccompanied by
+.\" the source, must acknowledge the copyright and authors of this work.
+.\" %%%LICENSE_END
+.TH FANOTIFY_MARK 2 2014-04-24 "Linux" "Linux Programmer's Manual"
+.SH NAME
+fanotify_mark \- add, remove, or modify an fanotify mark on a filesystem
+object
+.SH SYNOPSIS
+.nf
+.B #include <sys/fanotify.h>
+.sp
+.BI "int fanotify_mark(int " fanotify_fd ", unsigned int " flags ,
+.BI "                  uint64_t " mask ", int " dirfd \
+", const char *" pathname );
+.fi
+.SH DESCRIPTION
+For an overview of the fanotify API, see
+.BR fanotify (7).
+.PP
+.BR fanotify_mark (2)
+adds, removes, or modifies an fanotify mark on a filesystem object.
+The caller must have read permission on the filesystem object that is to be
+marked.
+.PP
+The
+.I fanotify_fd
+argument is a file descriptor returned by
+.BR fanotify_init (2).
+.PP
+.I flags
+is a bit mask describing the modification to perform.
+It must include exactly one of the following values:
+.TP
+.B FAN_MARK_ADD
+The events in
+.I mask
+will be added to the mark mask (or to the ignore mask).
+.I mask
+must be nonempty or the error
+.B EINVAL
+will occur.
+.TP
+.B FAN_MARK_REMOVE
+The events in argument
+.I mask
+will be removed from the mark mask (or from the ignore mask).
+.I mask
+must be nonempty or the error
+.B EINVAL
+will occur.
+.TP
+.B FAN_MARK_FLUSH
+Remove either all mount or non-mount marks from the fanotify group.
+If
+.I flag
+contains
+.BR FAN_MARK_MOUNT ,
+all marks for mounts are removed from the group.
+Otherwise, all marks for directories and files are removed.
+No flag other than
+.B FAN_MARK_MOUNT
+can be used in conjunction with
+.BR FAN_MARK_FLUSH .
+.I mask
+is ignored.
+.PP
+If none of the values above is specified, or more than one is specified, the
+call fails with the error
+.BR EINVAL .
+.PP
+In addition,
+.I flags
+may contain zero or more of the following:
+.TP
+.B FAN_MARK_DONT_FOLLOW
+If
+.I pathname
+is a symbolic link, mark the link itself, rather than the file to which it
+refers.
+(By default,
+.BR fanotify_mark ()
+dereferences
+.I pathname
+if it is a symbolic link.)
+.TP
+.B FAN_MARK_ONLYDIR
+If the filesystem object to be marked is not a directory, the error
+.B ENOTDIR
+shall be raised.
+.TP
+.B FAN_MARK_MOUNT
+Mark the mount point specified by
+.IR pathname .
+If
+.I pathname
+is not itself a mount point, the mount point containing
+.I pathname
+will be marked.
+All directories, subdirectories, and the contained files of the mount point
+will be monitored.
+.TP
+.B FAN_MARK_IGNORED_MASK
+The events in
+.I mask
+shall be added to or removed from the ignore mask.
+.TP
+.B FAN_MARK_IGNORED_SURV_MODIFY
+The ignore mask shall survive modify events.
+If this flag is not set, the ignore mask is cleared when a modify event occurs
+for the ignored file or directory.
+.PP
+.I mask
+defines which events shall be listened to (or which shall be ignored).
+It is a bit mask composed of the following values:
+.TP
+.B FAN_ACCESS
+Create an event when a file or directory (but see BUGS) is accessed (read).
+.TP
+.B FAN_MODIFY
+Create an event when a file is modified (write).
+.TP
+.B FAN_CLOSE_WRITE
+Create an event when a writable file is closed.
+.TP
+.B FAN_CLOSE_NOWRITE
+Create an event when a read-only file or directory is closed.
+.TP
+.B FAN_OPEN
+Create an event when a file or directory is opened.
+.TP
+.B FAN_OPEN_PERM
+Create an event when a permission to open a file or directory is requested.
+An fanotify file descriptor created with
+.B FAN_CLASS_PRE_CONTENT
+or
+.B FAN_CLASS_CONTENT
+is required.
+.TP
+.B FAN_ACCESS_PERM
+Create an event when a permission to read a file or directory is requested.
+An fanotify file descriptor created with
+.B FAN_CLASS_PRE_CONTENT
+or
+.B FAN_CLASS_CONTENT
+is required.
+.TP
+.B FAN_ONDIR
+Events for directories shall be created, for example when
+.BR opendir (2),
+.BR readdir (2)
+(but see BUGS), and
+.BR closedir (2)
+are called.
+Without this flag, only events for files are created.
+.TP
+.B FAN_EVENT_ON_CHILD
+Events for the immediate children of marked directories shall be created.
+The flag has no effect when marking mounts.
+Note that events are not generated for children of the subdirectories
+of marked directories.
+To monitor complete directory trees it is necessary to mark the relevant
+mount.
+.PP
+The following composed value is defined:
+.TP
+.B FAN_CLOSE
+A file is closed
+.RB ( FAN_CLOSE_WRITE | FAN_CLOSE_NOWRITE ).
+.PP
+The filesystem object to be marked is determined by the file descriptor
+.I dirfd
+and the pathname specified in
+.IR pathname :
+.IP * 3
+If
+.I pathname
+is NULL,
+.I dirfd
+defines the filesystem object to be marked.
+.IP *
+If
+.I pathname
+is NULL, and
+.I dirfd
+takes the special value
+.BR AT_FDCWD ,
+the current working directory is to be marked.
+.IP *
+If
+.I pathname
+is absolute, it defines the filesystem object to be marked, and
+.I dirfd
+is ignored.
+.IP *
+If
+.I pathname
+is relative, and
+.I dirfd
+does not have the value
+.BR AT_FDCWD ,
+then the filesystem object to be marked is determined by interpreting
+.I pathname
+relative the directory referred to by
+.IR dirfd .
+.IP *
+If
+.I pathname
+is relative, and
+.I dirfd
+has the value
+.BR AT_FDCWD,
+then the filesystem object to be marked is determined by interpreting
+.I pathname
+relative the current working directory.
+.SH RETURN VALUE
+On success,
+.BR fanotify_mark ()
+returns 0.
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.SH ERRORS
+.TP
+.B EBADF
+An invalid file descriptor was passed in
+.IR fanotify_fd .
+.TP
+.B EINVAL
+An invalid value was passed in
+.IR flags
+or
+.IR mask ,
+or
+.I fanotify_fd
+was not an fanotify file descriptor.
+.TP
+.B EINVAL
+The fanotify file descriptor was opened with
+.B FAN_CLASS_NOTIF
+and mask contains a flag for permission events
+.RB ( FAN_OPEN_PERM
+or
+.BR FAN_ACCESS_PERM ).
+.TP
+.B ENOENT
+The filesystem object indicated by
+.IR dirfd
+and
+.IR pathname
+does not exist.
+This error also occurs when trying to remove a mark from an object which is not
+marked.
+.TP
+.B ENOMEM
+The necessary memory could not be allocated.
+.TP
+.B ENOSPC
+The number of marks exceeds the limit of 8192 and
+.B FAN_UNLIMITED_MARKS
+was not specified in the call to
+.BR fanotify_init (2).
+.TP
+.B ENOTDIR
+.I flags
+contains
+.BR FAN_MARK_ONLYDIR ,
+and
+.I dirfd
+and
+.I pathname
+do not specify a directory.
+.SH VERSIONS
+.BR fanotify_mark ()
+was introduced in version 2.6.36 of the Linux kernel and enabled in version
+2.6.37.
+.SH CONFORMING TO
+This system call is Linux-specific.
+.SH BUGS
+As of Linux 3.15,
+the following bugs exist:
+.IP * 3
+.\" FIXME: Patch is in next-20140424.
+If
+.I flags
+contains
+.BR FAN_MARK_FLUSH ,
+.I dfd
+and
+.I pathname
+must indicate a filesystem object, even though this object is not used.
+.IP *
+.\" FIXME: Patch is in next-20140424.
+.BR readdir (2)
+does not result in a
+.B FAN_ACCESS
+event.
+.IP *
+.\" FIXME: Patch proposed.
+If
+.BR fanotify_mark (2)
+is called with
+.B FAN_MARK_FLUSH,
+.I flags
+is not checked for invalid values.
+.SH SEE ALSO
+.BR fanotify_init (2),
+.BR fanotify (7)
diff --git a/man7/fanotify.7 b/man7/fanotify.7
new file mode 100644
index 0000000..083244f
--- /dev/null
+++ b/man7/fanotify.7
@@ -0,0 +1,684 @@
+.\" Copyright (C) 2013, Heinrich Schuchardt <xypron.glpk@gmx.de>
+.\"
+.\" %%%LICENSE_START(VERBATIM)
+.\" Permission is granted to make and distribute verbatim copies of this
+.\" manual provided the copyright notice and this permission notice are
+.\" preserved on all copies.
+.\"
+.\" Permission is granted to copy and distribute modified versions of
+.\" this manual under the conditions for verbatim copying, provided that
+.\" the entire resulting derived work is distributed under the terms of
+.\" a permission notice identical to this one.
+.\"
+.\" Since the Linux kernel and libraries are constantly changing, this
+.\" manual page may be incorrect or out-of-date.  The author(s) assume.
+.\" no responsibility for errors or omissions, or for damages resulting.
+.\" from the use of the information contained herein.  The author(s) may.
+.\" not have taken the same level of care in the production of this.
+.\" manual, which is licensed free of charge, as they might when working.
+.\" professionally.
+.\"
+.\" Formatted or processed versions of this manual, if unaccompanied by
+.\" the source, must acknowledge the copyright and authors of this work.
+.\" %%%LICENSE_END
+.TH FANOTIFY 7 2014-04-24 "Linux" "Linux Programmer's Manual"
+.SH NAME
+fanotify \- monitoring filesystem events
+.SH DESCRIPTION
+The fanotify API provides notification and interception of filesystem events.
+Use cases include virus scanning and hierarchical storage management.
+Currently, only a limited set of events is supported.
+In particular, there is no support for create, delete, and move events.
+(See
+.BR inotify (7)
+for details of an API that does notify those events.)
+
+Additional capabilities compared to the
+.BR inotify (7)
+API are monitoring of complete mounts, access permission decisions, and the
+possibility to read or modify files before access by other applications.
+
+The following system calls are used with this API:
+.BR fanotify_init (2),
+.BR fanotify_mark (2),
+.BR read (2),
+.BR write (2),
+and
+.BR close (2).
+.SS fanotify_init(), fanotify_mark(), and notification groups
+The
+.BR fanotify_init (2)
+system call creates and initializes an fanotify notification group
+and returns a file descriptor referring to it.
+.PP
+An fanotify notification group is a kernel-internal object that holds
+a list of files, directories, and mount points for which events shall be
+created.
+.PP
+For each entry in an fanotify notification group, two bit masks exist: the
+.I mark
+mask and the
+.I ignore
+mask.
+The mark mask defines file activities for which an event shall be created.
+The ignore mask defines activities for which no event shall be generated.
+Having these two types of masks permits a mount point or directory to be
+marked for receiving events, while at the same time ignoring events for
+specific objects under that mount point or directory.
+.PP
+The 
+.BR fanotify_mark (2)
+system call adds a file, directory, or mount to a notification group
+and specifies which events
+shall be reported (or ignored), or removes or modifies such an entry.
+.PP
+A possible usage of the ignore mask is for a file cache.
+Events of interest for a file cache are modification of a file and closing
+of the same.
+Hence, the cached directory or mount point is to be marked to receive these
+events.
+After receiving the first event informing that a file has been modified, the
+corresponding cache entry will be invalidated.
+No further modification events for this file are of interest until the file is
+closed.
+Hence, the modify event can be added to the ignore mask.
+Upon receiving the closed event, the modify event can be removed from the
+ignore mask and the file cache entry can be updated.
+.PP
+The entries in the fanotify notification groups refer to files and directories
+via their inode number and to mounts via their mount ID.
+If files or directories are renamed or moved, the respective entries survive.
+If files or directories are deleted or mounts are unmounted, the corresponding
+entries are deleted.
+.SS The event queue
+As events occur on the filesystem objects monitired by a notification group,
+the fanotify system generates events that are collected in a queue.
+These events can then be read (using
+.BR read (2)
+or similar)
+from the fanotify file descriptor
+returned by
+.BR fanotify_init (2).
+
+Two types of events are generated:
+notification events and permission events.
+Notification events are merely informative
+and require no action to be taken by
+the receiving application except for closing the file descriptor passed in the
+event.
+Permission events are requests to the receiving application to decide whether
+permission for a file access shall be granted.
+For these events, the recipient must write a response which decides whether
+access is granted or not.
+
+Queue entries for notification events are removed when the event has been
+read.
+Queue entries for permission events are removed when the permission
+decision has been taken by writing to the fanotify file descriptor.
+.SS Reading fanotify events
+Calling
+.BR read (2)
+for the file descriptor returned by
+.BR fanotify_init (2)
+blocks (if the flag
+.B FAN_NONBLOCK
+is not specified in the call to
+.BR fanotify_init (2))
+until either a file event occurs or the call is interrupted by a signal
+(see
+.BR signal (7)).
+
+The return value of
+.BR read (2)
+is the length of the filled buffer, or \-1 in case of an error.
+After a successful
+.BR read (2),
+the read buffer contains one or more of the following structures:
+
+.in +4n
+.nf
+struct fanotify_event_metadata {
+    __u32 event_len;
+    __u8 vers;
+    __u8 reserved;
+    __u16 metadata_len;
+    __aligned_u64 mask;
+    __s32 fd;
+    __s32 pid;
+};
+.fi
+.in
+.PP
+The fields of this structure as follows:
+.TP
+.I event_len
+This is the length of the data for the current event and the offset to the next
+event in the buffer.
+In the current implementation, the value of
+.I event_len
+is always
+.BR FAN_EVENT_METADATA_LEN .
+In principle, the API design would allow to return variable-length structures.
+Therefore, and for performance reasons, it is recommended to use a larger
+buffer size when reading, for example 4096 bytes.
+.TP
+.I vers
+This field holds a version number for the structure.
+It must be compared to
+.B FANOTIFY_METADATA_VERSION
+to verify that the structures returned at runtime match
+the structures defined at compile time.
+In case of a mismatch, the application should abandon trying to use the
+fanotify file descriptor.
+.TP
+.I reserved
+This field is not used.
+.TP
+.I metadata_len
+This is the length of the structure.
+The field was introduced to facilitate the implementation of optional headers
+per event type.
+No such optional headers exist in the current implementation.
+.TP
+.I mask
+This is a bit mask describing the event.
+.TP
+.I fd
+This is an open file descriptor for the object being accessed, or
+.B FAN_NOFD
+if a queue overflow occurred.
+The file descriptor can be used to access the contents of the monitored file or
+directory.
+The
+.B FMODE_NONOTIFY
+file status flag is set on the corresponding open file description.
+This flag suppresses fanotify event generation.
+Hence, when the receiver of the fanotify event accesses the notified file or
+directory using this file descriptor, no additional events will be created.
+The reading application is responsible for closing the file descriptor.
+.TP
+.I pid
+This is the ID of the process that caused the event.
+A program listening to fanotify events can compare this PID to the PID returned
+by
+.BR getpid (2),
+to determine whether the event is caused by the listener itself, or is due to a
+file access by another program.
+.PP
+The bit mask in
+.I mask
+signals which events have occurred for a single filesystem object.
+Multiple bits may be set in this mask,
+if more than one event occurred for the monitored filesystem obect.
+In particular,
+consecutive events for the same filesystem object and originating from the
+same process may be merged into a single event, with the exception that two
+permission events are never merged into one queue entry.
+.PP
+The bits that may appear in
+.I mask
+are as follows:
+.TP
+.B FAN_ACCESS
+A file or a directory (but see BUGS) was accessed (read).
+.TP
+.B FAN_OPEN
+A file or a directory was opened.
+.TP
+.B FAN_MODIFY
+A file was modified.
+.TP
+.B FAN_CLOSE_WRITE
+A file that was opened for writing
+.RB ( O_WRONLY
+or
+.BR O_RDWR )
+was closed.
+.TP
+.B FAN_CLOSE_NOWRITE
+A file or directory that was opened read-only
+.RB ( O_RDONLY )
+was closed.
+.TP
+.B FAN_Q_OVERFLOW
+The event queue exceeded the limit of 16384 entries.
+This limit can be overridden in the call to
+.BR fanotify_init (2)
+by setting the flag
+.BR FAN_UNLIMITED_QUEUE .
+.TP
+.B FAN_ACCESS_PERM
+An application wants to read a file or directory, for example using
+.BR read (2)
+or
+.BR readdir (2).
+The reader must write a response that determines whether the permission to
+access the filesystem object shall be granted.
+.TP
+.B FAN_OPEN_PERM
+An application wants to open a file or directory.
+The reader must write a response that determines whether the permission to
+open the filesystem object shall be granted.
+.PP
+To check for any close event, the following bit mask may be used:
+.TP
+.B FAN_CLOSE
+A file was closed.
+This is a synonym for;
+
+    FAN_CLOSE_WRITE | FAN_CLOSE_NOWRITE
+.PP
+The following macros are provided to iterate over a buffer containing fanotify
+event metadata returned by a
+.BR read (2)
+from an fanotify file descriptor.
+.TP
+.B FAN_EVENT_OK(meta, len)
+This macro checks the remaining length
+.I len
+of the buffer
+.I meta
+against the length of the metadata structure and the
+.I event_len
+field of the first metadata structure in the buffer.
+.TP
+.B FAN_EVENT_NEXT(meta, len)
+This macro sets the pointer
+.I meta
+to the next metadata structure using the length indicated in the
+.I event_len
+field of the metadata structure and reduces the remaining length of the
+buffer
+.IR len .
+.SS Monitoring an fanotify file descriptor for events
+When an fanotify event occurs, the fanotify file descriptor indicates as
+readable when passed to
+.BR epoll (7),
+.BR poll (2),
+or
+.BR select (2).
+.SS Dealing with permission events
+For permission events, the application must
+.BR write (2)
+a structure of the following form to the
+fanotify file descriptor:
+
+.in +4n
+.nf
+struct fanotify_response {
+    __s32 fd;
+    __u32 response;
+};
+.fi
+.in
+.PP
+The fields of this structure are as follows:
+.TP
+.I fd
+This is the file descriptor from the structure
+.IR fanotify_event_metadata .
+.TP
+.I response
+This field indicates whether or not the permission is to be granted.
+Its value must be either
+.B FAN_ALLOW
+to allow the file operation or
+.B FAN_DENY
+to deny the file operation.
+.PP
+If access is denied, the requesting application call will receive an
+.BR EPERM
+error.
+.SS Closing the fanotify file descriptor
+.PP
+When all file descriptors referring to the fanotify notification group are
+closed, the fanotify group is released and its resources
+are freed for reuse by the kernel.
+Upon
+.BR close (2),
+outstanding permission events will be set to allowed.
+.SS /proc/[pid]/fdinfo
+The file
+.I /proc/[pid]/fdinfo/[fd]
+contains information about fanotify marks for file descriptor
+.I fd
+of process
+.IR pid .
+See the kernel source file
+.I Documentation/filesystems/proc.txt
+for details.
+.SH ERRORS
+In addition to the usual errors for
+.BR read (2),
+the following errors can occur when reading from the fanotify file descriptor:
+.TP
+.B EINVAL
+The buffer is too short to hold the event.
+.TP
+.B EMFILE
+The per-process limit on the number of open files has been reached.
+See the description of
+.B RLIMIT_NOFILE
+in
+.BR getrlimit (2).
+.TP
+.B ENFILE
+The system-wide limit on the number of open files has been reached.
+See
+.I /proc/sys/fs/file-max
+in
+.BR proc (5).
+.TP
+.B ETXTBSY
+This error is returned by
+.BR read (2)
+if
+.B O_RDWR
+or
+.B O_WRONLY
+was specified in the
+.I event_f_flags
+argument when calling
+.BR fanotify_init (2)
+and an event occurred for a monitored file that is currently being executed.
+.PP
+In addition to the usual errors for
+.BR write (2),
+the following errors can occur when writing to the fanotify file descriptor:
+.TP
+.B EINVAL
+Fanotify access permissions are not enabled in the kernel configuration or the
+value of
+.I response
+in the response structure is not valid.
+.TP
+.B ENOENT
+The file descriptor
+.I fd
+in the response structure is not valid.
+This might occur because the file was already deleted by another thread or
+process.
+.SH VERSIONS
+The fanotify API was introduced in version 2.6.36 of the Linux kernel and
+enabled in version 2.6.37.
+Fdinfo support was added in version 3.8.
+.SH "CONFORMING TO"
+The fanotify API is Linux-specific.
+.SH NOTES
+The fanotify API is available only if the kernel was built with the
+.B CONFIG_FANOTIFY
+configuration option enabled.
+In addition, fanotify permission handling is available only if the
+.B CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+configuration option is enabled.
+.SS Limitations and caveats
+Fanotify reports only events that a user-space program triggers through the
+filesystem API.
+As a result, it does not catch remote events that occur on network filesystems.
+.PP
+The fanotify API does not report file accesses and modifications that
+may occur because of
+.BR mmap (2),
+.BR msync (2),
+and
+.BR munmap (2).
+.PP
+Events for directories are created only if the directory itself is opened,
+read, and closed.
+Adding, removing, or changing children of a marked directory does not create
+events for the monitored directory itself.
+.PP
+Fanotify monitoring of directories is not recursive: to monitor subdirectories
+under a directory, additional marks must be created.
+(But note that the fanotify API provides no way of  detecting when a
+subdirectory has been created under a marked directory, which makes recursive
+monitoring difficult.)
+Monitoring mounts offers the capability to monitor a whole directory tree.
+.PP
+The event queue can overflow.
+In this case, events are lost.
+.SH BUGS
+As of Linux 3.15,
+the following bug exists:
+.IP * 3
+.\" FIXME: A patch was proposed.
+When an event is generated, no check is made to see whether the user ID of the
+receiving process has authorization to read or write the file before passing a
+file descriptor for that file.
+This poses a security risk, when the
+.B CAP_SYS_ADMIN
+capability is set for programs executed by unprivileged users.
+.SH EXAMPLE
+The following program demonstrates the usage of the fanotify API.
+It marks the mount point passed as command-line argument
+and waits for events of type
+.B FAN_PERM_OPEN
+and
+.BR FAN_CLOSE_WRITE .
+When a permission event occurs, a
+.B FAN_ALLOW
+response is given.
+.PP
+The following output was recorded while editing the file
+.IR /home/user/temp/notes .
+Before the file was opened, a
+.B FAN_OPEN_PERM
+event occurred.
+After the file was closed, a
+.B FAN_CLOSE_WRITE
+event occurred.
+Execution of the program ends when the user presses the ENTER key.
+.SS Example output
+.in +4n
+.nf
+# ./fanotify_example /home
+Press enter key to terminate.
+Listening for events.
+FAN_OPEN_PERM: File /home/user/temp/notes
+FAN_CLOSE_WRITE: File /home/user/temp/notes
+
+Listening for events stopped.
+.fi
+.in
+.SS Program source
+.nf
+#define _GNU_SOURCE     /* Needed to get O_LARGEFILE definition */
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <poll.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/fanotify.h>
+#include <unistd.h>
+
+/* Read all available fanotify events from the file descriptor 'fd' */
+
+static void
+handle_events(int fd)
+{
+    const struct fanotify_event_metadata *metadata;
+    char buf[4096];
+    ssize_t len;
+    char path[PATH_MAX];
+    ssize_t path_len;
+    char procfd_path[PATH_MAX];
+    struct fanotify_response response;
+
+    /* Loop while events can be read from fanotify file descriptor */
+
+    for(;;) {
+
+        /* Read some events */
+
+        len = read(fd, (void *) &buf, sizeof(buf));
+        if (len == \-1 && errno != EAGAIN) {
+            perror("read");
+            exit(EXIT_FAILURE);
+        }
+
+        /* Check if end of available data reached */
+
+        if (len <= 0)
+            break;
+
+        /* Point to the first event in the buffer */
+
+        metadata = (struct fanotify_event_metadata *) buf;
+
+        /* Loop over all events in the buffer */
+
+        while (FAN_EVENT_OK(metadata, len)) {
+
+            /* Check that run\-time and compile\-time structures match */
+
+            if (metadata\->vers != FANOTIFY_METADATA_VERSION) {
+                fprintf(stderr,
+                        "Mismatch of fanotify metadata version.\\n");
+                exit(EXIT_FAILURE);
+            }
+
+            /* metadata\->fd contains either FAN_NOFD, indicating a
+               queue overflow, or a file descriptor (a nonnegative
+               integer). Here, we simply ignore queue overflow. */
+
+            if (metadata\->fd >= 0) {
+
+                /* Handle open permission event */
+
+                if (metadata\->mask & FAN_OPEN_PERM) {
+                    printf("FAN_OPEN_PERM: ");
+
+                    /* Allow file to be opened */
+
+                    response.fd = metadata\->fd;
+                    response.response = FAN_ALLOW;
+                    write(fd, &response,
+                            sizeof(struct fanotify_response));
+                }
+
+                /* Handle closing of writable file event */
+
+                if (metadata\->mask & FAN_CLOSE_WRITE)
+                    printf("FAN_CLOSE_WRITE: ");
+
+                /* Retrieve and print pathname of the accessed file */
+
+                snprintf(procfd_path, sizeof(procfd_path),
+                         "/proc/self/fd/%d", metadata\->fd);
+                path_len = readlink(procfd_path, path,
+                                    sizeof(path) \- 1);
+                if (path_len == \-1) {
+                    perror("readlink");
+                    exit(EXIT_FAILURE);
+                }
+
+                path[path_len] = '\\0';
+                printf("File %s\\n", path);
+
+                /* Close the file descriptor of the event */
+
+                close(metadata\->fd);
+            }
+
+            /* Advance to next event */
+
+            metadata = FAN_EVENT_NEXT(metadata, len);
+        }
+    }
+}
+
+int
+main(int argc, char *argv[])
+{
+    char buf;
+    int fd, poll_num;
+    nfds_t nfds;
+    struct pollfd fds[2];
+
+    /* Check mount point is supplied */
+
+    if (argc != 2) {
+        fprintf(stderr, "Usage: %s MOUNT\\n", argv[0]);
+        exit(EXIT_FAILURE);
+    }
+
+    printf("Press enter key to terminate.\\n");
+
+    /* Create the file descriptor for accessing the fanotify API */
+
+    fd = fanotify_init(FAN_CLOEXEC | FAN_CLASS_CONTENT | FAN_NONBLOCK,
+                       O_RDONLY | O_LARGEFILE);
+    if (fd == \-1) {
+        perror("fanotify_init");
+        exit(EXIT_FAILURE);
+    }
+
+    /* Mark the mount for:
+       \- permission events before opening files
+       \- notification events after closing a write\-enabled
+         file descriptor */
+
+    if (fanotify_mark(fd, FAN_MARK_ADD | FAN_MARK_MOUNT,
+                      FAN_OPEN_PERM | FAN_CLOSE_WRITE, \-1,
+                      argv[1]) == \-1) {
+        perror("fanotify_mark");
+        exit(EXIT_FAILURE);
+    }
+
+    /* Prepare for polling */
+
+    nfds = 2;
+
+    /* Console input */
+
+    fds[0].fd = STDIN_FILENO;
+    fds[0].events = POLLIN;
+
+    /* Fanotify input */
+
+    fds[1].fd = fd;
+    fds[1].events = POLLIN;
+
+    /* This is the loop to wait for incoming events */
+
+    printf("Listening for events.\\n");
+
+    while (1) {
+        poll_num = poll(fds, nfds, \-1);
+        if (poll_num == \-1) {
+            if (errno == EINTR)     /* Interrupted by a signal */
+                continue;           /* Restart poll() */
+
+            perror("poll");         /* Unexpected error */
+            exit(EXIT_FAILURE);
+        }
+
+        if (poll_num > 0) {
+            if (fds[0].revents & POLLIN) {
+
+                /* Console input is available: empty stdin and quit */
+
+                while (read(STDIN_FILENO, &buf, 1) > 0 && buf != '\\n')
+                    continue;
+                break;
+            }
+
+            if (fds[1].revents & POLLIN) {
+
+                /* Fanotify events are available */
+
+                handle_events(fd);
+            }
+        }
+    }
+
+    printf("Listening for events stopped.\\n");
+    exit(EXIT_SUCCESS);
+}
+.fi
+.SH "SEE ALSO"
+.ad l
+.BR fanotify_init (2),
+.BR fanotify_mark (2),
+.BR inotify (7)

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
