Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaEZRBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:01:49 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:64447 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaEZRBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:01:41 -0400
MIME-Version: 1.0
In-Reply-To: <1401110850-3552-4-git-send-email-tixxdz@opendz.org>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org> <1401110850-3552-4-git-send-email-tixxdz@opendz.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 26 May 2014 10:01:20 -0700
Message-ID: <CALCETrU+O+p_EYao1k6y0t6JnJ+sV97zAGkn=enuJPEzpcW_Wg@mail.gmail.com>
Subject: Re: [PATCH 3/9] procfs: add proc_read_from_buffer() and
 pid_entry_read() helpers
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 6:27 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> This patch is preparation, it adds a couple of helpers to read data and
> to get the cached permission checks during that ->read().
>
> Currently INF entries share the same code, they do not implement
> specific ->open(), only ->read() coupled with callback calls. Doing
> permission checks during ->open() will not work and will only disturb
> the INF entries that do not need permission checks. Yes not all the INF
> entries need checks, the ones that need protections are listed below:
> /proc/<pid>/wchan
> /proc/<pid>/syscall
> /proc/<pid>/{auxv,io}  (will be handled in next patches).
>
> So to have proper permission checks convert this INF entries to REG
> entries and use their open() and read() handlers to implement these
> checks. To achieve this we add the following helpers:
>
> * proc_read_from_buffer() a wrapper around simple_read_from_buffer(), it
>   makes sure that count <= PROC_BLOCK_SIZE (3*1024)
>
> * pid_entry_read(): it will get a free page and pass it to the specific
>   /proc/<pid>/$entry handler (callback). The handler is of the same
>   types of the previous INF handlers, it will only receive an extra
>   "permitted" argument that contains the cached permission check that
>   was performed during ->open().
>
>   The handler is of type:
>   typedef int (*proc_read_fn_t)(char *page,
>                                struct task_struct *task, int permitted);

[...]

This strikes me as *way* too complicated.  Why not just change
proc_info_file_operations to *always* cache may_ptrace on open?

FWIW, it's been awhile: was anything actually wrong with using f_cred,
other than the fact that it would have required adjusting the LSM
hooks?

Admittedly, I don't see anything fundamentally wrong with caching
may_ptrace on open as long as revoke in in the cards eventually, but
it's plausible that a good f_cred-based implementation would make
revoke less necessary.

--Andy
