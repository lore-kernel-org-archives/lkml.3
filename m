Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaEFVku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:40:50 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:34249 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaEFVkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:40:49 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwix8dSDQ1N1Qu2-9rzGxWeeGAv4fSPVQWGo1YNzJoCoA@mail.gmail.com>
References: <e94ab903e725eaf9d98e56f3043878bde7fc1b58.1399408110.git.luto@amacapital.net>
	<CA+55aFy6NzQOfyne4xLqQQCvuhpi-KSXnJNLjXTRc7+4ChPAnQ@mail.gmail.com>
	<CA+55aFw_Dj7Lx_bE0B3mDxMUNz_K1yc=saziC9dmA_dKSkFWiw@mail.gmail.com>
	<CA+55aFwix8dSDQ1N1Qu2-9rzGxWeeGAv4fSPVQWGo1YNzJoCoA@mail.gmail.com>
Date: Tue, 6 May 2014 14:40:48 -0700
X-Google-Sender-Auth: yivaLzN1gT61LfZSyTT3r4noGY8
Message-ID: <CA+55aFywAWExT-9o5v_1dWPV7aZUUOURoox-RryS9H0VaLijXg@mail.gmail.com>
Subject: Re: [ABOMINATION] x86: Fast interrupt return to userspace
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 2:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Whatever. I got enough profile data to say that it seems to have cut
> 'iret' overhead by at least two thirds. So it may not *work*, but from
> a "hey look, some random numbers" standpoint it is worth playing with.

Just to clarify: that's just the "iret" part. On both the kernel build
and my microbenchmark, the fault itself is the more expensive part.

But on my microbenchmark, it used to be 80% page fault overhead, where
the split was roughly 55/25 percentage points. So the cost of "iret"
was almost a third of the total page fault cost, and roughly a quarter
of the total cost on that microbeanchmark.

And remember: that microbenchmark improved absolute performance by
about 23%. That already implied that most of iret just went away. The
(partial) profile numbers I did get before the machine hung seem to
back that up, with the page fault overhead now looking like 67% of
total (but remember: it's a smaller total, so the real improvement is
bigger than that 80% -> 67% thing), with the percentage point split
being roughly 64/3. So with that sysret trick, the 'iret" overhead is
pretty much negligible - it went from a third of the page fault cost
to 1/20th or so.

But the fault itself obviously doesn't speed up.

                  Linus
