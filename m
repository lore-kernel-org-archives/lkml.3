Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3IKTZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:25:09 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:56800 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3IKTZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:25:07 -0400
MIME-Version: 1.0
In-Reply-To: <1378926562.4714.11.camel@joe-AO722>
References: <20130911044116.GA17294@www.outflux.net>
	<1378875632.606.5.camel@joe-AO722>
	<CAGXu5jLm1RNp4mB2KfeRumTqeWgcAsZ4CpQQQGA67WukERefXQ@mail.gmail.com>
	<20130911093118.GD25896@mwanda>
	<CAGXu5j+H_RLwj9c6CKxMpaYeR9kS-qDnK+e1mOHHt9zh6vAm=w@mail.gmail.com>
	<1378926562.4714.11.camel@joe-AO722>
Date: Wed, 11 Sep 2013 12:25:06 -0700
X-Google-Sender-Auth: JHrlFZzta6EYzfa7hIc3xk56b5o
Message-ID: <CAGXu5jLO6109fkejXqX=WhkQnfAUeWtTcow0v1BNqyi=8=Qa3Q@mail.gmail.com>
Subject: Re: [PATCH] staging: dgnc: fix potential format string flaw
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lidza Louina <lidza.louina@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 12:09 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2013-09-11 at 11:19 -0700, Kees Cook wrote:
>> On Wed, Sep 11, 2013 at 2:31 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> > On Tue, Sep 10, 2013 at 10:19:17PM -0700, Kees Cook wrote:
>> >> In the former case, format characters will get processed by the
>> >> sprintf logic. In the latter, they are printed as-is. In this specific
>> >> case, if there was a way to inject strings like "ohai %n" into the
>> >> msgbuf string, the former would actually attempt to resolve the %n. In
>> >> the simple case, this could lead to Oopses, and in the unlucky case,
>> >> it could allow arbitrary memory writing and execution control.
>> >>
>> >> http://en.wikipedia.org/wiki/Uncontrolled_format_string
>> >
>> > The kernel ignores %n so hopefully it can't actually write to memory.
>>
>> I wish! This is not the case, though. See FORMAT_TYPE_NRCHARS in
>> lib/vsprintf.c's vsnprintf().
>>
>> $ git grep '%n' | wc -l
>> 111
>
> Umm.
>
> See: lib/vsprintf.c
>
> /**
>  * vsnprintf - Format a string and place it in a buffer
> [...]
>  * %n is ignored
>
> %n does work for vsscanf though.

The comment is a lie:

        int len = 0;
        printk("len:%d\n", len);
        printk("%s%n\n", "Ohai!", &len);
        printk("len:%d\n", len);

[    0.025930] len:0
[    0.026003] Ohai!
[    0.026261] len:5

The functionality between scanf and printf was, I think, merged in
2009, if I'm reading the git blame correctly.

-Kees

-- 
Kees Cook
Chrome OS Security
