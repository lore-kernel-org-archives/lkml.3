Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbaHHJH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:07:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbaHHJHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:07:54 -0400
Date: Fri, 8 Aug 2014 14:37:15 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: jgarzik@bitpay.com,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Amos Kong <akong@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: Re: [PATCH 1/2] rngd: add udev rule to source from hwrng if
 virtio-rng present
Message-ID: <20140808090715.GG14400@grmbl.mre>
References: <cover.1407416628.git.amit.shah@redhat.com>
 <dd2ddb8458e5ab5cffceb7fac2e3f71e9e2197f3.1407416628.git.amit.shah@redhat.com>
 <53E3D3FF.70707@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E3D3FF.70707@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) 07 Aug 2014 [12:31:11], H. Peter Anvin wrote:
> On 08/07/2014 06:08 AM, Amit Shah wrote:
> > On KVM guests where the virtio-rng device is available, and set as the
> > current rng, this udev rule will start rngd which will feed in the
> > host-provided entropy to /dev/random.
> > 
> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > ---
> >  90-virtio-rng.rules | 1 +
> >  1 file changed, 1 insertion(+)
> >  create mode 100644 90-virtio-rng.rules
> > 
> > diff --git a/90-virtio-rng.rules b/90-virtio-rng.rules
> > new file mode 100644
> > index 0000000..07f2f9c
> > --- /dev/null
> > +++ b/90-virtio-rng.rules
> > @@ -0,0 +1 @@
> > +KERNEL=="hw_random", ATTR{rng_current}=="virtio*", RUN+="/sbin/rngd -r /dev/hwrng"
> > 
> 
> I'm not sure this is really right.  rngd can receive input from a number
> of sources, and I suspect it would be better to rngd to be started much
> earlier and perhaps get sent a SIGHUP to reconfigure when a hw_random
> device appears ... not just the virtio one.

Right - yea.  Modern distros do start rngd by default (at least Fedora
and RHEL do), so this does make sense.

But as you note below, not all distros may start rngd...

> Currently rngd exits if there is no daemon.  There are a few ways to
> deal with that: one is to run rngd on changes and leave a pid file
> around; the rngd can try to signal the old rngd or launch itself;
> another option would be to have a different rngd for each source.

Currently the kernel can only have one rng_current, which is a pity.
So in the current case, rngd only needs one instance -- and it'll
always accept stuff from /dev/hwrng and it doesn't matter if the
rng_current is changed as long as there's some rng there.

>  To
> some degree the above is obsolete when we get khwrngd widely deployed,
> but that is a new-kernel-only kind of thing.

Right - I'm wondering if any such changes as propsed here are now
obsolted already by khwrngd?

Thanks,

		Amit
