Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3LTHsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:48:15 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42060 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3LTHsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:48:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAEr7rXiOeBCzSmbkKDPqaSt3H85wciOiG0z=-Lbi73_Lx6AkVg@mail.gmail.com>
References: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com>
	<20131119153837.GA5966@phenom.dumpdata.com>
	<1384885783.15360.40.camel@Solace>
	<CAEr7rXiCL-MagPwn76ZdTOJH03M8GCrKF2fGw0YWdnPZK332CA@mail.gmail.com>
	<CAEr7rXjgFi17vuV91R7=U4rkOKCMOw95kgWu0A0+yrfgHpR6Ow@mail.gmail.com>
	<1386206018.3926.138.camel@Abyss>
	<CAEr7rXiOeBCzSmbkKDPqaSt3H85wciOiG0z=-Lbi73_Lx6AkVg@mail.gmail.com>
Date: Fri, 20 Dec 2013 02:48:12 -0500
Message-ID: <CAEr7rXjnkeYSCRmvvFyx06Q4rccfBD__-GzkrbJhUeEOjsT8Pg@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH v2 0/2] xen: vnuma introduction for pv guest
From: Elena Ufimtseva <ufimtseva@gmail.com>
To: Dario Faggioli <dario.faggioli@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, akpm@linux-foundation.org,
        wency@cn.fujitsu.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, tangchen@cn.fujitsu.com,
        mingo@redhat.com, David Vrabel <david.vrabel@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, tglx@linutronix.de,
        Ian Campbell <ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 2:39 AM, Elena Ufimtseva <ufimtseva@gmail.com> wrote:
> On Wed, Dec 4, 2013 at 8:13 PM, Dario Faggioli
> <dario.faggioli@citrix.com> wrote:
>> On mer, 2013-12-04 at 01:20 -0500, Elena Ufimtseva wrote:
>>> On Tue, Dec 3, 2013 at 7:35 PM, Elena Ufimtseva <ufimtseva@gmail.com> wrote:
>>> > Oh guys, I feel really bad about not replying to these emails... Somehow these
>>> > replies all got deleted.. wierd.
>>> >
>> No worries... You should see *my* backlog. :-P
>>
>>> > Ok, about that automatic balancing. At the moment of the last patch
>>> > automatic numa balancing seem to
>>> > work, but after rebasing on the top of 3.12-rc2 I see similar issues.
>>> > I will try to figure out what commits broke and will contact Ingo
>>> > Molnar and Mel Gorman.
>>> >
>>> As of now I have patch v4 for reviewing. Not sure if it will be
>>> beneficial to post it for review
>>> or look closer at the current problem.
>>>
>> You mean the Linux side? Perhaps stick somewhere a reference to the git
>> tree/branch where it lives, but, before re-sending, let's wait for it to
>> be as issue free as we can tell?
>>
>>> The issue I am seeing right now is defferent from what was happening before.
>>> The corruption happens when on change_prot_numa way :
>>>
>> Ok, so, I think I need to step back a bit from the actual stack trace
>> and look at the big picture. Please, Elena or anyone, correct me if I'm
>> saying something wrong about how Linux's autonuma works and interacts
>> with Xen.
>>
>> The way it worked when I last looked at it was sort of like this:
>>  - there was a kthread scanning all the pages, removing the PAGE_PRESENT
>>    bit from actually present pages, and adding a new special one
>>    (PAGE_NUMA or something like that);
>>  - when a page fault is triggered and the PAGE_NUMA flag is found, it
>>    figures out the page is actually there, so no swap or anything.
>>    However, it tracks from what node the access to that page came from,
>>    matches it with the node where the page actually is and collect some
>>    statistics about that;
>>  - at some point (and here I don't remember the exact logic, since it
>>    changed quite a few times) pages ranking badly in the stats above are
>>    moved from one node to another.
>
> Hello Dario, Konrad.
>
> - Yes, there is a kernel worker that runs on each node and scans some
> pages stats and
> marks them as _PROT_NONE and resets _PAGE_PRESENT.
> The page fault at this moment is triggered and control is being
> returned back to the linux pv kernel
> to process with handle_mm_fault and page numa fault handler if
> discovered if that was a numa pmd/pte with
> present flag cleared.
> About the stats, I will have to collect some sensible information.
>
>>
>> Is this description still accurate? If yes, here's what I would (double)
>> check, when running this in a PV guest on top of Xen:
>>
>>  1. the NUMA hinting page fault, are we getting and handling them
>>     correctly in the PV guest? Are the stats in the guest kernel being
>>     updated in a sensible way, i.e., do they make sense and properly
>>     relate to the virtual topology of the guest?
>>     At some point we thought it would have been necessary to intercept
>>     these faults and make sure the above is true with some help from the
>>     hypervisor... Is this the case? Why? Why not?
>
> The real healp needed from hypervisor is to allow _PAGE_NUMA flags on
> pte/pmd entries.
> I have done so in hypervisor by utilizing same _PAGE_NUMA bit and
> including into the allowed bit mask.
> As this bit is the same as PAGE_GLOBAL in hypervisor, that may induce
> some other errors. So far I have not seen any
> and I will double check on this.
>
>>
>>  2. what happens when autonuma tries to move pages from one node to
>>     another? For us, that would mean in moving from one virtual node
>>     to another... Is there a need to do anything at all? I mean, is
>>     this, from our perspective, just copying the content of an MFN from
>>     node X into another MFN on node Y, or do we need to update some of
>>     our vnuma tracking data structures in Xen?
>>
>> If we have this figured out already, then I think we just chase bugs and
>> repost the series. If not, well, I think we should. :-D
>>
> here is the best part :)
>
> After a fresh look at the numa autobalancing, applying recent patches,
> talking some to riel who works now on mm numa autobalancing and
> running some tests including dd, ltp, kernel compiling and my own
> tests, autobalancing now is working
> correctly with vnuma. Now I can see sucessfully migrated pages in /proc/vmstat:
>
> numa_pte_updates 39
> numa_huge_pte_updates 0
> numa_hint_faults 36
> numa_hint_faults_local 23
> numa_pages_migrated 4
> pgmigrate_success 4
> pgmigrate_fail 0
>
> I will be running some tests with transparent huge pages as the
> migration of such will be failing.
> Probably it is possible to find all the patches related to numa
> autobalancing and figure out possible reasons
> of why previously balancing was not working. Giving the amount of work
> kernel folks spent recently to fix
> issues with numa and the significance of the changes itself, I might
> need few more attempts to understand it.
>
> I am going to test THP and if that works will follow up with patches.
>
> Dario, what tools did you use to test NUMA on xen? Maybe there is
> something I can use as well?
> Here http://lwn.net/Articles/558593/ Mel Gorman uses specjbb and jvm,
> I though I can run something similar.

And of course, more details will follow... :)



>
>> Thanks and Regards,
>> Dario
>>
>> --
>> <<This happens because I choose it to happen!>> (Raistlin Majere)
>> -----------------------------------------------------------------
>> Dario Faggioli, Ph.D, http://about.me/dario.faggioli
>> Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)
>>
>
>
>
> --
> Elena



-- 
Elena
