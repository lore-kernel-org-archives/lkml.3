Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3IZShk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:37:40 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:51799 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab3IZShh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:37:37 -0400
Message-ID: <52447DED.5080205@linux.vnet.ibm.com>
Date: Fri, 27 Sep 2013 00:03:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, mgorman@suse.de, dave@sr71.net,
        hannes@cmpxchg.org, tony.luck@intel.com, matthew.garrett@nebula.com,
        riel@redhat.com, srinivas.pandruvada@linux.intel.com,
        willy@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org,
        rjw@sisk.pl, gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com,
        santosh.shilimkar@ti.com, kosaki.motohiro@gmail.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@stericsson.com,
        loic.pallardy@stericsson.com, thomas.abraham@linaro.org,
        amit.kachhap@linaro.org
Subject: Re: [Results] [RFC PATCH v4 00/40] mm: Memory Power Management
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com> <52437128.7030402@linux.vnet.ibm.com> <20130925164057.6bbaf23bdc5057c42b2ab010@linux-foundation.org> <20130925234734.GK18242@two.firstfloor.org> <52438AA9.3020809@linux.intel.com> <20130925182129.a7db6a0fd2c7cc3b43fda92d@linux-foundation.org> <20130926015016.GM18242@two.firstfloor.org> <20130925195953.826a9f7d.akpm@linux-foundation.org> <524439D5.8020306@linux.vnet.ibm.com> <52445993.7050608@linux.intel.com> <52446841.2030301@linux.vnet.ibm.com> <524477AC.9090400@linux.intel.com>
In-Reply-To: <524477AC.9090400@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092618-1618-0000-0000-000004B20D31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 11:36 PM, Arjan van de Ven wrote:
>>>>>
>>>>
>>>> Arjan, are you referring to the fact that Intel/SNB systems can exploit
>>>> memory self-refresh only when the entire system goes idle? Is that why
>>>> this
>>>> patchset won't turn out to be that useful on those platforms?
>>>
>>> no we can use other things (CKE and co) all the time.
>>>
>>
>> Ah, ok..
>>
>>> just that we found that statistical grouping gave 95%+ of the benefit,
>>> without the cost of being aggressive on going to a 100.00% grouping
>>>
>>
>> And how do you do that statistical grouping? Don't you need patches
>> similar
>> to those in this patchset? Or are you saying that the existing vanilla
>> kernel itself does statistical grouping somehow?
> 
> so the way I scanned your patchset.. half of it is about grouping,
> the other half (roughly) is about moving stuff.
> 

Actually, either by number-of-lines or by patch count, a majority of the
patchset is about grouping, and only a few patches do the moving part.

As I mentioned in my earlier mail, patches 1-33 achieve the grouping,
whereas patches 34-40 do the movement. (Both sorted-buddy allocator and
the region allocators are grouping techniques.)

And v3 of this patchset actually didn't have the movement stuff at all,
it just had the grouping parts. And they got me upto around 120 free-regions
at the end of test run - a noticeably better consolidation ratio compared
to mainline (18).

http://article.gmane.org/gmane.linux.kernel.mm/106283

> the grouping makes total sense to me.

Ah, great!

> actively moving is the part that I am very worried about; that part
> burns power to do
> (and performance).... for which the ROI is somewhat unclear to me
> (but... data speaks. I can easily be convinced with data that proves one
> way or the other)
> 

Actually I have added some intelligence in the moving parts to avoid being
too aggressive. For example, I don't do _any_ movement if more than 32 pages
in a region are used, since it will take a considerable amount of work to
evacuate that region. Further, my evacuation/compaction technique is very
conservative:
1. I reclaim only clean page-cache pages. So no disk I/O involved.
2. I move movable pages around.
3. I allocate target pages for migration using the fast buddy-allocator
   itself, so there is not a lot of PFN scanning involved.

And that's it! No other case for page movement. And with this conservative
approach itself, I'm getting great consolidation ratios!
I am also thinking of adding more smartness in the code to be very choosy in
doing the movement, and do it only in cases where it is almost guaranteed to
be beneficial. For example, I can make the kmempowerd kthread more "lazy"
while moving/reclaiming stuff; I can bias the page movements such that "cold"
pages are left around (since they are not expected to be referenced much
anyway) and only the (few) hot pages are moved... etc.

And this aggressiveness can be exposed as a policy/knob to userspace as well,
so that the user can control its degree as he wishes.

> is moving stuff around the
> 95%-of-the-work-for-the-last-5%-of-the-theoretical-gain
> or is statistical grouping enough to get > 95% of the gain... without
> the cost of moving.
>

I certainly agree with you on the part that moving pages should really be
a last resort sort of thing, and do it only where it really pays off. So
we should definitely go with grouping first, and then see how much additional
benefit the moving stuff will bring along with the involved overhead (by
appropriate benchmarking).

But one of the goals of this patchset was to give a glimpse of all the
techniques/algorithms we can employ to consolidate memory references, and get
an idea of the extent to which such algorithms would be effective in getting
us excellent consolidation ratios.

And now that we have several techniques to choose from (and with varying
qualities and aggressiveness), we can start evaluating them more deeply and
choose the ones that give us the most benefits with least cost/overhead.
 
> 
>>
>> Also, I didn't fully understand how NUMA policy will help in this case..
>> If you want to group memory allocations/references into fewer memory
>> regions
>> _within_ a node, will NUMA policy really help? For example, in this
>> patchset,
>> everything (all the allocation/reference shaping) is done _within_ the
>> NUMA boundary, assuming that the memory regions are subsets of a NUMA
>> node.
>>
 
Regards,
Srivatsa S. Bhat

