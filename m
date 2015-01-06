Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbbAFUVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:21:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbbAFUVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:21:17 -0500
Date: Tue, 6 Jan 2015 18:20:54 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>
Subject: Re: [RFC 2/2] x86, vdso, pvclock: Simplify and speed up the vdso
 pvclock reader
Message-ID: <20150106202054.GA1564@amt.cnet>
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
> > What is the point with the new flags bit though?
> 
> To try to work around the problem on old hosts.  I'm not at all
> convinced that this is worthwhile or that it helps, though.

Don't think so. Just fix the host bug.

> >> Also, if you do this, can you also make setting and clearing
> >> STABLE_BIT properly atomic across all vCPUs?  Or at least do something
> >> like setting it last and clearing it first on vPCU 0?
> >
> > If the version "seqlock" works properly across vCPUs, why do you need
> > STABLE_BIT "properly atomic" ?
> >
> > Please define what you mean by "properly atomic".
> >
> 
> I'd like to be able to rely using vCPU 0's pvti even from other vCPUs
> in the vdso if the stable bit is set.  That means that the host should
> avoid doing things like migrating the guest, clearing the stable bit
> for vCPU 1, resuming vCPU 1, and waiting long enough to clear the
> stable bit for vCPU 0 that vCPU 1's vdso code could see invalid data
> and return a bad timestamp.
> 
> Maybe this scenario is impossible, but getting rid of any getcpu-like
> operation in the vdso has really nice benefits. 

You can park every vCPU in host while updating vCPU-0's timestamp.

See kvm_gen_update_masterclock:

+	/* no guest entries from this point */
+	pvclock_update_vm_gtod_copy(kvm);

	- touch guest memory

+	/* guest entries allowed */
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		clear_bit(KVM_REQ_MCLOCK_INPROGRESS, &vcpu->requests);

>  It's faster and it
> lets us guarantee that the vdso's pvti data fits in a single page.
> The latter means that we can easily make it work like the hpet
> mapping, which gets us 32-bit support and will *finally* let us turn
> off user access to the fixmap if vsyscall=none.
> 
> (We can, of course, still do this if the pvti data needs to be an
> array, but it's messier.)
> 
> --Andy
