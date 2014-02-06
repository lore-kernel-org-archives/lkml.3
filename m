Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaBFPq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:46:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbaBFPqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:46:24 -0500
Message-ID: <52F3AE4F.8060504@suse.de>
Date: Thu, 06 Feb 2014 16:46:23 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Kay Sievers <kay@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [systemd-devel] [PATCH] tty: Set correct tty name in 'active'
 sysfs attribute
References: <1391595106-86957-1-git-send-email-hare@suse.de> <CANq1E4QM-SwAhBmgGgmKjAHaKW-QZ7GPBkKyrv_=ek1CFmRWEw@mail.gmail.com>
In-Reply-To: <CANq1E4QM-SwAhBmgGgmKjAHaKW-QZ7GPBkKyrv_=ek1CFmRWEw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 01:53 PM, David Herrmann wrote:
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
>>  drivers/tty/tty_io.c | 14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
>> index c74a00a..17db8ca 100644
>> --- a/drivers/tty/tty_io.c
>> +++ b/drivers/tty/tty_io.c
>> @@ -3545,9 +3545,19 @@ static ssize_t show_cons_active(struct device *dev,
>>                 if (i >= ARRAY_SIZE(cs))
>>                         break;
>>         }
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
>>                 count += sprintf(buf + count, "%s%d%c",
>> -                                cs[i]->name, cs[i]->index, i ? ' ':'\n');
>> +                                name, index, i ? ' ':'\n');
>> +       }
> 
> Nice catch and indeed, systemd already relies on these names to be
> identical to their char-dev name. Fortunately, VTs and most serial
> devices register the console with the same name as the TTY, so we're
> fine.
> Two minor nitpicks:
> 1) Could you use tty_line_name() instead of sprintf()? It's in the
> same file and avoids duplicating the name_base logic.
Ok. Not that it makes the patch nicer, but hey.

> 2) Does it make sense to print the console-name if ->device() returns
> NULL? Seems weird if we print console-names and tty-names in the same
> attribute. It's unlikely that it causes problems, but there might be
> conflicts.
> 
This is basically a fallback; this is the old behaviour, which still
might be called for when coming across a tty which just has a stub
for the ->device callback.
It's not that the '->device' callback is used that frequently, so I
wouldn't be surprised here.

Meanwhile I've sent a new patch, reviews are welcome there.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
