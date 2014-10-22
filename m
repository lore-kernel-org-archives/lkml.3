Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbaJVSox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:44:53 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:59739 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaJVSov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:44:51 -0400
MIME-Version: 1.0
In-Reply-To: <1413978269-17274-2-git-send-email-drysdale@google.com>
References: <1413978269-17274-1-git-send-email-drysdale@google.com> <1413978269-17274-2-git-send-email-drysdale@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 22 Oct 2014 11:44:29 -0700
Message-ID: <CALCETrWbj=BTDyKqtbSKteANj3J3UFZnrvWv9DMosCoEZaSoeA@mail.gmail.com>
Subject: Re: [PATCHv5 1/3] syscalls,x86: implement execveat() system call
To: David Drysdale <drysdale@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 4:44 AM, David Drysdale <drysdale@google.com> wrote:
> Add a new system execveat(2) syscall. execveat() is to execve() as
> openat() is to open(): it takes a file descriptor that refers to a
> directory, and resolves the filename relative to that.
>

>         bprm->file = file;
> -       bprm->filename = bprm->interp = filename->name;
> +       if (fd == AT_FDCWD || filename->name[0] == '/') {
> +               bprm->filename = filename->name;
> +       } else {
> +               /*
> +                * Build a pathname that reflects how we got to the file,
> +                * either "/dev/fd/<fd>" (for an empty filename) or
> +                * "/dev/fd/<fd>/<filename>".
> +                */
> +               pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
> +               if (!pathbuf) {
> +                       retval = -ENOMEM;
> +                       goto out_unmark;
> +               }
> +               bprm->filename = pathbuf;
> +               if (filename->name[0] == '\0')
> +                       sprintf(pathbuf, "/dev/fd/%d", fd);

If the fd is O_CLOEXEC, then this will result in a confused child
process.  Should we fail exec attempts like that for non-static
programs?  (E.g. set filename to "" or something and fix up the binfmt
drivers to handle that?)

> +               else
> +                       snprintf(pathbuf, PATH_MAX,
> +                                "/dev/fd/%d/%s", fd, filename->name);

Does this need to handle the case where the result exceeds PATH_MAX?

--Andy
