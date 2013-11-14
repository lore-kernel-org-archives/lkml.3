Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab3KNJQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 04:16:10 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42413 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab3KNJQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 04:16:05 -0500
Message-ID: <5284940D.6050402@linux.vnet.ibm.com>
Date: Thu, 14 Nov 2013 14:42:45 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Preeti Murthy <preeti.lkml@gmail.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        mikey@neuling.org, linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH v2] sched: Check sched_domain before computing group power.
References: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org> <20131112105547.GA27310@linux.vnet.ibm.com> <20131112115736.GO5056@laptop.programming.kicks-ass.net> <20131112164126.GF2559@linux.vnet.ibm.com> <CAM4v1pNMn=5oZDiX3fUp9uPkZTPJgk=vEKEjevzvpwn=PjTzXg@mail.gmail.com> <20131113112329.GC543@linux.vnet.ibm.com> <52846863.4060001@linux.vnet.ibm.com> <20131114083037.GT21461@twins.programming.kicks-ass.net>
In-Reply-To: <20131114083037.GT21461@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111409-0928-0000-0000-00000369DD4B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 11/14/2013 02:00 PM, Peter Zijlstra wrote:
> On Thu, Nov 14, 2013 at 11:36:27AM +0530, Preeti U Murthy wrote:
>> However I was thinking that a better fix would be to reorder the way we call
>> update_group_power() and cpu_attach_domain(). Why do we need to do
>> update_group_power() of the groups of the sched domains that would probably
>> degenerate in cpu_attach_domain()? So it seemed best to move update_group_power()
>> to after cpu_attach_domain() so that it saves unnecessary iterations over
>> sched domains which could degenerate, and it fixes the issue that you have brought out
>> as well. See below for the patch:
> 
> So how is publishing the domain tree before we've set these values at
> all going to help avoid the divide-by-zero problem?

We are still doing initialization of cpu power and power_orig during
building of sched domains right? Except that it is being done after CPUs
have base domains attached to them.

But if you are talking about the check in sched_debug_one() on if
power_orig has been initialized, then yes, this patch fails. I am sorry
I overlooked the sched_debug() checks in cpu_attach_domain().
> 
> Also its just terribly bad form to publish something before you're done
> with initialization.

You are right. cpu_rq(cpu)->sd is going to be used by anyone intending
to iterate through the sched domains. By the time we publish this, every
parameter related to sched domains and groups need to be initialized.
The fact that sched_domain_debug() is going to be called by
cpu_attach_domain() to do one final sanity check on all the parameters
of the sched domains further emphasizes that we cannot have anything
un-initialised at this stage. So clearly my patch is incorrect.
Please add my Reviewed-by to Srikar's patch.

Thanks.

Regards
Preeti U. Murthy
> 

