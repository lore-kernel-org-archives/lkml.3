Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466AbaD3MPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:15:09 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:34708 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486AbaD3MPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:15:05 -0400
Date: Wed, 30 Apr 2014 08:15:01 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
Subject: Re: [PATCH man-pages v1] fcntl.2: update manpage with verbiage
 about open file description locks
Message-ID: <20140430081501.3aca5cba@tlielax.poochiereds.net>
In-Reply-To: <5360D56F.4070509@gmail.com>
References: <1398797474-744-1-git-send-email-jlayton@poochiereds.net>
	<5360D56F.4070509@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014 12:50:23 +0200
"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:

> [CC += linux-man]
> 
> Jeff,
> 
> Thanks very much for writing this patch!
> 
> I've taken your patch into a branch and add a number of details. I have 
> one or two questions below.
> 
> On 04/29/2014 08:51 PM, Jeff Layton wrote:
> > Signed-off-by: Jeff Layton <jlayton@poochiereds.net>
> > ---
> >  man2/fcntl.2 | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 109 insertions(+), 3 deletions(-)
> > 
> > diff --git a/man2/fcntl.2 b/man2/fcntl.2
> > index d0154a6d9f42..8d119dfec24c 100644
> > --- a/man2/fcntl.2
> > +++ b/man2/fcntl.2
> > @@ -191,6 +191,9 @@ and
> >  .BR O_SYNC
> >  flags; see BUGS, below.
> >  .SS Advisory locking
> > +This section describes traditional POSIX record locks. Also see the section on
> > +open file description locks below.
> > +.PP
> >  .BR F_SETLK ,
> >  .BR F_SETLKW ,
> >  and
> > @@ -213,7 +216,8 @@ struct flock {
> >      off_t l_start;   /* Starting offset for lock */
> >      off_t l_len;     /* Number of bytes to lock */
> >      pid_t l_pid;     /* PID of process blocking our lock
> > -                        (F_GETLK only) */
> > +                        (returned for F_GETLK and F_OFD_GETLK only. Set
> > +                         to 0 for open file description locks) */
> >      ...
> >  };
> >  .fi
> > @@ -349,9 +353,13 @@ returns details about one of these locks in the
> >  .IR l_type ", " l_whence ", " l_start ", and " l_len
> >  fields of
> >  .I lock
> > -and sets
> > +.
> > +If the conflicting lock is a traditional POSIX lock, then the
> > +.I l_pid
> > +to be the PID of the process holding that lock. If the
> > +conflicting lock is an open file description lock, then the
> >  .I l_pid
> > -to be the PID of the process holding that lock.
> > +will be set to \-1.
> >  Note that the information returned by
> >  .BR F_GETLK
> >  may already be out of date by the time the caller inspects it.
> > @@ -394,6 +402,104 @@ should be avoided; use
> >  and
> >  .BR write (2)
> >  instead.
> > +.SS Open file description locks (non-POSIX)
> > +.BR F_OFD_GETLK ", " F_OFD_SETLK " and  " F_OFD_SETLKW
> > +are used to acquire, release and test open file description record locks.
> > +These are byte-range locks that work identically to the traditional advisory
> > +record locks described above, but are associated with the open file description
> > +on which they were acquired rather than the process, much like locks acquired
> > +with
> > +.BR flock (2)
> > +.
> > +.PP
> > +Unlike traditional advisory record locks, these locks are inherited
> > +across
> > +.BR fork (2)
> > +and
> > +.BR clone (2)
> > +with
> > +.BR CLONE_FILES
> > +and are only released on the last close of the open file description instead
> > +of being released on any close of the file.
> > +.PP
> > +Open file description locks always conflict with traditional record locks,
> > +even when they are acquired by the same process on the same file descriptor.
> > +They only conflict with each other when they are acquired on different
> > +open file descriptions.
> > +.PP
> > +Note that in contrast to traditional record locks, the
> > +.I flock
> > +structure passed in as an argument to the open file description lock commands
> > +must have the
> > +.I l_pid
> > +value set to 0.
> 
> In ERRORS, I added EINVAL for this case.
> 
> > +.TP
> > +.BR F_OFD_SETLK " (\fIstruct flock *\fP)"
> > +Acquire an open file description lock (when
> > +.I l_type
> > +is
> > +.B F_RDLCK
> > +or
> > +.BR F_WRLCK )
> > +or release an open file description lock (when
> > +.I l_type
> > +is
> > +.BR F_UNLCK )
> > +on the bytes specified by the
> > +.IR l_whence ", " l_start ", and " l_len
> > +fields of
> > +.IR lock .
> > +If a conflicting lock is held by another process,
> > +this call returns \-1 and sets
> > +.I errno
> > +to
> > +.B EACCES
> > +or
> > +.BR EAGAIN .
> 
> The "EACCES or EAGAIN" thing comes from POSIX, because different 
> implementations of tradition record locks returned one of these errors. 
> So, portable applications using traditional locks must handle either 
> possibility. However, that argument doesn't apply for these new locks. 
> Surely, we just want to say "set errno to EAGAIN" for this case?
> 
> > +.TP
> > +.BR F_OFD_SETLKW " (\fIstruct flock *\fP)"
> > +As for
> > +.BR F_OFD_SETLK ,
> > +but if a conflicting lock is held on the file, then wait for that lock to be
> > +released. If a signal is caught while waiting, then the call is interrupted
> > +and (after the signal handler has returned) returns immediately (with return
> > +value \-1 and
> > +.I errno
> > +set to
> > +.BR EINTR ;
> > +see
> > +.BR signal (7)).
> > +.TP
> > +.BR F_OFD_GETLK " (\fIstruct flock *\fP)"
> > +On input to this call,
> > +.I lock
> > +describes an open file description lock we would like to place on the file.
> > +If the lock could be placed,
> > +.BR fcntl ()
> > +does not actually place it, but returns
> > +.B F_UNLCK
> > +in the
> > +.I l_type
> > +field of
> > +.I lock
> > +and leaves the other fields of the structure unchanged.
> > +If one or more incompatible locks would prevent
> > +this lock being placed, then
> > +.BR fcntl ()
> > +returns details about one of these locks in the
> > +.IR l_type ", " l_whence ", " l_start ", and " l_len
> > +fields of
> > +.I lock
> > +.
> > +If the conflicting lock is a process-associated record lock, then the
> > +.I l_pid
> > +will be set to the PID of the process holding that lock. If the
> > +conflicting lock is an open file description lock, then the
> > +.I l_pid
> > +will be set to -1 to indicate that it is not associated with a process.
> > +Note that the information returned by
> > +.BR F_OFD_GETLK
> > +may already be out of date by the time the caller inspects it.
> >  .SS Mandatory locking
> >  (Non-POSIX.)
> >  The above record locks may be either advisory or mandatory,
> 
> Based on some past conversations, I added a number of details
> to the page, and also reworked your text a little to eliminate some 
> of the redundancy with the discussion of traditional locks. Below,
> I've reproduced all of the relevant pieces from the current draft
> (including the existing text on traditional locks). Could I ask
> you to take a look at the pieces marked with '#' in column 1
> (which are places where I either tweaked your text significantly,
> or added details) and let me know if it looks okay.
> 
>   DESCRIPTION
>    Advisory record locking
> #      Linux  implements  traditional ("process-associated") UNIX record
> #      locks, as standardized by POSIX.  For a  Linux-specific  alterna‐
> #      tive  with  better  semantics,  see  the  discussion of open file
> #      description locks below.
> 
>        F_SETLK, F_SETLKW, and F_GETLK are used to acquire, release,  and
>        test for the existence of record locks (also known as byte-range,
>        file-segment, or file-region locks).  The third  argument,  lock,
>        is  a  pointer  to  a  structure  that has at least the following
>        fields (in unspecified order).
> 
>            struct flock {
>                ...
>                short l_type;    /* Type of lock: F_RDLCK,
>                                    F_WRLCK, F_UNLCK */
>                short l_whence;  /* How to interpret l_start:
>                                    SEEK_SET, SEEK_CUR, SEEK_END */
>                off_t l_start;   /* Starting offset for lock */
>                off_t l_len;     /* Number of bytes to lock */
>                pid_t l_pid;     /* PID of process blocking our lock
>                                    (set by F_GETLK and F_OFD_GETLK) */
>                ...
>            };
> 
>        The l_whence, l_start, and l_len fields of this structure specify
>        the  range  of  bytes we wish to lock.  Bytes past the end of the
>        file may be locked, but not bytes before the start of the file.
> 
>        l_start is the starting offset for the lock, and  is  interpreted
>        relative  to  either:  the  start  of  the  file  (if l_whence is
>        SEEK_SET); the current file offset (if l_whence is SEEK_CUR);  or
>        the  end of the file (if l_whence is SEEK_END).  In the final two
>        cases, l_start can be a negative number provided the offset  does
>        not lie before the start of the file.
> 
>        l_len  specifies  the  number of bytes to be locked.  If l_len is
>        positive, then the range to be locked covers bytes l_start up  to
>        and  including  l_start+l_len-1.   Specifying 0 for l_len has the
>        special meaning: lock all bytes starting at the  location  speci‐
>        fied  by l_whence and l_start through to the end of file, no mat‐
>        ter how large the file grows.
> 
>        POSIX.1-2001 allows (but does not require) an  implementation  to
>        support  a negative l_len value; if l_len is negative, the inter‐
>        val described by  lock  covers  bytes  l_start+l_len  up  to  and
>        including  l_start-1.   This  is  supported by Linux since kernel
>        versions 2.4.21 and 2.5.49.
> 
>        The l_type field can be used to place a read (F_RDLCK) or a write
>        (F_WRLCK)  lock  on  a  file.  Any number of processes may hold a
>        read lock (shared lock) on a file region, but  only  one  process
>        may  hold  a  write  lock  (exclusive  lock).   An exclusive lock
>        excludes all other locks, both shared and  exclusive.   A  single
>        process can hold only one type of lock on a file region; if a new
>        lock is applied to an already-locked region,  then  the  existing
>        lock  is  converted  to the new lock type.  (Such conversions may
>        involve splitting, shrinking, or coalescing with an existing lock
>        if  the  byte  range specified by the new lock does not precisely
>        coincide with the range of the existing lock.)
> 
>        F_SETLK (struct flock *)
>               Acquire a lock (when l_type  is  F_RDLCK  or  F_WRLCK)  or
>               release a lock (when l_type is F_UNLCK) on the bytes spec‐
>               ified by the l_whence, l_start, and l_len fields of  lock.
>               If  a  conflicting  lock  is held by another process, this
>               call returns -1 and sets errno to EACCES or EAGAIN.
> 
>        F_SETLKW (struct flock *)
>               As for F_SETLK, but if a conflicting lock is held  on  the
>               file, then wait for that lock to be released.  If a signal
>               is caught while waiting, then the call is interrupted  and
>               (after  the  signal  handler has returned) returns immedi‐
>               ately (with return value -1 and errno set  to  EINTR;  see
>               signal(7)).
> 
>        F_GETLK (struct flock *)
>               On input to this call, lock describes a lock we would like
>               to place on the  file.   If  the  lock  could  be  placed,
>               fcntl() does not actually place it, but returns F_UNLCK in
>               the l_type field of lock and leaves the  other  fields  of
>               the structure unchanged.
> 
>               If  one or more incompatible locks would prevent this lock
>               being placed, then fcntl() returns details  about  one  of
>               these  locks  in  the l_type, l_whence, l_start, and l_len
>               fields of lock.  If the conflicting lock is a  traditional
>               (process-associated)  record lock, then the l_pid field is
>               set to the PID of the process holding that lock.   If  the
>               conflicting  lock  is  an open file description lock, then
>               l_pid is set to -1.  Note that  the  returned  information
>               may already be out of date by the time the caller inspects
>               it.
> 
>        In order to place a read lock, fd must be open for  reading.   In
>        order  to  place  a  write lock, fd must be open for writing.  To
>        place both types of lock, open a file read-write.
> 
>        As well as being removed by an explicit F_UNLCK, record locks are
>        automatically released when the process terminates.
> 
>        Record  locks  are  not inherited by a child created via fork(2),
>        but are preserved across an execve(2).
> 
>        Because of the buffering performed by the stdio(3)  library,  the
>        use  of  record  locking  with routines in that package should be
>        avoided; use read(2) and write(2) instead.
> 
> #      The record locks described above are associated with the  process
> #      (unlike  the  open file description locks described below).  This
> #      has some unfortunate consequences:
> 
> #      *  If a process holding a lock on a file closes any file descrip‐
> #         tor  referring to the file, then all of the process's locks on
> #         the file are released, no matter which  file  descriptor  they
> #         were  obtained  via.  This is bad: it means that a process can
> #         lose its locks on a file such as /etc/passwd or /etc/mtab when
> #         for  some reason a library function decides to open, read, and
> #         close the same file.
> 
> #      *  The threads in a process share locks.  In other words, a  mul‐
> #         tithreaded  program  can't  use  record locking to ensure that
> #         threads don't simultaneously access the same region of a file.
> 
> #      Open file description locks solve both of these problems.
> 
>    Open file description locks (non-POSIX)
> #      Open file description locks are advisory byte-range  locks  whose
> #      operation is in most respects identical to the traditional record
> #      locks described above.  This lock  type  is  Linux-specific,  and
> #      available since Linux 3.15.
> 
> #      The  principal  difference  between  the  two  lock types is that
> #      whereas traditional record locks are associated with  a  process,
> #      open  file  description  locks  are associated with the open file
> #      description on which they are acquired, much like locks  acquired
> #      with  flock(2).   Consequently  (and  unlike traditional advisory
> #      record locks), open file description locks are  inherited  across
> #      fork(2)  (and  clone(2) with CLONE_FILES), and are only automati‐
> #      cally released on the last close of the  open  file  description,
> #      instead of being released on any close of the file.
> 
>        Open  file  description  locks  always  conflict with traditional
>        record locks, even when they are acquired by the same process  on
>        the same file descriptor.
> 
> #      Open  file  description  locks  placed  via  the  same  open file
> #      description (i.e., via the same file descriptor, or via a  dupli‐
> #      cate  of the file descriptor created by fork(2), dup(2), fcntl(2)
> #      F_DUPFD, and so on) are always  compatible:  if  a  new  lock  is
> #      placed  on  an  already  locked region, then the existing lock is
> #      converted to the new lock type.  (Such conversions may result  in
> #      splitting, shrinking, or coalescing with an existing lock as dis‐
> #      cussed above.)
> 
> #      On the other hand, open file description locks may conflict  with
> #      each  other  when  they  are  acquired  via  different  open file
> #      descriptions.  Thus, the threads in a multithreaded  program  can
> #      use  open  file description locks to synchronize access to a file
> #      region by having each thread perform its own open(2) on the  file
> #      and applying locks via the resulting file descriptor.
> 
>        As  with  traditional  advisory  locks,  the  third  argument  to
>        fcntl(), lock, is a pointer to an flock structure.   By  contrast
>        with  traditional record locks, the l_pid field of that structure
>        must be set to zero when using the commands described below.
> 
>        The commands for working with open  file  description  locks  are
>        analogous to those used with traditional locks:
> 
>        F_OFD_SETLK (struct flock *)
>               Acquire  an  open  file  description  lock (when l_type is
>               F_RDLCK or F_WRLCK) or release an  open  file  description
>               lock  (when  l_type  is F_UNLCK) on the bytes specified by
>               the l_whence, l_start, and l_len fields  of  lock.   If  a
>               conflicting  lock  is  held  by another process, this call
>               returns -1 and sets errno to EACCES or EAGAIN.
> 
>        F_OFD_SETLKW (struct flock *)
>               As for F_OFD_SETLK, but if a conflicting lock is  held  on
>               the  file,  then  wait for that lock to be released.  If a
>               signal is caught while waiting, then the  call  is  inter‐
>               rupted and (after the signal handler has returned) returns
>               immediately (with return value -1 and errno set to  EINTR;
>               see signal(7)).
> 
>        F_OFD_GETLK (struct flock *)
>               On  input  to  this  call,  lock  describes  an  open file
>               description lock we would like to place on the  file.   If
>               the  lock could be placed, fcntl() does not actually place
>               it, but returns F_UNLCK in the l_type field  of  lock  and
>               leaves  the  other  fields of the structure unchanged.  If
>               one or more incompatible locks  would  prevent  this  lock
>               being  placed,  then  details about one of these locks are
>               returned via lock, as described above for F_GETLK.
> 
>    Mandatory locking
>        Warning: the Linux implementation of mandatory locking is unreli‐
>        able.  See BUGS below.
> 
> #      By  default,  both traditional (process-associated) and open file
> #      description record locks are advisory.  Advisory  locks  are  not
> #      enforced and are useful only between cooperating processes.
> 
>        Both  lock  types  can  also  be  mandatory.  Mandatory locks are
>        enforced for all processes.  If a process  tries  to  perform  an
>        incompatible  access (e.g., read(2) or write(2)) on a file region
>        that has an incompatible mandatory lock, then the result  depends
>        upon  whether  the  O_NONBLOCK  flag is enabled for its open file
>        description.  If the O_NONBLOCK flag is  not  enabled,  then  the
>        system  call is blocked until the lock is removed or converted to
>        a mode that is compatible with the  access.   If  the  O_NONBLOCK
>        flag  is  enabled,  then  the  system  call  fails with the error
>        EAGAIN.
> 
>        To make use of mandatory locks, mandatory locking must be enabled
>        both  on  the filesystem that contains the file to be locked, and
>        on the file itself.  Mandatory locking is enabled on a filesystem
>        using  the  "-o mand" option to mount(8), or the MS_MANDLOCK flag
>        for mount(2).  Mandatory locking is enabled on  a  file  by  dis‐
>        abling group execute permission on the file and enabling the set-
>        group-ID permission bit (see chmod(1) and chmod(2)).
> 
>        Mandatory locking is not specified by POSIX.  Some other  systems
>        also  support  mandatory  locking, although the details of how to
>        enable it vary across systems.
> 
>   RETURN VALUE
>        For a successful call, the return value depends on the operation:
> 
>        F_DUPFD  The new descriptor.
> 
>        F_GETFD  Value of file descriptor flags.
> 
>        F_GETFL  Value of file status flags.
> 
>        F_GETLEASE
>                 Type of lease held on file descriptor.
> 
>        F_GETOWN Value of descriptor owner.
> 
>        F_GETSIG Value  of  signal sent when read or write becomes possi‐
>                 ble, or zero for traditional SIGIO behavior.
> 
>        F_GETPIPE_SZ
>                 The pipe capacity.
> 
> #      All other commands
> #               Zero.
> 
> #      On error, -1 is returned, and errno is set appropriately.
> 
>   ERRORS
>   [...]
> 
> #      EINVAL cmd is  F_OFD_SETLK,  F_OFD_SETLKW,  or  F_OFD_GETLK,  and
> #             l_pid was not specified as zero.
> 
>   [...]
> 
>   CONFORMING TO
>   [...]
>        F_OFD_SETLK, F_OFD_SETLKW, and  F_OFD_GETLK  are  Linux-specific,
>        but  work is being done to have them included in the next version
>        of POSIX.1.
> $ vi f
> f ==> /hdd/backup/home/mtk/man-pages/man-pages/man2/f/2014-04-30_12:44:55
> 
> $ cat f
>   DESCRIPTION
>   [...]
> 
>    Advisory record locking
> #      Linux  implements  traditional ("process-associated") UNIX record
> #      locks, as standardized by POSIX.  For a  Linux-specific  alterna‐
> #      tive  with  better  semantics,  see  the  discussion of open file
> #      description locks below.
> 
>        F_SETLK, F_SETLKW, and F_GETLK are used to acquire, release,  and
>        test for the existence of record locks (also known as byte-range,
>        file-segment, or file-region locks).  The third  argument,  lock,
>        is  a  pointer  to  a  structure  that has at least the following
>        fields (in unspecified order).
> 
>            struct flock {
>                ...
>                short l_type;    /* Type of lock: F_RDLCK,
>                                    F_WRLCK, F_UNLCK */
>                short l_whence;  /* How to interpret l_start:
>                                    SEEK_SET, SEEK_CUR, SEEK_END */
>                off_t l_start;   /* Starting offset for lock */
>                off_t l_len;     /* Number of bytes to lock */
>                pid_t l_pid;     /* PID of process blocking our lock
>                                    (set by F_GETLK and F_OFD_GETLK) */
>                ...
>            };
> 
>        The l_whence, l_start, and l_len fields of this structure specify
>        the  range  of  bytes we wish to lock.  Bytes past the end of the
>        file may be locked, but not bytes before the start of the file.
> 
>        l_start is the starting offset for the lock, and  is  interpreted
>        relative  to  either:  the  start  of  the  file  (if l_whence is
>        SEEK_SET); the current file offset (if l_whence is SEEK_CUR);  or
>        the  end of the file (if l_whence is SEEK_END).  In the final two
>        cases, l_start can be a negative number provided the offset  does
>        not lie before the start of the file.
> 
>        l_len  specifies  the  number of bytes to be locked.  If l_len is
>        positive, then the range to be locked covers bytes l_start up  to
>        and  including  l_start+l_len-1.   Specifying 0 for l_len has the
>        special meaning: lock all bytes starting at the  location  speci‐
>        fied  by l_whence and l_start through to the end of file, no mat‐
>        ter how large the file grows.
> 
>        POSIX.1-2001 allows (but does not require) an  implementation  to
>        support  a negative l_len value; if l_len is negative, the inter‐
>        val described by  lock  covers  bytes  l_start+l_len  up  to  and
>        including  l_start-1.   This  is  supported by Linux since kernel
>        versions 2.4.21 and 2.5.49.
> 
>        The l_type field can be used to place a read (F_RDLCK) or a write
>        (F_WRLCK)  lock  on  a  file.  Any number of processes may hold a
>        read lock (shared lock) on a file region, but  only  one  process
>        may  hold  a  write  lock  (exclusive  lock).   An exclusive lock
>        excludes all other locks, both shared and  exclusive.   A  single
>        process can hold only one type of lock on a file region; if a new
>        lock is applied to an already-locked region,  then  the  existing
>        lock  is  converted  to the new lock type.  (Such conversions may
>        involve splitting, shrinking, or coalescing with an existing lock
>        if  the  byte  range specified by the new lock does not precisely
>        coincide with the range of the existing lock.)
> 
>        F_SETLK (struct flock *)
>               Acquire a lock (when l_type  is  F_RDLCK  or  F_WRLCK)  or
>               release a lock (when l_type is F_UNLCK) on the bytes spec‐
>               ified by the l_whence, l_start, and l_len fields of  lock.
>               If  a  conflicting  lock  is held by another process, this
>               call returns -1 and sets errno to EACCES or EAGAIN.
> 
>        F_SETLKW (struct flock *)
>               As for F_SETLK, but if a conflicting lock is held  on  the
>               file, then wait for that lock to be released.  If a signal
>               is caught while waiting, then the call is interrupted  and
>               (after  the  signal  handler has returned) returns immedi‐
>               ately (with return value -1 and errno set  to  EINTR;  see
>               signal(7)).
> 
>        F_GETLK (struct flock *)
>               On input to this call, lock describes a lock we would like
>               to place on the  file.   If  the  lock  could  be  placed,
>               fcntl() does not actually place it, but returns F_UNLCK in
>               the l_type field of lock and leaves the  other  fields  of
>               the structure unchanged.
> 
>               If  one or more incompatible locks would prevent this lock
>               being placed, then fcntl() returns details  about  one  of
>               these  locks  in  the l_type, l_whence, l_start, and l_len
>               fields of lock.  If the conflicting lock is a  traditional
>               (process-associated)  record lock, then the l_pid field is
>               set to the PID of the process holding that lock.   If  the
>               conflicting  lock  is  an open file description lock, then
>               l_pid is set to -1.  Note that  the  returned  information
>               may already be out of date by the time the caller inspects
>               it.
> 
>        In order to place a read lock, fd must be open for  reading.   In
>        order  to  place  a  write lock, fd must be open for writing.  To
>        place both types of lock, open a file read-write.
> 
>        As well as being removed by an explicit F_UNLCK, record locks are
>        automatically released when the process terminates.
> 
>        Record  locks  are  not inherited by a child created via fork(2),
>        but are preserved across an execve(2).
> 
>        Because of the buffering performed by the stdio(3)  library,  the
>        use  of  record  locking  with routines in that package should be
>        avoided; use read(2) and write(2) instead.
> 
> #      The record locks described above are associated with the  process
> #      (unlike  the  open file description locks described below).  This
> #      has some unfortunate consequences:
> 
> #      *  If a process holding a lock on a file closes any file descrip‐
> #         tor  referring to the file, then all of the process's locks on
> #         the file are released, no matter which  file  descriptor  they
> #         were  obtained  via.  This is bad: it means that a process can

