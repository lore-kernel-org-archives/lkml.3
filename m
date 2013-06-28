Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab3F1Uhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:37:45 -0400
Received: from relay3.sgi.com ([192.48.152.1]:53730 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751017Ab3F1Uhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:37:43 -0400
Message-ID: <51CDF417.3050406@sgi.com>
Date: Fri, 28 Jun 2013 15:37:43 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel J Blueman <daniel@numascale-asia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <holt@sgi.com>, <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        <x86@kernel.org>, <linux-doc@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [RFC] Transparent on-demand memory setup initialization embedded
 in the (GFP) buddy allocator
References: <51CBB2F7.3050604@numascale-asia.com>
In-Reply-To: <51CBB2F7.3050604@numascale-asia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.140]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 10:35 PM, Daniel J Blueman wrote:
> On Wednesday, June 26, 2013 9:30:02 PM UTC+8, Andrew Morton wrote:
> >
> > On Wed, 26 Jun 2013 11:22:48 +0200 Ingo Molnar <mi...@kernel.org> 
> wrote:
> >
> > > except that on 32 TB
> > > systems we don't spend ~2 hours initializing 8,589,934,592 page 
> heads.
> >
> > That's about a million a second which is crazy slow - even my 
> prehistoric desktop
> > is 100x faster than that.
> >
> > Where's all this time actually being spent?
>
> The complexity of a directory-lookup architecture to make the 
> (intrinsically unscalable) cache-coherency protocol scalable gives you 
> a ~1us roundtrip to remote NUMA nodes.
>
> Probably a lot of time is spent in some memsets, and RMW cycles which 
> are setting page bits, which are intrinsically synchronous, so the 
> initialising core can't get to 12 or so outstanding memory transactions.
>
> Since EFI memory ranges have a flag to state if they are zerod (which 
> may be a fair assumption for memory on non-bootstrap processor NUMA 
> nodes), we can probably collapse the RMWs to just writes.
>
> A normal write will require a coherency cycle, then a fetch and a 
> writeback when it's evicted from the cache. For this purpose, 
> non-temporal writes would eliminate the cache line fetch and give a 
> massive increase in bandwidth. We wouldn't even need a store-fence as 
> the initialising core is the only one online.
>
> Daniel

Could you elaborate a bit more? or suggest a specific area to look at?

After some experiments with trying to just set some fields in the struct 
page directly I haven't been able to produce any improvements.  Of 
course there is lots about the area which I don't have much experience with.

Nate

