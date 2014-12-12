Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030925AbaLLRUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:20:18 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:33599 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030874AbaLLRUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:20:15 -0500
MIME-Version: 1.0
In-Reply-To: <1415653764-22162-1-git-send-email-cernekee@gmail.com>
References: <1415653764-22162-1-git-send-email-cernekee@gmail.com>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Fri, 12 Dec 2014 09:19:54 -0800
Message-ID: <CAJiQ=7C9qV2acVLWjacwsRmGMbyKUqCT5VbnO5TzeLLX73xMaQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] [CIFS] Fix signed/unsigned pointer warning
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 1:09 PM, Kevin Cernekee <cernekee@gmail.com> wrote:
> Commit 2ae83bf93882d1 ("[CIFS] Fix setting time before epoch (negative
> time values)") changed "u64 t" to "s64 t", which makes do_div() complain
> about a pointer signedness mismatch:
>
>       CC      fs/cifs/netmisc.o
>     In file included from ./arch/mips/include/asm/div64.h:12:0,
>                      from include/linux/kernel.h:124,
>                      from include/linux/list.h:8,
>                      from include/linux/wait.h:6,
>                      from include/linux/net.h:23,
>                      from fs/cifs/netmisc.c:25:
>     fs/cifs/netmisc.c: In function ‘cifs_NTtimeToUnix’:
>     include/asm-generic/div64.h:43:28: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>       (void)(((typeof((n)) *)0) == ((uint64_t *)0)); \
>                                 ^
>     fs/cifs/netmisc.c:941:22: note: in expansion of macro ‘do_div’
>        ts.tv_nsec = (long)do_div(t, 10000000) * 100;
>
> Introduce a temporary "u64 abs_t" variable to fix this.
>
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>  fs/cifs/netmisc.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
>
> Note: this is compile-tested only (on a 32-bit build).
>
>
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index b333ff6..abae6dd 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -926,6 +926,7 @@ cifs_NTtimeToUnix(__le64 ntutc)
>
>         /* Subtract the NTFS time offset, then convert to 1s intervals. */
>         s64 t = le64_to_cpu(ntutc) - NTFS_TIME_OFFSET;
> +       u64 abs_t;
>
>         /*
>          * Unfortunately can not use normal 64 bit division on 32 bit arch, but
> @@ -933,13 +934,14 @@ cifs_NTtimeToUnix(__le64 ntutc)
>          * to special case them
>          */
>         if (t < 0) {
> -               t = -t;
> -               ts.tv_nsec = (long)(do_div(t, 10000000) * 100);
> +               abs_t = -t;
> +               ts.tv_nsec = (long)(do_div(abs_t, 10000000) * 100);
>                 ts.tv_nsec = -ts.tv_nsec;
> -               ts.tv_sec = -t;
> +               ts.tv_sec = -abs_t;
>         } else {
> -               ts.tv_nsec = (long)do_div(t, 10000000) * 100;
> -               ts.tv_sec = t;
> +               abs_t = t;
> +               ts.tv_nsec = (long)do_div(abs_t, 10000000) * 100;
> +               ts.tv_sec = abs_t;
>         }
>
>         return ts;
> --
> 2.1.1
>

Hi guys,

I am still seeing this warning on Linus' head of tree.  Do you think
this is something we can pull in for 3.19?

Thanks!
