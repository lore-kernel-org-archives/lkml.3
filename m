Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbbAFVyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:54:32 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:63159 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603AbbAFVya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:54:30 -0500
MIME-Version: 1.0
In-Reply-To: <20150106202054.GA1564@amt.cnet>
References: <20150105191756.GA31201@amt.cnet> <CALCETrVWmbcv1w5a3N1VzyWEobP0qW+RQkhWO9yOkxzdKdJgeg@mail.gmail.com>
 <20150105224858.GA6846@amt.cnet> <54AB9FFD.6070309@redhat.com>
 <54ABCE85.6070004@redhat.com> <CALCETrWKgB7nj19zW_cQaa4RWjDojbN92_3+-27bHXbB-EEOnA@mail.gmail.com>
 <20150106181331.GA24590@amt.cnet> <CALCETrXzJkxbUsVgPbKNpBdp32yf=0M=RfseX=u7Mg2Mmsz2VQ@mail.gmail.com>
 <20150106184512.GA31263@amt.cnet> <CALCETrVTVESPYCsoj719Y9UJMkkcJBV0mrA3TtLVjs2DYmYoVw@mail.gmail.com>
 <20150106202054.GA1564@amt.cnet>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 6 Jan 2015 13:54:08 -0800
Message-ID: <CALCETrU2SOOE=UQzqWJFHk5ya0e0drEgk0bPQHLtFd3vD04Zrw@mail.gmail.com>
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

On Tue, Jan 6, 2015 at 12:20 PM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Tue, Jan 06, 2015 at 11:49:09AM -0800, Andy Lutomirski wrote:
>> > What is the point with the new flags bit though?
>>
>> To try to work around the problem on old hosts.  I'm not at all
>> convinced that this is worthwhile or that it helps, though.
>
> Don't think so. Just fix the host bug.
>
>> >> Also, if you do this, can you also make setting and clearing
>> >> STABLE_BIT properly atomic across all vCPUs?  Or at least do something
>> >> like setting it last and clearing it first on vPCU 0?
>> >
>> > If the version "seqlock" works properly across vCPUs, why do you need
>> > STABLE_BIT "properly atomic" ?
>> >
>> > Please define what you mean by "properly atomic".
>> >
>>
>> I'd like to be able to rely using vCPU 0's pvti even from other vCPUs
>> in the vdso if the stable bit is set.  That means that the host should
>> avoid doing things like migrating the guest, clearing the stable bit
>> for vCPU 1, resuming vCPU 1, and waiting long enough to clear the
>> stable bit for vCPU 0 that vCPU 1's vdso code could see invalid data
>> and return a bad timestamp.
>>
>> Maybe this scenario is impossible, but getting rid of any getcpu-like
>> operation in the vdso has really nice benefits.
>
> You can park every vCPU in host while updating vCPU-0's timestamp.
>
> See kvm_gen_update_masterclock:
>
> +       /* no guest entries from this point */
> +       pvclock_update_vm_gtod_copy(kvm);
>
>         - touch guest memory
>
> +       /* guest entries allowed */
> +       kvm_for_each_vcpu(i, vcpu, kvm)
> +               clear_bit(KVM_REQ_MCLOCK_INPROGRESS, &vcpu->requests);
>

Can we do that easily?  It looks like we're holding a spinlock in
there.  Could we make pvclock_gtod_sync_lock into a mutex?

We could also add something to explicitly prevent any of the guests
from entering until we're updated all of them, but that would hurt
performance even more.  It would be kind of nice if we could avoid
serializing all CPUs entirely, though.  For example, if we could
increment all the versions, then write all the pvtis, then increment
all the versions again from a single function, then everything is
atomic for a correctly behaving guest, but if the guest isn't actually
reading the time, then it doesn't stall.

(Also, we should really have a cpu_relax in all of these loops, IMO,
so that pause loop exiting can take effect.)

--Andy

>>  It's faster and it
>> lets us guarantee that the vdso's pvti data fits in a single page.
>> The latter means that we can easily make it work like the hpet
>> mapping, which gets us 32-bit support and will *finally* let us turn
>> off user access to the fixmap if vsyscall=none.
>>
>> (We can, of course, still do this if the pvti data needs to be an
>> array, but it's messier.)
>>
>> --Andy



-- 
Andy Lutomirski
AMA Capital Management, LLC
