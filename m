Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbaIDGqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 02:46:44 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45841 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaIDGqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 02:46:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140904011420.GA31350@kroah.com>
References: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
	<20140904004947.GA17138@vmdeb7>
	<20140904011420.GA31350@kroah.com>
Date: Thu, 4 Sep 2014 08:46:40 +0200
Message-ID: <CAH6sp9OaqkdW82HOKMf8gxLLsBzXPCq2HYj7ya+C3YXiFwhgOQ@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: remove possible use of uninitialized value
From: Frans Klaver <fransklaver@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Darren Hart <dvhart@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 3:14 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Sep 03, 2014 at 05:49:47PM -0700, Darren Hart wrote:
>> On Thu, Sep 04, 2014 at 12:53:25AM +0200, Frans Klaver wrote:
>> > In store_sys_acpi, if count equals zero, or parse_arg()s sscanf call
>> > fails, 'value' remains possibly uninitialized. In that case 'value'
>> > shouldn't be used to produce the store_sys_acpi()s return value.

Here I should probably remove either 'the' or the 's' after store_sys_acpi().


>> > Only test the return value of set_acpi() if we can actually call it.
>> > Return rv otherwise.
>> >
>> > Signed-off-by: Frans Klaver <fransklaver@gmail.com>
>> > ---
>> >  drivers/platform/x86/eeepc-laptop.c | 8 ++++----
>> >  1 file changed, 4 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
>> > index bd533c2..41f12ba 100644
>> > --- a/drivers/platform/x86/eeepc-laptop.c
>> > +++ b/drivers/platform/x86/eeepc-laptop.c
>> > @@ -279,10 +279,10 @@ static ssize_t store_sys_acpi(struct device *dev, int cm,
>> >     int rv, value;
>> >
>> >     rv = parse_arg(buf, count, &value);
>> > -   if (rv > 0)
>> > -           value = set_acpi(eeepc, cm, value);
>>
>> That was rather horrible wasn't it? :-)
>>
>> > -   if (value < 0)
>> > -           return -EIO;
>> > +   if (rv > 0) {
>> > +           if (set_acpi(eeepc, cm, value) < 0)
>> > +                   return -EIO;
>>
>> Is there a compelling reason not to propogate the return code of set_acpi?
>> (ENODEV specifically). I see -EIO in Documentation/filesystems/sysfs.txt, but
>> it's used by default if the show() pointer is NULL (for example), but otherwise
>> propogates the error.
>>
>> Specifically it states:
>>
>> - show() or store() can always return errors. If a bad value comes
>>   through, be sure to return an error.
>>
>> Greg, does this need to be -EIO? or is returning someting like ENODEV preferable
>> if it more accurately reflects the error?
>
> Just return the value of set_acpi() and you should be fine.

According to 6dff29b63a5bf2eaf3313cb8a84f0b7520c43401 "eeepc-laptop:
disp attribute should be write-only" it should be -EIO. -ENODEV would
be misleading.

Thanks,
Frans
