Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbaBDTG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:06:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46812 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaBDTG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:06:56 -0500
Message-ID: <52F13A1C.3040003@zytor.com>
Date: Tue, 04 Feb 2014 11:06:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de, sandyinchina@gmail.com
Subject: Re: [RFC PATCH 0/5] CPU Jitter RNG
References: <2039634.jSmQAS6tdi@myon.chronox.de> <20140204170823.GF12768@thunk.org>
In-Reply-To: <20140204170823.GF12768@thunk.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 09:08 AM, Theodore Ts'o wrote:
> I really wish we could get someone inside Intel who has deep knowledge
> about CPU internals to render an opinion about this.  My reaction to
> "I can't explain where the entropy is coming from" seems very similar
> to what my home grown attempts to create an encryption algoritm when I
> was much younger and much more foolish --- "it must be secure because
> I can't break it".

I think I have deep enough knowledge about CPU architectures in general
(as opposed to specific Intel designs, which I wouldn't be able to
comment on anyway) to comment.  The more modern and high performance a
design you have the more sources of unpredictability there are.
However, there are very few, if any, (unintentional) sources of actual
quantum noise in a synchronous CPU, which means that this is at its core
a PRNG albeit with a large and rather obfuscated state space.

The quantum noise sources there are in a system are generally two
independent clocks running against each other.  However, independent
clocks are rare; instead, most clocks are in fact slaved against each
other using PLLs and similar structures.  When mixing spread spectrum
clocks and non-spread-spectrum clocks that relationship can be very
complex, but at least for some designs it is still at its core predictable.

The most damning thing in my view is that the CPUs that need it the most
-- small, embedded machines without high resolution clocks and few
sources of I/O noise -- are also the simplest designs and therefore are
the least likely ones to have any actual entropy coming out of this.

As mentioned, I definitely have no objection to these sort of things as
zero-credit entropy sources -- they cannot, by definition, do harm,
unless they somehow cancel other inputs out -- but the notion of making
them creditable sources makes me skeptical in the extreme.

> I will note that there are parts of 
> 
>> [2] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html
> 
> which don't really add much to the discussion, but instead just simply
> make an expert question how deep the analysis has gone.  Measuring the
> statistical tests of the entropy pool is a complete waste of time ---
> and in general, using things like "dieharder" don't do anything to
> increase one's confidence (and could decrease one's confidence if it
> makes it appear too much like a snake oil sales document).  Sure,
> passing dieharder is necessary, but it isn't even vaguely close to
> sufficient.

This definitely doesn't help one iota.

> Modulo questions of how much CPU overhead it has, I wouldn't have an
> objection to adding additional sources into the entropy pool, such as
> what Joern has suggested.  It's when there is a proposal to give such
> output entropy credit that I start to get queasy.  (But then again,
> since most applications uses /dev/urandom, the question of entropy
> credit isn't that important for many use cases.)

Entropy credit mostly matters for rngd backpressure, although I do
believe that for things like generating passwords or persistent keys at
least one should use /dev/random.

	-hpa


