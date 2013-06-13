Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab3FMAFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 20:05:04 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:53878 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091Ab3FMAFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 20:05:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWfpK6oVaeY8tv+TrTq0pu-s1BMVsQ91E10XF6qTAv5mw@mail.gmail.com>
References: <20130611184113.GA2288@www.outflux.net>
	<CAE9FiQXCj+H=h+SPcfW82dBK5n6aDGuX+pmg7zr+6mKtdD4nMg@mail.gmail.com>
	<CAGXu5jLnHTuMSQbLUPbJXAADMwOZAeNv_WyknuEiggCaqA5gpw@mail.gmail.com>
	<CAE9FiQWfpK6oVaeY8tv+TrTq0pu-s1BMVsQ91E10XF6qTAv5mw@mail.gmail.com>
Date: Wed, 12 Jun 2013 17:05:00 -0700
X-Google-Sender-Auth: dllKFm9ZWJKwBgXfkS6K-OYxWjE
Message-ID: <CAGXu5jL5v1ddQEqwDLkxQj=Ryf+9Omw2Vg2xTaih9mrXLMDttA@mail.gmail.com>
Subject: Re: [PATCH] x86, boot: access cmdline when loaded high
From: Kees Cook <keescook@chromium.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 1:54 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Jun 11, 2013 at 12:26 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Tue, Jun 11, 2013 at 12:17 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Tue, Jun 11, 2013 at 11:41 AM, Kees Cook <keescook@chromium.org> wrote:
>>>> The __cmdline_find_option routine requires that the kernel cmdline be
>>>> located under 0x10000. When running the compressed boot code, if the
>>>> cmdline is loaded above this range, it will be ignored. This breaks
>>>> recognition of things like "earlyprintk=...". Since the compressed boot
>>>> code is already tricking the cmdline routines about locations, take it all
>>>> the way and access the cmdline via offset instead of via actual location.
>>>
>>> Hi,
>>>
>>> What is point of the patch?
>>> It looks like it try to fix one bug, but it doesn't,
>>> as there is no bug out there.
>>>
>>> Before the patch, command line that is loaded high
>>> can be processed correctly in arch/x86/boot/compressed/cmdline.c.
>>
>> It can't. Here is the code from arch/x86/boot/cmdline.c:
>
> Are you sure?
>
> I tested that with kexec loaded second kernel high.
>
> How do you test that?
>
>>
>> int __cmdline_find_option(unsigned long cmdline_ptr, const char
>> *option, char *buffer, int bufsize)
>> ...
>>         if (!cmdline_ptr)
>>                 return -1;      /* No command line */
>>
>>         cptr = cmdline_ptr & 0xf;
>>         set_fs(cmdline_ptr >> 4);
>>
>>         while (cptr < 0x10000 && (c = rdfs8(cptr++))) {
>>
>>
>> This means that if get_cmd_line_ptr() returns an address >= 0x10000,
>> __cmdline_find_option will simply ignore the cmdline.
>
> No, you read the code wrong. you miss the
>
> cptr = cmdline_ptr & 0xf;

Ah-ha! I see what I missed. I didn't notice 16a4baa6 which did this:
-       if (!cmdline_ptr || cmdline_ptr >= 0x100000)
-               return -1;      /* No command line, or inaccessible */
+       if (!cmdline_ptr)
+               return -1;      /* No command line */

That fixes the problem I was seeing. :)

Thanks!

-Kees

--
Kees Cook
Chrome OS Security
