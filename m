Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab3ANXGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 18:06:31 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:44837 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab3ANXGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 18:06:30 -0500
MIME-Version: 1.0
In-Reply-To: <20130114094325.GC1228@liondog.tnic>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-23-git-send-email-yinghai@kernel.org>
	<20130113214132.GB17200@liondog.tnic>
	<CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com>
	<20130114094325.GC1228@liondog.tnic>
Date: Mon, 14 Jan 2013 15:06:28 -0800
X-Google-Sender-Auth: fjVq1qQqAXG2p47dOAcw4UIUh0M
Message-ID: <CAE9FiQWXjMLmhL40A7j4nWpTxY86XegGpXy-9uqYBbqq4Tz3zA@mail.gmail.com>
Subject: Re: [PATCH v7u1 22/31] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 1:43 AM, Borislav Petkov <bp@suse.de> wrote:
>> >> --- a/arch/x86/boot/compressed/cmdline.c
>> >> +++ b/arch/x86/boot/compressed/cmdline.c
>> >> @@ -17,6 +17,8 @@ static unsigned long get_cmd_line_ptr(void)
>> >>  {
>> >>       unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
>> >>
>> >> +     cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;
>> >> +
>> >>       return cmd_line_ptr;
>> >>  }
>> >
>> > On 32-bit, this unsigned long cmd_line_ptr is 4 bytes and the OR doesn't
>> > have any effect on the final result. You probably want to do:
>>
>> yes, that is what we want to keep 32bit and 64bit unified.
>>
>> >
>> > #ifdef CONFIG_64BIT
>> >         cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;
>> > #endif
>> >
>> > right?
>> >
>> > Or instead look at ->sentinel to know whether the ext_* fields are valid
>> > or not, and save yourself the OR if not.
>>
>> no.
>>
>> that is whole point of sentinel, we don't need to check sentinel everywhere
>> because ext_* are valid.
>
> Dude, do you even read my comments? This line:
>
>         cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;
>
> doesn't do a whit on 32-bit. So execute it *only* on 32-bit!

Following should work on 32bit, and keep them same code on
32bit and 64bit.

because ext_cmd_line_ptr is always 0 on 32bit.

Index: linux-2.6/arch/x86/boot/compressed/cmdline.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/compressed/cmdline.c
+++ linux-2.6/arch/x86/boot/compressed/cmdline.c
@@ -17,6 +17,9 @@ static unsigned long get_cmd_line_ptr(vo
 {
        unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;

+       if (real_mode->ext_cmd_line_ptr)
+               cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;
+
        return cmd_line_ptr;
 }
 int cmdline_find_option(const char *option, char *buffer, int bufsize)
