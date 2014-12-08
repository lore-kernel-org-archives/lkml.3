Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbaLHFU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 00:20:57 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:36270 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaLHFU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 00:20:56 -0500
Date: Sun, 7 Dec 2014 21:20:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141208052048.GJ25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141202193252.GB17595@redhat.com>
 <547E4C14.6040509@oracle.com>
 <54813C03.8040009@oracle.com>
 <CA+55aFyZOo=HzB_n3gLqswFsN1FcMdumaKLBk+fbhDD3wrvXnA@mail.gmail.com>
 <5481C92E.6020805@oracle.com>
 <CA+55aFxnCxJcg7NgNeqn_P_TugpcHTUk+v21Td25Aw6+2Z8=YA@mail.gmail.com>
 <54846B06.8050906@oracle.com>
 <20141207182420.GG25340@linux.vnet.ibm.com>
 <20141207194304.GA17810@linux.vnet.ibm.com>
 <5484E2AB.1070503@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5484E2AB.1070503@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120805-0013-0000-0000-000006DBDF37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 06:28:43PM -0500, Sasha Levin wrote:
> On 12/07/2014 02:43 PM, Paul E. McKenney wrote:
> > On Sun, Dec 07, 2014 at 10:24:20AM -0800, Paul E. McKenney wrote:
> >> On Sun, Dec 07, 2014 at 09:58:14AM -0500, Sasha Levin wrote:
> >>> On 12/05/2014 01:15 PM, Linus Torvalds wrote:
> >>>> On Fri, Dec 5, 2014 at 7:03 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> >>>>>
> >>>>> Yes, it's going to a serial line, but it's only about 100 lines/second on
> >>>>> average. I wouldn't expect it to cause anything to hang!
> >>>>
> >>>> A regular 16650 serial chip? Running at 115kbps, I assume? So that's
> >>>> about 11kB/s.
> >>>>
> >>>> And the serial console is polling, since it can't sleep or depend on interrupts.
> >>>>
> >>>> At a average line length of what, 40 characters? At less than 300
> >>>> lines/s, you'd be using up 100% of one CPU. And since the printouts
> >>>> are serialized, that would be all other CPU's too..
> >>>>
> >>>> 100 lines/s _average_ means that I can easily see it be 300lines/s for a while.
> >>>>
> >>>> So yeah. The serial console is simply not designed to handle
> >>>> continuous output. It's for the "occasional" stuff.
> >>>>
> >>>> The fact that your rcu lockups go away when you make the fault
> >>>> injection be quiet makes me really suspect this is related.
> >>>
> >>> The lockups themselves "go away", but looking closer at the log
> >>> without those extra prints, I'm seeing:
> >>>
> >>> [ 1458.700070] INFO: rcu_preempt detected stalls on CPUs/tasks:
> >>> [ 1458.700133]  (detected by 19, t=30502 jiffies, g=12293, c=12292, q=0)
> >>> [ 1458.702764] INFO: Stall ended before state dump start
> >>>
> >>> Quite often.
> >>>
> >>> Maybe the extra prints were just a catalyst?
> >>
> >> Is anything else being printed about the time that these message show
> >> up?  Or is this the only output for the 40,000 jiffies preceding this
> >> message?
> 
> There's actually nothing going on (beyond fuzzing noise) before/after:
> 
> [  756.618342] kexec-bzImage64: Not a bzImage
> [  762.381734] kexec-bzImage64: Not a bzImage
> [  765.129612] Unable to find swap-space signature
> [  771.022304] Unable to find swap-space signature
> [  793.434417] kexec-bzImage64: Not a bzImage
> [  797.978210] => alloc_cpumask_var: failed!
> [  800.253116] kexec-bzImage64: Not a bzImage
> [  818.280056] INFO: rcu_sched detected stalls on CPUs/tasks:
> [  818.280056]  (detected by 11, t=30503 jiffies, g=-295, c=-296, q=0)
> [  818.283400] INFO: Stall ended before state dump start
> [  829.523992] audit: type=1326 audit(39.680:47): auid=4294967295 uid=2385760256 gid=2214330370 ses=4294967295 pid=13307 comm="trinity-c353" exe="/trinity/trinity" sig=9 arch=c000003e syscall=96 compat=0 ip=0x7fffcb7bee47 code=0x0
> [  830.890841] audit: type=1326 audit(41.010:48): auid=4294967295 uid=310902784 gid=201841673 ses=4294967295 pid=13294 comm="trinity-c350" exe="/trinity/trinity" sig=9 arch=c000003e syscall=96 compat=0 ip=0x7fffcb7bee47 code=0x0

I have seen this caused by lost IPIs, but you have to lose two of them,
which seems less than fully likely.

> > And could you please build with CONFIG_RCU_CPU_STALL_INFO=y and try
> > this again?
> 
> I already have it set:
> 
> $ grep STALL_INFO .config
> CONFIG_RCU_CPU_STALL_INFO=y

Ah, apologies.  OK, time to make this the default, and later to remove
the option...

							Thanx, Paul

