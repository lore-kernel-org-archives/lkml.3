Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968042Ab3HIQMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:12:47 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:61934 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968003Ab3HIQMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:12:45 -0400
Message-ID: <520514FB.8060502@tilera.com>
Date: Fri, 9 Aug 2013 12:12:43 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 1/2] workqueue: add new schedule_on_cpu_mask() API
References: <5202CEAA.9040204@linux.vnet.ibm.com> <201308072335.r77NZJPA022490@farm-0012.internal.tilera.com> <20130809150257.GM20515@mtj.dyndns.org>
In-Reply-To: <20130809150257.GM20515@mtj.dyndns.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/2013 11:02 AM, Tejun Heo wrote:
> Hello, Chris.
>
> On Wed, Aug 07, 2013 at 04:49:44PM -0400, Chris Metcalf wrote:
>> This primitive allows scheduling work to run on a particular set of
>> cpus described by a "struct cpumask".  This can be useful, for example,
>> if you have a per-cpu variable that requires code execution only if the
>> per-cpu variable has a certain value (for example, is a non-empty list).
> So, this allows scheduling work items on !online CPUs.  Workqueue does
> allow scheduling per-cpu work items on offline CPUs if the CPU has
> ever been online, but the behavior when scheduling work items on cpu
> which has never been online is undefined.  I think the interface at
> least needs to verify that the the target cpus have been online,
> trigger warning and mask off invalid CPUs otherwise.

I could certainly make schedule_on_cpu_mask() do sanity checking, perhaps via a WARN_ON_ONCE() if offline cpus were specified, and otherwise just have it create a local struct cpumask that it and's with cpu_online_mask, suitably wrapping with get_online_cpus()/put_online_cpus().  (I'm not sure how to test if a cpu has ever been online, vs whether it's online right now.)  I don't want to unnecessarily slow down the existing schedule_on_each_cpu(), so perhaps the implementation should have a static schedule_on_cpu_mask_internal() function that is the same as my previous schedule_on_cpu_mask(), allowing schedule_on_each_cpu() to call it directly to bypass the checking.

That said... I wonder if it might make sense to treat this API the same as other APIs that already take a cpu?  schedule_work_on(), schedule_delayed_work_on(), and queue_delayed_work_on() all take a cpu parameter without API comment or validity checking; queue_work_on() just says "the caller must ensure [the cpu] can't go away".  Does it make sense to just add a similar comment to schedule_on_cpu_mask() rather than make this API the first to actually do cpu validity checking?

Let me know; I'm happy to respin it either way.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

