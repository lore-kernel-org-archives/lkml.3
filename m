Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbaEFMbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:31:20 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:38887 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbaEFMbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:31:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140505133517.71b7dc7cf327cb304e8a9edc@linux-foundation.org>
References: <CALZtONB-wT16fPX7GjBVFO_5Bof3=zxviG22p6_9ymbnzA9QAA@mail.gmail.com>
 <1399300985-11137-1-git-send-email-ddstreet@ieee.org> <20140505133517.71b7dc7cf327cb304e8a9edc@linux-foundation.org>
From: Dan Streetman <ddstreet@ieee.org>
Date: Tue, 6 May 2014 08:30:56 -0400
X-Google-Sender-Auth: jw0r1miR1EarRV267m7Ldg1aJqk
Message-ID: <CALZtONAVTQuOF3ddZ6jVZqCGgKBicAtT=_w5w4GEueYAsf3jtw@mail.gmail.com>
Subject: Re: [PATCH] plist: replace pr_debug with printk in plist_test()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Fabian Frederick <fabf@skynet.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 4:35 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon,  5 May 2014 10:43:05 -0400 Dan Streetman <ddstreet@ieee.org> wrote:
>
>> Replace pr_debug() in lib/plist.c test function plist_test() with
>> printk(KERN_DEBUG ...).
>>
>> Without DEBUG defined, pr_debug() is complied out, but the entire
>> plist_test() function is already inside CONFIG_DEBUG_PI_LIST, so
>> printk should just be used directly.
>>
>> --- a/lib/plist.c
>> +++ b/lib/plist.c
>> @@ -175,7 +175,7 @@ static int  __init plist_test(void)
>>       int nr_expect = 0, i, loop;
>>       unsigned int r = local_clock();
>>
>> -     pr_debug("start plist test\n");
>> +     printk(KERN_DEBUG "start plist test\n");
>
> Now someone will come along and helpfully switch it back to pr_debug()
> again :(
>
> What about adding a #define DEBUG?
>
>
>
> This aspect of pr_debug() is rather surprising and unfortunate and I
> guess we screwed it up.  pr_debug() should unconditionally do the
> printk, just like pr_warn, pr_emerg, etc.  And there should be a
> separate pr_debug_cond() which honours the DEBUG setting.

I agree, it's definitely surprising and not obvious.  At the least,
maybe some clearer comments/docs would help; besides actually
reviewing the printk.h code, the only other indication of this
behavior is CodingStyle which currently says:

"For messages that aren't associated with a particular device,
<linux/printk.h> defines pr_debug() and pr_info()."

Listing pr_debug() and pr_info() on the same line with no
qualifications kind of implies they behave the same.  Maybe the
example should be pr_err() and pr_info(), or really anything besides
pr_debug(), which is discussed in (very brief) detail in the next
paragraph...

"Such messages should be compiled out when the DEBUG symbol is not
defined (that is, by default they are not included).  When you use
dev_dbg() or pr_debug(), that's automatic.  Many subsystems have
Kconfig options to turn on -DDEBUG."

While that does explain that pr_debug() won't actually print anything
without DEBUG defined, it's hardly in a way that jumps out, clearly
indicating that pr_debug() is unlike all the other pr_XXX() functions.

I'll try sending a patch to update the docs to make pr_debug()'s
behavior clearer...

>
> akpm3:/usr/src/linux-3.15-rc4> grep -r pr_debug . | wc -l
> 10286
>
> Boy, that's going to be a big patch ;)
