Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab3EEQrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 12:47:21 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:18234 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3EEQrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 12:47:20 -0400
X-IronPort-AV: E=Sophos;i="4.87,616,1363132800"; 
   d="scan'208";a="22288051"
Date: Sun, 5 May 2013 17:47:12 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Christopher Covington <cov@codeaurora.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Xen-devel] [PATCH 1/3] arm_arch_timer: introduce
 arch_timer_stolen_ticks
In-Reply-To: <5183976A.6000703@arm.com>
Message-ID: <alpine.DEB.2.02.1305051745390.4756@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com> <1367436460-10183-1-git-send-email-stefano.stabellini@eu.citrix.com> <51817CBE.4050003@codeaurora.org> <1367482772.21869.26.camel@zakaz.uk.xensource.com> <5182DBA9.9080609@codeaurora.org>
 <alpine.DEB.2.02.1305031130210.5398@kaball.uk.xensource.com> <5183976A.6000703@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 May 2013, Marc Zyngier wrote:
> On 03/05/13 11:43, Stefano Stabellini wrote:
> > On Thu, 2 May 2013, Christopher Covington wrote:
> >>> So the virtual timer should appear to have been running even while time
> >>> is being stolen and therefore stolen time needs to be accounted via some
> >>> other means.
> >>
> >> Something that's not currently obvious to me is that given that the stolen
> >> cycle accounting should be done, what makes the architected timer interrupt
> >> handler the ideal place to do it?
> > 
> > That is a good question and I would appreciate suggestions to improve
> > the patch.
> > 
> > Given that Xen x86 and ia64 does stolen time accounting from the timer
> > interrupt handler:
> > 
> > arch/x86/xen/time.c:xen_timer_interrupt
> > arch/ia64/kernel/time.c:timer_interrupt
> > 
> > and given that the arch_timer is the only timer used by Xen on ARM and
> > that it includes a virt_timer that is made on purpose to be used by
> > virtual machines, I thought that it might be a good place for it.
> > 
> > I also thought that doing it this way, KVM should be able to reuse the
> > same hook.
> 
> Indeed. I just need to understand how time stealing works there ;-).
> 
> Now, KVM is not necessarily limited to arch_timers, and we've run KVM
> using a QEMU-provided timer in the past. Can you think of a more generic
> location for this hook? Possibly something that would satisfy the
> requirements of other architectures while we're at it?

Probably the best option would be to reuse

kernel/sched/cputime.c:steal_account_process_tick

but that also means introducing CONFIG_PARAVIRT on arm.
I am up for that, what do you think?
