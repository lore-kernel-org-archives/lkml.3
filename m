Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaIDOkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:40:19 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:47811 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaIDOkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:40:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140904141041.GB23299@kroah.com>
References: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
	<20140904004947.GA17138@vmdeb7>
	<20140904011420.GA31350@kroah.com>
	<CAH6sp9OaqkdW82HOKMf8gxLLsBzXPCq2HYj7ya+C3YXiFwhgOQ@mail.gmail.com>
	<20140904141041.GB23299@kroah.com>
Date: Thu, 4 Sep 2014 16:40:11 +0200
Message-ID: <CAH6sp9P3NJBFS=ewJnY3jVJc_dDf7LQs2TwYKZu7=bFhdAZXxg@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: remove possible use of uninitialized value
From: Frans Klaver <fransklaver@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Darren Hart <dvhart@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 4:10 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Sep 04, 2014 at 08:46:40AM +0200, Frans Klaver wrote:
>> On Thu, Sep 4, 2014 at 3:14 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Wed, Sep 03, 2014 at 05:49:47PM -0700, Darren Hart wrote:
>> >> On Thu, Sep 04, 2014 at 12:53:25AM +0200, Frans Klaver wrote:
>> >> > In store_sys_acpi, if count equals zero, or parse_arg()s sscanf call
>> >> > fails, 'value' remains possibly uninitialized. In that case 'value'
>> >> > shouldn't be used to produce the store_sys_acpi()s return value.
>>
>> Here I should probably remove either 'the' or the 's' after store_sys_acpi().
>>
>>
>> >> > Only test the return value of set_acpi() if we can actually call it.
>> >> > Return rv otherwise.
>> >> >
>> >> > Signed-off-by: Frans Klaver <fransklaver@gmail.com>
>> >> > ---
>> >> >  drivers/platform/x86/eeepc-laptop.c | 8 ++++----
>> >> >  1 file changed, 4 insertions(+), 4 deletions(-)
>> >> >
>> >> > diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
>> >> > index bd533c2..41f12ba 100644
>> >> > --- a/drivers/platform/x86/eeepc-laptop.c
>> >> > +++ b/drivers/platform/x86/eeepc-laptop.c
>> >> > @@ -279,10 +279,10 @@ static ssize_t store_sys_acpi(struct device *dev, int cm,
>> >> >     int rv, value;
>> >> >
>> >> >     rv = parse_arg(buf, count, &value);
>> >> > -   if (rv > 0)
>> >> > -           value = set_acpi(eeepc, cm, value);
>> >>
>> >> That was rather horrible wasn't it? :-)
>> >>
>> >> > -   if (value < 0)
>> >> > -           return -EIO;
>> >> > +   if (rv > 0) {
>> >> > +           if (set_acpi(eeepc, cm, value) < 0)
>> >> > +                   return -EIO;
>> >>
>> >> Is there a compelling reason not to propogate the return code of set_acpi?
>> >> (ENODEV specifically). I see -EIO in Documentation/filesystems/sysfs.txt, but
>> >> it's used by default if the show() pointer is NULL (for example), but otherwise
>> >> propogates the error.
>> >>
>> >> Specifically it states:
>> >>
>> >> - show() or store() can always return errors. If a bad value comes
>> >>   through, be sure to return an error.
>> >>
>> >> Greg, does this need to be -EIO? or is returning someting like ENODEV preferable
>> >> if it more accurately reflects the error?
>> >
>> > Just return the value of set_acpi() and you should be fine.
>>
>> According to 6dff29b63a5bf2eaf3313cb8a84f0b7520c43401 "eeepc-laptop:
>> disp attribute should be write-only" it should be -EIO. -ENODEV would
>> be misleading.
>
> If something is "write only" then there should not be a store function
> for it at all, the file should not be marked as writable, to prevent
> anything from ever being written to it at the higher-level filesystem
> layer, and never get down to the driver layer...

If something is "write only" it should not have a show function.
Removing the show function for the disp attribute would probably also
remove the necessity for the file permissions.

I'll I fire up my eeepc and see what I can figure out. Should I take
Pauls patch and see how it fits into this?

Thanks,
Frans
