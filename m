Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab3EBIjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:39:08 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:51742 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3EBIjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:39:00 -0400
Date: Thu, 2 May 2013 10:38:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Basic perf PMU support for Haswell v11
Message-ID: <20130502083856.GA27380@gmail.com>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
 <20130426065503.GA31197@gmail.com>
 <20130426225235.GI16732@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426225235.GI16732@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ FYI, we are still in the merge window when maintainers are very busy, so
  don't expect quick replies to mails that are not about merge window
  related patches and commits. Those issues are typically handled after
  -rc1 has been released, once most of the merge fallout in the upstream
  kernel has been resolved. ]

* Andi Kleen <andi@firstfloor.org> wrote:

> > How well was this 
> > patch-set tested on non-Haswell hardware, which makes up 99.99% of our 
> > installed base?
> 
> I tested on a couple systems now and then: usually Haswell, IvyBridge,
> sometimes also Westmere and Atom. I don't retest every iteration,
> as you know most of the changes you're requesting don't affect
> the binary.
> 
> My test bed is likely to be smaller than yours though and as usual
> as you well know some part of the kernel QA is after release.
> 
> > 
> > In particular, after applying your patches, 'perf top' stopped working on 
> > an Intel testbox of mine:
> > 
> >   processor       : 15
> >   vendor_id       : GenuineIntel
> >   cpu family      : 6
> >   model           : 26
> >   model name      : Intel(R) Xeon(R) CPU           X55600 @ 2.80GHz
> 
> I assume the second 0 is a typo?

Probably a typo in the BIOS.

> >   stepping        : 5
> 
> > 'perf top' just does not produce any profiling output - it says 0 events.
> 
> Thanks for testing.
> 
> I found a similar system (not same stepping, but same model) and tested
> perf top works fine here. Also on a couple of other systems.
> 
> Since I cannot reproduce I would need your help debugging it.
> 
> I assume it worked before my patches.

Yes, obviously.

Here's another easy to test symptom of the bug:

 $ perf record ./hackbench 10
 Time: 0.097
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.043 MB perf.data (~1866 samples) ]

 $ perf report --stdio
 Error:
 The perf.data file has no samples!

Expected result is a profile displayed by 'perf report'.

> [...]  If you don't know please double check. Also I assume there's no 
> general problem between the user land perf you used and the kernel.
> 
> The only patch I could think of which may affect other systems
> is the moving of the APIC ack.

Btw., I warned you about the delicate placement of the APIC ACK in my 
Haswell patches review feedback mail, months ago:

  https://lkml.org/lkml/2013/2/13/78

which mail you never replied to and which warning you apparently ignored. 

When modifying the PMU ack sequence, please find the relevant Intel SDM 
that recommends a different ACK sequence from what is implemented 
currently, and document this in the changelog.

I'm going to ignore your APIC ACK patch until you do it properly.

> So does it work if you revert 
> 
>  perf, x86: Move NMI clearing to end of PMI handler after ...
> 
> If that is it we could white list it for Haswell.

No, reverting that patch did not fix the bug.

I have bisected it down to this patch of yours:

   "perf/x86: Add Haswell PMU support"

Most of that patch has no effect on non-Haswell machines, so the scope of 
problematic changes should be pretty small.

My quick guess is that your patch broke fixed counters.

If you find the bug or want me to test anything please send a delta patch, 
relative to your last series - as I have parts of your patches applied 
already locally with cleanups, etc.

Thanks,

	Ingo
