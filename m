Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbbAHWb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:31:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757367AbbAHWbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:31:55 -0500
Date: Thu, 8 Jan 2015 20:31:33 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>
Subject: Re: [RFC 2/2] x86, vdso, pvclock: Simplify and speed up the vdso
 pvclock reader
Message-ID: <20150108223132.GA5861@amt.cnet>
References: <20150105191756.GA31201@amt.cnet>
 <CALCETrVWmbcv1w5a3N1VzyWEobP0qW+RQkhWO9yOkxzdKdJgeg@mail.gmail.com>
 <20150105224858.GA6846@amt.cnet>
 <54AB9FFD.6070309@redhat.com>
 <54ABCE85.6070004@redhat.com>
 <CALCETrWKgB7nj19zW_cQaa4RWjDojbN92_3+-27bHXbB-EEOnA@mail.gmail.com>
 <20150106181331.GA24590@amt.cnet>
 <CALCETrXzJkxbUsVgPbKNpBdp32yf=0M=RfseX=u7Mg2Mmsz2VQ@mail.gmail.com>
 <20150106184512.GA31263@amt.cnet>
 <CALCETrVTVESPYCsoj719Y9UJMkkcJBV0mrA3TtLVjs2DYmYoVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVTVESPYCsoj719Y9UJMkkcJBV0mrA3TtLVjs2DYmYoVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 11:49:09AM -0800, Andy Lutomirski wrote:
> On Tue, Jan 6, 2015 at 10:45 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > On Tue, Jan 06, 2015 at 10:26:22AM -0800, Andy Lutomirski wrote:
> >> On Tue, Jan 6, 2015 at 10:13 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >> > On Tue, Jan 06, 2015 at 08:56:40AM -0800, Andy Lutomirski wrote:
> >> >> On Jan 6, 2015 4:01 AM, "Paolo Bonzini" <pbonzini@redhat.com> wrote:
> >> >> >
> >> >> >
> >> >> >
> >> >> > On 06/01/2015 09:42, Paolo Bonzini wrote:
> >> >> > > > > Still confused.  So we can freeze all vCPUs in the host, then update
> >> >> > > > > pvti 1, then resume vCPU 1, then update pvti 0?  In that case, we have
> >> >> > > > > a problem, because vCPU 1 can observe pvti 0 mid-update, and KVM
> >> >> > > > > doesn't increment the version pre-update, and we can return completely
> >> >> > > > > bogus results.
> >> >> > > > Yes.
> >> >> > > But then the getcpu test would fail (1->0).  Even if you have an ABA
> >> >> > > situation (1->0->1), it's okay because the pvti that is fetched is the
> >> >> > > one returned by the first getcpu.
> >> >> >
> >> >> > ... this case of partial update of pvti, which is caught by the version
> >> >> > field, if of course different from the other (extremely unlikely) that
> >> >> > Andy pointed out.  That is when the getcpus are done on the same vCPU,
> >> >> > but the rdtsc is another.
> >> >> >
> >> >> > That one can be fixed by rdtscp, like
> >> >> >
> >> >> > do {
> >> >> >     // get a consistent (pvti, v, tsc) tuple
> >> >> >     do {
> >> >> >         cpu = get_cpu();
> >> >> >         pvti = get_pvti(cpu);
> >> >> >         v = pvti->version & ~1;
> >> >> >         // also acts as rmb();
> >> >> >         rdtsc_barrier();
> >> >> >         tsc = rdtscp(&cpu1);
> >> >>
> >> >> Off-topic note: rdtscp doesn't need a barrier at all.  AIUI AMD
> >> >> specified it that way and both AMD and Intel implement it correctly.
> >> >> (rdtsc, on the other hand, definitely needs the barrier beforehand.)
> >> >>
> >> >> >         // control dependency, no need for rdtsc_barrier?
> >> >> >     } while(cpu != cpu1);
> >> >> >
> >> >> >     // ... compute nanoseconds from pvti and tsc ...
> >> >> >     rmb();
> >> >> > }   while(v != pvti->version);
> >> >>
> >> >> Still no good.  We can migrate a bunch of times so we see the same CPU
> >> >> all three times and *still* don't get a consistent read, unless we
> >> >> play nasty games with lots of version checks (I have a patch for that,
> >> >> but I don't like it very much).  The patch is here:
> >> >>
> >> >> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vdso_paranoia&id=a69754dc5ff33f5187162b5338854ad23dd7be8d
> >> >>
> >> >> but I don't like it.
> >> >>
> >> >> Thus far, I've been told unambiguously that a guest can't observe pvti
> >> >> while it's being written, and I think you're now telling me that this
> >> >> isn't true and that a guest *can* observe pvti while it's being
> >> >> written while the low bit of the version field is not set.  If so,
> >> >> this is rather strongly incompatible with the spec in the KVM docs.
> >> >>
> >> >> I don't suppose that you and Marcelo could agree on what the actual
> >> >> semantics that KVM provides are and could write it down in a way that
> >> >> people who haven't spent a long time staring at the request code
> >> >> understand?  And maybe you could even fix the implementation while
> >> >> you're at it if the implementation is, indeed, broken.  I have ugly
> >> >> patches to fix it here:
> >> >>
> >> >> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vdso_paranoia&id=3b718a050cba52563d831febc2e1ca184c02bac0
> >> >>
> >> >> but I'm not thrilled with them.
> >> >>
> >> >> --Andy
> >> >
> >> > I suppose that separating the version write from the rest of the pvclock
> >> > structure is sufficient, as that would guarantee the writes are not
> >> > reordered even with fast string REP MOVS.
> >> >
> >> > Thanks for catching this Andy!
> >> >
> >>
> >> Don't you stil need:
> >>
> >> version++;
> >> write the rest;
> >> version++;
> >>
> >> with possible smp_wmb() in there to keep the compiler from messing around?
> >
> > Correct. Could just as well follow the protocol and use odd/even, which
> > is what your patch does.
> >
> > What is the point with the new flags bit though?
> 
> To try to work around the problem on old hosts.  I'm not at all
> convinced that this is worthwhile or that it helps, though.

Andy, 

Are you going to submit the fix or should i? 

