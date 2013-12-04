Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3LDGUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 01:20:46 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59912 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3LDGUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 01:20:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAEr7rXiCL-MagPwn76ZdTOJH03M8GCrKF2fGw0YWdnPZK332CA@mail.gmail.com>
References: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com>
	<20131119153837.GA5966@phenom.dumpdata.com>
	<1384885783.15360.40.camel@Solace>
	<CAEr7rXiCL-MagPwn76ZdTOJH03M8GCrKF2fGw0YWdnPZK332CA@mail.gmail.com>
Date: Wed, 4 Dec 2013 01:20:43 -0500
Message-ID: <CAEr7rXjgFi17vuV91R7=U4rkOKCMOw95kgWu0A0+yrfgHpR6Ow@mail.gmail.com>
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

On Tue, Dec 3, 2013 at 7:35 PM, Elena Ufimtseva <ufimtseva@gmail.com> wrote:
> On Tue, Nov 19, 2013 at 1:29 PM, Dario Faggioli
> <dario.faggioli@citrix.com> wrote:
>> On mar, 2013-11-19 at 10:38 -0500, Konrad Rzeszutek Wilk wrote:
>>> On Mon, Nov 18, 2013 at 03:25:48PM -0500, Elena Ufimtseva wrote:
>>> > The patchset introduces vnuma to paravirtualized Xen guests
>>> > runnning as domU.
>>> > Xen subop hypercall is used to retreive vnuma topology information.
>>> > Bases on the retreived topology from Xen, NUMA number of nodes,
>>> > memory ranges, distance table and cpumask is being set.
>>> > If initialization is incorrect, sets 'dummy' node and unsets
>>> > nodemask.
>>> > vNUMA topology is constructed by Xen toolstack. Xen patchset is
>>> > available at https://git.gitorious.org/xenvnuma/xenvnuma.git:v3.
>>>
>>> Yeey!
>>>
>> :-)
>>
>>> One question - I know you had questions about the
>>> PROT_GLOBAL | ~PAGE_PRESENT being set on PTEs that are going to
>>> be harvested for AutoNUMA balancing.
>>>
>>> And that the hypercall to set such PTE entry disallows the
>>> PROT_GLOBAL (it stripts it off)? That means that when the
>>> Linux page system kicks in (as it has ~PAGE_PRESENT) the
>>> Linux pagehandler won't see the PROT_GLOBAL (as it has
>>> been filtered out). Which means that the AutoNUMA code won't
>>> kick in.
>>>
>>> (see http://article.gmane.org/gmane.comp.emulators.xen.devel/174317)
>>>
>>> Was that problem ever answered?
>>>
>> I think the issue is a twofold one.
>>
>> If I remember correctly (Elena, please, correct me if I'm wrong) Elena
>> was seeing _crashes_ with both vNUMA and AutoNUMA enabled for the guest.
>> That's what pushed her to investigate the issue, and led to what you're
>> summing up above.
>>
>> However, it appears the crash was due to something completely unrelated
>> to Xen and vNUMA, was affecting baremetal too, and got fixed, which
>> means the crash is now gone.
>>
>> It remains to be seen (I think) whether that also means that AutoNUMA
>> works. In fact, chatting about this in Edinburgh, Elena managed to
>> convince me pretty badly that we should --as part of the vNUMA support--
>> do something about this, in order to make it work. At that time I
>> thought we should be doing something to avoid the system to go ka-boom,
>> but as I said, even now that it does not crash anymore, she was so
>> persuasive that I now find it quite hard to believe that we really don't
>> need to do anything. :-P
>
> Yes, you were right Dario :) See at the end. pv guests do not crash,
> but they have user space memory corruption.
> Ok, so I will try to understand what again had happened during this
> weekend.
> Meanwhile posting patches for Xen.
>
>>
>> I guess, as soon as we get the chance, we should see if this actually
>> works, i.e., in addition to seeing the proper topology and not crashing,
>> verify that AutoNUMA in the guest is actually doing is job.
>>
>> What do you think? Again, Elena, please chime in and explain how things
>> are, if I got something wrong. :-)
>>
>
> Oh guys, I feel really bad about not replying to these emails... Somehow these
> replies all got deleted.. wierd.
>
> Ok, about that automatic balancing. At the moment of the last patch
> automatic numa balancing seem to
> work, but after rebasing on the top of 3.12-rc2 I see similar issues.
> I will try to figure out what commits broke and will contact Ingo
> Molnar and Mel Gorman.
>
> Konrad,
> as of PROT_GLOBAL flag, I will double check once more to exclude
> errors from my side.
> Last time I was able to have numa_balancing working without any
> modifications from hypervisor side.
> But again, I want to double check this, some experiments might have
> appear being good :)
>
>
>> Regards,
>> Dario
>>
>> --
>> <<This happens because I choose it to happen!>> (Raistlin Majere)
>> -----------------------------------------------------------------
>> Dario Faggioli, Ph.D, http://about.me/dario.faggioli
>> Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)
>>
>

