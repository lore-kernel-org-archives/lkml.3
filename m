Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab3IMXXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 19:23:36 -0400
Received: from smtprelay0127.hostedemail.com ([216.40.44.127]:36957 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755875Ab3IMXXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 19:23:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2561:2564:2682:2685:2689:2691:2692:2828:2859:2899:2901:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:61
X-HE-Tag: mice21_591290462b04f
X-Filterd-Recvd-Size: 4297
Message-ID: <1379114610.2066.37.camel@joe-AO722>
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: George Spelvin <linux@horizon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eldad Zack <eldad@fogrefinery.com>, Jan Beulich <jbeulich@suse.com>,
        Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date: Fri, 13 Sep 2013 16:23:30 -0700
In-Reply-To: <CAGXu5jJxJVK7cu2Sc4Sdng_rLDL8ziC6aecAi7G0zL4fYnY-9Q@mail.gmail.com>
References: <20130913195335.18955.qmail@science.horizon.com>
	 <1379111268.2066.22.camel@joe-AO722>
	 <CAGXu5jJxJVK7cu2Sc4Sdng_rLDL8ziC6aecAi7G0zL4fYnY-9Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-13 at 16:03 -0700, Kees Cook wrote:
> On Fri, Sep 13, 2013 at 3:27 PM, Joe Perches <joe@perches.com> wrote:
> > On Fri, 2013-09-13 at 15:53 -0400, George Spelvin wrote:
> >> > Maybe WARN_ONCE so it's easier to emit the format too.
> >>
> >> Good idea.  And, if it's not too much trouble, a comment explaining
> >> why it's deliberately omitted so the issue doesn't arise again.
> >
> > Before any of the %n uses could be removed, I believe seq_printf
> > could to be converted to return void and have a another mechanism
> > to determine if any error occurred and the length of the output of
> > seq_printf.
> >
> > I've done a preliminary conversion of seq_printf and seq_vprintf
> > to return void and added last_ret and last_len to struct seq_file.
> >
> > If that's applied, it's trivial to convert vsnprintf to skip %n.
> >
> > Anyone have an opinion of a different conversion mechanism?
> 
> Maybe I missed this somewhere in the thread, but I'm not sure I
> understand the move to "void".

Hi Kees.

Al Viro suggested just fixing the misuses.
https://lkml.org/lkml/2013/9/11/801

David Laight suggested converting to void.
https://lkml.org/lkml/2013/9/12/113

>  Here's what I see, please correct me:
> 
> 1- seq_printf currently returns success/failure
> 2- some callers of seq_printf (correctly) use the return value as
> success/failure indication
> 3- some callers of seq_printf (incorrectly) use the return value as a
> length indication
> 4- both success/failure and length are important outputs from seq_printf
> 5- we need a way to access the length written during the call

Right and I agree with all of that.

> 6- want to minimize impact on the code base

Maybe not.

> Due to 1 and 2, it seems like there's no sense in changing the return
> value to void. Success/failure is already returned, and there are
> users of it. No sense changing them.

Except that future code might expect len instead of bool.
I did and would again.

So, I really don't care much and I don't really want to
paper over existing misuses, so I choose to fix them all.

> The normal way to handle multiple return values (4 and 5) is to add a
> pointer argument. For example: seq_printf(s, &len, fmt, args...) where
> len can be NULL. But this runs against 6.
> 
> Due to 6, to solve 4 and 5, usually macro or inline tricks are used,
> for example:
> __printf(3, 4) int seq_printf_len(struct seq_file *, size_t *len, ...);
> #define seq_printf(s, fmt, ...) seq_printf_len(s, NULL, fmt, ##__VA_ARGS__)

I'd rather fix the code that's defective than
paper over the defects with macro tricks.

> With this, solving 3 becomes possible (your void patch has already
> detected all the users of the return value, so we can sort out which
> expect length and which expect success/failure),

I (believe I) did that.

> and lets us actually
> remove the %n uses trivially too.

Soon I hope.

Anyone else have an opinion?

