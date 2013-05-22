Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab3EVSet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:34:49 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:13229 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3EVSes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:34:48 -0400
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8DFCng/+ALmLZYRFnZn15ELiOAuLr3NkII
X-RZG-CLASS-ID: mo00
Date: Wed, 22 May 2013 20:34:41 +0200
From: Stephan Mueller <smueller@chronox.de>
To: Sandy Harris <sandyinchina@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH][RFC] CPU Jitter random number generator (resent)
Message-ID: <20130522203441.79c2f22f@tauon>
In-Reply-To: <CACXcFm=Quwx-Mi9s67jQe3HvJ55S3zb+3qsPxkYPvy4A+0Hrqw@mail.gmail.com>
References: <20130521084455.5c651991@tauon>
	<CACXcFm=PCPs23Kd8B0+B7418fSaz=59Z4DRcj3-Wcd-i=Meang@mail.gmail.com>
	<20130521190157.GD22559@thunk.org>
	<CACXcFmnyDh7kBN3SCLGH3DcHH2gZO2_7weL_pch00g+3Jsjegg@mail.gmail.com>
	<20130522082058.5592b2aa@tauon>
	<CACXcFm=Quwx-Mi9s67jQe3HvJ55S3zb+3qsPxkYPvy4A+0Hrqw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013 13:40:04 -0400
Sandy Harris <sandyinchina@gmail.com> wrote:

Hi Sandy,

> Stephan Mueller <smueller@chronox.de> wrote:
> 
> > Ted is right that the non-deterministic behavior is caused by the OS
> > due to its complexity. ...
> 
> >> >  For VM's, it means we should definitely use
> >> > paravirtualization to get randomness from the host OS.
> >> ...
> >
> > That is already in place at least with KVM and Xen as QEMU can pass
> > through access to the host /dev/random to the guest. Yet, that
> > approach is dangerous IMHO because you have one central source of
> > entropy for the host and all guests. One guest can easily starve
> > all other guests and the host of entropy. I know that is the case
> > in user space as well.
> 
> Yes, I have always thought that random(4) had a problem in that
> area; over-using /dev/urandom can affect /dev/random. I've never
> come up with a good way to fix it, though.

I think there is no way unless we either:

- use a seed source that is very fast, like hardware oscillators

- use a per-consumer seed source where the consumer can only hurt
  himself when he overuses the resource
> 
> > That is why I am offering an implementation that is able to
> > decentralize the entropy collection process. I think it would be
> > wrong to simply update /dev/random with another seed source of the
> > CPU jitter -- it could be done as one aspect to increase the
> > entropy in the system. I think users should slowly but surely
> > instantiate their own instance of an entropy collector.
> 
> I'm not sure that's a good idea. Certainly for many apps just seeding
> a per-process PRNG well is enough, and a per-VM random device
> looks essential, though there are at least two problems possible
> because random(4) was designed before VMs were at all common
> so it is not clear it can cope with that environment. The host
> random device may be overwhelmed, and the guest entropy may
> be inadequate or mis-estimated because everything it relies on --
> devices, interrupts, ... -- is virtualised.

Right. That is why we need to open up other sources for entropy that
work also in a virtual environment.

The proposed solution generates entropy equally well in a virtual
environment as outlined in the documentation. I also performed testing
in virtual environments and obtained the same results as the tests on a
host system.

What could be done is:

- in the short term to wire up the CPU Jitter RNG to /dev/random as
  another source for entropy in the host and the guest. This way,
  the /dev/random implementation in the guest would get good entropy
  without requiring host support.

- in the medium term, move consumers of entropy in user space and
  kernel space (like SSL connections, VPN implementations,
  OpenSSH, ....) to instantiate an independent copy of the jitter RNG
  and thus easing the load on /dev/random. This can be implemented by
  using the proposed connections to the different crypto libraries of
  OpenSSL, libgcrypt, ..., and even the kernel crypto API. Every
  consumer that has its own instance of the jitter RNG would not need to
  call /dev/random any more
> 
> I want to keep the current interface where a process can just
> read /dev/random or /dev/urandom as required. It is clean,
> simple and moderately hard for users to screw up. It may

I am not so sure about the last words. Using /dev/random correctly has
many pitfalls, IMHO:

- The OS must ensure that it is seeded during boot and that seed is
  stored during shutdown. This is already a problem in many embedded
  devices where this is done incorrectly.

- When you install full disk encryptions during the initial
  installation, there is hardly any entropy in /dev/random (at least
  when using a non-GUI installer), but you want to get entropy for a
  very long living key.

- A simple read(fd) from /dev/random is not sufficient. You must take
  care of EINTR. I have seen many uses of /dev/random where developers
  even overlooked that simple problem.

- Currently /dev/random uses SSDs as seed source. You must manually
  turn them off as seed source via /sys files.

> need some behind-the-scenes improvements to handle new
> loads, but I cannot see changing the interface itself.

I am not proposing any change to that interface. I am proposing a
complete independent offering of an entropy source that a caller could
use instead of /dev/random, if he wishes.
> 
> > I would personally think that precisely for routers, the approach
> > fails, because there may be no high-resolution timer. At least
> > trying to execute my code on a raspberry pie resulted in a failure:
> > the initial jent_entropy_init() call returned with the indication
> > that there is no high-res timer.
> 
> My maxwell(8) uses the hi-res timer by default but also has a
> compile-time option to use the lower-res timer if required. You
> still get entropy, just not as much.
> 
> This affects more than just routers. Consider using Linux on
> a tablet PC or in a web server running in a VM. Neither needs
> the realtime library; in fact adding that may move them away
> from their optimisation goals.
> 
> >> > What I'm against is relying only on solutions such as HAVEGE or
> >> > replacing /dev/random with something scheme that only relies on
> >> > CPU timing and ignores interrupt timing.
> >>
> >> My question is how to incorporate some of that into /dev/random.
> >> At one point, timing info was used along with other stuff. Some
> >> of that got deleted later, What is the current state? Should we
> >> add more?
> >
> > Again, I would like to suggest that we look beyond a central entropy
> > collector like /dev/random. I would like to suggest to consider
> > decentralizing the collection of entropy.
> 
> I'm with Ted on this one.

When you want to consider the jitter RNG for /dev/random, it should be
used as a seed source similar to the add_*_randomness functions. I
could implement a suggestion if that is the wish. For example, such a
seed source could be triggered if the entropy estimator of the
input_pool falls below some threshold. The jitter RNG could be used to
top the entropy off to some level above another threshold.

But again, the long term goal is that there is no need of central
entropy collection device like /dev/random any more.

Ciao
Stephan
> 
> --
> Who put a stop payment on my reality check?



-- 
| Cui bono? |
