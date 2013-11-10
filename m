Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab3KJU2w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 15:28:52 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43234 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821Ab3KJU2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 15:28:44 -0500
X-Sasl-enc: q3kaDYa9ggUeNUMg0m+Xg5hmOcVGakO+GgrkBIlZnKZE 1384115323
Message-ID: <527FEC56.5070306@ladisch.de>
Date: Sun, 10 Nov 2013 21:28:06 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
References: <2579337.FPgJGgHYdz@tauon> <2051753.dJvMFQBFA1@myon.chronox.de> <527FB4CB.7000106@ladisch.de> <8100659.WdgUuKxd0z@myon.chronox.de>
In-Reply-To: <8100659.WdgUuKxd0z@myon.chronox.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller wrote:
> Am Sonntag, 10. November 2013, 17:31:07 schrieb Clemens Ladisch:
>> In the case of CPUs, the jitter you observe in delta
>> times results in part from the complexities of the inner state, and in
>> part from real random noise.  The first part is deterministic and might
>> be predicted by anyone who has enough knowledge about the CPU's
>> internals.
>
> Right, and that is why I tried to eliminate the CPU mechanisms that may be
> having a deterministic impact. If I miss a mechanism or your have other
> suggestions, please help me.

Many CPUs allow to disable branch prediction, but this is very vendor
specific (try to find MSR documentation).  The biggest offender probably
is the out-of-order execution engine, which cannot be disabled.

>>> When you ask for testing of stuck values, what shall I really test for?
>>> Shall I test adjacent measurements for the same or alternating values?
>>
>> Same or alternating delta time values happen even on random CPUs.  You
>> need a theory of how random and non-random CPUs work, and how this
>> difference affects the delta times, before you can test for that.
>
> Are you telling me that I should invent a formula and apply it?

I was not implying that the theory has nothing to do with the physical
device.  It must correctly _describe_ the relevant physical processes.

>>> The test for the same values is caught with the Von-Neumann unbiaser.
>>
>> No, the von Neumann unbiaser is run on the whitened bitstream, i.e.,
>> _after_ the folding operation.
>
> The folding is whitened? How do you reach that conclusion? Yes, the folding is
> my (very simple) post-processing. But I am not calling it whitened as all
> statistical problems the underlying variations have *will* be still visible in
> the folded value.

If you don't want to call it "whitening", call it "randomness extraction"
instead.  But its input is a series of delta times like this:
  00000000000000000000000001010011
  00000000000000000000000010011010
  00000000000000000000000001011011
  00000000000000000000000001100100
  00000000000000000000000010111000
and the purpose of the folding is to remove these zero patterns.

> What would you expect me to do when I should do to come up with an entropy
> estimate that I not already have done?

I do not expect you (or anybody) to be able to come up with a correct
entropy estimate for CPU jitter.

> There are so many assessments on entropy I make, I am surprised that I
> am said to have no entropy assessment.

Again: Shannon entropy assumes that you have a sequence of independent
and identically distributed random variables.  And you cannot prove
these properties from the output; you need to know the process that
generates the values.


Regards,
Clemens
