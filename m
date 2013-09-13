Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab3IMXD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 19:03:27 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:51299 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab3IMXD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 19:03:26 -0400
MIME-Version: 1.0
In-Reply-To: <1379111268.2066.22.camel@joe-AO722>
References: <20130913195335.18955.qmail@science.horizon.com>
	<1379111268.2066.22.camel@joe-AO722>
Date: Fri, 13 Sep 2013 16:03:25 -0700
X-Google-Sender-Auth: p-iqGNarWDrzkdE9v6iMehLM5Bo
Message-ID: <CAGXu5jJxJVK7cu2Sc4Sdng_rLDL8ziC6aecAi7G0zL4fYnY-9Q@mail.gmail.com>
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: George Spelvin <linux@horizon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eldad Zack <eldad@fogrefinery.com>, Jan Beulich <jbeulich@suse.com>,
        Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 3:27 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2013-09-13 at 15:53 -0400, George Spelvin wrote:
>> > Maybe WARN_ONCE so it's easier to emit the format too.
>>
>> Good idea.  And, if it's not too much trouble, a comment explaining
>> why it's deliberately omitted so the issue doesn't arise again.
>
> Before any of the %n uses could be removed, I believe seq_printf
> could to be converted to return void and have a another mechanism
> to determine if any error occurred and the length of the output of
> seq_printf.
>
> I've done a preliminary conversion of seq_printf and seq_vprintf
> to return void and added last_ret and last_len to struct seq_file.
>
> If that's applied, it's trivial to convert vsnprintf to skip %n.
>
> Anyone have an opinion of a different conversion mechanism?

Maybe I missed this somewhere in the thread, but I'm not sure I
understand the move to "void". Here's what I see, please correct me:

1- seq_printf currently returns success/failure
2- some callers of seq_printf (correctly) use the return value as
success/failure indication
3- some callers of seq_printf (incorrectly) use the return value as a
length indication
4- both success/failure and length are important outputs from seq_printf
5- we need a way to access the length written during the call
6- want to minimize impact on the code base

Due to 1 and 2, it seems like there's no sense in changing the return
value to void. Success/failure is already returned, and there are
users of it. No sense changing them.

The normal way to handle multiple return values (4 and 5) is to add a
pointer argument. For example: seq_printf(s, &len, fmt, args...) where
len can be NULL. But this runs against 6.

Due to 6, to solve 4 and 5, usually macro or inline tricks are used,
for example:

__printf(3, 4) int seq_printf_len(struct seq_file *, size_t *len, ...);
#define seq_printf(s, fmt, ...) seq_printf_len(s, NULL, fmt, ##__VA_ARGS__)

With this, solving 3 becomes possible (your void patch has already
detected all the users of the return value, so we can sort out which
expect length and which expect success/failure), and lets us actually
remove the %n uses trivially too.

-Kees

-- 
Kees Cook
Chrome OS Security
