Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaLRVNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:13:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:60249 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaLRVNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:13:16 -0500
Date: Thu, 18 Dec 2014 22:12:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: Re: [PATCH] tick/powerclamp: Remove tick_nohz_idle abuse
In-Reply-To: <20141218115239.53d17e39@jacob-VirtualBox>
Message-ID: <alpine.DEB.2.11.1412182209010.17382@nanos>
References: <alpine.DEB.2.11.1412181110110.17382@nanos> <54930EB1.9080309@linux.vnet.ibm.com> <DD415AA12F8FF042BF4EA69DF123C1478AF91730@ORSMSX101.amr.corp.intel.com> <20141218115239.53d17e39@jacob-VirtualBox>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014, Jacob Pan wrote:
> OK I agree, also as I mentioned earlier, Peter already has a patch for
> consolidated idle loop and remove tick_nohz_idle_enter/exit call from
> powerclamp driver. I have been working on a few tweaks to maintain the
> functionality and efficiency with the consolidated idle loop.
> We can apply the patches on top of yours.

No. This is equally wrong as I pointed out before. The 'unified' idle
loop is still fake and just pretending to be idle.

If simple standard interfaces like cpu_idle() are not working from
idle code anymore then this simply stinks. And that's what any fake
idle thread will do.

The whole approach is wrong. Implement a sched fair throttler and you
can avoid the whoile trainwreck.
 
> > 1. Queue a deferable periodic timer whose handler checks if idle
> > needs to be injected. If so, it sets rq->need_throttle for the cpu.
> > If its already in the fake idle period, it clears rq->need_throttle
> > and sets need_resched.
> > 
> The key to powerclamp driver is to achieve package level idle
> states, which implies synchronized idle injection. From
> power/performance standpoint, only package level idle states is worth
> injection.

Then use a synchronized non deferrable timer on all cpus. It's simple
enough.
 
Thanks,

	tglx
