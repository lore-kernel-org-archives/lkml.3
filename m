Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab3IWVZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:25:11 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:65349 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab3IWVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:25:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130921235217.GB12132@localhost.localdomain>
References: <20130920153400.GA32516@www.outflux.net>
	<20130921235217.GB12132@localhost.localdomain>
Date: Mon, 23 Sep 2013 14:25:01 -0700
X-Google-Sender-Auth: 7YOTbVmWPz7Cz8N2YbPy-uGa5Jk
Message-ID: <CAGXu5jJcMjh+_40rFgY3+J3w1p_PfHWNjv_NP5U79teHJDfqYg@mail.gmail.com>
Subject: Re: [PATCH RESEND] printk: report boot console names during cut-over
From: Kees Cook <keescook@chromium.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 4:52 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Fri, Sep 20, 2013 at 08:34:01AM -0700, Kees Cook wrote:
>> This reports the names of boot consoles as they're being disabled to
>> help identify which is which during cut-over. Helps answer the question
>> "which boot console actually got activated?" once the regular console
>> is running, mostly when debugging boot console failures.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  kernel/printk/printk.c |   16 ++++++++++------
>>  1 file changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
>> index b4e8500..0dc54c9 100644
>> --- a/kernel/printk/printk.c
>> +++ b/kernel/printk/printk.c
>> @@ -2361,14 +2361,18 @@ void register_console(struct console *newcon)
>>       if (bcon &&
>>           ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV) &&
>>           !keep_bootcon) {
>> -             /* we need to iterate through twice, to make sure we print
>> -              * everything out, before we unregister the console(s)
>> +             /* We need to iterate through all boot consoles, to make
>> +              * sure we print everything out, before we unregister them.
>>                */
>> -             printk(KERN_INFO "console [%s%d] enabled, bootconsole disabled\n",
>> -                     newcon->name, newcon->index);
>> -             for_each_console(bcon)
>> -                     if (bcon->flags & CON_BOOT)
>> +             for_each_console(bcon) {
>> +                     if (bcon->flags & CON_BOOT) {
>> +                             printk(KERN_INFO "console [%s%d] enabled, "
>> +                                     "bootconsole [%s%d] disabled\n",
>> +                                     newcon->name, newcon->index,
>> +                                     bcon->name, bcon->index);
>>                               unregister_console(bcon);
>
> Looks useful! But I think the "console %foo disabled" message should move to unregister_console()
> instead. That way it also handles printk_late_init() and all other console unregisters.

Yeah, that's a much cleaner way to do this. I'll send a new patch. Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
