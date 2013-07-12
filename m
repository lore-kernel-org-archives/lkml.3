Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab3GLI2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:28:07 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:52564 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284Ab3GLI2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:28:01 -0400
Date: Fri, 12 Jul 2013 10:27:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robin Holt <holt@sgi.com>, Borislav Petkov <bp@alien8.de>,
        Robert Richter <rric@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Nate Zimmer <nzimmer@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Rob Landley <rob@landley.net>,
        Mike Travis <travis@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 0/4] Transparent on-demand struct page initialization
 embedded in the buddy allocator
Message-ID: <20130712082756.GA4328@gmail.com>
References: <1373594635-131067-1-git-send-email-holt@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373594635-131067-1-git-send-email-holt@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> [...]
> 
> With this patch, we did boot a 16TiB machine.  Without the patches, the 
> v3.10 kernel with the same configuration took 407 seconds for 
> free_all_bootmem.  With the patches and operating on 2MiB pages instead 
> of 1GiB, it took 26 seconds so performance was improved.  I have no feel 
> for how the 1GiB chunk size will perform.

That's pretty impressive.

It's still a 15x speedup instead of a 512x speedup, so I'd say there's 
something else being the current bottleneck, besides page init 
granularity.

Can you boot with just a few gigs of RAM and stuff the rest into hotplug 
memory, and then hot-add that memory? That would allow easy profiling of 
remaining overhead.

Side note:

Robert Richter and Boris Petkov are working on 'persistent events' support 
for perf, which will eventually allow boot time profiling - I'm not sure 
if the patches and the tooling support is ready enough yet for your 
purposes.

Robert, Boris, the following workflow would be pretty intuitive:

 - kernel developer sets boot flag: perf=boot,freq=1khz,size=16MB

 - we'd get a single (cycles?) event running once the perf subsystem is up
   and running, with a sampling frequency of 1 KHz, sending profiling
   trace events to a sufficiently sized profiling buffer of 16 MB per
   CPU.

 - once the system reaches SYSTEM_RUNNING, profiling is stopped either
   automatically - or the user stops it via a new tooling command.

 - the profiling buffer is extracted into a regular perf.data via a
   special 'perf record' call or some other, new perf tooling 
   solution/variant.

   [ Alternatively the kernel could attempt to construct a 'virtual'
     perf.data from the persistent buffer, available via /sys/debug or
     elsewhere in /sys - just like the kernel constructs a 'virtual' 
     /proc/kcore, etc. That file could be copied or used directly. ]

 - from that point on this workflow joins the regular profiling workflow: 
   perf report, perf script et al can be used to analyze the resulting
   boot profile.

Thanks,

	Ingo
