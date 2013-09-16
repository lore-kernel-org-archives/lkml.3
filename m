Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab3IPPzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:55:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55649 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3IPPzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:55:11 -0400
Date: Mon, 16 Sep 2013 16:55:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, joe@perches.com,
        George Spelvin <linux@horizon.com>, dan.carpenter@oracle.com,
        Jan Beulich <JBeulich@suse.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] vsprintf: ignore %n again
Message-ID: <20130916155504.GC13318@ZenIV.linux.org.uk>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379317437-28329-1-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 12:43:55AM -0700, Kees Cook wrote:
> Whether seq_printf should return void or error, %n still needs to be removed.
> As such, instead of changing the seq_file structure and adding instructions
> to all callers of seq_printf, just examine seq->count for the callers that
> care about how many characters were put into the buffer, as suggested by
> George Spelvin. First patch removes all %n usage in favor of checking
> seq->count before/after. Second patch makes %n ignore its argument.

This is completely pointless.  *ANY* untrusted format string kernel-side
is pretty much it.  Blocking %n is not "defense in depth", it's security
theater.  Again, if attacker can feed an arbitrary format string to
vsnprintf(), it's over - you've lost.  It's not just about information
leaks vs. ability to store a value of attacker's choosing at the address
of attacker's choosing as it was in userland.  Kernel-side an ability to
trigger read from an arbitrary address is much nastier than information
leak risk; consider iomem, for starters.

What we ought to do is prevention of _that_.  AFAICS, we have reasonably
few call chains that might transmit format string; most of the calls
are with plain and simple string literal.  I wonder if could get away
with reasonable amount of annotations to catch such crap...

Consider, e.g. introducing __vsnprint(), with vsnprintf(s, n, fmt, ...)
expanding to __vsnprintf(1, s, n, fmt, ...) if fmt is a string literal
and __vsnprintf(0, s, n, fmt, ...) otherwise.  Now,
int __sprintf(int safe, char *buf, const char *fmt, ...)
{
        va_list args;
        int i;

        va_start(args, fmt);
        i = __vsnprintf(safe, buf, INT_MAX, fmt, args);
        va_end(args);

        return i;
}
and #define for sprintf (expanding it to either __sprintf(1, ...)
or __sprintf(0, ...)).  That plus similar for snprintf and seq_printf
will already take care of most of the call chains leading to __vsnprintf() -
relatively few calls with have 0 passed to it.  Add WARN_ON(!safe) to
__vsnprintf and we probably won't drown in warnings.  Now, we can start
adding things like that to remaining call chains *and* do things like
replacing
                        snd_iprintf(buffer, fields[i].format,
                                *get_dummy_ll_ptr(dummy, fields[i].offset));
with
			/* fields[i].format is known to be a valid format */
                        __snd_iprintf(1, buffer, fields[i].format,
                                *get_dummy_ll_ptr(dummy, fields[i].offset));
to deal with the places where the origin of format string is provably safe,
but not a string literal (actually, s/1/__FORMAT_IS_SAFE/, to make it
greppable).

Comments?
