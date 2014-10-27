Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaJ0MBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:01:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51948 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbaJ0MBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:01:21 -0400
Date: Mon, 27 Oct 2014 13:01:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Wise <pabs3@bonedaddy.net>
Subject: Re: [PATCH] sysctl: terminate strings also on \r
Message-ID: <20141027120115.GB18586@amd>
References: <20141021202137.GA20114@www.outflux.net>
 <20141022162638.875681da6bbb9e027d2d3bee@linux-foundation.org>
 <CAGXu5j+sW89tZDA5GQnkL4E9wHTScftyxUhyAjbWnEfxGocBjg@mail.gmail.com>
 <20141027095626.GD9807@amd>
 <CAMuHMdVeFGjti-6ghv_u6_r2HkKHwWj70TGzQ0yGkuTmu7zBLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVeFGjti-6ghv_u6_r2HkKHwWj70TGzQ0yGkuTmu7zBLQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-10-27 11:11:53, Geert Uytterhoeven wrote:
> On Mon, Oct 27, 2014 at 10:56 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > On Wed 2014-10-22 16:43:10, Kees Cook wrote:
> >> On Wed, Oct 22, 2014 at 4:26 PM, Andrew Morton
> >> <akpm@linux-foundation.org> wrote:
> >> > On Tue, 21 Oct 2014 13:21:37 -0700 Kees Cook <keescook@chromium.org> wrote:
> >> >
> >> >> From: Paul Wise <pabs3@bonedaddy.net>
> >> >>
> >> >> This partially mitigates a common strategy used by attackers for hiding
> >> >> the full contents of strings in procfs from naive sysadmins who use cat,
> >> >> more or sysctl to inspect the contents of strings in procfs.
> >> >>
> >> >> ...
> >> >>
> >> >> --- a/kernel/sysctl.c
> >> >> +++ b/kernel/sysctl.c
> >> >> @@ -1739,7 +1739,7 @@ static int _proc_do_string(char *data, int maxlen, int write,
> >> >>               while ((p - buffer) < *lenp && len < maxlen - 1) {
> >> >>                       if (get_user(c, p++))
> >> >>                               return -EFAULT;
> >> >> -                     if (c == 0 || c == '\n')
> >> >> +                     if (c == 0 || c == '\n' || c == '\r')
> >> >>                               break;
> >> >>                       data[len++] = c;
> >> >>               }
> >> >
> >> > There are no valid uses of \r in a procfs write?
> >>
> >> I struggle to imagine one; everything I found that uses proc_dostring
> >> seems to be names, paths, and commands.
> >
> > Well, filename can contain \r, right?
> 
> Even \n. AFAIK, the only thing a filename cannot contain is the nul character
> and a forward slash, as that's used to separate path components (so slash
> is valid for a path name).
> 
> Still, we can hide stuff using ANSI ESC sequences, and e.g. backspaces,
> right?

Right :-(. So this patch makes no sense, it would have to forbid any
character < 32 to be effective.

And more sfun is... with ESCape sequences, you can actually cause
stuff to be forced as an input on poor admin's terminal. cat could be
"fixed", but pretty much all the command line tools could be abused to
do this... I see no reasonable way forward.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
