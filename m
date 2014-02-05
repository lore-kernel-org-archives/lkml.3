Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaBEMxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 07:53:49 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:60297 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaBEMxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 07:53:48 -0500
MIME-Version: 1.0
In-Reply-To: <1391595106-86957-1-git-send-email-hare@suse.de>
References: <1391595106-86957-1-git-send-email-hare@suse.de>
Date: Wed, 5 Feb 2014 13:53:47 +0100
Message-ID: <CANq1E4QM-SwAhBmgGgmKjAHaKW-QZ7GPBkKyrv_=ek1CFmRWEw@mail.gmail.com>
Subject: Re: [systemd-devel] [PATCH] tty: Set correct tty name in 'active'
 sysfs attribute
From: David Herrmann <dh.herrmann@gmail.com>
To: Hannes Reinecke <hare@suse.de>
Cc: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Kay Sievers <kay@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Feb 5, 2014 at 11:11 AM, Hannes Reinecke <hare@suse.de> wrote:
> The 'active' sysfs attribute should refer to the currently
> active tty devices the console is running on, not the currently
> active console.
> The console structure doesn't refer to any device in sysfs,
> only the tty the console is running on has.
> So we need to print out the tty names in 'active', not
> the console names.
>
> Cc: Lennart Poettering <lennart@poettering.net>
> Cc: Kay Sievers <kay@vrfy.org>
> Signed-off-by: Werner Fink <werner@suse.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/tty/tty_io.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index c74a00a..17db8ca 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -3545,9 +3545,19 @@ static ssize_t show_cons_active(struct device *dev,
>                 if (i >= ARRAY_SIZE(cs))
>                         break;
>         }
> -       while (i--)
> +       while (i--) {
> +               const struct tty_driver *driver;
> +               const char *name = cs[i]->name;
> +               int index = cs[i]->index;
> +
> +               driver = cs[i]->device(cs[i], &index);
> +               if (driver) {
> +                       index += driver->name_base;
> +                       name = driver->name;
> +               }
>                 count += sprintf(buf + count, "%s%d%c",
> -                                cs[i]->name, cs[i]->index, i ? ' ':'\n');
> +                                name, index, i ? ' ':'\n');
> +       }

Nice catch and indeed, systemd already relies on these names to be
identical to their char-dev name. Fortunately, VTs and most serial
devices register the console with the same name as the TTY, so we're
fine.
Two minor nitpicks:
1) Could you use tty_line_name() instead of sprintf()? It's in the
same file and avoids duplicating the name_base logic.
2) Does it make sense to print the console-name if ->device() returns
NULL? Seems weird if we print console-names and tty-names in the same
attribute. It's unlikely that it causes problems, but there might be
conflicts.

Thanks
David

>         console_unlock();
>
>         return count;
> --
> 1.7.12.4
>
> _______________________________________________
> systemd-devel mailing list
> systemd-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/systemd-devel
