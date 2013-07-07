Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab3GGD7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 23:59:38 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37841 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab3GGD7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 23:59:36 -0400
Date: Sun, 7 Jul 2013 11:59:07 +0800
From: Wang YanQing <udknight@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>, mingo@kernel.org,
        peterz@infradead.org, jbeulich@suse.com, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, mina86@mina86.org,
        srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        jun.zhang@intel.com, fengguang.wu@intel.com
Subject: Re: [PATCH V2] smp: Give WARN()ing when calling
 smp_call_function_many()/single() in serving irq
Message-ID: <20130707035907.GA2875@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Chuansheng Liu <chuansheng.liu@intel.com>, mingo@kernel.org,
	peterz@infradead.org, jbeulich@suse.com, paulmck@linux.vnet.ibm.com,
	akpm@linux-foundation.org, mina86@mina86.org,
	srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	jun.zhang@intel.com, fengguang.wu@intel.com
References: <1360163901.24670.13.camel@cliu38-desktop-build>
 <1361023075.11130.12.camel@cliu38-desktop-build>
 <1361023812.11130.15.camel@cliu38-desktop-build>
 <alpine.DEB.2.02.1307051548430.32106@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1307051615100.32106@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307051615100.32106@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 04:37:14PM +0200, Thomas Gleixner wrote:
> Hmm, even there it matters, because of the following scenario:
> 
> CPU 0
> smp_call_function_single(CPU 1)
>     csd_lock(CPU 1)

No, smpl_call_function_single(CPU 1)
will csd_lock(CPU 0), not csd_lock(CPU 1)

>     irq_enter()
>     irq_exit()
>     __do_softirq()
>     smp_call_function_many()
>       setup csd (CPU 1)
>         csd_lock(CPU 1) ==> CPU 0 deadlocked itself.
> 

maybe below is the scenario:
     irq_enter()
     irq_exit()
     __do_softirq()
     smp_call_function_single()
       setup csd (CPU 1)
         csd_lock(CPU 0) ==> CPU 0 deadlocked itself.
 

> And this is even more likely to happen than the lock issue.
> 
> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
