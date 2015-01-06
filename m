Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbbAFTtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:49:41 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:55921 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932943AbbAFTtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:49:31 -0500
MIME-Version: 1.0
In-Reply-To: <20150106184512.GA31263@amt.cnet>
References: <20150105152511.GA9172@amt.cnet> <CALCETrXRs4NmhMvp+7kydrfyGCiNymkTe_sP6HFVvhMCC2Ei0Q@mail.gmail.com>
 <20150105191756.GA31201@amt.cnet> <CALCETrVWmbcv1w5a3N1VzyWEobP0qW+RQkhWO9yOkxzdKdJgeg@mail.gmail.com>
 <20150105224858.GA6846@amt.cnet> <54AB9FFD.6070309@redhat.com>
 <54ABCE85.6070004@redhat.com> <CALCETrWKgB7nj19zW_cQaa4RWjDojbN92_3+-27bHXbB-EEOnA@mail.gmail.com>
 <20150106181331.GA24590@amt.cnet> <CALCETrXzJkxbUsVgPbKNpBdp32yf=0M=RfseX=u7Mg2Mmsz2VQ@mail.gmail.com>
 <20150106184512.GA31263@amt.cnet>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 6 Jan 2015 11:49:09 -0800
Message-ID: <CALCETrVTVESPYCsoj719Y9UJMkkcJBV0mrA3TtLVjs2DYmYoVw@mail.gmail.com>
Subject: Re: [RFC 2/2] x86, vdso, pvclock: Simplify and speed up the vdso
 pvclock reader
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 10:45 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Tue, Jan 06, 2015 at 10:26:22AM -0800, Andy Lutomirski wrote:
>> On Tue, Jan 6, 2015 at 10:13 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>> > On Tue, Jan 06, 2015 at 08:56:40AM -0800, Andy Lutomirski wrote:
>> >> On Jan 6, 2015 4:01 AM, "Paolo Bonzini" <pbonzini@redhat.com> wrote:
>> >> >
>> >> >
>> >> >
>> >> > On 06/01/2015 09:42, Paolo Bonzini wrote:
>> >> > > > > Still confused.  So we can freeze all vCPUs in the host, then update
>> >> > > > > pvti 1, then resume vCPU 1, then update pvti 0?  In that case, we have
>> >> > > > > a problem, because vCPU 1 can observe pvti 0 mid-update, and KVM
>> >> > > > > doesn't increment the version pre-update, and we can return completely
>> >> > > > > bogus results.
>> >> > > > Yes.
>> >> > > But then the getcpu test would fail (1->0).  Even if you have an ABA
>> >> > > situation (1->0->1), it's okay because the pvti that is fetched is the
>> >> > > one returned by the first getcpu.
>> >> >
>> >> > ... this case of partial update of pvti, which is caught by the version
>> >> > field, if of course different from the other (extremely unlikely) that
>> >> > Andy pointed out.  That is when the getcpus are done on the same vCPU,
>> >> > but the rdtsc is another.
>> >> >
>> >> > That one can be fixed by rdtscp, like
>> >> >
>> >> > do {
>> >> >     // get a consistent (pvti, v, tsc) tuple
>> >> >     do {
>> >> >         cpu = get_cpu();
>> >> >         pvti = get_pvti(cpu);
>> >> >         v = pvti->version & ~1;
>> >> >         // also acts as rmb();
>> >> >         rdtsc_barrier();
>> >> >         tsc = rdtscp(&cpu1);
>> >>
>> >> Off-topic note: rdtscp doesn't need a barrier at all.  AIUI AMD
>> >> specified it that way and both AMD and Intel implement it correctly.
>> >> (rdtsc, on the other hand, definitely needs the barrier beforehand.)
>> >>
>> >> >         // control dependency, no need for rdtsc_barrier?
>> >> >     } while(cpu != cpu1);
>> >> >
>> >> >     // ... compute nanoseconds from pvti and tsc ...
>> >> >     rmb();
>> >> > }   while(v != pvti->version);
>> >>
>> >> Still no good.  We can migrate a bunch of times so we see the same CPU
>> >> all three times and *still* don't get a consistent read, unless we
>> >> play nasty games with lots of version checks (I have a patch for that,
>> >> but I don't like it very much).  The patch is here:
>> >>
>> >> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vdso_paranoia&id=a69754dc5ff33f5187162b5338854ad23dd7be8d
>> >>
>> >> but I don't like it.
>> >>
>> >> Thus far, I've been told unambiguously that a guest can't observe pvti
>> >> while it's being written, and I think you're now telling me that this
>> >> isn't true and that a guest *can* observe pvti while it's being
>> >> written while the low bit of the version field is not set.  If so,
>> >> this is rather strongly incompatible with the spec in the KVM docs.
>> >>
>> >> I don't suppose that you and Marcelo could agree on what the actual
>> >> semantics that KVM provides are and could write it down in a way that
>> >> people who haven't spent a long time staring at the request code
>> >> understand?  And maybe you could even fix the implementation while
>> >> you're at it if the implementation is, indeed, broken.  I have ugly
>> >> patches to fix it here:
>> >>
>> >> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vdso_paranoia&id=3b718a050cba52563d831febc2e1ca184c02bac0
>> >>
>> >> but I'm not thrilled with them.
>> >>
>> >> --Andy
>> >
>> > I suppose that separating the version write from the rest of the pvclock
>> > structure is sufficient, as that would guarantee the writes are not
>> > reordered even with fast string REP MOVS.
>> >
>> > Thanks for catching this Andy!
>> >
>>
>> Don't you stil need:
>>
>> version++;
>> write the rest;
>> version++;
>>
>> with possible smp_wmb() in there to keep the compiler from messing around?
>
> Correct. Could just as well follow the protocol and use odd/even, which
> is what your patch does.
>
> What is the point with the new flags bit though?

To try to work around the problem on old hosts.  I'm not at all
convinced that this is worthwhile or that it helps, though.

>
>> Also, if you do this, can you also make setting and clearing
>> STABLE_BIT properly atomic across all vCPUs?  Or at least do something
>> like setting it last and clearing it first on vPCU 0?
>
> If the version "seqlock" works properly across vCPUs, why do you need
> STABLE_BIT "properly atomic" ?
>
> Please define what you mean by "properly atomic".
>

I'd like to be able to rely using vCPU 0's pvti even from other vCPUs
in the vdso if the stable bit is set.  That means that the host should
avoid doing things like migrating the guest, clearing the stable bit
for vCPU 1, resuming vCPU 1, and waiting long enough to clear the
stable bit for vCPU 0 that vCPU 1's vdso code could see invalid data
and return a bad timestamp.

Maybe this scenario is impossible, but getting rid of any getcpu-like
operation in the vdso has really nice benefits.  It's faster and it
lets us guarantee that the vdso's pvti data fits in a single page.
The latter means that we can easily make it work like the hpet
mapping, which gets us 32-bit support and will *finally* let us turn
off user access to the fixmap if vsyscall=none.

(We can, of course, still do this if the pvti data needs to be an
array, but it's messier.)

--Andy
