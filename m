Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaLWC5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 21:57:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:48942 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbaLWC5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 21:57:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="432397521"
Date: Mon, 22 Dec 2014 18:57:08 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: Re: [PATCH] tick/powerclamp: Remove tick_nohz_idle abuse
Message-ID: <20141222185708.15bbdd17@jacob-VirtualBox>
In-Reply-To: <5494D160.8060808@linux.vnet.ibm.com>
References: <alpine.DEB.2.11.1412181110110.17382@nanos>
	<54930EB1.9080309@linux.vnet.ibm.com>
	<DD415AA12F8FF042BF4EA69DF123C1478AF91730@ORSMSX101.amr.corp.intel.com>
	<20141218115239.53d17e39@jacob-VirtualBox>
	<alpine.DEB.2.11.1412182209010.17382@nanos>
	<20141219103900.101f6c6d@jacob-VirtualBox>
	<alpine.DEB.2.11.1412192054130.17382@nanos>
	<5494D160.8060808@linux.vnet.ibm.com>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2014 07:01:12 +0530
Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:

> On 12/20/2014 01:26 AM, Thomas Gleixner wrote:
> > On Fri, 19 Dec 2014, Jacob Pan wrote:
> > 
> >> On Thu, 18 Dec 2014 22:12:57 +0100 (CET)
> >> Thomas Gleixner <tglx@linutronix.de> wrote:
> >>
> >>> On Thu, 18 Dec 2014, Jacob Pan wrote:
> >>>> OK I agree, also as I mentioned earlier, Peter already has a
> >>>> patch for consolidated idle loop and remove
> >>>> tick_nohz_idle_enter/exit call from powerclamp driver. I have
> >>>> been working on a few tweaks to maintain the functionality and
> >>>> efficiency with the consolidated idle loop. We can apply the
> >>>> patches on top of yours.
> >>>
> >>> No. This is equally wrong as I pointed out before. The 'unified'
> >>> idle loop is still fake and just pretending to be idle.
> >>>
> >> In terms of efficiency, the consolidated idle loop will allow
> >> turning off sched tick during idle injection period. If we just
> >> take out the tick_nohz_idle_xxx call, the effectiveness of
> >> powerclamp is going down significantly. I am not arguing the
> >> design but from fixing regression perspective or short term
> >> solution.
> > 
> > There is no perspective. Period.
> > 
> > Its violates every rightful assumption of the nohz_IDLE_* code and
> > just ever worked by chance. There is so much subtle wreckage lurking
> > there that the only sane solution is to forbid it. End of story.
> > 
> > Thanks,
> > 
> > 	tglx
> > 
> Hi Jacob,
> 
> Like Thomas pointed out, we can design a sane solution for powerclamp.
> Idle injection is nothing but throttling of runqueue. If the runqueue
> is throttled, no fair tasks will be selected and the natural choice
> in the absence of tasks from any other sched class is the idle task.
> 
> The idle loop will automatically be called and the nohz state will
> also fall in place. The cpu is really idle now: the runqueue has no
> tasks and the task running on the cpu is the idle thread. The
> throttled tasks are on a separate list.
> 
> When the period of idle injection is over, we unthrottle the runqueue.
> All this being taken care of my a non-deferrable timer. This design
> ensures that the intention of powerclamp is not hampered while at the
> same time maintaining a sane state for nohz; you will get the
> efficiency you want.
> 
> Of course there may be corner cases and challenges around
> synchronization of package idle, which I am sure we can work around
> with a better design such as the above. I am working on that patchset
> and will post out in a day. You can take a look and let us know the
> pieces we are missing.
> 
> I find that implementing the above design is not too hard.
> 
Hi Preeti,
Yeah, it seems to be a good approach. looking forward to work with you
on this. Timer may scale better for larger systems. One question, will
timer irq gets unpredictable delays if run by ksoftirqd?
BTW, I may not be able to respond quickly during the holidays. If
things workout, it may benefit ACPI PAD driver as well.


Thanks,

Jacob
> Regards
> Preeti U Murthy
> 

[Jacob Pan]
