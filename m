Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaF3OyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:54:21 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36842 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaF3OyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:54:19 -0400
MIME-Version: 1.0
In-Reply-To: <1404124096-21445-16-git-send-email-drysdale@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com> <1404124096-21445-16-git-send-email-drysdale@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 30 Jun 2014 07:53:57 -0700
Message-ID: <CALCETrUi71FgVABRF4C+n_STc02j=GxRwBqDaoC+NLeAP9Ui3w@mail.gmail.com>
Subject: Re: [PATCH 4/5] man-pages: cap_rights_limit.2: limit FD rights for Capsicum
To: David Drysdale <drysdale@google.com>
Cc: LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 3:28 AM, David Drysdale <drysdale@google.com> wrote:
> Signed-off-by: David Drysdale <drysdale@google.com>
> ---
>  man2/cap_rights_limit.2 | 171 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 171 insertions(+)
>  create mode 100644 man2/cap_rights_limit.2
>
> diff --git a/man2/cap_rights_limit.2 b/man2/cap_rights_limit.2
> new file mode 100644
> index 000000000000..3484ee1076aa
> --- /dev/null
> +++ b/man2/cap_rights_limit.2
> @@ -0,0 +1,171 @@
> +.\"
> +.\" Copyright (c) 2008-2010 Robert N. M. Watson
> +.\" Copyright (c) 2012-2013 The FreeBSD Foundation
> +.\" Copyright (c) 2013-2014 Google, Inc.
> +.\" All rights reserved.
> +.\"
> +.\" %%%LICENSE_START(BSD_2_CLAUSE)
> +.\" Redistribution and use in source and binary forms, with or without
> +.\" modification, are permitted provided that the following conditions
> +.\" are met:
> +.\" 1. Redistributions of source code must retain the above copyright
> +.\"    notice, this list of conditions and the following disclaimer.
> +.\" 2. Redistributions in binary form must reproduce the above copyright
> +.\"    notice, this list of conditions and the following disclaimer in the
> +.\"    documentation and/or other materials provided with the distribution.
> +.\"
> +.\" THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
> +.\" ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> +.\" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> +.\" ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
> +.\" FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> +.\" DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> +.\" OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> +.\" HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
> +.\" LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
> +.\" OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
> +.\" SUCH DAMAGE.
> +.\" %%%LICENSE_END
> +.\"
> +.TH CAP_RIGHTS_LIMIT 2 2014-05-07 "Linux" "Linux Programmer's Manual"
> +.SH NAME
> +cap_rights_limit \- limit Capsicum capability rights
> +.SH SYNOPSIS
> +.nf
> +.B #include <sys/capsicum.h>
> +.sp
> +.BI "int cap_rights_limit(int " fd ", const struct cap_rights *" rights ,
> +.BI "                     unsigned int " fcntls ,
> +.BI "                     int " nioctls ", unsigned int *" ioctls );

Am I missing the docs for struct cap_rights somewhere?

> +.SH DESCRIPTION
> +When a file descriptor is created by a function such as
> +.BR accept (2),
> +.BR accept4 (2),
> +.BR creat (2),
> +.BR epoll_create (2),
> +.BR eventfd (2),
> +.BR mq_open (2),
> +.BR open (2),
> +.BR openat (2),
> +.BR pdfork (2),
> +.BR pipe (2),
> +.BR pipe2 (2),
> +.BR signalfd (2),
> +.BR socket (2),
> +.BR socketpair (2)
> +or
> +.BR timerfd_create (2),
> +it implicitly has all Capsicum capability rights.
> +Those rights can be reduced (but never expanded) by using the
> +.BR cap_rights_limit ()
> +system call.
> +Once Capsicum capability rights are reduced, operations on the file descriptor
> +.I fd
> +will be limited to those permitted by the remainder of the arguments.
> +.PP
> +The
> +.I rights
> +argument describes the primary rights for the file descriptor, and
> +should be prepared using
> +.BR cap_rights_init (3)
> +family of functions.  The complete list of primary rights can be found in the
> +.BR rights (7)
> +manual page.
> +.PP
> +If a file descriptor is granted the
> +.B CAP_FCNTL
> +primary capability right, the list of allowed
> +.BR fcntl (2)
> +commands can be selectively reduced (but never expanded) with the
> +.I fcntls
> +argument.  The following flags may be specified in the
> +.I fcntls
> +argument:
> +.TP
> +.B CAP_FCNTL_GETFL
> +Permit
> +.B F_GETFL
> +command.
> +.TP
> +.B CAP_FCNTL_SETFL
> +Permit
> +.B F_SETFL
> +command.
> +.TP
> +.B CAP_FCNTL_GETOWN
> +Permit
> +.B F_GETOWN
> +command.
> +.TP
> +.B CAP_FCNTL_SETOWN
> +Permit
> +.B F_SETOWN
> +command.
> +.PP
> +A value of
> +.B CAP_FCNTL_ALL
> +for the
> +.I fcntls
> +argument leaves the set of allowed
> +.BR fcntl (2)
> +commands unchanged.

What about the locking fcntl operations?  (Arguably the old crappy
POSIX lock operations should be flat-out disallowed on capability fds,
but I see nothing wrong with selectively allowing the new open file
description locks.)

--Andy
