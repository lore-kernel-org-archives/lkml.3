Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaBUOss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:48:48 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64442 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbaBUOsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:48:47 -0500
MIME-Version: 1.0
In-Reply-To: <20140220235119.236520201@linuxfoundation.org>
References: <20140220235118.191692546@linuxfoundation.org>
	<20140220235119.236520201@linuxfoundation.org>
Date: Fri, 21 Feb 2014 09:48:46 -0500
X-Google-Sender-Auth: KVy1zfQpdR2wOW6oGB2fqxrxFmc
Message-ID: <CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs attribute
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        David Herrmann <dh.herrmann@gmail.com>, Werner Fink <werner@suse.de>,
        Hannes Reinecke <hare@suse.de>, Ray Strode <halfline@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 6:52 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.13-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Hannes Reinecke <hare@suse.de>
>
> commit d8a5dc3033af2fd6d16030d2ee4fbd073460fe54 upstream.
>
> The 'active' sysfs attribute should refer to the currently active tty
> devices the console is running on, not the currently active console.
>
> The console structure doesn't refer to any device in sysfs, only the tty
> the console is running on has.  So we need to print out the tty names in
> 'active', not the console names.
>
> This resolves an issue on s390 platforms in determining the correct
> console device to use.

Just to be double sure this is seen, Ray points out that it breaks
current plymouth because the heuristic changed.  Hold off on this one?

josh

>
> Cc: Lennart Poettering <lennart@poettering.net>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: David Herrmann <dh.herrmann@gmail.com>
> Signed-off-by: Werner Fink <werner@suse.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  Documentation/ABI/testing/sysfs-tty |    3 ++-
>  drivers/tty/tty_io.c                |   25 ++++++++++++++++++-------
>  2 files changed, 20 insertions(+), 8 deletions(-)
>
> --- a/Documentation/ABI/testing/sysfs-tty
> +++ b/Documentation/ABI/testing/sysfs-tty
> @@ -3,7 +3,8 @@ Date:           Nov 2010
>  Contact:       Kay Sievers <kay.sievers@vrfy.org>
>  Description:
>                  Shows the list of currently configured
> -                console devices, like 'tty1 ttyS0'.
> +                tty devices used for the console,
> +                like 'tty1 ttyS0'.
>                  The last entry in the file is the active
>                  device connected to /dev/console.
>                  The file supports poll() to detect virtual
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -1267,16 +1267,17 @@ static void pty_line_name(struct tty_dri
>   *     @p: output buffer of at least 7 bytes
>   *
>   *     Generate a name from a driver reference and write it to the output
> - *     buffer.
> + *     buffer. Return the number of bytes written.
>   *
>   *     Locking: None
>   */
> -static void tty_line_name(struct tty_driver *driver, int index, char *p)
> +static ssize_t tty_line_name(struct tty_driver *driver, int index, char *p)
>  {
>         if (driver->flags & TTY_DRIVER_UNNUMBERED_NODE)
> -               strcpy(p, driver->name);
> +               return sprintf(p, "%s", driver->name);
>         else
> -               sprintf(p, "%s%d", driver->name, index + driver->name_base);
> +               return sprintf(p, "%s%d", driver->name,
> +                              index + driver->name_base);
>  }
>
>  /**
> @@ -3545,9 +3546,19 @@ static ssize_t show_cons_active(struct d
>                 if (i >= ARRAY_SIZE(cs))
>                         break;
>         }
> -       while (i--)
> -               count += sprintf(buf + count, "%s%d%c",
> -                                cs[i]->name, cs[i]->index, i ? ' ':'\n');
> +       while (i--) {
> +               struct tty_driver *driver;
> +               const char *name = cs[i]->name;
> +               int index = cs[i]->index;
> +
> +               driver = cs[i]->device(cs[i], &index);
> +               if (driver) {
> +                       count += tty_line_name(driver, index, buf + count);
> +                       count += sprintf(buf + count, "%c", i ? ' ':'\n');
> +               } else
> +                       count += sprintf(buf + count, "%s%d%c",
> +                                        name, index, i ? ' ':'\n');
> +       }
>         console_unlock();
>
>         return count;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
