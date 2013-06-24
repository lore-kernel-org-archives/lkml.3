Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab3FXTkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:40:07 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:42276 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab3FXTkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:40:04 -0400
Date: Mon, 24 Jun 2013 21:39:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, holt@sgi.com, travis@sgi.com,
        rob@landley.net, tglx@linutronix.de, mingo@redhat.com,
        yinghai@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 2/2] x86_64, mm: Reinsert the absent memory
Message-ID: <20130624193959.GB4065@gmail.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
 <1371831934-156971-3-git-send-email-nzimmer@sgi.com>
 <20130623092840.GB13445@gmail.com>
 <20130623093250.GA13776@gmail.com>
 <51C88400.7090907@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C88400.7090907@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 06/23/2013 02:32 AM, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@kernel.org> wrote:
> > 
> >> Yet another thing to consider would be to implement an initialization 
> >> speedup of 3 orders of magnitude: initialize on the large page (2MB) 
> >> grandularity and on-demand delay the initialization of the 4K granular 
> >> struct pages [but still allocating them] - which I suspect are a good 
> >> chunk of the overhead? That way we could initialize in 2MB steps and speed 
> >> up the 2 hours bootup of 32 TB of RAM to 14 seconds...
> >>
> >> [ The cost would be one more branch in the buddy allocator, to detect
> >>   not-yet-initialized 2 MB chunks as we encounter them. Acceptable I 
> >>   think. ]
> > 
> > One advantage of this scheme would be that we could use it on pretty much 
> > any box, it would provide instant boot time speedups everywhere [a couple 
> > of hundred msecs on a small 4GB box - significant I think] - and would 
> > spread out and parallelize initialization to later stages.
> 
> Even better if we could start at the 1 GB level, which most of these 
> really huge machines will have hardware support for.

That might be a bit too granular: if we hit such an uninitialized block of 
memory we'd have to process 262,144 pages - potentially from an IRQ 
handler that does GFP_ATOMIC... or other latency critical code.

With 2MB we'd have to on-demand initialize 512 pages, which shouldn't show 
up during normal use.

Thanks,

	Ingo
