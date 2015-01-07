Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbbAGOp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:45:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbbAGOp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:45:27 -0500
Date: Wed, 7 Jan 2015 12:45:03 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>
Subject: Re: [RFC 2/2] x86, vdso, pvclock: Simplify and speed up the vdso
 pvclock reader
Message-ID: <20150107144503.GA16114@amt.cnet>
References: <20150105152511.GA9172@amt.cnet>
 <CALCETrXRs4NmhMvp+7kydrfyGCiNymkTe_sP6HFVvhMCC2Ei0Q@mail.gmail.com>
 <20150105191756.GA31201@amt.cnet>
 <CALCETrVWmbcv1w5a3N1VzyWEobP0qW+RQkhWO9yOkxzdKdJgeg@mail.gmail.com>
 <20150105224858.GA6846@amt.cnet>
 <54AB9FFD.6070309@redhat.com>
 <54ABCE85.6070004@redhat.com>
 <CALCETrWKgB7nj19zW_cQaa4RWjDojbN92_3+-27bHXbB-EEOnA@mail.gmail.com>
 <54ACC64F.6030304@redhat.com>
 <CALCETrXGGV9R_4Knz_0LTaz3X2PS1KJDdBfq_RHAVquKdUjrYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXGGV9R_4Knz_0LTaz3X2PS1KJDdBfq_RHAVquKdUjrYQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 11:18:21PM -0800, Andy Lutomirski wrote:
> On Tue, Jan 6, 2015 at 9:38 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> >
> > On 06/01/2015 17:56, Andy Lutomirski wrote:
> >> Still no good.  We can migrate a bunch of times so we see the same CPU
> >> all three times
> >
> > There are no three times.  The CPU you see here:
> >
> >>>
> >>>
> >>>     // ... compute nanoseconds from pvti and tsc ...
> >>>     rmb();
> >>> }   while(v != pvti->version);
> >
> > is the same you read here:
> >
> >>>         cpu = get_cpu();
> >
> > The algorithm is:
> 
> I still don't see why this is safe, and I think that the issue is that
> you left out part of the loop.
> 
> >
> > 1) get a consistent (cpu, version, tsc)
> >
> >    1.a) get cpu
> 
> Suppose we observe cpu 0.
> 
> >    1.b) get pvti[cpu]->version, ignoring low bit
> 
> Missing step, presumably here: read pvti[cpu]->tsc_timestamp, scale,
> etc.  This could all execute on vCPU 1.  We could read values that are
> inconsistent with each other.
> 
> >    1.c) get (tsc, cpu)
> 
> Now we could end up back on vCPU 0.
> 
> >    1.d) if cpu from 1.a and 1.c do not match, loop
> >    1.e) if pvti[cpu] was being updated, we'll loop later
> >
> > 2) compute nanoseconds from pvti[cpu] and tsc
> >
> > 3) if pvti[cpu] changed under our feet during (2), i.e. version doesn't
> > match, retry.
> >
> > As long as the CPU is consistent between get_cpu() and rdtscp(), there
> > is no problem with migration, because pvti is always accessed for that
> > one CPU.  If there were any problem, it would be caught by the version
> > check.  Writing it down with two nested do...whiles makes it clearer IMHO.
> 
> Why exactly would it be caught by the version check?
> 
> My ugly patch tries to make the argument that, at any point at which
> we observe ourselves to be on a given vCPU, that vCPU won't be
> updating pvti.  That means that, if version doesn't change between two
> consecutive observations that we're on that vCPU, then we're okay.
> This IMO sucks.  It's fragile, it's hard to make a coherent argument
> about correctness, and it requires at least two getcpu-like operations
> to read the time.  Those operations are *slow*.  One is much better
> than two, and zero is much better than one.
> 
> >
> >> and *still* don't get a consistent read, unless we
> >> play nasty games with lots of version checks (I have a patch for that,
> >> but I don't like it very much).  The patch is here:
> >>
> >> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vdso_paranoia&id=a69754dc5ff33f5187162b5338854ad23dd7be8d
> >>
> >> but I don't like it.
> >>
> >> Thus far, I've been told unambiguously that a guest can't observe pvti
> >> while it's being written, and I think you're now telling me that this
> >> isn't true and that a guest *can* observe pvti while it's being
> >> written while the low bit of the version field is not set.  If so,
> >> this is rather strongly incompatible with the spec in the KVM docs.
> >
> > Where am I saying that?
> 
> I thought the conclusion from what you and Marcelo pointed out about
> the code was that, once the first vCPU updated its pvti, it could
> start running guest code while the other vCPUs are still updating
> pvti, so its guest code can observe the other vCPUs mid-update.
> 
> >> Also, if you do this, can you also make setting and clearing
> >> STABLE_BIT properly atomic across all vCPUs?  Or at least do something
> >> like setting it last and clearing it first on vPCU 0?
> >
> > That would be nice if you want to make the pvclock area fit in a single
> > page.  However, it would have to be a separate flag bit, or a separate
> > CPUID feature.
> 
> It would be nice to have.  Although I think that fixing the host to
> increment version pre-update and post-update may actually be good
> enough.  Is there any case in which it would fail in practice if we
> made that fix and always looked at pvti 0?

TSC_STABLE_BIT -> ~TSC_STABLE_BIT transition steps would finish but 
still allow VCPU-1 to use stale values from VCPU-0.

To fix, do one of the following:

1) Check validity of local TSC_STABLE_BIT in addition (slow).
2) Perform update of VCPU-0 pvclock area before allowing
any other VCPU to VM-entry.



> 
> --Andy
> 
> >
> > Paolo
> 
> 
> 
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC
