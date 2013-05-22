Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab3EVRkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:40:10 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:39942 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3EVRkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:40:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130522082058.5592b2aa@tauon>
References: <20130521084455.5c651991@tauon>
	<CACXcFm=PCPs23Kd8B0+B7418fSaz=59Z4DRcj3-Wcd-i=Meang@mail.gmail.com>
	<20130521190157.GD22559@thunk.org>
	<CACXcFmnyDh7kBN3SCLGH3DcHH2gZO2_7weL_pch00g+3Jsjegg@mail.gmail.com>
	<20130522082058.5592b2aa@tauon>
Date: Wed, 22 May 2013 13:40:04 -0400
Message-ID: <CACXcFm=Quwx-Mi9s67jQe3HvJ55S3zb+3qsPxkYPvy4A+0Hrqw@mail.gmail.com>
Subject: Re: [PATCH][RFC] CPU Jitter random number generator (resent)
From: Sandy Harris <sandyinchina@gmail.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller <smueller@chronox.de> wrote:

> Ted is right that the non-deterministic behavior is caused by the OS
> due to its complexity. ...

>> >  For VM's, it means we should definitely use
>> > paravirtualization to get randomness from the host OS.
>> ...
>
> That is already in place at least with KVM and Xen as QEMU can pass
> through access to the host /dev/random to the guest. Yet, that approach
> is dangerous IMHO because you have one central source of entropy for
> the host and all guests. One guest can easily starve all other guests
> and the host of entropy. I know that is the case in user space as well.

Yes, I have always thought that random(4) had a problem in that
area; over-using /dev/urandom can affect /dev/random. I've never
come up with a good way to fix it, though.

> That is why I am offering an implementation that is able to
> decentralize the entropy collection process. I think it would be wrong
> to simply update /dev/random with another seed source of the CPU
> jitter -- it could be done as one aspect to increase the entropy in
> the system. I think users should slowly but surely instantiate their own
> instance of an entropy collector.

I'm not sure that's a good idea. Certainly for many apps just seeding
a per-process PRNG well is enough, and a per-VM random device
looks essential, though there are at least two problems possible
because random(4) was designed before VMs were at all common
so it is not clear it can cope with that environment. The host
random device may be overwhelmed, and the guest entropy may
be inadequate or mis-estimated because everything it relies on --
devices, interrupts, ... -- is virtualised.

I want to keep the current interface where a process can just
read /dev/random or /dev/urandom as required. It is clean,
simple and moderately hard for users to screw up. It may
need some behind-the-scenes improvements to handle new
loads, but I cannot see changing the interface itself.

> I would personally think that precisely for routers, the approach
> fails, because there may be no high-resolution timer. At least trying
> to execute my code on a raspberry pie resulted in a failure: the
> initial jent_entropy_init() call returned with the indication that
> there is no high-res timer.

My maxwell(8) uses the hi-res timer by default but also has a
compile-time option to use the lower-res timer if required. You
still get entropy, just not as much.

This affects more than just routers. Consider using Linux on
a tablet PC or in a web server running in a VM. Neither needs
the realtime library; in fact adding that may move them away
from their optimisation goals.

>> > What I'm against is relying only on solutions such as HAVEGE or
>> > replacing /dev/random with something scheme that only relies on CPU
>> > timing and ignores interrupt timing.
>>
>> My question is how to incorporate some of that into /dev/random.
>> At one point, timing info was used along with other stuff. Some
>> of that got deleted later, What is the current state? Should we
>> add more?
>
> Again, I would like to suggest that we look beyond a central entropy
> collector like /dev/random. I would like to suggest to consider
> decentralizing the collection of entropy.

I'm with Ted on this one.

--
Who put a stop payment on my reality check?
