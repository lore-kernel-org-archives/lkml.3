Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaH2Ons (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:43:48 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:22716 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaH2Onr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:43:47 -0400
X-IronPort-AV: E=Sophos;i="5.04,424,1406592000"; 
   d="scan'208";a="167187110"
Message-ID: <5400919F.5090801@citrix.com>
Date: Fri, 29 Aug 2014 15:43:43 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kees Cook <keescook@chromium.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH] Solved the Xen PV/KASLR riddle
References: <20140827204940.GA10556@laptop.dumpdata.com> <1409248903-19625-1-git-send-email-stefan.bader@canonical.com> <53FFB045.9010809@citrix.com> <54003BE5.5010603@canonical.com> <54008BF2.5050905@citrix.com> <54008F05.9090403@canonical.com>
In-Reply-To: <54008F05.9090403@canonical.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/14 15:32, Stefan Bader wrote:
> On 29.08.2014 16:19, Andrew Cooper wrote:
>> On 29/08/14 09:37, Stefan Bader wrote:
>>> On 29.08.2014 00:42, Andrew Cooper wrote:
>>>> On 28/08/2014 19:01, Stefan Bader wrote:
>>>>>>> So not much further... but then I think I know what I do next. Probably should
>>>>>>> have done before. I'll replace the WARN_ON in vmalloc that triggers by a panic
>>>>>>> and at least get a crash dump of that situation when it occurs. Then I can dig
>>>>>>> in there with crash (really should have thought of that before)...
>>>>>> <nods> I dug a bit in the code (arch/x86/xen/mmu.c) but there is nothing there
>>>>>> that screams at me, so I fear I will have to wait until you get the crash
>>>>>> and get some clues from that.
>>>>> Ok, what a journey. So after long hours of painful staring at the code...
>>>>> (and btw, if someone could tell me how the heck one can do a mfn_to_pfn
>>>>> in crash, I really would appreaciate :-P)
>>>> The M2P map lives in the Xen reserved virtual address space in each PV
>>>> guest, and forms part of the PV ABI.  It is mapped read-only, in the
>>>> native width of the guest.
>>>>
>>>> 32bit PV (PAE) at 0xF5800000
>>>> 64bit PV at 0xFFFF800000000000
>>>>
>>>> This is represented by the MACH2PHYS_VIRT_START symbol from the Xen
>>>> public header files.  You should be able to blindly construct a pointer
>>>> to it (if you have nothing better to hand), as it will be hooked into
>>>> the guests pagetables before execution starts.  Therefore,
>>>> "MACH2PHYS_VIRT_START[(unsigned long)pfn]" ought to do in a pinch.
>>> machine_to_phys_mapping is set to that address but its not mapped inside the
>>> crash dump. Somehow vtop in crash handles translations. I need to have a look at
>>> their code, I guess.
>>>
>>> Thanks,
>>> Stefan
>> What context is the crash dump?  If it is a Xen+dom0 kexec()d to native
>> linux, then the m2p should still be accessible given dom0's cr3.  If it
>> is some state copied off-host then you will need to adjust the copy to
>> include that virtual range.
> No its a domU dump of a PV guest taken with "xl dump-core" (or actually the
> result of on-crash trigger).

Ah - I believe the m2p lives in one of the Xen elf notes for a domain
coredump.  See what readelf -n shows.

~Andrew
