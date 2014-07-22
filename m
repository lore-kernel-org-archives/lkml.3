Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaGVND6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:03:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:60250 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaGVND5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:03:57 -0400
Date: Tue, 22 Jul 2014 15:03:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Bruno Wolff III <bruno@wolff.to>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140722130343.GD3935@laptop>
References: <20140718101633.GP9918@twins.programming.kicks-ass.net>
 <20140718130126.GA2401@wolff.to>
 <20140718141648.GE20603@laptop.programming.kicks-ass.net>
 <20140718145040.GG12054@laptop.lan>
 <20140718161602.GH12054@laptop.lan>
 <20140721163528.GA10433@wolff.to>
 <20140721165212.GO3935@laptop>
 <20140722094740.GJ12054@laptop.lan>
 <20140722103857.GK12054@laptop.lan>
 <20140722121001.GA30631@wolff.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722121001.GA30631@wolff.to>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 07:10:01AM -0500, Bruno Wolff III wrote:
> On Tue, Jul 22, 2014 at 12:38:57 +0200,
>  Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >Could you provide the output of cpuid and cpuid -r for your machine?
> >This code is magic and I've no idea what your machine is telling it to
> >do :/
> 
> I am attaching both sets of output. (I also added copies to the bug report.)

Thanks! and yes I now see (and I should have seen before) what is
'broken'.

>    0x00000000 0x00: eax=0x00000002 ebx=0x756e6547 ecx=0x6c65746e edx=0x49656e69

This gives us cpuid_level=0x02

>    0x00000002 0x00: eax=0x665b5001 ebx=0x00000000 ecx=0x00000000 edx=0x007b7040

Which means that init_intel_cacheinfo() will not use cpuid4 for
cacheinfo and we revert to cpuid2, which translates into:

>    cache and TLB information (2):
>       0x50: instruction TLB: 4K & 2M/4M pages, 64 entries
>       0x5b: data TLB: 4K & 4M pages, 64 entries
>       0x66: L1 data cache: 8K, 4-way, 64 byte lines
>       0x40: No L3 cache
>       0x70: Trace cache: 12K-uop, 8-way
>       0x7b: L2 cache: 512K, 8-way, sectored, 64 byte lines

Now the problem is that cpu_llc_id is only set on new_l[23], and set to
l[23]_id. Both new_l[23] and l[23]_id are only set in the cpuid4 case.

So for this P4 cpu_llc_id remains unset.

Furthermore cpuid2 does not include cpu masks, so we need to use cpuid1:

>    (multi-processing method): Intel leaf 1

>   0x00000001 0x00: eax=0x00000f29 ebx=0x0002080b ecx=0x00004400 edx=0xbfebfbff

to reconstruct the topology, with the added assumption that SMT threads
share all caches.

Oh, of course we do SMP detection and setup after the cache setup...
lovely.

/me goes bang head against wall

