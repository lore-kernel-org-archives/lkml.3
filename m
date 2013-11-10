Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab3KJQbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 11:31:48 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.31]:58614 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab3KJQbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 11:31:47 -0500
Message-ID: <527FB4CB.7000106@ladisch.de>
Date: Sun, 10 Nov 2013 17:31:07 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
References: <2579337.FPgJGgHYdz@tauon> <3842150.yBzxVUWavK@tauon> <527EB181.2000602@ladisch.de> <2051753.dJvMFQBFA1@myon.chronox.de>
In-Reply-To: <2051753.dJvMFQBFA1@myon.chronox.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller wrote:
> Am Samstag, 9. November 2013, 23:04:49 schrieb Clemens Ladisch:
>> Stephan Mueller wrote:
>>> Am Mittwoch, 6. November 2013, 08:04:32 schrieb Theodore Ts'o:
>>>> On Wed, Nov 06, 2013 at 01:51:17PM +0100, Stephan Mueller wrote:
>>>>>> That's unfortunate, since it leaves open the question of whether this
>>>>>> jitter is something that could be at least somewhat predictable if you
>>>>>> had a lot more information about the internal works of the CPU or
>>>>>> not....
>>>>>
>>>>> I do not understand that answer: I thought we are talking about the
>>>>> search of non-predictable noise sources. If you cannot predict the
>>>>> sequence even if you have the state of the CPU, that is what we are
>>>>> looking for, is it not?
>>>>
>>>> I was asking the question about whether someone who knew more about
>>>> the internal _workings_ of the CPU, note of the state of the CPU.
>>>> This is not necessarily "the NSA guy", but someone who knows more
>>>> about the internal workings of the Intel CPU (such as an Intel
>>>> engineer --- and I've had Intel express misgivings about approaches
>>>> which depend on "CPU jitter" approaches), or just someone who has
>>>> spent a lot more time trying to examine the black box of the Intel CPU
>>>> from the outside.
>>>
>>> I try to get more information from my contacts to other vendors. But I
>>> am wondering what shall we do if the answer is (maybe even proven with
>>> some test results) that they see the same issue themselves and have no
>>> handle on it?
>>>
>>> I mean, what is it that I would need to test and demonstrate to prove or
>>> disprove my RNG?
>>
>> You need to prove that the CPU will never get into an internal state
>> where the loop execution times happen to form a predictable pattern.
>> Alternatively, detect this so that the measurements can be thrown away.
>
> That statement sounds very nice, and I would love to prove it. But I do not
> see any way to do that except applying statistical tests on a large number of
> different systems

Then you cannot say anything about unknown future CPU models.

> But we have to keep requirements to my RNG in league with the research applied
> to other noise sources. Let us look at physical noise sources we all know and
> love:
>
> - The conclusion that radioactive decay is random is based on the quantum
> theory. That theory contains a number of formulas which were all validated
> with a plethora of measurements. Yet, there is no proof (in the mathematical
> sense) that the formulas are correct.

But we assume that the unpredictability of quantum mechanics is a limit
for _everyone_.  In the case of CPUs, the jitter you observe in delta
times results in part from the complexities of the inner state, and in
part from real random noise.  The first part is deterministic and might
be predicted by anyone who has enough knowledge about the CPU's
internals.

Additionally, physical noise sources allow us to estimate the entropy of
our measurements.  There is no such estimate for the CPU jitter RNG.

(BTW, the entropy calculations in the paper are meaningless, because the
Shannon formula assumes the values are created independently.  Entropy
calculation always depends on the process that created those values.
For example, the entropy of 11001001000011111101101010100010001000 is
zero if you know that this is just pi.  To take a more relevant example,
assume a completely deterministic CPU where each measuring loop takes
exactly one timer tick; the delta times would look like this:
  1 1 1 1 1 1 1 1 1 1 1 1 ...
Now assume that the timer runs at a speed of 4/3 relative to the CPU,
i.e., every third loop, another tick has accumulated:
  1 1 2 1 1 2 1 1 2 1 1 2 ...
Now assume that in every fourth loop iteration, the instruction decoder
falls behind and stalls the pipeline for the same time as one loop
iteration:
  1 1 2 2 2 1 1 3 1 2 1 3 ...
This sequence still has zero entropy.)

> For software:
>
> - The noise sources of interrupts, HID events, HDD fluctuations are all based
> on deductive science. There is even no formulas or other mathematical model
> behind them to state that they are good for RNGs.

Indeed.  However, in the absence of a 'real' RNG, these are the best
that the kernel has.  And at least these events come from multiple
sources and are mostly independent.

>>> We can certainly test very much, but one thing we cannot prove, and
>>> that is the fundamental jitter, provided it is a result of quantum
>>> fluctuations. Just as with any other noise source, basic fundamental
>>> principles are hard if not impossible to test.
>>
>> You cannot test if the noise source was replaced with fake hardware.
>> But if you know the characteristics of the noise source, you can test
>> for likely failure modes, such as the output value being stuck or
>> oscillating.
>
> And here I am asking for help!  [...]
> When you ask for testing of stuck values, what shall I really test for?
> Shall I test adjacent measurements for the same or alternating values?

Same or alternating delta time values happen even on random CPUs.  You
need a theory of how random and non-random CPUs work, and how this
difference affects the delta times, before you can test for that.

(You might take the deterministic toy CPU from above, use more realistic
timings, and add several layers of cache, write buffers, timer I/O wait
states, and out-of-order execution, while still staying deterministic.
Then add real randomness to the I/O or bus clocks, or power management
delays, and check if the result has the same characteristics as your
measurements of real CPUs.)

> The test for the same values is caught with the Von-Neumann unbiaser.

No, the von Neumann unbiaser is run on the whitened bitstream, i.e.,
_after_ the folding operation.

The unbiasing should happen _before_ the whitener.  This implies that
you cannot use the von Neumann unbiaser because the sequence of delta
times is not a sequence of single, independent bits.

(Even for single bits, independence is strictly needed.  Otherwise,
a von Neumann unbiaser could _remove_ entropy.  For example, consider
a noise source that outputs bits in groups of two, where the first bit
is perfectly random, but the second bit is always zero, or the same as
the first.)

> If I test for alternating values, other people may come in and ask to
> check for pattern x or y.

Well, if those people know a pattern that can _actually_ differentiate
between random and non-random delta times, then you should test for it.
(And I'd buy them a beer; with an entropy estimate, the CPU jitter RNG
would be perfect.)


Regards,
Clemens
