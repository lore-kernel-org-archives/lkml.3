Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763348Ab3DDQkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:40:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762791Ab3DDQkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:40:35 -0400
Date: Thu, 4 Apr 2013 19:39:33 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alexander Graf <agraf@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Christoffer Dall <c.dall@virtualopensystems.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC] kvm: add PV MMIO EVENTFD
Message-ID: <20130404163933.GF27672@redhat.com>
References: <959E147D-EB7B-4F4B-9F84-4F1BBA98DEF8@suse.de>
 <20130404123806.GG17919@redhat.com>
 <EF153515-9835-4FB9-B6BC-73D0BDC86492@suse.de>
 <20130404124501.GH17919@redhat.com>
 <1B68D701-103D-4B1A-8F5E-3916753699CB@suse.de>
 <20130404125649.GI17919@redhat.com>
 <8E65D34D-2DA7-4C2E-9C3E-BE3A7DBC3279@suse.de>
 <20130404133318.GI6467@redhat.com>
 <14B443D5-5785-487D-9EA3-0AD20141BC06@suse.de>
 <20130404153629.GN6467@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130404153629.GN6467@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 06:36:30PM +0300, Michael S. Tsirkin wrote:
> > processor	: 0
> > vendor_id	: AuthenticAMD
> > cpu family	: 16
> > model		: 8
> > model name	: Six-Core AMD Opteron(tm) Processor 8435
> > stepping	: 0
> > cpu MHz		: 800.000
> > cache size	: 512 KB
> > physical id	: 0
> > siblings	: 6
> > core id		: 0
> > cpu cores	: 6
> > apicid		: 8
> > initial apicid	: 0
> > fpu		: yes
> > fpu_exception	: yes
> > cpuid level	: 5
> > wp		: yes
> > flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt npt lbrv svm_lock nrip_save pausefilter
> > bogomips	: 5199.87
> > TLB size	: 1024 4K pages
> > clflush size	: 64
> > cache_alignment	: 64
> > address sizes	: 48 bits physical, 48 bits virtual
> > power management: ts ttp tm stc 100mhzsteps hwpstate
> 
> Hmm, svm code seems less optimized for MMIO, but PIO
> is almost identical. Gleb says the unittest is broken
> on AMD so I'll wait until it's fixed to test.
> 
It's not unittest is broken, its my environment is broken :)

> Did you do PIO reads by chance?
> 
> > > 
> > > Or could be different software, this is on top of 3.9.0-rc5, what
> > > did you try?
> > 
> > 3.0 plus kvm-kmod of whatever was current back in autumn :).
> > 
> > > 
> > >> MST, could you please do a real world latency benchmark with virtio-net and
> > >> 
> > >>  * normal ioeventfd
> > >>  * mmio-pv eventfd
> > >>  * hcall eventfd
> > > 
> > > I can't do this right away, sorry.  For MMIO we are discussing the new
> > > layout on the virtio mailing list, guest and qemu need a patch for this
> > > too.  My hcall patches are stale and would have to be brought up to
> > > date.
> > > 
> > > 
> > >> to give us some idea how much performance we would gain from each approach? Thoughput should be completely unaffected anyway, since virtio just coalesces kicks internally.
> > > 
> > > Latency is dominated by the scheduling latency.
> > > This means virtio-net is not the best benchmark.
> > 
> > So what is a good benchmark?
> 
> E.g. ping pong stress will do but need to look at CPU utilization,
> that's what is affected, not latency.
> 
> > Is there any difference in speed at all? I strongly doubt it. One of virtio's main points is to reduce the number of kicks.
> 
> For this stage of the project I think microbenchmarks are more appropriate.
> Doubling the price of exit is likely to be measureable. 30 cycles likely
> not ...
> 
> > > 
> > >> I'm also slightly puzzled why the wildcard eventfd mechanism is so significantly slower, while it was only a few percent on my test system. What are the numbers you're listing above? Cycles? How many cycles do you execute in a second?
> > >> 
> > >> 
> > >> Alex
> > > 
> > > 
> > > It's the TSC divided by number of iterations.  kvm unittest this value, here's
> > > what it does (removed some dead code):
> > > 
> > > #define GOAL (1ull << 30)
> > > 
> > >        do {
> > >                iterations *= 2;
> > >                t1 = rdtsc();
> > > 
> > >                        for (i = 0; i < iterations; ++i)
> > >                                func();
> > >                t2 = rdtsc();
> > >        } while ((t2 - t1) < GOAL);
> > >        printf("%s %d\n", test->name, (int)((t2 - t1) / iterations));
> > 
> > So it's the number of cycles per run.
> > 
> > That means translated my numbers are:
> > 
> >   MMIO: 4307
> >   PIO: 3658
> >   HCALL: 1756
> > 
> > MMIO - PIO = 649
> > 
> > which aligns roughly with your PV MMIO callback.
> > 
> > My MMIO benchmark was to poke the LAPIC version register. That does go through instruction emulation, no?
> > 
> > 
> > Alex
> 
> Why wouldn't it?
> 
Intel decodes access to apic page, but we use it only for fast eoi.

--
			Gleb.
