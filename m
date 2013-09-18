Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab3IROcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:32:42 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:60840 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3IROcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:32:41 -0400
MIME-Version: 1.0
In-Reply-To: <201309182214.IDD13060.FFOVJOLOFQtHSM@I-love.SAKURA.ne.jp>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
	<20130916155504.GC13318@ZenIV.linux.org.uk>
	<CAGXu5jK2d+9m0uA84nGbZ5E=s974NRn+Sxz3iRcTsFWqWFTGNQ@mail.gmail.com>
	<201309182214.IDD13060.FFOVJOLOFQtHSM@I-love.SAKURA.ne.jp>
Date: Wed, 18 Sep 2013 07:32:40 -0700
X-Google-Sender-Auth: 0bY_vHAs36WipkfvBKV1i24Dy7w
Message-ID: <CAGXu5jKztpsUwTCa0dMNHUS==dPQE02FvT=xjNfZLK80NSriXQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] vsprintf: ignore %n again
From: Kees Cook <keescook@chromium.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, George Spelvin <linux@horizon.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jan Beulich <JBeulich@suse.com>,
        Motohiro KOSAKI <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 6:14 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Kees Cook wrote:
>> > Consider, e.g. introducing __vsnprint(), with vsnprintf(s, n, fmt, ...)
>> > expanding to __vsnprintf(1, s, n, fmt, ...) if fmt is a string literal
>> > and __vsnprintf(0, s, n, fmt, ...) otherwise.  Now,
>> > int __sprintf(int safe, char *buf, const char *fmt, ...)
>> > {
>> >         va_list args;
>> >         int i;
>> >
>> >         va_start(args, fmt);
>> >         i = __vsnprintf(safe, buf, INT_MAX, fmt, args);
>> >         va_end(args);
>> >
>> >         return i;
>> > }
>>
>> Unless I've misunderstood, I think we'd already get very close to this
>> with the gcc options instead. This patch set is what I've been using
>> to generate the format string fixes over the last few months, with 7
>> sent this last round:
>
> Can we utilize __builtin_constant_p() ?

This seems promising.

>
> ---------- source start ----------
> #include <stdio.h>
>
> #define func(fmt)                                       \
>         if (__builtin_constant_p(fmt))                  \
>                 printf("const : %s\n", fmt);            \
>         else                                            \
>                 printf("not const : %s\n", fmt);        \
>
>
> int main(int argc, char *argv[])
> {
>         const char *fmt1 = "const char *";
>         const char fmt2[] = "const char []";
>         const char * const fmt3 = "const char * const";
>         func("literal");
>         func(fmt1);
>         func(fmt2);
>         func(fmt3);
>         return 0;
> }
> ---------- source end ----------
>
> ---------- output start ----------
> const : literal
> not const : const char *
> not const : const char []
> const : const char * const

What version of gcc did you use? I don't get the last as const, for
some reason. And as Dan mentions, shouldn't const char[] be detected
as const too?

-Kees

> ---------- output end ----------
>
> __builtin_constant_p() seems to enforce use of either "literal" or "* const".
>
> An example change
>
> ---------- patch start ----------
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -120,8 +120,9 @@ asmlinkage int printk_emit(int facility, int level,
>                            const char *dict, size_t dictlen,
>                            const char *fmt, ...);
>
> -asmlinkage __printf(1, 2) __cold
> -int printk(const char *fmt, ...);
> +//asmlinkage __printf(1, 2) __cold
> +//int printk(const char *fmt, ...);
> +#define printk(fmt, ...) compiletime_assert(__builtin_constant_p(fmt), "Non-c  onstant format string")
>
>  /*
>   * Special printk facility for scheduler use only, _DO_NOT_USE_ !
> ---------- patch end ----------
>
> caught errors like below.
>
>   CC [M]  drivers/scsi/esas2r/esas2r_log.o
> drivers/scsi/esas2r/esas2r_log.c: In function 'esas2r_log_master':
> drivers/scsi/esas2r/esas2r_log.c:174: error: call to '__compiletime_assert_174' declared with attribute error: Non-constant format string



-- 
Kees Cook
Chrome OS Security
