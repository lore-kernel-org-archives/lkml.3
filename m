Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969AbaAEEpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 23:45:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaAEEpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 23:45:53 -0500
Message-ID: <1388897147.5342.36.camel@marge.simpson.net>
Subject: Re: [PATCH] Revert "x86: Disable IST stacks for debug/int 3/stack
 fault for PREEMPT_RT"
From: Mike Galbraith <bitbucket@online.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>, 723180@bugs.debian.org,
        Brian Silverman <bsilver16384@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Date: Sun, 05 Jan 2014 05:45:47 +0100
In-Reply-To: <20140104181807.GS20765@two.firstfloor.org>
References: <20130917061329.4872.51468.reportbug@dell-inspiron-linux.dlinkrouter>
	 <1379427451.23881.48.camel@deadeye.wl.decadent.org.uk>
	 <CAP01z6LVxoA6kDJeL8NuO2aA22BjMvXSk9ZY7z9cOK1=k56vpg@mail.gmail.com>
	 <1379905562.3913.8.camel@deadeye.wl.decadent.org.uk>
	 <CAP01z6+j6moUio9pc3G3iz+ebJCdKEvngddxnxazRP+NXwLkyg@mail.gmail.com>
	 <1380115449.4430.21.camel@deadeye.wl.decadent.org.uk>
	 <52AE0419.3050103@linutronix.de> <20140103135548.GA6327@linutronix.de>
	 <20140104181807.GS20765@two.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:irRZoVHehSXsUXQ78E3MmrijvgbRXrho0mMFJrZiXtx
 davHy7dGCq6fy9OfHMgxZnQrwGEYUwf582AyM16nhUTFCyUEUE
 TlDlrorvgvl8/GG/OG4tArHUpBI2R0r6JTYJu8SOts3/x/Sayo
 74jLrLcigpPHyRlgKPUPjO3pCSDcf3TeG8wyMxxPRTTo9CvGSz
 VpyRRyDHsk5HXQRjJj4iwzJhURitvh9TJSmRICYr342ATkt5Qc
 Y44yMNfjjWZJ9XGNcHU8p/PgeyGBguv2Z7HMywGFJqImoWLqvz
 tFbvbOZI/l7h7XNGoPBu+mVYYzp2OJofYxtta+6lg9Wc8bso5O
 +0emOP6wAnp93unQ798fI84yiSIrhHqtZaP5zgNQ44iHnNOPPs
 qVidSOzkxCI0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-04 at 19:18 +0100, Andi Kleen wrote: 
> On Fri, Jan 03, 2014 at 02:55:48PM +0100, Sebastian Andrzej Siewior wrote:
> > where do I start. Let me explain what is going on here. The code
> > sequence
> 
> Yes the IST stacks are needed for correctness, even in more cases than
> the example below. You cannot just disable them, just because you don't
> like them.

You had a better reason than dislike.

<quote> 
From: Andi Kleen <ak@suse.de>
Date: Fri, 3 Jul 2009 08:44:10 -0500
Subject: [PATCH 209/303] x86: Disable IST stacks for debug/int 3/stack fault for PREEMPT_RT

Normally the x86-64 trap handlers for debug/int 3/stack fault run
on a special interrupt stack to make them more robust
when dealing with kernel code.

The PREEMPT_RT kernel can sleep in locks even while allocating
GFP_ATOMIC memory. When one of these trap handlers needs to send
real time signals for ptrace it allocates memory and could then
try to to schedule.  But it is not allowed to schedule on a
IST stack. This can cause warnings and hangs.

This patch disables the IST stacks for these handlers for PREEMPT_RT
kernel. Instead let them run on the normal process stack.

...

A better solution would be to use similar logic as the NMI "paranoid"
path: check if signal is for user space, if yes go back to entry.S, switch stack,
call sync_regs, then do the signal sending etc.

</quote>

Or perhaps tell sleeping locks to spin in annoying spots?  I converted
rt spinlocks globally to preemptible spinning locks (wasn't pretty, but
worked), so seems that could work.

-Mike

