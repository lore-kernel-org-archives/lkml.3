Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab3FKUyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:54:10 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:62186 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab3FKUyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:54:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLnHTuMSQbLUPbJXAADMwOZAeNv_WyknuEiggCaqA5gpw@mail.gmail.com>
References: <20130611184113.GA2288@www.outflux.net>
	<CAE9FiQXCj+H=h+SPcfW82dBK5n6aDGuX+pmg7zr+6mKtdD4nMg@mail.gmail.com>
	<CAGXu5jLnHTuMSQbLUPbJXAADMwOZAeNv_WyknuEiggCaqA5gpw@mail.gmail.com>
Date: Tue, 11 Jun 2013 13:54:04 -0700
X-Google-Sender-Auth: -_O_ZD-Cg2KE19mUechVImN5fZI
Message-ID: <CAE9FiQWfpK6oVaeY8tv+TrTq0pu-s1BMVsQ91E10XF6qTAv5mw@mail.gmail.com>
Subject: Re: [PATCH] x86, boot: access cmdline when loaded high
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>
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

On Tue, Jun 11, 2013 at 12:26 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Jun 11, 2013 at 12:17 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Tue, Jun 11, 2013 at 11:41 AM, Kees Cook <keescook@chromium.org> wrote:
>>> The __cmdline_find_option routine requires that the kernel cmdline be
>>> located under 0x10000. When running the compressed boot code, if the
>>> cmdline is loaded above this range, it will be ignored. This breaks
>>> recognition of things like "earlyprintk=...". Since the compressed boot
>>> code is already tricking the cmdline routines about locations, take it all
>>> the way and access the cmdline via offset instead of via actual location.
>>
>> Hi,
>>
>> What is point of the patch?
>> It looks like it try to fix one bug, but it doesn't,
>> as there is no bug out there.
>>
>> Before the patch, command line that is loaded high
>> can be processed correctly in arch/x86/boot/compressed/cmdline.c.
>
> It can't. Here is the code from arch/x86/boot/cmdline.c:

Are you sure?

I tested that with kexec loaded second kernel high.

How do you test that?

>
> int __cmdline_find_option(unsigned long cmdline_ptr, const char
> *option, char *buffer, int bufsize)
> ...
>         if (!cmdline_ptr)
>                 return -1;      /* No command line */
>
>         cptr = cmdline_ptr & 0xf;
>         set_fs(cmdline_ptr >> 4);
>
>         while (cptr < 0x10000 && (c = rdfs8(cptr++))) {
>
>
> This means that if get_cmd_line_ptr() returns an address >= 0x10000,
> __cmdline_find_option will simply ignore the cmdline.

No, you read the code wrong. you miss the

cptr = cmdline_ptr & 0xf;

Yinghai
