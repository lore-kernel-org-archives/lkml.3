Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab3BVPTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 10:19:54 -0500
Received: from two.firstfloor.org ([193.170.194.197]:35064 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab3BVPTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 10:19:52 -0500
Date: Fri, 22 Feb 2013 16:19:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] perf, x86: Support full width counting v3
Message-ID: <20130222151950.GK2928@two.firstfloor.org>
References: <1361213287-7636-1-git-send-email-andi@firstfloor.org>
 <1361213287-7636-5-git-send-email-andi@firstfloor.org>
 <20130222134630.GA8960@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222134630.GA8960@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 02:46:30PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Recent Intel CPUs like Haswell and IvyBridge have a new 
> > alternative MSR range for perfctrs that allows writing the 
> > full counter width. Enable this range if the hardware reports 
> > it using a new capability bit.
> > 
> > This lowers the overhead of perf stat slightly because it has 
> > to do less interrupts to accumulate the counter value. On 
> > Haswell it also avoids some problems with TSX aborting when 
> > the end of the counter range is reached.
> 
> The changelog does not adequately explain why this patch is 
> critical for basic Haswell enablement. "Avoids some problems 
> with TSX aborting" is not very helpful.

Updated description below. I don't want you from stop reviewing
the rest of the patches, so I'm not posting a new series
for now just for a new description. Please keep reading.
You may make it through to the end.

---

Recent Intel CPUs like Haswell and IvyBridge have a new
alternative MSR range for perfctrs that allows writing the
full counter width. Enable this range if the hardware reports
it using a new capability bit.

This lowers the overhead of perf stat slightly because it has
to do less interrupts to accumulate the counter value. On
Haswell it also avoids some problems with TSX aborting when
the end of the counter range is reached. This can be observed
when the checkpoint flag has been set, which has been enabled
by the basic PMU patch. An overflow will abort the transaction
and set the counter back. If the counter is near the overflow
before the transaction this could happen continuously, forcing
a transaction to continuously abort.
This is a partial fix, but it makes the overflows much less 
likely by using a larger counter, to lower the probability of the
event. Additional counter measures are in the additional extended
Haswell patchkit.

