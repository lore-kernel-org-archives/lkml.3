Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab3CKCmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 22:42:17 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:57779 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3CKCmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 22:42:16 -0400
Message-ID: <513D447B.5060906@linux.vnet.ibm.com>
Date: Mon, 11 Mar 2013 10:42:03 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wakeup buddy
References: <5136EB06.2050905@linux.vnet.ibm.com> <1362645372.2606.11.camel@laptop> <1362649419.4652.12.camel@marge.simpson.net> <51394EE3.1020706@linux.vnet.ibm.com> <1362725051.31859.40.camel@marge.simpson.net> <5139938A.1040504@linux.vnet.ibm.com> <1362731173.31859.81.camel@marge.simpson.net>
In-Reply-To: <1362731173.31859.81.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031102-5140-0000-0000-000002DF41D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 04:26 PM, Mike Galbraith wrote:
> On Fri, 2013-03-08 at 15:30 +0800, Michael Wang wrote: 
>> On 03/08/2013 02:44 PM, Mike Galbraith wrote:
> 
>>> In general, I think things would work better if we'd just rate limit how
>>> frequently we can wakeup migrate each individual task.  
>>
>> Isn't the wakeup buddy already limit the rate? and by turning the knob,
>> we could change the rate on our demand.
> 
> I was referring to the existing kernel, not as altered. 
> 
>> We want
>>> jabbering tasks to share L3, but we don't really want to trash L2 at an
>>> awesome rate.
>>
>> I don't get it..., it's a task which has 'sleep' for some time, unless
>> there is no task running on prev_cpu when it's sleeping, otherwise
>> whatever the new cpu is, we will trash L2, isn't it?
> 
> I'm thinking if you wake it to it's old home after a microscopic sleep,
> it has a good chance of evicting the current resident, rescuing its L2.
> If tasks which do microscopic sleep can't move around at a high rate,
> they'll poke holes in fewer preempt victims.  If they're _really_ fast
> switchers, always wake affine.  They can't hurt much, they don't do much
> other than schedule off.

I get your point, it's about the task which sleep frequently for a very
short time, you are right, keep them around prev_cpu could gain some
benefit.

There are still many factors need to be considered, for example, if the
cpu around prev_cpu are busier than those around curr_cpu, then pull
from prev to curr still likely to be a good choice...for the consider of
future.

Also for sure, that depends on what's the workload in the system, and
how they cooperate with each other.

IMHO, I think wakeup buddy is a compromising solution for this case,
before we could figure out the correct formular (and a efficient way to
collect all the info we rely on), such a flexible optimization is not bad.

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

