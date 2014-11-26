Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaKZNMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:12:31 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:35793 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaKZNM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:12:27 -0500
Date: Wed, 26 Nov 2014 13:12:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tim Sander <tim@krieglstein.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>
Subject: Re: [PATCH 3.18-rc3 v9 5/5] arm: smp: Handle ipi_cpu_backtrace()
 using FIQ (if available)
Message-ID: <20141126131210.GI3836@n2100.arm.linux.org.uk>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
 <1416936401-5147-1-git-send-email-daniel.thompson@linaro.org>
 <1416936401-5147-6-git-send-email-daniel.thompson@linaro.org>
 <2744845.J3XUj2a9bM@dabox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2744845.J3XUj2a9bM@dabox>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 01:46:52PM +0100, Tim Sander wrote:
> Hi Daniel
> 
> Am Dienstag, 25. November 2014, 17:26:41 schrieb Daniel Thompson:
> > Previous changes have introduced both a replacement default FIQ handler
> > and an implementation of arch_trigger_all_cpu_backtrace for ARM but
> > these are currently independent of each other.
> > 
> > This patch plumbs together these features making it possible, on platforms
> > that support it, to trigger backtrace using FIQ.
> Does this ipi handler interfere in any way with set_fiq_handler?
> 
> As far as i know there is only one FIQ handler vector so i guess there is a 
> potential conflict. But i have not worked with IPI's so i might be completley
> wrong.

First, the code in arch/arm/kernel/fiq.c should work with this new FIQ
code in that the new FIQ code is used as the "default" handler (as
opposed to the original handler which was a total no-op.)

Secondly, use of arch/arm/kernel/fiq.c in a SMP system is really not a
good idea: the FIQ registers are private to each CPU in the system, and
there is no infrastructure to allow fiq.c to ensure that it loads the
right CPU with the register information for the provided handler.

So, use of arch/arm/kernel/fiq.c and the IPI's use of FIQ /should/ be
mutually exclusive.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
