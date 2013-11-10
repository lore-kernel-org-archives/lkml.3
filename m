Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3KJRWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 12:22:12 -0500
Received: from mail.eperm.de ([89.247.134.16]:41242 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab3KJRWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 12:22:04 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Sun, 10 Nov 2013 18:21:47 +0100
Message-ID: <8100659.WdgUuKxd0z@myon.chronox.de>
User-Agent: KMail/4.11.2 (Linux/3.11.7-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <527FB4CB.7000106@ladisch.de>
References: <2579337.FPgJGgHYdz@tauon> <2051753.dJvMFQBFA1@myon.chronox.de> <527FB4CB.7000106@ladisch.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 10. November 2013, 17:31:07 schrieb Clemens Ladisch:

Hi Clemens,

> Stephan Mueller wrote:
> > Am Samstag, 9. November 2013, 23:04:49 schrieb Clemens Ladisch:
> >> Stephan Mueller wrote:
> >>> Am Mittwoch, 6. November 2013, 08:04:32 schrieb Theodore Ts'o:
> >>>> On Wed, Nov 06, 2013 at 01:51:17PM +0100, Stephan Mueller wrote:
> >>>>>> That's unfortunate, since it leaves open the question of whether this
> >>>>>> jitter is something that could be at least somewhat predictable if
> >>>>>> you
> >>>>>> had a lot more information about the internal works of the CPU or
> >>>>>> not....
> >>>>> 
> >>>>> I do not understand that answer: I thought we are talking about the
> >>>>> search of non-predictable noise sources. If you cannot predict the
> >>>>> sequence even if you have the state of the CPU, that is what we are
> >>>>> looking for, is it not?
> >>>> 
> >>>> I was asking the question about whether someone who knew more about
> >>>> the internal _workings_ of the CPU, note of the state of the CPU.
> >>>> This is not necessarily "the NSA guy", but someone who knows more
> >>>> about the internal workings of the Intel CPU (such as an Intel
> >>>> engineer --- and I've had Intel express misgivings about approaches
> >>>> which depend on "CPU jitter" approaches), or just someone who has
> >>>> spent a lot more time trying to examine the black box of the Intel CPU
> >>>> from the outside.
> >>> 
> >>> I try to get more information from my contacts to other vendors. But I
> >>> am wondering what shall we do if the answer is (maybe even proven with
> >>> some test results) that they see the same issue themselves and have no
> >>> handle on it?
> >>> 
> >>> I mean, what is it that I would need to test and demonstrate to prove or
> >>> disprove my RNG?
> >> 
> >> You need to prove that the CPU will never get into an internal state
> >> where the loop execution times happen to form a predictable pattern.
> >> Alternatively, detect this so that the measurements can be thrown away.
> > 
> > That statement sounds very nice, and I would love to prove it. But I do
> > not
> > see any way to do that except applying statistical tests on a large number
> > of different systems
> 
> Then you cannot say anything about unknown future CPU models.

I concur.

But neither can we say anything about future HDDs (note, they now start to 
fill them with Helium instead of air -- does that change anything in the 
disturbances?) or timers or interrupt hardware. Also, we know for a fact that 
the reliance on HDD as seed sources breaks down even today with SSDs!

Again, we are not discussing about random.c, so please let us not further 
elaborate on HDDs/SSDs and their significance. But I am asking that my RNG is 
treated with the *same* level of rigor we apply to other seed sources. Thus, 
we can safely assume that future CPUs have that jitter too, because chip 
vendors will NOT simply drop all their existing effort and start at zero 
designing a new CPU.

Besides, all my measurements show that the newer the CPU is, the more jitter 
it shows. Nonetheless, even the oldest ones I tested contain good jitter. 
> 
> > But we have to keep requirements to my RNG in league with the research
> > applied to other noise sources. Let us look at physical noise sources we
> > all know and love:
> > 
> > - The conclusion that radioactive decay is random is based on the quantum
> > theory. That theory contains a number of formulas which were all validated
> > with a plethora of measurements. Yet, there is no proof (in the
> > mathematical sense) that the formulas are correct.
> 
> But we assume that the unpredictability of quantum mechanics is a limit

Here you say it: we *assume*. And please bear in mind that we all know for a 
fact that the theory behind quantum physics is not complete, because it does 
not work together with the theory of relativity. That again is a hint that 
there is NO proof that decay is really unpredictable.

But we disgres again, and I will skip more discussions about that theory.

> for _everyone_.  In the case of CPUs, the jitter you observe in delta
> times results in part from the complexities of the inner state, and in
> part from real random noise.  The first part is deterministic and might
> be predicted by anyone who has enough knowledge about the CPU's
> internals.

Right, and that is why I tried to eliminate the CPU mechanisms that may be 
having a deterministic impact. If I miss a mechanism or your have other 
suggestions, please help me.
> 
> Additionally, physical noise sources allow us to estimate the entropy of
> our measurements.  There is no such estimate for the CPU jitter RNG.

Well, I thought I have hints on the estimations of entropy in all my graphs by 
calculating a Shannon Entropy value. Granted, that is over the execution 
duration of my folding loop. Yet, that gives a good hint on the variations in 
place.
> 
> (BTW, the entropy calculations in the paper are meaningless, because the
> Shannon formula assumes the values are created independently.  Entropy
> calculation always depends on the process that created those values.
> For example, the entropy of 11001001000011111101101010100010001000 is
> zero if you know that this is just pi.  To take a more relevant example,
> assume a completely deterministic CPU where each measuring loop takes
> exactly one timer tick; the delta times would look like this:
>   1 1 1 1 1 1 1 1 1 1 1 1 ...
> Now assume that the timer runs at a speed of 4/3 relative to the CPU,
> i.e., every third loop, another tick has accumulated:
>   1 1 2 1 1 2 1 1 2 1 1 2 ...
> Now assume that in every fourth loop iteration, the instruction decoder
> falls behind and stalls the pipeline for the same time as one loop
> iteration:
>   1 1 2 2 2 1 1 3 1 2 1 3 ...
> This sequence still has zero entropy.)

First, the patterns you mention will be immediately obvious with the Chi-
Square measurements -- see section 4.3 of my document. So, I disregard the 
discussion of patterns.

Second, we have to establish that entropy is *relative*. What is entropic to 
me, may be fully deterministic to you (when I look at the desk of my wife, it 
is all chaos to me, but when I ask her to get me some information, she needs 5 
seconds to dig through her heaps and get me the stuff -- i.e. it is no chaos 
for her). That said, of course if I have full knowledge of all mechanisms that 
affect my RNG, I have zero entropy. But what I am saying is that I do not have 
that knowledge. The key now is to explain that nobody else has that either.
> 
> > For software:
> > 
> > - The noise sources of interrupts, HID events, HDD fluctuations are all
> > based on deductive science. There is even no formulas or other
> > mathematical model behind them to state that they are good for RNGs.
> 
> Indeed.  However, in the absence of a 'real' RNG, these are the best
> that the kernel has.  And at least these events come from multiple
> sources and are mostly independent.

Great, and here we are together. All I am offering is yet *another* noise 
source that is *added* to the existing ones.

The only big difference is that my noise source works on demand whereas the 
others work by being triggered by the kernel operation. Therefore, I tried to 
provide the patch in a way that my RNG is used as the last resort before 
/dev/random blocks.

Yet, my RNG as a seed source is available way earlier than any of the other 
seed sources. Moreover, it works in environments the others start to fail. 
That is why I am pushing my RNG in, because I have an itch (the missing 
/dev/random entropy in environments I care about -- embedded, Live CDs and 
virtual environments) that I want to scratch.
> 
> >>> We can certainly test very much, but one thing we cannot prove, and
> >>> that is the fundamental jitter, provided it is a result of quantum
> >>> fluctuations. Just as with any other noise source, basic fundamental
> >>> principles are hard if not impossible to test.
> >> 
> >> You cannot test if the noise source was replaced with fake hardware.
> >> But if you know the characteristics of the noise source, you can test
> >> for likely failure modes, such as the output value being stuck or
> >> oscillating.
> > 
> > And here I am asking for help!  [...]
> > When you ask for testing of stuck values, what shall I really test for?
> > Shall I test adjacent measurements for the same or alternating values?
> 
> Same or alternating delta time values happen even on random CPUs.  You
> need a theory of how random and non-random CPUs work, and how this
> difference affects the delta times, before you can test for that.

Are you telling me that I should invent a formula and apply it? Where have you 
seen such an approach in existing RNGs?
> 
> (You might take the deterministic toy CPU from above, use more realistic

Your toy CPU from above contains some artificially created deterministic 
behavior. Sure I can check for that. But then somebody else tells me, why not 
checking for pattern X or Y. So, that effort is bound to failure, IMHO.

> timings, and add several layers of cache, write buffers, timer I/O wait
> states, and out-of-order execution, while still staying deterministic.
> Then add real randomness to the I/O or bus clocks, or power management
> delays, and check if the result has the same characteristics as your
> measurements of real CPUs.)

I have no idea how that proposal would look like in real live.
> 
> > The test for the same values is caught with the Von-Neumann unbiaser.
> 
> No, the von Neumann unbiaser is run on the whitened bitstream, i.e.,
> _after_ the folding operation.

The folding is whitened? How do you reach that conclusion? Yes, the folding is 
my (very simple) post-processing. But I am not calling it whitened as all 
statistical problems the underlying variations have *will* be still visible in 
the folded value. Patterns in the underlying timer *will* be visible -- and I 
have demonstrated that in section 4.3.
> 
> The unbiasing should happen _before_ the whitener.  This implies that
> you cannot use the von Neumann unbiaser because the sequence of delta
> times is not a sequence of single, independent bits.

You are right when the processing is a whitening. But it is not! Whitening 
implies that you somehow are able to hide statistical problems with the 
applied whitening. My folding DOES NOT do that. So, it is no whitening.
> 
> (Even for single bits, independence is strictly needed.  Otherwise,
> a von Neumann unbiaser could _remove_ entropy.  For example, consider
> a noise source that outputs bits in groups of two, where the first bit
> is perfectly random, but the second bit is always zero, or the same as
> the first.)

I know that. But from what I see, there is no patterns so far and therefore, 
the only conclusion I can reach is that they are independent.

But if you do not like the Von-Neumann unbiaser, take it out. And still, the 
statistical tests will pass.
> 
> > If I test for alternating values, other people may come in and ask to
> > check for pattern x or y.
> 
> Well, if those people know a pattern that can _actually_ differentiate
> between random and non-random delta times, then you should test for it.
> (And I'd buy them a beer; with an entropy estimate, the CPU jitter RNG
> would be perfect.)

What would you expect me to do when I should do to come up with an entropy 
estimate that I not already have done? There are so many assessments on 
entropy I make, I am surprised that I am said to have no entropy assessment.

Ciao
Stephan
-- 
| Cui bono? |
