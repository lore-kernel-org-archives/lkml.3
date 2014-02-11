Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaBKScC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:32:02 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:45214 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaBKScA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:32:00 -0500
MIME-Version: 1.0
In-Reply-To: <20140211165013.GV27965@twins.programming.kicks-ass.net>
References: <1392132015-14521-1-git-send-email-eranian@google.com>
	<1392132015-14521-7-git-send-email-eranian@google.com>
	<20140211161905.GS27965@twins.programming.kicks-ass.net>
	<CABPqkBRmt120Xn02sR8nhFCjuxSJ7xZbE4-G57x7rgsmB3nwNg@mail.gmail.com>
	<20140211165013.GV27965@twins.programming.kicks-ass.net>
Date: Tue, 11 Feb 2014 19:31:59 +0100
Message-ID: <CABPqkBSoW5bUret1-Rnm4AQSVrDm+CkrzuzZzdeh9HN8bsj58Q@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] perf/x86/uncore: add SNB/IVB/HSW client uncore
 memory controller support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 5:50 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Feb 11, 2014 at 05:25:39PM +0100, Stephane Eranian wrote:
>> On Tue, Feb 11, 2014 at 5:19 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Tue, Feb 11, 2014 at 04:20:12PM +0100, Stephane Eranian wrote:
>> >> This patch adds a new uncore PMU for Intel SNB/IVB/HSW client
>> >
>> >
>> >> @@ -3501,6 +3844,28 @@ static int __init uncore_pci_init(void)
>> >>               pci_uncores = ivt_pci_uncores;
>> >>               uncore_pci_driver = &ivt_uncore_pci_driver;
>> >>               break;
>> >> +     case 42: /* Sandy Bridge */
>> >> +             ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_SNB_IMC);
>> >> +             if (ret)
>> >> +                     return ret;
>> >> +             pci_uncores = snb_pci_uncores;
>> >> +             uncore_pci_driver = &snb_uncore_pci_driver;
>> >> +             break;
>> >> +     case 60: /* Haswell */
>> >> +     case 69: /* Haswell Celeron */
>> >> +             ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_HSW_IMC);
>> >> +             if (ret)
>> >> +                     return ret;
>> >> +             pci_uncores = snb_pci_uncores;
>> >> +             uncore_pci_driver = &hsw_uncore_pci_driver;
>> >> +             break;
>> >> +     case 58: /* Ivy Bridge */
>> >> +             ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_IVB_IMC);
>> >> +             if (ret)
>> >> +                     return ret;
>> >> +             pci_uncores = snb_pci_uncores;
>> >> +             uncore_pci_driver = &ivb_uncore_pci_driver;
>> >> +             break;
>> >>       default:
>> >>               return 0;
>> >>       }
>> >
>> > I reorderd that list; but looking at perf_event_intel.c we have a lot
>> > more HSW clients listed there. Plz as to make it consistent.
>>
>> I don't have all of them, so no testing possible. I doubt they have so
>> many clients model numbers.
>
> Yeah, I don't have any of those chips.. last I have is WSM-EP.
>
> Anyway, perf_event_intel.c lists: 60,63,69,70,71 as being haswell
> clients.  Andi did all that, so if its wrong its on Intel anyway.
>
What he has is okay for core. They all have the same core PMU at 99%.
But the uncore can be radically different. Look at IVB (58) vs IVB-EP (62).
So this is more risky there. That is why I did not add the other model numbers.

> I'm still thinking we ought to make a big Intel classification function;
> something that returns something like:
>
> struct intel_part {
>         enum { client, ep, ex } type;
>         enum { core, core2, nhm, wsm, snb, ivb, hsw } gen;
> };
>
> And we can do things like:
>
>   if (ip.type == client && ip.gen >= snb)
>
> And then we only have to fix up the one classification function with all
> those stupid model numbers, instead of having them duplicated all over
> the stinking place.

Yeah, I am not opposed to that idea for PMU purposes.
