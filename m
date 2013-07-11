Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3GKWKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:10:38 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:55792 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab3GKWKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:10:37 -0400
MIME-Version: 1.0
In-Reply-To: <51758630.6000003@gmx.de>
References: <1360862966-6376-1-git-send-email-jmaggard10@gmail.com>
	<5169477D.1000400@gmx.de>
	<CAKgsxVT3_ge2vxcGWzy6NJYPEGwB1Wbw2eE7a=JtWWBb8o4XVg@mail.gmail.com>
	<51758630.6000003@gmx.de>
Date: Thu, 11 Jul 2013 15:10:35 -0700
Message-ID: <CAKgsxVQqBE8vZUyBedpTysFMHVCnS1SayeNtMAPF9D0=RCoX4g@mail.gmail.com>
Subject: Re: fanotify: fix support of large files
From: Justin Maggard <jmaggard10@gmail.com>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: linux-kernel@vger.kernel.org, eparis@redhat.com, LinoSanfilippo@gmx.de,
        Tzvetan Chaliavski <tzvetanc@commtouch.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 11:49 AM, Heinrich Schuchardt
<xypron.glpk@gmx.de> wrote:
>
> Hello Justin,
>
> I downloaded the example,
> http://www.lanedo.com/~aleksander/fanotify/fanotify-example.c
> compiled it without modification
> $ gcc fanotify-example.c -o fanotify-example
> and started the executable. In a separate windows I executed
> truncate -s 2048m 2048m
>
> This is the output of the first window:
> $ sudo ./fanotify-example /home/user/temp/
> Started monitoring directory '/home/user/temp/'...
> Received event in path '/home/user/temp/2048m' pid=3659 (truncate):
>         FAN_OPEN
> Received event in path '/home/user/temp/2048m' pid=3659 (truncate):
>         FAN_CLOSE_WRITE
>
> $ uname -a
> Linux family2 3.8.0 #1 SMP Fri Feb 22 22:07:58 CET 2013 i686 GNU/Linux
>

Ah yes, that's the reason.  I'm running on x86_64.  32-bit platforms
actually work if you set O_LARGEFILE.  From /usr/incude/bits/fcntl.h:

#ifdef __USE_LARGEFILE64
# if __WORDSIZE == 64
#  define O_LARGEFILE   0
# else
#  define O_LARGEFILE   0100000
# endif
#endif

If I include <asm/fcntl.h> instead of <fcntl.h>, it gets set to
0x8000, and my large file fanotify test works.  Or, of course, I can
define that flag locally and use it.  But it feels like I shouldn't
have to do that.

-Justin

>
> To reproduce your problem, could you, please, provide the Linux configuration file (look in your /boot directory) and a link to the source of the Linux kernel version you use. Then I can use your configuration file to compile that kernel version.
>
> Best regards
>
> Heinrich Schuchardt
>
>
> On 19.04.2013 21:23, Justin Maggard wrote:
>>
>> On Sat, Apr 13, 2013 at 4:54 AM, Heinrich Schuchardt<xypron.glpk@gmx.de>  wrote:
>>>
>>> Dear Justin,
>>>
>>> looking at the example at
>>> http://www.lanedo.com/~aleksander/fanotify/fanotify-example.c
>>> the large file support is enabled by passing O_LARGEFILE to fanotify_init:
>>>
>>>    if ((fanotify_fd = fanotify_init (FAN_CLOEXEC,
>>>                                      O_RDONLY | O_CLOEXEC | O_LARGEFILE))<
>>> 0)
>>>
>>> Could you, please, check if this solves your issue.
>>>
>>> (I am resending this message because HTML was rejected by
>>> linux-kernel@vger.kernel.org).
>>>
>>> Best regards
>>>
>>> Heinrich Schuchardt
>>>
>>
>> No, unfortunately that doesn't help.  I slightly modifed
>> fanotify-example.c to call perror() when read() fails, and here's the
>> output:
>>
>> jmaggard@jmaggard-W520:~/fanotify-test$ sudo ./fanotify-example .&
>> [1] 7248
>> jmaggard@jmaggard-W520:~/fanotify-test$ Started monitoring directory '.'...
>> truncate -s 2047m 2047m
>> Received event in path '/home/jmaggard/fanotify-test/2047m' pid=7250 (unknown):
>> FAN_OPEN
>> FAN_CLOSE_WRITE
>> jmaggard@jmaggard-W520:~/fanotify-test$ truncate -s 2048m 2048m
>> read: Value too large for defined data type
>>
>> -Justin
>>
>
