Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaGaAMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:12:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:58275 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaGaAM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:12:29 -0400
Date: Thu, 31 Jul 2014 02:12:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] irq / PM: New driver interface for wakeup
 interrupts
In-Reply-To: <alpine.DEB.2.10.1407302350260.4170@nanos>
Message-ID: <alpine.DEB.2.10.1407310137510.4997@nanos>
References: <20140724212620.GO3935@laptop> <3042738.6Ohp3GcNCj@vostro.rjw.lan> <8151374.tpuvaHv3nd@vostro.rjw.lan> <5808955.xYYC2DJrBV@vostro.rjw.lan> <alpine.DEB.2.10.1407302350260.4170@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, Thomas Gleixner wrote:
> On Wed, 30 Jul 2014, Rafael J. Wysocki wrote:
> Before this code changes in any way I want to see:
> 
>  1) a description of the existing semantics and their background
> 
>  2) a description of the short comings of the existing semantics w/o
>     considering the new fangled (hardware) use cases
> 
>  3) a description how to mitigate the short comings described in #2
>     w/o breaking the world and some more and introducing hard to
>     decode regressions
> 
>  4) a description why the improvements introduced by #3 are not
>     sufficient for the new fangled (hardware) use cases
> 
>  5) a description how to mitigate the short comings described in #4
>     w/o breaking the world and some more and introducing hard to
>     decode regressions

Aside of that I want to see a coherent explanation why a shared MSI
interrupt makes any sense at all.

25:  1 <....> 0   PCI-MSI-edge      aerdrv, PCIe PME

AFAICT, that's the primary reason why you insist to support wakeup
sources on shared irq lines. And to be honest, it's utter bullshit.

The whole purpose of MSI is to avoid interrupt sharing, but of course
if that particular interrupt source has two potential causes, i.e. the
AER and the PME one and the stupid hardware does not support different
vectors or the drivers are not able to do so, it's conveniant to make
them shared instead of thinking about them what they really are:

 Separate interrupts on a secondary interrupt controller connected to
 the primary (MSI) one.

That's what is in fact. Simply because you can enable/disable them at
the same IP block quite contrary to stuff which is physically shared
by hard wired electrical connections.

Slapping IRQF_SHARED on that and then whining about shortcomings of
the core code is way simpler than sitting down and think about
actual topologies, right?

Most architectures aside of x86 have long ago realized that and the
core has all infrastructure available to deal with irq topologies. You
just have to utilize it.

Thanks,

	tglx




