Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab3LLFhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 00:37:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65447 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3LLFhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 00:37:33 -0500
Message-ID: <1386826641.6056.31.camel@marge.simpson.net>
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
From: Mike Galbraith <bitbucket@online.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Date: Thu, 12 Dec 2013 06:37:21 +0100
In-Reply-To: <52A94065.1050103@zytor.com>
References: <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de>
	 <20131211113839.GF21683@pd.tnic>
	 <20131211115239.GA21999@twins.programming.kicks-ass.net>
	 <1386764955.12005.60.camel@marge.simpson.net>
	 <20131211124352.GB21999@twins.programming.kicks-ass.net>
	 <20131211134048.GH21683@pd.tnic> <20131211145655.GB4510@gmail.com>
	 <20131211164318.GA2480@laptop.programming.kicks-ass.net>
	 <20131211175036.GC12431@gmail.com> <52A8F073.9040500@zytor.com>
	 <20131211231425.GD8863@pd.tnic> <52A908DB.60902@zytor.com>
	 <1386822357.6056.12.camel@marge.simpson.net> <52A94065.1050103@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:hiLaVOqBFHDu4bbaN3HokiyoDBDBElja6Kh1kh7iYRP
 EvyTsb/NBy/q0QOitfSM+3vSdKUGVHWlDTe+DGp530R8ZqT04A
 0RWsuAthdLXbJOwzMEPMAvrki8PO/fvsku3N+wmtRIkuCyubzJ
 m1inDA8JHTTXmYC2essNgMhtNj0EVtdD9nSBTyNtiS+ka6JcwY
 iwATOyoYC/sMAS3UbA3naqB2jRNSGo10md3ZGMnqUQS67dJAf4
 BJQyh3UjH0vk1DroCy50QsFgoFGv8OtzCVhxD/8ni8Xc6WohL4
 4im3ZVPGaHzpyENGL7oSZiMlcYO/lqX31T1XBH2pe3+LGiPE/N
 IGBArSRg9wKvkhzfH4kdio+QFRwD9Lwg+lOMqonWRIARxNmpA/
 9yxj76YBOlqyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 20:49 -0800, H. Peter Anvin wrote: 
> On 12/11/2013 08:25 PM, Mike Galbraith wrote:
> >  arch/x86/include/asm/mwait.h   |    4 ++--
> >  arch/x86/kernel/cpu/common.c   |    7 ++++---
> >  arch/x86/kernel/setup_percpu.c |    1 +
> >  3 files changed, 7 insertions(+), 5 deletions(-)
> > 
> > Index: linux-2.6/arch/x86/kernel/cpu/common.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/kernel/cpu/common.c
> > +++ linux-2.6/arch/x86/kernel/cpu/common.c
> > @@ -65,13 +65,14 @@ void __init setup_cpu_local_masks(void)
> >  }
> >  
> >  /* allocate percpu area for mwait doorbell */
> > -char __percpu *mwait_doorbell;
> > +DEFINE_PER_CPU(char *, mwait_doorbell);
> > +EXPORT_PER_CPU_SYMBOL(mwait_doorbell);
> >  
> 
> Sorry, this is wrong.  This is NOT a percpu variable, it is a pointer to
> a percpu allocation, but the variable itself is not a percpu variable.
> This explains your boom.

With that fixed, it boots, but is not quite perfect.

... 
[  258.560079] fbcon: radeondrmfb (fb0) is primary device
[  258.722483] Console: switching to colour frame buffer device 128x48
[  258.847076] radeon 0000:01:03.0: fb0: radeondrmfb frame buffer device
[  258.911991] radeon 0000:01:03.0: registered panic notifier
[  258.968772] [drm] Initialized radeon 2.35.0 20080528 for 0000:01:03.0 on minor 0
...
[  469.738604] netxen_nic 0000:04:00.3: using msi-x interrupts
[  469.739078] netxen_nic 0000:04:00.3: eth5: GbE port initialized
[  469.830512] ipmi_si 00:01: Found new BMC (man_id: 0x00000b, prod_id: 0x2000, dev_id: 0x13)
[  469.830524] ipmi_si 00:01: IPMI kcs interface initialized
[  473.729862] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
...
[  711.636741] fuse init (API version 7.22)

...zzzz ok box, doctor appointment is in an hour away.

-Mike 