"were obtained via" is a little awkward. How about "regardless of which
file descriptor on which they were obtained".

> #         lose its locks on a file such as /etc/passwd or /etc/mtab when
> #         for  some reason a library function decides to open, read, and
> #         close the same file.
> 
> #      *  The threads in a process share locks.  In other words, a  mul‐
> #         tithreaded  program  can't  use  record locking to ensure that
> #         threads don't simultaneously access the same region of a file.
> 
> #      Open file description locks solve both of these problems.
> 
>    Open file description locks (non-POSIX)
> #      Open file description locks are advisory byte-range  locks  whose
> #      operation is in most respects identical to the traditional record
> #      locks described above.  This lock  type  is  Linux-specific,  and
> #      available since Linux 3.15.
> 
> #      The  principal  difference  between  the  two  lock types is that
> #      whereas traditional record locks are associated with  a  process,
> #      open  file  description  locks  are associated with the open file
> #      description on which they are acquired, much like locks  acquired
> #      with  flock(2).   Consequently  (and  unlike traditional advisory
> #      record locks), open file description locks are  inherited  across
> #      fork(2)  (and  clone(2) with CLONE_FILES), and are only automati‐
> #      cally released on the last close of the  open  file  description,
> #      instead of being released on any close of the file.
> 
>        Open  file  description  locks  always  conflict with traditional
>        record locks, even when they are acquired by the same process  on
>        the same file descriptor.
> 
> #      Open  file  description  locks  placed  via  the  same  open file
> #      description (i.e., via the same file descriptor, or via a  dupli‐
> #      cate  of the file descriptor created by fork(2), dup(2), fcntl(2)
> #      F_DUPFD, and so on) are always  compatible:  if  a  new  lock  is
> #      placed  on  an  already  locked region, then the existing lock is
> #      converted to the new lock type.  (Such conversions may result  in
> #      splitting, shrinking, or coalescing with an existing lock as dis‐
> #      cussed above.)
> 
> #      On the other hand, open file description locks may conflict  with
> #      each  other  when  they  are  acquired  via  different  open file
> #      descriptions.  Thus, the threads in a multithreaded  program  can
> #      use  open  file description locks to synchronize access to a file
> #      region by having each thread perform its own open(2) on the  file
> #      and applying locks via the resulting file descriptor.
> 
>        As  with  traditional  advisory  locks,  the  third  argument  to
>        fcntl(), lock, is a pointer to an flock structure.   By  contrast
>        with  traditional record locks, the l_pid field of that structure
>        must be set to zero when using the commands described below.
> 
>        The commands for working with open  file  description  locks  are
>        analogous to those used with traditional locks:
> 
>        F_OFD_SETLK (struct flock *)
>               Acquire  an  open  file  description  lock (when l_type is
>               F_RDLCK or F_WRLCK) or release an  open  file  description
>               lock  (when  l_type  is F_UNLCK) on the bytes specified by
>               the l_whence, l_start, and l_len fields  of  lock.   If  a
>               conflicting  lock  is  held  by another process, this call
>               returns -1 and sets errno to EACCES or EAGAIN.
> 
>        F_OFD_SETLKW (struct flock *)
>               As for F_OFD_SETLK, but if a conflicting lock is  held  on
>               the  file,  then  wait for that lock to be released.  If a
>               signal is caught while waiting, then the  call  is  inter‐
>               rupted and (after the signal handler has returned) returns
>               immediately (with return value -1 and errno set to  EINTR;
>               see signal(7)).
> 
>        F_OFD_GETLK (struct flock *)
>               On  input  to  this  call,  lock  describes  an  open file
>               description lock we would like to place on the  file.   If
>               the  lock could be placed, fcntl() does not actually place
>               it, but returns F_UNLCK in the l_type field  of  lock  and
>               leaves  the  other  fields of the structure unchanged.  If
>               one or more incompatible locks  would  prevent  this  lock
>               being  placed,  then  details about one of those locks are
>               returned via lock, as described above for F_GETLK.
> 
>    Mandatory locking
>        Warning: the Linux implementation of mandatory locking is unreli‐
>        able.  See BUGS below.
> 
> #      By  default,  both traditional (process-associated) and open file
> #      description record locks are advisory.  Advisory  locks  are  not
> #      enforced and are useful only between cooperating processes.
> 
>        Both  lock  types  can  also  be  mandatory.  Mandatory locks are
>        enforced for all processes.  If a process  tries  to  perform  an
>        incompatible  access (e.g., read(2) or write(2)) on a file region
>        that has an incompatible mandatory lock, then the result  depends
>        upon  whether  the  O_NONBLOCK  flag is enabled for its open file
>        description.  If the O_NONBLOCK flag is  not  enabled,  then  the
>        system  call is blocked until the lock is removed or converted to
>        a mode that is compatible with the  access.   If  the  O_NONBLOCK
>        flag  is  enabled,  then  the  system  call  fails with the error
>        EAGAIN.
> 
>        To make use of mandatory locks, mandatory locking must be enabled
>        both  on  the filesystem that contains the file to be locked, and
>        on the file itself.  Mandatory locking is enabled on a filesystem
>        using  the  "-o mand" option to mount(8), or the MS_MANDLOCK flag
>        for mount(2).  Mandatory locking is enabled on  a  file  by  dis‐
>        abling group execute permission on the file and enabling the set-
>        group-ID permission bit (see chmod(1) and chmod(2)).
> 
>        Mandatory locking is not specified by POSIX.  Some other  systems
>        also  support  mandatory  locking, although the details of how to
>        enable it vary across systems.
> 
>   [...]
> 
>   RETURN VALUE
>        For a successful call, the return value depends on the operation:
> 
>        F_DUPFD  The new descriptor.
> 
>        F_GETFD  Value of file descriptor flags.
> 
>        F_GETFL  Value of file status flags.
> 
>        F_GETLEASE
>                 Type of lease held on file descriptor.
> 
>        F_GETOWN Value of descriptor owner.
> 
>        F_GETSIG Value  of  signal sent when read or write becomes possi‐
>                 ble, or zero for traditional SIGIO behavior.
> 
>        F_GETPIPE_SZ
>                 The pipe capacity.
> 
> #      All other commands
> #               Zero.
> 
> #      On error, -1 is returned, and errno is set appropriately.
> 
>   ERRORS
>   [...]
> 
> #      EINVAL cmd is  F_OFD_SETLK,  F_OFD_SETLKW,  or  F_OFD_GETLK,  and
> #             l_pid was not specified as zero.
> 

The kernel will also return -EINVAL if it doesn't recognize the cmd
value being passed in. It may be worth mentioning that as well as
that's the best mechanism to tell whether the kernel actually supports
OFD locks.

>   [...]
> 
>   CONFORMING TO
>   [...]
> #      F_OFD_SETLK, F_OFD_SETLKW, and  F_OFD_GETLK  are  Linux-specific,
> #      but  work is being done to have them included in the next version
> #      of POSIX.1.
> 
> 
> Cheers,
> 
> Michael
> 
> 

Other than the two nits above, this looks great.

Thanks!
-- 
Jeff Layton <jlayton@poochiereds.net>
