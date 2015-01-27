Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbbA0RUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:20:30 -0500
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:51797
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755607AbbA0RU3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:20:29 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/7] staging: comedi: comedi_compat32.c: fix COMEDI_CMD
 copy back
Thread-Topic: [PATCH 1/7] staging: comedi: comedi_compat32.c: fix COMEDI_CMD
 copy back
Thread-Index: AQHQOkj/9sUSELuifke8cRQsJ9Wk5JzUlQUA//+dJrA=
Date: Tue, 27 Jan 2015 17:20:27 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D88260ECFDC@P3PWEX4MB002.ex4.secureserver.net>
References: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
 <1422373824-12793-2-git-send-email-abbotti@mev.co.uk>
 <54C7B5B2.1080607@mev.co.uk>
In-Reply-To: <54C7B5B2.1080607@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 27, 2015 8:59 AM, Ian Abbott wrote:
> On 27/01/15 15:50, Ian Abbott wrote:
>> `do_cmd_ioctl()` in "comedi_fops.c" handles the `COMEDI_CMD` ioctl.
>> This returns `-EAGAIN` if it has copied a modified `struct comedi_cmd`
>> back to user-space.  (This occurs when the low-level Comedi driver's
>> `do_cmdtest()` handler returns non-zero to indicate a problem with the
>> contents of the `struct comedi_cmd`, or when the `struct comedi_cmd` has
>> the `CMDF_BOGUS` flag set.)
>>
>> `compat_cmd()` in "comedi_compat32.c" handles the 32-bit compatible
>> version of the `COMEDI_CMD` ioctl.  Currently, it never copies a 32-bit
>> compatible version of `struct comedi_cmd` back to user-space, which is
>> at odds with the way the regular `COMEDI_CMD` ioctl is handled.  To fix
>> it, change `compat_cmd()` to copy a 32-bit compatible version of the
>> `struct comedi_cmd` back to user-space when the main ioctl handler
>> returns `-EAGAIN`.
>>
>> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
>> Cc: <stable@vger.kernel.org>
>> ---
>>   drivers/staging/comedi/comedi_compat32.c | 13 +++++++++++--
>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/comedi/comedi_compat32.c b/drivers/staging/comedi/comedi_compat32.c
>> index 5a4c74f..2440c60 100644
>> --- a/drivers/staging/comedi/comedi_compat32.c
>> +++ b/drivers/staging/comedi/comedi_compat32.c
>> @@ -262,7 +262,8 @@ static int compat_cmd(struct file *file, unsigned long arg)
>>   {
>>   	struct comedi_cmd __user *cmd;
>>   	struct comedi32_cmd_struct __user *cmd32;
>> -	int rc;
>> +	long rc;
>> +	int err;
>
> Gah!  That change in type of the 'rc' variable resulted from me changing 
> the order of the patches in the series.  It still works, but looks a bit 
> out of place.  Should I post an updated version without this niggle?

Please fix it. I does look strange. Actually, the last patch looks strange.

The "normal" return type in the kernel is an 'int'. As you mention in the
commit message: "The `unlocked_ioctl` and `compat_ioctl` file operations
are both defined to return a `long` (I don't know why)." It seems cleaner
to just have all the static functions return an int and just have
comedi_compat_ioctl() return the long value. Maybe just add a comment
why...

My 2 cents...

Regards,
Hartley




