Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab3HQANI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:13:08 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:65263 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab3HQANG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:13:06 -0400
Date: Fri, 16 Aug 2013 21:26:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux kernel cross-compilers
Message-ID: <20130816192651.GA13953@merkur.ravnborg.org>
References: <520C9A39.3030808@roeck-us.net> <CAMo8BfKyqZYMkh96wyZSpYUpXwqFQZkco=XgtjUrNG-jSzW5pA@mail.gmail.com> <20130816054823.GB28445@thor.bakeyournoodle.com> <CAMo8Bf+veq_DU7-hnB0yySy6YWpwU2TYx3U9e89c_m8Mv9Cv5w@mail.gmail.com> <520DD9CA.90305@roeck-us.net> <CAMo8BfLvVk+2CyQD28otU265J4rvbt0Eg11Vqr4u4zjKjrTanw@mail.gmail.com> <520DEF05.9030803@roeck-us.net> <CAMo8BfKWFGxr6a48tFqGCourOcWOTO9rmCHy3Q05jR_QEuq=Cg@mail.gmail.com> <520E48A7.3050401@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520E48A7.3050401@roeck-us.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 08:43:35AM -0700, Guenter Roeck wrote:
> On 08/16/2013 02:45 AM, Max Filippov wrote:
>>>> Guenter,
>>>> can you share a complete build log with V=1?
>>>>
>>>
>>> http://roeck-us.net/linux/logs/make.xtensa.log.bad
>>> http://roeck-us.net/linux/logs/make.xtensa.log.ok
>>>
>>> Key difference: the failing command in the bad case is
>>>          xtensa-linux-objcopy -O elf32-xtensa-le
>>> and in the good case
>>>          xtensa-linux-objcopy -O elf32-xtensa-be
>>>
>>> Same compiler (4.6.3 from kernel.org), same configuration file, same command
>>> line.
>>> Configuration file is generated from defconfig, and the resulting .config
>>> file
>>> is the same in both cases.
>>>
>>> If I execute make and expicitly set BIG_ENDIAN=1 on the failing system as
>>> parameter to it,
>>> it works fine. If I set BIG_ENDIAN=0 on the passing system, it fails.
>>>
>>> I am puzzled. Guess there must be something different, but I have no idea
>>> what it might be.
>>
>> What is the output of
>>
>> echo -e __XTENSA_EB__ | xtensa-linux-gcc -E -
>>
>> on the failing system?
>>
> It is "1", but that let me pinpoint the problem.
>
> On the failing system, the version of echo executed by make does
> not understand the "-e" option. Thus, when running arch/xtensa/boot/Makefile,
> "echo -e __XTENSA_EB__" returns "-e __XTENSA_EB__", which doesn't compile,
> and BIG_ENDIAN ends up being 0. So the compiler is completely innocent.
>
> I found out the root source: SHELL is set the /bin/sh, which on the failing
> system points to /bin/dash (default in Ubuntu, or at least it used to be).
> dash apparently has a built-in version of echo which does not understand '-e'.

Could you try to replace "echo -e bla" with "printf "bla".
Kbuild.include uses some similar tricks but here printf is used.
Maybe this can be dash compatible then

	Sam