As of now I have patch v4 for reviewing. Not sure if it will be
beneficial to post it for review
or look closer at the current problem.
The issue I am seeing right now is defferent from what was happening before.
The corruption happens when on change_prot_numa way :

[ 6638.021439]  pfn 45e602, highest_memmap_pfn - 14ddd7
[ 6638.021444] BUG: Bad page map in process dd  pte:800000045e602166
pmd:abf1a067
[ 6638.021449] addr:00007f4fda2d8000 vm_flags:00100073
anon_vma:ffff8800abf77b90 mapping:          (null) index:7f4fda2d8
[ 6638.021457] CPU: 1 PID: 1033 Comm: dd Tainted: G    B   W    3.13.0-rc2+ #10
[ 6638.021462]  0000000000000000 00007f4fda2d8000 ffffffff813ca5b1
ffff88010d68deb8
[ 6638.021471]  ffffffff810f2c88 00000000abf1a067 800000045e602166
0000000000000000
[ 6638.021482]  000000000045e602 ffff88010d68deb8 00007f4fda2d8000
800000045e602166
[ 6638.021492] Call Trace:
[ 6638.021497]  [<ffffffff813ca5b1>] ? dump_stack+0x41/0x51
[ 6638.021503]  [<ffffffff810f2c88>] ? print_bad_pte+0x19d/0x1c9
[ 6638.021509]  [<ffffffff810f3aef>] ? vm_normal_page+0x94/0xb3
[ 6638.021519]  [<ffffffff810fb788>] ? change_protection+0x35c/0x5a8
[ 6638.021527]  [<ffffffff81107965>] ? change_prot_numa+0x13/0x24
[ 6638.021533]  [<ffffffff81071697>] ? task_numa_work+0x1fb/0x299
[ 6638.021539]  [<ffffffff8105ef54>] ? task_work_run+0x7b/0x8f
[ 6638.021545]  [<ffffffff8100e658>] ? do_notify_resume+0x53/0x68
[ 6638.021552]  [<ffffffff813d4432>] ? int_signal+0x12/0x17
[ 6638.021560]  pfn 45d732, highest_memmap_pfn - 14ddd7
[ 6638.021565] BUG: Bad page map in process dd  pte:800000045d732166
pmd:10d684067
[ 6638.021572] addr:00007fff7c143000 vm_flags:00100173
anon_vma:ffff8800abf77960 mapping:          (null) index:7fffffffc
[ 6638.021582] CPU: 1 PID: 1033 Comm: dd Tainted: G    B   W    3.13.0-rc2+ #10
[ 6638.021587]  0000000000000000 00007fff7c143000 ffffffff813ca5b1
ffff8800abf339b0
[ 6638.021595]  ffffffff810f2c88 000000010d684067 800000045d732166
0000000000000000
[ 6638.021603]  000000000045d732 ffff8800abf339b0 00007fff7c143000
800000045d732166

The code has changed since last problem, I will work on this to see
where it comes from.

Elena

>
>
> --
> Elena



-- 
Elena
