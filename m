Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbaBUOqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:46:37 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:55606 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbaBUOqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:46:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAA_Uwz+DZJ0f6ow3YSsSK9HDt639P7Up4_5ienoJO5VW4ZhF2Q@mail.gmail.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
	<1392986945-9693-86-git-send-email-luis.henriques@canonical.com>
	<CAA_Uwz+DZJ0f6ow3YSsSK9HDt639P7Up4_5ienoJO5VW4ZhF2Q@mail.gmail.com>
Date: Fri, 21 Feb 2014 09:46:34 -0500
X-Google-Sender-Auth: k0ZPmx8Uxhp63TctxkjvKdO6S-c
Message-ID: <CA+5PVA72=8KvdOgTLc7NZfMq_bFob6-rEhTktNJJ0qBRgr4iiQ@mail.gmail.com>
Subject: Re: [PATCH 3.11 085/121] tty: Set correct tty name in 'active' sysfs attribute
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Ray Strode <halfline@gmail.com>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ubuntu kernel team <kernel-team@lists.ubuntu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        David Herrmann <dh.herrmann@gmail.com>, Werner Fink <werner@suse.de>,
        Hannes Reinecke <hare@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 9:37 AM, Ray Strode <halfline@gmail.com> wrote:
> Hi,
>
> This broke plymouth, i think.  Plymouth used the herustic:
> "/sys/class/tty/console/active contains something other than tty0" to
> mean "probably has serial consoles, force verbose messages instead of
> a splash screen".  Now on a normal system it contains tty1.
>
> I pushed a commit to plymouth that gets it working again, but it could
> cause compatiblity concerns if new kernels are pushed to old releases.

Hm.  Breaking userspace is probably a bad thing here.

Greg, you have this queued for 3.13.5 at the moment.  Maybe we should
hold off on this one until this discussion is sorted out?

josh

> On Fri, Feb 21, 2014 at 7:48 AM, Luis Henriques
> <luis.henriques@canonical.com> wrote:
>> 3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Hannes Reinecke <hare@suse.de>
>>
>> commit d8a5dc3033af2fd6d16030d2ee4fbd073460fe54 upstream.
>>
>> The 'active' sysfs attribute should refer to the currently active tty
>> devices the console is running on, not the currently active console.
>>
>> The console structure doesn't refer to any device in sysfs, only the tty
>> the console is running on has.  So we need to print out the tty names in
>> 'active', not the console names.
>>
>> This resolves an issue on s390 platforms in determining the correct
>> console device to use.
>>
>> Cc: Lennart Poettering <lennart@poettering.net>
>> Cc: Kay Sievers <kay@vrfy.org>
>> Cc: Jiri Slaby <jslaby@suse.cz>
>> Cc: David Herrmann <dh.herrmann@gmail.com>
>> Signed-off-by: Werner Fink <werner@suse.de>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
>> ---
>>  Documentation/ABI/testing/sysfs-tty |  3 ++-
>>  drivers/tty/tty_io.c                | 25 ++++++++++++++++++-------
>>  2 files changed, 20 insertions(+), 8 deletions(-)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-tty b/Documentation/ABI/testing/sysfs-tty
>> index ad22fb0..a2ccec3 100644
>> --- a/Documentation/ABI/testing/sysfs-tty
>> +++ b/Documentation/ABI/testing/sysfs-tty
>> @@ -3,7 +3,8 @@ Date:           Nov 2010
>>  Contact:       Kay Sievers <kay.sievers@vrfy.org>
>>  Description:
>>                  Shows the list of currently configured
>> -                console devices, like 'tty1 ttyS0'.
>> +                tty devices used for the console,
>> +                like 'tty1 ttyS0'.
>>                  The last entry in the file is the active
>>                  device connected to /dev/console.
>>                  The file supports poll() to detect virtual
>> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
>> index 20689b9..ced6b3e 100644
>> --- a/drivers/tty/tty_io.c
>> +++ b/drivers/tty/tty_io.c
>> @@ -1263,16 +1263,17 @@ static void pty_line_name(struct tty_driver *driver, int index, char *p)
>>   *     @p: output buffer of at least 7 bytes
>>   *
>>   *     Generate a name from a driver reference and write it to the output
>> - *     buffer.
>> + *     buffer. Return the number of bytes written.
>>   *
>>   *     Locking: None
>>   */
>> -static void tty_line_name(struct tty_driver *driver, int index, char *p)
>> +static ssize_t tty_line_name(struct tty_driver *driver, int index, char *p)
>>  {
>>         if (driver->flags & TTY_DRIVER_UNNUMBERED_NODE)
>> -               strcpy(p, driver->name);
>> +               return sprintf(p, "%s", driver->name);
>>         else
>> -               sprintf(p, "%s%d", driver->name, index + driver->name_base);
>> +               return sprintf(p, "%s%d", driver->name,
>> +                              index + driver->name_base);
>>  }
>>
>>  /**
>> @@ -3539,9 +3540,19 @@ static ssize_t show_cons_active(struct device *dev,
>>                 if (i >= ARRAY_SIZE(cs))
>>                         break;
>>         }
>> -       while (i--)
>> -               count += sprintf(buf + count, "%s%d%c",
>> -                                cs[i]->name, cs[i]->index, i ? ' ':'\n');
>> +       while (i--) {
>> +               struct tty_driver *driver;
>> +               const char *name = cs[i]->name;
>> +               int index = cs[i]->index;
>> +
>> +               driver = cs[i]->device(cs[i], &index);
>> +               if (driver) {
>> +                       count += tty_line_name(driver, index, buf + count);
>> +                       count += sprintf(buf + count, "%c", i ? ' ':'\n');
>> +               } else
>> +                       count += sprintf(buf + count, "%s%d%c",
>> +                                        name, index, i ? ' ':'\n');
>> +       }
>>         console_unlock();
>>
>>         return count;
>> --
>> 1.9.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
