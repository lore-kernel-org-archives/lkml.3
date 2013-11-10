Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab3KJBKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 20:10:43 -0500
Received: from mail.eperm.de ([89.247.134.16]:41969 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758431Ab3KJBKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 20:10:39 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Sun, 10 Nov 2013 02:10:18 +0100
Message-ID: <2051753.dJvMFQBFA1@myon.chronox.de>
User-Agent: KMail/4.11.2 (Linux/3.11.7-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <527EB181.2000602@ladisch.de>
References: <2579337.FPgJGgHYdz@tauon> <3842150.yBzxVUWavK@tauon> <527EB181.2000602@ladisch.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 9. November 2013, 23:04:49 schrieb Clemens Ladisch:

Hi Clemens,

> Stephan Mueller wrote:
> > Am Mittwoch, 6. November 2013, 08:04:32 schrieb Theodore Ts'o:
> >> On Wed, Nov 06, 2013 at 01:51:17PM +0100, Stephan Mueller wrote:
> >>>> That's unfortunate, since it leaves open the question of whether this
> >>>> jitter is something that could be at least somewhat predictable if you
> >>>> had a lot more information about the internal works of the CPU or
> >>>> not....
> >>> 
> >>> I do not understand that answer: I thought we are talking about the
> >>> search of non-predictable noise sources. If you cannot predict the
> >>> sequence even if you have the state of the CPU, that is what we are
> >>> looking for, is it not?
> >> 
> >> I was asking the question about whether someone who knew more about
> >> the internal _workings_ of the CPU, note of the state of the CPU.
> >> This is not necessarily "the NSA guy", but someone who knows more
> >> about the internal workings of the Intel CPU (such as an Intel
> >> engineer --- and I've had Intel express misgivings about approaches
> >> which depend on "CPU jitter" approaches), or just someone who has
> >> spent a lot more time trying to examine the black box of the Intel CPU
> >> from the outside.
> > 
> > I try to get more information from my contacts to other vendors. But I
> > am wondering what shall we do if the answer is (maybe even proven with
> > some test results) that they see the same issue themselves and have no
> > handle on it?
> > 
> > I mean, what is it that I would need to test and demonstrate to prove or
> > disprove my RNG?
> 
> You need to prove that the CPU will never get into an internal state
> where the loop execution times happen to form a predictable pattern.
> Alternatively, detect this so that the measurements can be thrown away.

That statement sounds very nice, and I would love to prove it. But I do not 
see any way to do that except applying statistical tests on a large number of 
different systems and by disabling CPU features -- as I have done.

I am fully aware that statistical tests cannot prove the conclusion that the 
noise source is proper.

But we have to keep requirements to my RNG in league with the research applied 
to other noise sources. Let us look at physical noise sources we all know and 
love:

- The conclusion that radioactive decay is random is based on the quantum 
theory. That theory contains a number of formulas which were all validated 
with a plethora of measurements. Yet, there is no proof (in the mathematical 
sense) that the formulas are correct. These formulas are based on deductive 
science but *not* inductive science (like math).

- Oscillators: Again, the conclusion of oscillators being appropriate depends 
on deductive science.

- Shot noise, Johnson noise, etc. of resistors, transistors is again based on 
deductive science.

For software:

- The noise sources of interrupts, HID events, HDD fluctuations are all based 
on deductive science. There is even no formulas or other mathematical model 
behind them to state that they are good for RNGs.

So, there was never a proof in the sense of an inductive science of any noise 
source. That means I cannot be expected to show a full formulated proof based 
on inductive science of the noise source I offer here.

Yet, I meet the deductive science approach with my RNG as I base my 
conclusions on a large array of measurements. And I give the tools to perform 
the measurements to everybody. So, everybody can easily redo the testing, or, 
if possible, prove me wrong!

You may look into [1] and [2]. [1] mentions that inductive methods cannot 
reach absolute proof.
> 
> > We can certainly test very much, but one thing we cannot prove, and
> > that is the fundamental jitter, provided it is a result of quantum
> > fluctuations. Just as with any other noise source, basic fundamental
> > principles are hard if not impossible to test.
> 
> You cannot test if the noise source was replaced with fake hardware.
> But if you know the characteristics of the noise source, you can test
> for likely failure modes, such as the output value being stuck or
> oscillating.

And here I am asking for help! What did I do so far:

- Test the CPU in kernel and user mode.

- Selectively and mutually disable CPU features (see appendix F.46 of my 
documentation).

- Tested on quiet and heavily loaded CPUs.

- Testing on the same physical system / CPU with different operating systems.

What else can I do?

When you ask for testing of stuck values, what shall I really test for? Shall 
I test adjacent measurements for the same or alternating values? The test for 
the same values is caught with the Von-Neumann unbiaser. If I test for 
alternating values, other people may come in and ask to check for pattern x or 
y.

But then, section 4.3 of my document contains an analysis of patterns. As I do 
not use a whitener, any pattern WILL be visible with the Chi-Square test 
result. All tests I conducted show a good Chi-Square value! That leads me to 
the conclusion that there is NO pattern visible.
> 
> In the case of CPU jitter measurements, you do not have direct access to
> the noise source; you measure it indirectly through the CPU's internal
> state.  So you need to know how the delta times of a noisy CPU are
> different from the delta times of a CPU without or with unsuitable
> noise source.

Please give me a practical example! This statement is again a nice theoretical 
wish, but my considerations above for the different noise sources can again be 
applied here: I have never seen elaborate stuck tests on any other physical or 
non-physical RNG. Yes, I have seen the FIPS 140-2 continuous test, but that is 
already implemented in my code.

[1] https://en.wikipedia.org/wiki/Inductive_reasoning

[2] https://en.wikipedia.org/wiki/Deductive_reasoning

Ciao
Stephan
-- 
| Cui bono? |
