Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbaJ3HEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 03:04:50 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57167 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaJ3HEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 03:04:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Xiong Zhou <jencce.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@android.com, nnk@google.com,
        john.stultz@linaro.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: android: logger: fix kuid/uid in logger_entry
Date: Thu, 30 Oct 2014 08:04:44 +0100
Message-ID: <3175901.1lz7PhpNtK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.LFD.2.11.1410301007090.3316@dhcp12-144.nay.redhat.com>
References: <alpine.LFD.2.11.1410301007090.3316@dhcp12-144.nay.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:lp0vCufT2b87wisys3HaFsFU6lfVgUIlXtr3C/fV0DM
 sj+TIklaSfcxHAcj/txcD2l+jZqmIovVPGGSrForxLwHb1XdNY
 ylYo4WKGLYAzaweGa21uVWqW3lYFl6Z5wvDEzoUP8OIUoqumCs
 fGcLocChuu5XOKCp1g1oQpV6Eiy83HTGxcK0no4U5pR2oaJJOT
 OtReXtAPycteBjQfobpYH0bxO46l4oTno3Z4fDrj6W4TJOrdn6
 NLPBolav9BxpGKqcQXgWCmRCOLXX+9xWBhbhT99L47whonrBRV
 p5Pmbbta2MqxWJ3dCVDz423BT4O0TAVJC18lzTPn1bYMBteGrX
 Rg6xA7vCIPBQvhRTPI6A=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 10:23:31 Xiong Zhou wrote:
> From: Xiong Zhou <jencce.kernel@gmail.com>
> 
> struct logger_entry can be returned to userspace via ioctl,
> so it is wrong to have a kuid_t member, fixing it to uid_t.
> This was introduced by commit bd471258f2, to pass uidguid
> type checks : UIDGID_STRICT_TYPE_CHECKS, which has been
> removed from kernel in commit 261000a56b6.
> 
> Fixes: bd471258f2 (logger: use kuid_t instead of uid_t)
> Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>

Sorry, but this isn't good.

You had an earlier patch that introduced a bug by hiding a warning,
and now you send a new patch to hide the bug better instead of
fixing it?

> diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
> index 28b93d3..fb06bf2 100644
> --- a/drivers/staging/android/logger.c
> +++ b/drivers/staging/android/logger.c
> @@ -252,7 +252,7 @@ static size_t get_next_entry_by_uid(struct logger_log *log,
> 
>                 entry = get_entry_header(log, off, &scratch);
> 
> -               if (uid_eq(entry->euid, euid))
> +               if (entry->euid == __kuid_val(euid))
>                         return off;
> 
>                 next_len = sizeof(struct logger_entry) + entry->len;

The code above was correct, you are just breaking it more.

> @@ -430,7 +430,7 @@ static ssize_t logger_write_iter(struct kiocb *iocb, struct iov_iter *from)
>         header.tid = current->pid;
>         header.sec = now.tv_sec;
>         header.nsec = now.tv_nsec;
> -       header.euid = current_euid();
> +       header.euid = __kuid_val(current_euid());
>         header.len = count;
>         header.hdr_size = sizeof(struct logger_entry);
> 

This writes to the internal data structure, so here you should still use
kuid_t. The problem is that you are later leaking this to user space,
so a user in one container can read entries from a user with the same
uid in another container, and that a process calling read() with the
r_all bit set will get entries with uids from all containers, using
the kernel-internal uid values instead of the ones valid for the current
container.

	Arnd
