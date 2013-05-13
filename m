Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3EMTLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:11:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:48838 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab3EMTK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:10:58 -0400
Date: Mon, 13 May 2013 21:10:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bitbucket@online.de, tip-bot for Thomas Gleixner <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] tick: Cleanup NOHZ per cpu data on cpu
 down
In-Reply-To: <5190FE00.6010508@redhat.com>
Message-ID: <alpine.LFD.2.02.1305132035360.2863@ionos>
References: <alpine.LFD.2.02.1305031451561.2886@ionos> <tip-4b0c0f294f60abcdd20994a8341a95c8ac5eeb96@git.kernel.org> <5190FE00.6010508@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013, Prarit Bhargava wrote:
> Thomas, while this does fix up the NULL pointer issue, I think you've introduced
> a new bug in the schedule timer code.

I don't think that I introduced a new bug. I'm quite sure that change
unearthed another issue which was papered over by the stale data.

That memset is putting the data structure into the same state as we
have on boot. From tick-sched perspective cpu onlining is not
different between boot and an offline/online cycle

> While doing up and downs on the same CPU, I now occasionally see long delays in
> the up and down...

> [   81.744565] smpboot: Booting Node 1 Processor 19 APIC 0x28
> [   82.848591] smpboot: CPU 19 is now offline
> 
> Long delay in bringing CPU "up"
> 
> [   89.826533] smpboot: Booting Node 1 Processor 19 APIC 0x28
> [   84.905358] smpboot: CPU 19 is now offline
> [   87.565274] smpboot: Booting Node 1 Processor 19 APIC 0x28

Errm, the timestamps are random. -ENOTUSEFUL
 
> Also, if the system is in this state I cannot reboot -- the system appears to
> hang while bringing down CPUs...
> 
> Oddly, if I do
> 
> +       memset(ts, 0, sizeof(*ts));
> +       ts->tick_stopped = 1;
> 
> instead of your memset, everything works.  I'm looking at the tick-sched.c code
> to see why setting tick_stopped = 1 seems to fix the problem.

That doesn't make any sense. So instead of changing random values in
ts, could you please fire up the tracer and gather evidence, so we can
see what the system does when these long delays happen. You can start
and stop the tracer from your script and terminate if one of the
operations takes too long.

Thanks,

	tglx






