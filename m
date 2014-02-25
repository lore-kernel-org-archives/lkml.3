Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaBYHvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:51:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44920 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbaBYHvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:51:04 -0500
Message-ID: <530C4B65.2060207@suse.de>
Date: Tue, 25 Feb 2014 08:51:01 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Ray Strode <halfline@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Werner Fink <werner@suse.de>
Subject: Re: [PATCHv3] tty: Set correct tty name in 'active' sysfs attribute
References: <1393253450-12217-1-git-send-email-hare@suse.de> <CANq1E4Tt4bomRh9i1CL6LDYFi4afX1pPABJSczRSGsMJZsiqqg@mail.gmail.com>
In-Reply-To: <CANq1E4Tt4bomRh9i1CL6LDYFi4afX1pPABJSczRSGsMJZsiqqg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 03:58 PM, David Herrmann wrote:
> Hi
> 
> On Mon, Feb 24, 2014 at 3:50 PM, Hannes Reinecke <hare@suse.de> wrote:
>> The 'active' sysfs attribute should refer to the currently
>> active tty devices the console is running on, not the currently
>> active console.
>> The console structure doesn't refer to any device in sysfs,
>> only the tty the console is running on has.
>> So we need to print out the tty names in 'active', not
>> the console names.
>> But we need to take care for the virtual console to always display
>> 'tty0' so as not to break existing programs.
>>
>> Cc: Lennart Poettering <lennart@poettering.net>
>> Cc: Kay Sievers <kay@vrfy.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Jiri Slaby <jslaby@suse.cz>
>> Signed-off-by: Werner Fink <werner@suse.de>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/tty/tty_io.c | 24 ++++++++++++++++++------
>>  1 file changed, 18 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
>> index c74a00a..96eb462 100644
>> --- a/drivers/tty/tty_io.c
>> +++ b/drivers/tty/tty_io.c
>> @@ -1271,12 +1271,13 @@ static void pty_line_name(struct tty_driver *driver, int index, char *p)
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
>> @@ -3545,9 +3546,20 @@ static ssize_t show_cons_active(struct device *dev,
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
>> +               /* Some programs rely on 'tty0' for console */
>> +               if (driver && (index > 0 || driver->major != TTY_MAJOR)) {
> 
> As Ray mentioned in the previous discussion, this has to be
> cs[i]->index instead of "index" as ->device() changes the parameter.
> See drivers/tty/vt/vt.c vt_console_device().
> 
Positive?
I thought this was precisely the problem, ->device() changing the
index '0' into something non-zero.
The reports we had were that the line 'tty0' changed into 'tty1'.
Hence ->device() converted cs[i]->index (which is '0') into index
(which is '1').
Hence the check would be correct, wouldn't it?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
