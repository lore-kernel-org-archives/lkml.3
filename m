Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab3IPSUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 14:20:18 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:49968 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3IPSUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:20:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130916155504.GC13318@ZenIV.linux.org.uk>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
	<20130916155504.GC13318@ZenIV.linux.org.uk>
Date: Mon, 16 Sep 2013 11:20:16 -0700
X-Google-Sender-Auth: mYQzjKmbd6eTtlfuRoiINpieX7I
Message-ID: <CAGXu5jK2d+9m0uA84nGbZ5E=s974NRn+Sxz3iRcTsFWqWFTGNQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] vsprintf: ignore %n again
From: Kees Cook <keescook@chromium.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        George Spelvin <linux@horizon.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jan Beulich <JBeulich@suse.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 8:55 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Sep 16, 2013 at 12:43:55AM -0700, Kees Cook wrote:
>> Whether seq_printf should return void or error, %n still needs to be removed.
>> As such, instead of changing the seq_file structure and adding instructions
>> to all callers of seq_printf, just examine seq->count for the callers that
>> care about how many characters were put into the buffer, as suggested by
>> George Spelvin. First patch removes all %n usage in favor of checking
>> seq->count before/after. Second patch makes %n ignore its argument.
>
> This is completely pointless.  *ANY* untrusted format string kernel-side
> is pretty much it.  Blocking %n is not "defense in depth", it's security
> theater.  Again, if attacker can feed an arbitrary format string to
> vsnprintf(), it's over - you've lost.  It's not just about information
> leaks vs. ability to store a value of attacker's choosing at the address
> of attacker's choosing as it was in userland.  Kernel-side an ability to
> trigger read from an arbitrary address is much nastier than information
> leak risk; consider iomem, for starters.

I completely disagree. (Surprise!) Eliminating %n _does_ change
things. Why have the risk when solutions for getting the same behavior
take fewer instructions and are safer? Yes, I agree that arbitrary
format strings are still a very very bad thing, but %n makes it an
order of magnitude worse. Attacking format strings with %n is very
well understood by exploiters, so why give them this primitive for no
sensible reason?

> What we ought to do is prevention of _that_.  AFAICS, we have reasonably
> few call chains that might transmit format string; most of the calls
> are with plain and simple string literal.  I wonder if could get away
> with reasonable amount of annotations to catch such crap...

Yes. And if gcc would ignore const char arguments, we could do this:

diff --git a/Makefile b/Makefile
index e73f758..2bc680b 100644
--- a/Makefile
+++ b/Makefile
@@ -372,7 +372,6 @@ KBUILD_CPPFLAGS := -D__KERNEL__
 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
                   -fno-strict-aliasing -fno-common \
                   -Werror-implicit-function-declaration \
-                  -Wno-format-security \
                   -fno-delete-null-pointer-checks
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
@@ -659,6 +658,11 @@ KBUILD_CFLAGS      += $(call cc-option,-fno-strict-overflow
 # conserve stack if available
 KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)

+# Enable format-security when it can stop the build, otherwise disable.
+KBUILD_CFLAGS  += $(call cc-option,\
+                       -Wformat -Wformat-security -Werror=format-security,\
+                       -Wno-format-security)
+
 # use the deterministic mode of AR if available
 KBUILD_ARFLAGS := $(call ar-option,D)

I have a patch series that fixes all the warnings produced by gcc in
this state. All of our printf uses are already marked up in the
kernel, so this checks them all.

> Consider, e.g. introducing __vsnprint(), with vsnprintf(s, n, fmt, ...)
> expanding to __vsnprintf(1, s, n, fmt, ...) if fmt is a string literal
> and __vsnprintf(0, s, n, fmt, ...) otherwise.  Now,
> int __sprintf(int safe, char *buf, const char *fmt, ...)
> {
>         va_list args;
>         int i;
>
>         va_start(args, fmt);
>         i = __vsnprintf(safe, buf, INT_MAX, fmt, args);
>         va_end(args);
>
>         return i;
> }
> and #define for sprintf (expanding it to either __sprintf(1, ...)
> or __sprintf(0, ...)).  That plus similar for snprintf and seq_printf
> will already take care of most of the call chains leading to __vsnprintf() -
> relatively few calls with have 0 passed to it.  Add WARN_ON(!safe) to
> __vsnprintf and we probably won't drown in warnings.  Now, we can start
> adding things like that to remaining call chains *and* do things like
> replacing
>                         snd_iprintf(buffer, fields[i].format,
>                                 *get_dummy_ll_ptr(dummy, fields[i].offset));
> with
>                         /* fields[i].format is known to be a valid format */
>                         __snd_iprintf(1, buffer, fields[i].format,
>                                 *get_dummy_ll_ptr(dummy, fields[i].offset));
> to deal with the places where the origin of format string is provably safe,
> but not a string literal (actually, s/1/__FORMAT_IS_SAFE/, to make it
> greppable).

Unless I've misunderstood, I think we'd already get very close to this
with the gcc options instead. This patch set is what I've been using
to generate the format string fixes over the last few months, with 7
sent this last round:

http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=format-security

-Kees

-- 
Kees Cook
Chrome OS Security
