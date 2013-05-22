Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab3EVGVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:21:10 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:55710 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab3EVGVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:21:06 -0400
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8DFCng/+ALmLZYRFnZn15ELiOAuLr3NkII
X-RZG-CLASS-ID: mo00
Date: Wed, 22 May 2013 08:20:58 +0200
From: Stephan Mueller <smueller@chronox.de>
To: Sandy Harris <sandyinchina@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH][RFC] CPU Jitter random number generator (resent)
Message-ID: <20130522082058.5592b2aa@tauon>
In-Reply-To: <CACXcFmnyDh7kBN3SCLGH3DcHH2gZO2_7weL_pch00g+3Jsjegg@mail.gmail.com>
References: <20130521084455.5c651991@tauon>
 <CACXcFm=PCPs23Kd8B0+B7418fSaz=59Z4DRcj3-Wcd-i=Meang@mail.gmail.com>
 <20130521190157.GD22559@thunk.org>
 <CACXcFmnyDh7kBN3SCLGH3DcHH2gZO2_7weL_pch00g+3Jsjegg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 May 2013 17:39:49 -0400
Sandy Harris <sandyinchina@gmail.com> wrote:

Hi Sandy,

> On Tue, May 21, 2013 at 3:01 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> > I continue to be suspicious about claims that userspace timing
> > measurements are measuring anything other than OS behaviour.
> 
> Yes, but they do seem to contain some entropy. See links in the
> original post of this thread, the havege stuff and especially the
> McGuire et al paper.

Ted is right that the non-deterministic behavior is caused by the OS
due to its complexity. This complexity implies that you do not have a
clue what the fill levels of caches are, placement of data in RAM, etc.
I would expect that if you would have a tiny microkernel as your sole
software body on a CPU, there would be hardly any jitter. On the other
hand, the jitter is not mainly caused by interrupts and such, because
interrupts would cause a time delta that is by orders of magnitude
higher than most deltas (deltas vary around 20 to 40, interrupts cause
deltas in the mid thousands at least and ranging to more than 100,000).
> 
> >  But that
> > doesn't mean that they shouldn't exist.  Personally, I believe you
> > should try to collect as much entropy as you can, from as many
> > places as you can.
> 
> Yes.

That is the goal with the collection approach I offer. With the
repetition of the time delta measurements thousands of times to get one
64 bit random value, the goal is that you magnify and collect that tiny
bit of entropy.

My implementation is based on a sound mathematical base as I only use
XOR and concatenation of data. It has been reviewed by a mathematician
and other folks who worked on RNGs for a long time. Thus, once you
accept that the root cause typically delivers more than 1 bit of
entropy per measurement (the measurements I did showed more than 2 bits
of Shannon Entropy), then the collection process will result in a
random number that contains the claimed entropy.
> 
> >  For VM's, it means we should definitely use
> > paravirtualization to get randomness from the host OS.
> 
> Yes, I have not worked out the details but it seems clear that
> something along those lines would be a fine idea.

That is already in place at least with KVM and Xen as QEMU can pass
through access to the host /dev/random to the guest. Yet, that approach
is dangerous IMHO because you have one central source of entropy for
the host and all guests. One guest can easily starve all other guests
and the host of entropy. I know that is the case in user space as well.

That is why I am offering an implementation that is able to
decentralize the entropy collection process. I think it would be wrong
to simply update /dev/random with another seed source of the CPU
jitter -- it could be done as one aspect to increase the entropy in
the system. I think users should slowly but surely instantiate their own
instance of an entropy collector.
> 
> > For devices like Linux routers, what we desperately need is hardware
> > assist;  [or] mix
> > in additional timing information either at kernel device driver
> > level, or from systems such as HAVEGE.

I would personally think that precisely for routers, the approach
fails, because there may be no high-resolution timer. At least trying
to execute my code on a raspberry pie resulted in a failure: the
initial jent_entropy_init() call returned with the indication that
there is no high-res timer.
> >
> > What I'm against is relying only on solutions such as HAVEGE or
> > replacing /dev/random with something scheme that only relies on CPU
> > timing and ignores interrupt timing.
> 
> My question is how to incorporate some of that into /dev/random.
> At one point, timing info was used along with other stuff. Some
> of that got deleted later, What is the current state? Should we
> add more?

Again, I would like to suggest that we look beyond a central entropy
collector like /dev/random. I would like to suggest to consider
decentralizing the collection of entropy.

Ciao
Stephan
> 
> --
> Who put a stop payment on my reality check?



-- 
| Cui bono? |
