Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaAQTye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:54:34 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:36636 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaAQTyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:54:32 -0500
MIME-Version: 1.0
In-Reply-To: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 17 Jan 2014 11:54:09 -0800
Message-ID: <CALCETrVO+gr2aeDzOz2x8kWKBDG04ugb2GjWdPphUsNzACKzoA@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/2] Add mm flag to control THP
To: Alex Thorlton <athorlton@sgi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 1:01 PM, Alex Thorlton <athorlton@sgi.com> wrote:
> This patch adds an mm flag (MMF_THP_DISABLE) to disable transparent
> hugepages using prctl.
>

> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1998,6 +1998,17 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>                 if (arg2 || arg3 || arg4 || arg5)
>                         return -EINVAL;
>                 return current->no_new_privs ? 1 : 0;
> +       case PR_SET_THP_DISABLE:
> +               if (arg2)
> +                       set_bit(MMF_THP_DISABLE, &me->mm->flags);
> +               else
> +                       clear_bit(MMF_THP_DISABLE, &me->mm->flags);
> +               break;
> +       case PR_GET_THP_DISABLE:
> +               error = put_user(test_bit(MMF_THP_DISABLE,
> +                                &me->mm->flags),
> +                                (int __user *) arg2);
> +               break;

Usual nit: please return -EINVAL if unused args are nonzero.  This
makes it possible to extend these APIs in the future.

--Andy
