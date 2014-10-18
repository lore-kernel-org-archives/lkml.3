Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaJRXUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 19:20:50 -0400
Received: from mx02b.posteo.de ([89.146.230.120]:54452 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751238AbaJRXUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 19:20:49 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Oct 2014 19:20:49 EDT
Message-ID: <5442F3D0.3070203@posteo.de>
Date: Sun, 19 Oct 2014 01:12:16 +0200
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: arnd@arndb.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: always assign miscdevice to file->private_data
 in open()
References: <1412758074-7882-1-git-send-email-martink@posteo.de> <20141008134307.GA6099@kroah.com> <5436893D.5050804@posteo.de> <20141009155020.GB27912@kroah.com>
In-Reply-To: <20141009155020.GB27912@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-10-09 17:50, schrieb Greg KH:
> On Thu, Oct 09, 2014 at 03:10:21PM +0200, Martin Kepplinger wrote:
>> Am 2014-10-08 15:43, schrieb Greg KH:
>>> On Wed, Oct 08, 2014 at 10:47:54AM +0200, Martin Kepplinger wrote:
>>>> As of now, a miscdevice driver has to provide an implementation of
>>>> the open() file operation if it wants to have misc_open() assign a
>>>> pointer to struct miscdevice to file->private_data for other file
>>>> operations to use (given the user calls open()).
>>>>
>>>> This leads to situations where a miscdevice driver that doesn't need
>>>> internal operations during open() has to implement open() that only
>>>> returns immediately, in order to use the data in private_data in other
>>>> fops.
>>>
>>> Yeah, that's messy, do we have any in-kernel misc drivers that do this?
>>>
>>>> This change provides consistent behaviour for miscdevice developers by
>>>> always providing the pointer in private_data. A driver's open() fop would,
>>>> of course, just overwrite it, when using private_data itself.
>>>>
>>>> Signed-off-by: Martin Kepplinger <martink@posteo.de>
>>>> ---
>>>> This is really only a question: Do I understand this correctly, and,
>>>> could this change then hurt any existing driver?
>>>
>>> I don't know, take a look at the existing ones and see please.
>>>
>>>> As a driver developer it took me a while to figure out what happens here,
>>>> and in my situation it would have been nice to just have this feature as
>>>> part of the miscdevice API. Possibly documented somewhere?
>>>
>>> Patches always accepted for documentation :)
>>
>> What would be a good place for this?
>> Documentation/driver-model/device.txt or
>> Documentation/filesystem/vfs.txt like so? I'm not sure.
> 
> There's no documentation for misc devices?  If not, just put it in
> kerneldoc format in the misc .c file.
> 
>> >From facd10cfa7539755e960dec8cc009934200e68ec Mon Sep 17 00:00:00 2001
>> From: Martin Kepplinger <martink@posteo.de>
>> Date: Thu, 9 Oct 2014 14:54:28 +0200
>> Subject: [PATCH] documentation: misc_open sets private_data for driver's
>>  open()
>>
>> Signed-off-by: Martin Kepplinger <martink@posteo.de>
>> ---
>>  Documentation/filesystems/vfs.txt |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/filesystems/vfs.txt
>> b/Documentation/filesystems/vfs.txt
>> index 61d65cc..06df9d9 100644
>> --- a/Documentation/filesystems/vfs.txt
>> +++ b/Documentation/filesystems/vfs.txt
>> @@ -869,7 +869,8 @@ otherwise noted.
>>  	done the way it is because it makes filesystems simpler to
>>  	implement. The open() method is a good place to initialize the
>>  	"private_data" member in the file structure if you want to point
>> -	to a device structure
>> +	to a device structure. In the case of "struct miscdevice", when
>> +	you implement open() this is done automatically.
> 
> No, no one will notice this in the vfs.txt file, and the vfs doesn't
> care about misc devices.
> 
>>>> misc_open() is called in any case, on open(). As long as miscdevice drivers
>>>> don't explicitly rely on private_data being NULL exactly IF they don't
>>>> implement an open() fop (which I wouldn't imagine), this would make things
>>>> even more convenient.
>>>
>>> I agree, but it would be great if you can audit the existing misc
>>> drivers to ensure we don't break anything with this change.  Can you do
>>> that please?
>>>

applying said change to misc_open() core and removing open() from
video/fbdev/pxa3xx-gcu.c generates these warnings that I, at the moment,
don't fully understand. Do you konw what happens here?

In file included from arch/x86/vdso/vdso2c.c:161:0:
arch/x86/vdso/vdso2c.c: In function ‘main’:
arch/x86/vdso/vdso2c.h:118:6: warning: assuming signed overflow does not
occur when assuming that (X + c) < X is always false [-Wstrict-overflow]
In file included from arch/x86/vdso/vdso2c.c:165:0:
arch/x86/vdso/vdso2c.h:118:6: warning: assuming signed overflow does not
occur when assuming that (X + c) < X is always false [-Wstrict-overflow]

>>
>> I would grep -r "struct miscdevice" ./drivers/; and look at struct
>> file_operations of these results, see how their open() looks like, and
>> where they assign something to private_data.
>>
>> If you have an idea for a script that lists all relevant files for me,
>> please tell me.
> 
> You just came up with one there, that should be a good start.
> 
> good luck,
> 
> greg k-h
> 

