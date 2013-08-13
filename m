Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab3HMXEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:04:51 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:16688 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab3HMXEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:04:50 -0400
Message-ID: <520ABB8F.6000709@tilera.com>
Date: Tue, 13 Aug 2013 19:04:47 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v4 2/2] mm: make lru_add_drain_all() selective
References: <5202CEAA.9040204@linux.vnet.ibm.com> <201308072335.r77NZZwl022494@farm-0012.internal.tilera.com> <20130812140520.c6a2255d2176a690fadf9ba7@linux-foundation.org> <52099187.80301@tilera.com> <20130813123512.3d6865d8bf4689c05d44738c@linux-foundation.org> <20130813201958.GA28996@mtj.dyndns.org> <20130813133135.3b580af557d1457e4ee8331a@linux-foundation.org> <520A9E4A.2050203@tilera.com> <20130813141329.c55deccf462f3ad49129bbca@linux-foundation.org> <520AAF9C.1050702@tilera.com> <20130813152622.f15dcaaa672ba182308ce29f@linux-foundation.org>
In-Reply-To: <20130813152622.f15dcaaa672ba182308ce29f@linux-foundation.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/2013 6:26 PM, Andrew Morton wrote:
> On Tue, 13 Aug 2013 18:13:48 -0400 Chris Metcalf <cmetcalf@tilera.com> wrote:
>
>> On 8/13/2013 5:13 PM, Andrew Morton wrote:
>>> On Tue, 13 Aug 2013 16:59:54 -0400 Chris Metcalf <cmetcalf@tilera.com> wrote:
>>>
>>>>> Then again, why does this patchset exist?  It's a performance
>>>>> optimisation so presumably someone cares.  But not enough to perform
>>>>> actual measurements :(
>>>> The patchset exists because of the difference between zero overhead on
>>>> cpus that don't have drainable lrus, and non-zero overhead.  This turns
>>>> out to be important on workloads where nohz cores are handling 10 Gb
>>>> traffic in userspace and really, really don't want to be interrupted,
>>>> or they drop packets on the floor.
>>> But what is the effect of the patchset?  Has it been tested against the
>>> problematic workload(s)?
>> Yes.  The result is that syscalls such as mlockall(), which otherwise interrupt
>> every core, don't interrupt the cores that are running purely in userspace.
>> Since they are purely in userspace they don't have any drainable pagevecs,
>> so the patchset means they don't get interrupted and don't drop packets.
>>
>> I implemented this against Linux 2.6.38 and our home-grown version of nohz
>> cpusets back in July 2012, and we have been shipping it to customers since then.
> argh.
>
> Those per-cpu LRU pagevecs were a nasty but very effective locking
> amortization hack back in, umm, 2002.  They have caused quite a lot of
> weird corner-case behaviour, resulting in all the lru_add_drain_all()
> calls sprinkled around the place.  I'd like to nuke the whole thing,
> but that would require a fundamental rethnik/rework of all the LRU list
> locking.
>
> According to the 8891d6da17db0f changelog, the lru_add_drain_all() in
> sys_mlock() isn't really required: "it isn't must.  but it reduce the
> failure of moving to unevictable list.  its failure can rescue in
> vmscan later.  but reducing is better."
>
> I suspect we could just kill it.

That's probably true, but I suspect this change is still worthwhile for
nohz environments.  There are other calls of lru_add_drain_all(), and
you just don't want anything in the kernel that interrupts every core
when only a subset could be interrupted.  If the kernel can avoid
generating unnecessary interrupts to uninvolved cores, you can make
guarantees about jitter on cores that are running dedicated userspace code.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

