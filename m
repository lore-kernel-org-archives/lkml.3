Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbaCFBX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 20:23:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29973 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbaCFBX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 20:23:27 -0500
Message-ID: <5317CDC4.8020908@oracle.com>
Date: Wed, 05 Mar 2014 18:22:12 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Lang <david@lang.hm>
CC: Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        peterz@infradead.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de> <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140305145420.GA30173@redhat.com> <20140305155601.GF22728@two.firstfloor.org> <20140305163644.GA2824@redhat.com> <53175D54.1020804@oracle.com> <alpine.DEB.2.02.1403051506550.6682@nftneq.ynat.uz> <5317B7D5.2030403@oracle.com> <alpine.DEB.2.02.1403051555360.6682@nftneq.ynat.uz> <5317BE94.20703@oracle.com> <alpine.DEB.2.02.1403051631590.6682@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1403051631590.6682@nftneq.ynat.uz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 05:36 PM, David Lang wrote:
> Yes, you pay for two context switches, but you don't pay for threads
> B..ZZZ all running (and potentially spinning) trying to aquire the lock
> before thread A is able to complete it's work.
>

Ah, great. We are converging now.

> As soon as a second thread hits the contention, thread A gets time to
> finish.

Only as long as thread A could be scheduled immediately which may or may 
not be the case depending upon what else is running on the core thread A 
last ran on and if thread A needs to be migrated to another core.

>
> It's not as 'good' [1] as thread A just working longer,

and that is the exact spot where I am trying to improve performance.

> but it's FAR
> better than thread A sleeping while every other thread runs and
> potentially tries to get the lock

Absolutely. I agree with that.

>
> [1] it wastes the context switches, but it avoids the overhead of
> figuring out if the thread needs to extend it's time, and if it's time
> was actually extended, and what penalty it should suffer the next time
> it runs....

All of it can be done by setting and checking couple of flags in 
task_struct. That is not insignificant, but hardly expensive. Logic is 
quite simple:

resched()
{
	........
	if (immmunity) {
		if (!penalty) {
			immunity = 0;
			penalty = 1;
			-- skip context switch --
		}
		else {
			immunity = penalty = 0;
			-- do the context switch --
		}
	}
	.........
}

sched_yield()
{
	......
	penalty = 0;
	......
}

This simple logic will also work to defeat the obnoxius threads that 
keep setting immunity request flag repeatedly within the same critical 
section to give themselves multiple extensions.

Thanks,
Khalid
