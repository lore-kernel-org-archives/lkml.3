Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab3CLSYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:24:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355Ab3CLSYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:24:12 -0400
Date: Tue, 12 Mar 2013 19:22:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: Regression with orderly_poweroff()
Message-ID: <20130312182210.GA15862@redhat.com>
References: <1363058712.4534.12.camel@pasglop> <CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com> <CAKi4VALkUhOtP_8BOi3Mi8fTz8TUPwmwQq7WW27BEDue2wFNRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKi4VALkUhOtP_8BOi3Mi8fTz8TUPwmwQq7WW27BEDue2wFNRw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12, Lucas De Marchi wrote:
>
> I have some pending patches on LKML to remove
> call_usermodehelper_fns() and export call_usermodehelper_{setup,exec}.
>  Doing this we can separate the allocation part using GFP_ATOMIC

But this is pointless. Contrary, we should change __orderly_poweroff()
to do not use GFP_ATOMIC for argv_split(), see below.

> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2194,7 +2194,8 @@ static int __orderly_poweroff(void)
>   "PATH=/sbin:/bin:/usr/sbin:/usr/bin",
>   NULL
>   };
> - int ret;
> + struct subprocess_info *info;
> + int ret = -ENOMEM;
> 
>   argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
>   if (argv == NULL) {
> @@ -2203,7 +2204,10 @@ static int __orderly_poweroff(void)
>   return -ENOMEM;
>   }
> 
> - ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
> + info = call_usermodehelper_setup(argv[0], argv, envp, GFP_ATOMIC,
> + NULL, NULL, NULL);
> + if (info)
> + ret = call_usermodehelper_exec(info, UMH_WAIT_EXEC);

And how this can help? The real problem is not GFP_KERNEL.
call_usermodehelper_exec(UMH_WAIT_EXEC) will block.

Oleg.

