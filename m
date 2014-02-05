Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaBENxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:53:22 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34798 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751480AbaBENxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:53:21 -0500
Message-ID: <52F2424A.609@hurleysoftware.com>
Date: Wed, 05 Feb 2014 08:53:14 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>, Hannes Reinecke <hare@suse.de>
CC: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Kay Sievers <kay@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [systemd-devel] [PATCH] tty: Set correct tty name in 'active'
 sysfs attribute
References: <1391595106-86957-1-git-send-email-hare@suse.de> <CANq1E4QM-SwAhBmgGgmKjAHaKW-QZ7GPBkKyrv_=ek1CFmRWEw@mail.gmail.com>
In-Reply-To: <CANq1E4QM-SwAhBmgGgmKjAHaKW-QZ7GPBkKyrv_=ek1CFmRWEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 07:53 AM, David Herrmann wrote:
> Hi
>
> On Wed, Feb 5, 2014 at 11:11 AM, Hannes Reinecke <hare@suse.de> wrote:
>> The 'active' sysfs attribute should refer to the currently
>> active tty devices the console is running on, not the currently
>> active console.
>> The console structure doesn't refer to any device in sysfs,
>> only the tty the console is running on has.
>> So we need to print out the tty names in 'active', not
>> the console names.
>>
>> Cc: Lennart Poettering <lennart@poettering.net>
>> Cc: Kay Sievers <kay@vrfy.org>
>> Signed-off-by: Werner Fink <werner@suse.de>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/tty/tty_io.c | 14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
>> index c74a00a..17db8ca 100644
>> --- a/drivers/tty/tty_io.c
>> +++ b/drivers/tty/tty_io.c
>> @@ -3545,9 +3545,19 @@ static ssize_t show_cons_active(struct device *dev,
>>                  if (i >= ARRAY_SIZE(cs))
>>                          break;
>>          }
>> -       while (i--)
>> +       while (i--) {
>> +               const struct tty_driver *driver;
>> +               const char *name = cs[i]->name;
>> +               int index = cs[i]->index;
>> +
>> +               driver = cs[i]->device(cs[i], &index);
>> +               if (driver) {
>> +                       index += driver->name_base;
>> +                       name = driver->name;
>> +               }
>>                  count += sprintf(buf + count, "%s%d%c",
>> -                                cs[i]->name, cs[i]->index, i ? ' ':'\n');
>> +                                name, index, i ? ' ':'\n');
>> +       }
>
> Nice catch and indeed, systemd already relies on these names to be
> identical to their char-dev name. Fortunately, VTs and most serial
> devices register the console with the same name as the TTY, so we're
> fine.

What device did this trip over?

Also, this file is not private to systemd. Maybe these changes should
be forked into a different sysfs attribute, "active_devices"?

Regards,
Peter Hurley
