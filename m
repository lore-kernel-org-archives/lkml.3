Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaBCBjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 20:39:41 -0500
Received: from imap.thunk.org ([74.207.234.97]:53604 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbaBCBjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 20:39:40 -0500
Date: Sun, 2 Feb 2014 20:39:22 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
Message-ID: <20140203013922.GB6264@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
	blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
	tg@mirbsd.de
References: <20140202203617.GA9499@logfs.org>
 <16782692.5vMS7Bhbvf@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16782692.5vMS7Bhbvf@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 02, 2014 at 10:25:31PM +0100, Stephan Mueller wrote:
> Second, when I offered my initial patch which independently collects some 
> entropy on the CPU execution timing, I got shot down with one concern raised 
> by Ted, and that was about whether a user can influence the entropy collection 
> process.

Um, that wasn't my concern.  After all, when we sample keyboard timing
while trying to generate a GPG key, of course the user can and does
influence the entropy collection process.

The question is whether an attacker who has deep knowledge of the how
the CPU works internally, perhaps made worse with quantization effects
(i.e., it doesn't matter if analog-generated settling time is measured
in microseconds if the output is being clocked out in milliseconds),
such that it is predictable.

I really like Jörn's tests doing repeated boot testing and observing
on a SMP system, the slab allocation pattern is quite deterministic.
So even though the numbers might *look* random, an attacker with deep
knowledge of how the kernel was compiled and what memory allocations
get done during the boot sequence would be able to quite successfuly
measure it.

I'm guessing that indeed, on a 4-CPU KVM system, what you're measuring
is the when the host OS happens to be scheduling the KVM threads, with
some variability caused by external networking interrupts, etc.  It
would definitely be a good idea to retry that experiment on a real
4-CPU system to see what sort of results you might get.  It might very
well be that the attacker who knows the relative ordering of the
slab/thread activations but for which it's not entirely clear whether
one cpu will be ahead of another, that there is *some* entropy, but
perhaps only a handful bits.  It's the fact that we can't be sure how
much uncertainty there might be with an attacker with very deep
knowledge the CPU which is why Jörn's conservatism of not crediting
the entropy counter is quite understandable.

Of course, this doesn't help someone who is trying to speed up the
time it takes GPG to generate a new key pair.  But in terms of
improving /dev/urandom as it is used by many crypto applications, it
certainly can't hurt.

The real question is how much overhead does it add, and is it worth
it.  Jörn, I take it that was the reason for creating an even faster,
but weaker mixing function?  Was the existing "fast mix" causing a
measurable overhead, or was this your just being really paranoid about
not adding anything to the various kernel fastpaths?

    	   	       	   	   	  - Ted
