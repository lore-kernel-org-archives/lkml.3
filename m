Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaGKPoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:44:20 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51243 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaGKPoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:44:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19V2yXUWfHctZGCKXOklFT8BSb4qaCHI+Y=
X-DKIM: OpenDKIM Filter v2.0.1 titan DB7B85A8A8D
Date: Fri, 11 Jul 2014 11:44:07 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, stable@vger.kernel.org
Subject: Re: [RFC PATCH] hwrng: sysfs entry rng_seed_kernel, was: "Re:
 [PATCH v2 1/2] hwrng: fetch randomness only after device init"
Message-ID: <20140711154407.GD13108@titan.lakedaemon.net>
References: <cover.1404538109.git.amit.shah@redhat.com>
 <515a12ecc5fca5452bf0bfda4d54546d8fb5829c.1404538109.git.amit.shah@redhat.com>
 <20140709115317.GM13433@titan.lakedaemon.net>
 <20140709130822.GA4553@grmbl.mre>
 <20140709131737.GO13433@titan.lakedaemon.net>
 <20140709132524.GB4667@grmbl.mre>
 <20140709160725.GP13433@titan.lakedaemon.net>
 <20140711132626.GB17415@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711132626.GB17415@grmbl.mre>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:56:26PM +0530, Amit Shah wrote:
> On (Wed) 09 Jul 2014 [12:07:25], Jason Cooper wrote:
> > Amit, Kees,
> 
> (snip)
> 
> > I'm cooling to the idea of the init function for virtio-rng, and it
> > might be best just to admit that there's no way to seed the entropy pool
> > from the virtio-rng at probe time.  After all, once userspace is up, the
> > system should take advantage of /dev/hwrng for the generation of
> > long-term keys.  Either via rngd feeding /dev/random, or directly.
> > 
> > As for the follow-on patch you asked about, I think that's fine.  More
> > entropy can't hurt.
> > 
> > The below patch might be worth considering so that the user of a system
> > with only virtio-rng can kick the entropy pool as they see fit.  It's
> > probably not too kosher as is, but if the idea is liked, I could clean
> > it up and submit.
> > 
> > The advantage is that users don't need to have rngd installed and
> > running on the system in order to jump-start the entropy pool.
> 
> ... so a udev rule that looks for the new sysfs file, and asks the
> kernel to do its thing?

Or, as simple as:

[ -e /sys/.../rng_seed_kernel ] && echo "0" >/sys/.../rng_seed_kernel

in the initrd.  It needs to run *before* any init scripts which may create
keys.

> And maybe even a patch to rngd that looks for this file and does a
> similar thing?

I'm not opposed to that, but it doesn't fit the problem I'm trying to
solve.  Basically, average systems, not trying to be Ft Knox-secure, but
needing to generate long-term keys at first boot.  These systems won't
have an hwrng installed, but should use one if available.  eg
virtio-rng, or any of the on-die SoC hwrngs.

> There's also the option to use a delayed workqueue item, that will
> succeed if probe has finished.  This method doesn't have userspace
> dependencies.

Hmm, I like that idea better.  No ABI change to maintain, no userspace
changes...  You obviously know virtio-rng better than I do, care to take
a crack at it?

thx,

Jason.
