Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbaGWIFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:05:48 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:49929 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753919AbaGWIFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:05:37 -0400
Message-ID: <53CF6CC4.6090207@daenzer.net>
Date: Wed, 23 Jul 2014 17:05:24 +0900
From: =?windows-1252?Q?Michel_D=E4nzer?= <michel@daenzer.net>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
References: <53C77BB8.6030804@daenzer.net> <20140717075820.GE19379@twins.programming.kicks-ass.net> <53C8E90F.1010306@daenzer.net> <53CE00EF.70108@daenzer.net> <53CF31AE.30403@daenzer.net> <CA+55aFwyURgG717kmuAXzKcHddN_63GirtwHZB4ePKH+8qVtJw@mail.gmail.com> <20140723064948.GK3935@laptop>
In-Reply-To: <20140723064948.GK3935@laptop>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
 boundary="------------040501070900020109070301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040501070900020109070301
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 23.07.2014 15:49, Peter Zijlstra wrote:
> On Tue, Jul 22, 2014 at 09:21:40PM -0700, Linus Torvalds wrote:
>> On Tue, Jul 22, 2014 at 8:53 PM, Michel Dänzer <michel@daenzer.net> wrote:
>>>
>>> Just happened again with the same change on top of 3.16-rc6.
>>
>> The (maybe) related bugzilla entry is just odd. Bruno Wolff reports
>> that the BUG_ON() in his added patch triggers:
>>
>> +               cpumask_clear(sched_group_cpus(sg));
>> +               sg->sgc->capacity = 0;
>> +               BUG_ON(!cpumask_empty(sched_group_cpus(sg)));
>>
>> where it *just* did a cpumask_clear(), and now the BUG_ON() triggers
>> that it's no longer empty?
>>
>> That would imply an allocation error, but all the sched groups seem to
>> be properly allocated with the proper addition of cpumask_size().
>>
>> And his config file even has NR_CPUS being 32, so it should be a
>> single word of bitmap, which triggers all the simple code.
>>
>> Completely insane, in other words.
> 
> So we've had this other thread where the same happened:
> 
>  lkml.kernel.org/r/20140716145546.GA6922@wolff.to
> 
> (pointed Michel to that earlier)
> 
> And that seems to be sorted now (just found positive feedback in my
> Inbox this morning), it was a question of the arch code supplying
> completely 'broken' topology information, and the scheduler trusting it
> too much.
> 
> The real fix in that thread is:
> 
>  lkml.kernel.org/r/20140722133514.GM12054@laptop.lan
> 
> And I'll also add this to make the scheduler less trusting:
> 
>  lkml.kernel.org/r/20140722094740.GJ12054@laptop.lan
> 
> Michael, that's not going to tell us what's wrong with your machine, as
> you've not got the ancient dual P4 Xeon Bruno's got. Seeing how your
> cpuinfo says:
> 
> model name      : AMD A10-7850K Radeon R7, 12 Compute Cores 4C+8G
> 
> but we can start the same debugging session I suppose.
> 
> Could you run with this patch on top:
> 
>  lkml.kernel.org/r/20140718101633.GP9918@twins.programming.kicks-ass.net
> 
> And provide us with the dmesg after boot?

Attached. No FAIL messages yet.


-- 
Earthling Michel Dänzer            |                  http://www.amd.com
Libre software enthusiast          |                Mesa and X developer

--------------040501070900020109070301
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-rc6+ (daenzer@kaveri) (gcc version 4.9.0 (Debian 4.9.0-9) ) #146 SMP Wed Jul 23 16:58:12 JST 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.16.0-rc6+ root=/dev/mapper/VG--Debian-LV--sid ro init=/bin/systemd quiet radeon.lockup_timeout=0
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dcd1cfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dcd1d000-0x00000000dd154fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dd155000-0x00000000dd164fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dd165000-0x00000000dd6d0fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dd6d1000-0x00000000de50afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000de50b000-0x00000000de565fff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000de566000-0x00000000de566fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de567000-0x00000000de76cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000de76d000-0x00000000deba6fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000deba7000-0x00000000deff3fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000deff4000-0x00000000deffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v32.31 by American Megatrends
[    0.000000] efi:  ACPI=0xdd15c000  ACPI 2.0=0xdd15c000  SMBIOS=0xf04c0  MPS=0xfd440 
[    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] efi: mem01: type=7, attr=0xf, range=[0x0000000000008000-0x000000000005f000) (0MB)
[    0.000000] efi: mem02: type=4, attr=0xf, range=[0x000000000005f000-0x0000000000060000) (0MB)
[    0.000000] efi: mem03: type=3, attr=0xf, range=[0x0000000000060000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000001000000-0x0000000002aa5000) (26MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000002aa5000-0x00000000378b2000) (846MB)
[    0.000000] efi: mem07: type=2, attr=0xf, range=[0x00000000378b2000-0x0000000037c51000) (3MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x0000000037c51000-0x0000000098307000) (1542MB)
[    0.000000] efi: mem09: type=2, attr=0xf, range=[0x0000000098307000-0x00000000cc1b1000) (830MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x00000000cc1b1000-0x00000000cc1b7000) (0MB)
[    0.000000] efi: mem11: type=1, attr=0xf, range=[0x00000000cc1b7000-0x00000000cc1da000) (0MB)
[    0.000000] efi: mem12: type=7, attr=0xf, range=[0x00000000cc1da000-0x00000000cf4b7000) (50MB)
[    0.000000] efi: mem13: type=4, attr=0xf, range=[0x00000000cf4b7000-0x00000000cf567000) (0MB)
[    0.000000] efi: mem14: type=7, attr=0xf, range=[0x00000000cf567000-0x00000000cf56f000) (0MB)
[    0.000000] efi: mem15: type=4, attr=0xf, range=[0x00000000cf56f000-0x00000000cf595000) (0MB)
[    0.000000] efi: mem16: type=7, attr=0xf, range=[0x00000000cf595000-0x00000000cf5a1000) (0MB)
[    0.000000] efi: mem17: type=4, attr=0xf, range=[0x00000000cf5a1000-0x00000000cf5dc000) (0MB)
[    0.000000] efi: mem18: type=7, attr=0xf, range=[0x00000000cf5dc000-0x00000000cf5ed000) (0MB)
[    0.000000] efi: mem19: type=4, attr=0xf, range=[0x00000000cf5ed000-0x00000000cf61f000) (0MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x00000000cf61f000-0x00000000cf633000) (0MB)
[    0.000000] efi: mem21: type=4, attr=0xf, range=[0x00000000cf633000-0x00000000cf639000) (0MB)
[    0.000000] efi: mem22: type=7, attr=0xf, range=[0x00000000cf639000-0x00000000cf642000) (0MB)
[    0.000000] efi: mem23: type=4, attr=0xf, range=[0x00000000cf642000-0x00000000cf66a000) (0MB)
[    0.000000] efi: mem24: type=7, attr=0xf, range=[0x00000000cf66a000-0x00000000cf67f000) (0MB)
[    0.000000] efi: mem25: type=4, attr=0xf, range=[0x00000000cf67f000-0x00000000cf6b7000) (0MB)
[    0.000000] efi: mem26: type=7, attr=0xf, range=[0x00000000cf6b7000-0x00000000cf6cf000) (0MB)
[    0.000000] efi: mem27: type=4, attr=0xf, range=[0x00000000cf6cf000-0x00000000cf6ea000) (0MB)
[    0.000000] efi: mem28: type=7, attr=0xf, range=[0x00000000cf6ea000-0x00000000cf6f7000) (0MB)
[    0.000000] efi: mem29: type=4, attr=0xf, range=[0x00000000cf6f7000-0x00000000cf713000) (0MB)
[    0.000000] efi: mem30: type=7, attr=0xf, range=[0x00000000cf713000-0x00000000cf71f000) (0MB)
[    0.000000] efi: mem31: type=4, attr=0xf, range=[0x00000000cf71f000-0x00000000cf7e9000) (0MB)
[    0.000000] efi: mem32: type=7, attr=0xf, range=[0x00000000cf7e9000-0x00000000cf7f1000) (0MB)
[    0.000000] efi: mem33: type=4, attr=0xf, range=[0x00000000cf7f1000-0x00000000cf817000) (0MB)
[    0.000000] efi: mem34: type=7, attr=0xf, range=[0x00000000cf817000-0x00000000cf823000) (0MB)
[    0.000000] efi: mem35: type=4, attr=0xf, range=[0x00000000cf823000-0x00000000cf85f000) (0MB)
[    0.000000] efi: mem36: type=7, attr=0xf, range=[0x00000000cf85f000-0x00000000cf870000) (0MB)
[    0.000000] efi: mem37: type=4, attr=0xf, range=[0x00000000cf870000-0x00000000cf8a2000) (0MB)
[    0.000000] efi: mem38: type=7, attr=0xf, range=[0x00000000cf8a2000-0x00000000cf8b6000) (0MB)
[    0.000000] efi: mem39: type=4, attr=0xf, range=[0x00000000cf8b6000-0x00000000cf8bd000) (0MB)
[    0.000000] efi: mem40: type=7, attr=0xf, range=[0x00000000cf8bd000-0x00000000cf8c6000) (0MB)
[    0.000000] efi: mem41: type=4, attr=0xf, range=[0x00000000cf8c6000-0x00000000cf8ed000) (0MB)
[    0.000000] efi: mem42: type=7, attr=0xf, range=[0x00000000cf8ed000-0x00000000cf902000) (0MB)
[    0.000000] efi: mem43: type=4, attr=0xf, range=[0x00000000cf902000-0x00000000cf939000) (0MB)
[    0.000000] efi: mem44: type=7, attr=0xf, range=[0x00000000cf939000-0x00000000cf951000) (0MB)
[    0.000000] efi: mem45: type=4, attr=0xf, range=[0x00000000cf951000-0x00000000cf982000) (0MB)
[    0.000000] efi: mem46: type=7, attr=0xf, range=[0x00000000cf982000-0x00000000cf998000) (0MB)
[    0.000000] efi: mem47: type=4, attr=0xf, range=[0x00000000cf998000-0x00000000cf9e8000) (0MB)
[    0.000000] efi: mem48: type=7, attr=0xf, range=[0x00000000cf9e8000-0x00000000cfa04000) (0MB)
[    0.000000] efi: mem49: type=4, attr=0xf, range=[0x00000000cfa04000-0x00000000cfa6a000) (0MB)
[    0.000000] efi: mem50: type=7, attr=0xf, range=[0x00000000cfa6a000-0x00000000cfa72000) (0MB)
[    0.000000] efi: mem51: type=4, attr=0xf, range=[0x00000000cfa72000-0x00000000cfa98000) (0MB)
[    0.000000] efi: mem52: type=7, attr=0xf, range=[0x00000000cfa98000-0x00000000cfaa4000) (0MB)
[    0.000000] efi: mem53: type=4, attr=0xf, range=[0x00000000cfaa4000-0x00000000cfadf000) (0MB)
[    0.000000] efi: mem54: type=7, attr=0xf, range=[0x00000000cfadf000-0x00000000cfaf0000) (0MB)
[    0.000000] efi: mem55: type=4, attr=0xf, range=[0x00000000cfaf0000-0x00000000cfb22000) (0MB)
[    0.000000] efi: mem56: type=7, attr=0xf, range=[0x00000000cfb22000-0x00000000cfb36000) (0MB)
[    0.000000] efi: mem57: type=4, attr=0xf, range=[0x00000000cfb36000-0x00000000cfb3c000) (0MB)
[    0.000000] efi: mem58: type=7, attr=0xf, range=[0x00000000cfb3c000-0x00000000cfb45000) (0MB)
[    0.000000] efi: mem59: type=4, attr=0xf, range=[0x00000000cfb45000-0x00000000cfb6d000) (0MB)
[    0.000000] efi: mem60: type=7, attr=0xf, range=[0x00000000cfb6d000-0x00000000cfb82000) (0MB)
[    0.000000] efi: mem61: type=4, attr=0xf, range=[0x00000000cfb82000-0x00000000cfbba000) (0MB)
[    0.000000] efi: mem62: type=7, attr=0xf, range=[0x00000000cfbba000-0x00000000cfbbc000) (0MB)
[    0.000000] efi: mem63: type=4, attr=0xf, range=[0x00000000cfbbc000-0x00000000cfcec000) (1MB)
[    0.000000] efi: mem64: type=7, attr=0xf, range=[0x00000000cfcec000-0x00000000cfcf4000) (0MB)
[    0.000000] efi: mem65: type=4, attr=0xf, range=[0x00000000cfcf4000-0x00000000cfd1a000) (0MB)
[    0.000000] efi: mem66: type=7, attr=0xf, range=[0x00000000cfd1a000-0x00000000cfd26000) (0MB)
[    0.000000] efi: mem67: type=4, attr=0xf, range=[0x00000000cfd26000-0x00000000cfd62000) (0MB)
[    0.000000] efi: mem68: type=7, attr=0xf, range=[0x00000000cfd62000-0x00000000cfd73000) (0MB)
[    0.000000] efi: mem69: type=4, attr=0xf, range=[0x00000000cfd73000-0x00000000cfda5000) (0MB)
[    0.000000] efi: mem70: type=7, attr=0xf, range=[0x00000000cfda5000-0x00000000cfdb9000) (0MB)
[    0.000000] efi: mem71: type=4, attr=0xf, range=[0x00000000cfdb9000-0x00000000cfdc2000) (0MB)
[    0.000000] efi: mem72: type=7, attr=0xf, range=[0x00000000cfdc2000-0x00000000cfdcb000) (0MB)
[    0.000000] efi: mem73: type=4, attr=0xf, range=[0x00000000cfdcb000-0x00000000cfdef000) (0MB)
[    0.000000] efi: mem74: type=7, attr=0xf, range=[0x00000000cfdef000-0x00000000cfe04000) (0MB)
[    0.000000] efi: mem75: type=4, attr=0xf, range=[0x00000000cfe04000-0x00000000cfe3c000) (0MB)
[    0.000000] efi: mem76: type=7, attr=0xf, range=[0x00000000cfe3c000-0x00000000cfe54000) (0MB)
[    0.000000] efi: mem77: type=4, attr=0xf, range=[0x00000000cfe54000-0x00000000cfe89000) (0MB)
[    0.000000] efi: mem78: type=7, attr=0xf, range=[0x00000000cfe89000-0x00000000cfe9f000) (0MB)
[    0.000000] efi: mem79: type=4, attr=0xf, range=[0x00000000cfe9f000-0x00000000cff6f000) (0MB)
[    0.000000] efi: mem80: type=7, attr=0xf, range=[0x00000000cff6f000-0x00000000cff77000) (0MB)
[    0.000000] efi: mem81: type=4, attr=0xf, range=[0x00000000cff77000-0x00000000cffa0000) (0MB)
[    0.000000] efi: mem82: type=7, attr=0xf, range=[0x00000000cffa0000-0x00000000cffa3000) (0MB)
[    0.000000] efi: mem83: type=4, attr=0xf, range=[0x00000000cffa3000-0x00000000d00c1000) (1MB)
[    0.000000] efi: mem84: type=7, attr=0xf, range=[0x00000000d00c1000-0x00000000d00c3000) (0MB)
[    0.000000] efi: mem85: type=4, attr=0xf, range=[0x00000000d00c3000-0x00000000d010d000) (0MB)
[    0.000000] efi: mem86: type=7, attr=0xf, range=[0x00000000d010d000-0x00000000d010e000) (0MB)
[    0.000000] efi: mem87: type=4, attr=0xf, range=[0x00000000d010e000-0x00000000d01f9000) (0MB)
[    0.000000] efi: mem88: type=7, attr=0xf, range=[0x00000000d01f9000-0x00000000d0201000) (0MB)
[    0.000000] efi: mem89: type=4, attr=0xf, range=[0x00000000d0201000-0x00000000d0348000) (1MB)
[    0.000000] efi: mem90: type=7, attr=0xf, range=[0x00000000d0348000-0x00000000d034b000) (0MB)
[    0.000000] efi: mem91: type=4, attr=0xf, range=[0x00000000d034b000-0x00000000d03a0000) (0MB)
[    0.000000] efi: mem92: type=7, attr=0xf, range=[0x00000000d03a0000-0x00000000d03a4000) (0MB)
[    0.000000] efi: mem93: type=4, attr=0xf, range=[0x00000000d03a4000-0x00000000d0491000) (0MB)
[    0.000000] efi: mem94: type=7, attr=0xf, range=[0x00000000d0491000-0x00000000d0499000) (0MB)
[    0.000000] efi: mem95: type=4, attr=0xf, range=[0x00000000d0499000-0x00000000d0595000) (0MB)
[    0.000000] efi: mem96: type=7, attr=0xf, range=[0x00000000d0595000-0x00000000d0596000) (0MB)
[    0.000000] efi: mem97: type=4, attr=0xf, range=[0x00000000d0596000-0x00000000d05df000) (0MB)
[    0.000000] efi: mem98: type=7, attr=0xf, range=[0x00000000d05df000-0x00000000d05e1000) (0MB)
[    0.000000] efi: mem99: type=4, attr=0xf, range=[0x00000000d05e1000-0x00000000d061b000) (0MB)
[    0.000000] efi: mem100: type=7, attr=0xf, range=[0x00000000d061b000-0x00000000d061c000) (0MB)
[    0.000000] efi: mem101: type=4, attr=0xf, range=[0x00000000d061c000-0x00000000d067e000) (0MB)
[    0.000000] efi: mem102: type=7, attr=0xf, range=[0x00000000d067e000-0x00000000d0683000) (0MB)
[    0.000000] efi: mem103: type=4, attr=0xf, range=[0x00000000d0683000-0x00000000d0715000) (0MB)
[    0.000000] efi: mem104: type=7, attr=0xf, range=[0x00000000d0715000-0x00000000d071d000) (0MB)
[    0.000000] efi: mem105: type=4, attr=0xf, range=[0x00000000d071d000-0x00000000d07ce000) (0MB)
[    0.000000] efi: mem106: type=7, attr=0xf, range=[0x00000000d07ce000-0x00000000d07d5000) (0MB)
[    0.000000] efi: mem107: type=4, attr=0xf, range=[0x00000000d07d5000-0x00000000d0818000) (0MB)
[    0.000000] efi: mem108: type=7, attr=0xf, range=[0x00000000d0818000-0x00000000d081c000) (0MB)
[    0.000000] efi: mem109: type=4, attr=0xf, range=[0x00000000d081c000-0x00000000d0866000) (0MB)
[    0.000000] efi: mem110: type=7, attr=0xf, range=[0x00000000d0866000-0x00000000d086c000) (0MB)
[    0.000000] efi: mem111: type=4, attr=0xf, range=[0x00000000d086c000-0x00000000d0888000) (0MB)
[    0.000000] efi: mem112: type=7, attr=0xf, range=[0x00000000d0888000-0x00000000d088a000) (0MB)
[    0.000000] efi: mem113: type=4, attr=0xf, range=[0x00000000d088a000-0x00000000d08bb000) (0MB)
[    0.000000] efi: mem114: type=7, attr=0xf, range=[0x00000000d08bb000-0x00000000d08bc000) (0MB)
[    0.000000] efi: mem115: type=4, attr=0xf, range=[0x00000000d08bc000-0x00000000d0920000) (0MB)
[    0.000000] efi: mem116: type=7, attr=0xf, range=[0x00000000d0920000-0x00000000d0921000) (0MB)
[    0.000000] efi: mem117: type=4, attr=0xf, range=[0x00000000d0921000-0x00000000d0d17000) (3MB)
[    0.000000] efi: mem118: type=7, attr=0xf, range=[0x00000000d0d17000-0x00000000d0d1d000) (0MB)
[    0.000000] efi: mem119: type=4, attr=0xf, range=[0x00000000d0d1d000-0x00000000d0e93000) (1MB)
[    0.000000] efi: mem120: type=7, attr=0xf, range=[0x00000000d0e93000-0x00000000d0e94000) (0MB)
[    0.000000] efi: mem121: type=4, attr=0xf, range=[0x00000000d0e94000-0x00000000d1163000) (2MB)
[    0.000000] efi: mem122: type=7, attr=0xf, range=[0x00000000d1163000-0x00000000d1165000) (0MB)
[    0.000000] efi: mem123: type=4, attr=0xf, range=[0x00000000d1165000-0x00000000d1171000) (0MB)
[    0.000000] efi: mem124: type=7, attr=0xf, range=[0x00000000d1171000-0x00000000d1172000) (0MB)
[    0.000000] efi: mem125: type=4, attr=0xf, range=[0x00000000d1172000-0x00000000d1877000) (7MB)
[    0.000000] efi: mem126: type=7, attr=0xf, range=[0x00000000d1877000-0x00000000d1879000) (0MB)
[    0.000000] efi: mem127: type=4, attr=0xf, range=[0x00000000d1879000-0x00000000dbf98000) (167MB)
[    0.000000] efi: mem128: type=7, attr=0xf, range=[0x00000000dbf98000-0x00000000dc54a000) (5MB)
[    0.000000] efi: mem129: type=2, attr=0xf, range=[0x00000000dc54a000-0x00000000dc556000) (0MB)
[    0.000000] efi: mem130: type=3, attr=0xf, range=[0x00000000dc556000-0x00000000dcd1d000) (7MB)
[    0.000000] efi: mem131: type=0, attr=0xf, range=[0x00000000dcd1d000-0x00000000dcdf5000) (0MB)
[    0.000000] efi: mem132: type=0, attr=0xf, range=[0x00000000dcdf5000-0x00000000dd155000) (3MB)
[    0.000000] efi: mem133: type=9, attr=0xf, range=[0x00000000dd155000-0x00000000dd15c000) (0MB)
[    0.000000] efi: mem134: type=9, attr=0xf, range=[0x00000000dd15c000-0x00000000dd165000) (0MB)
[    0.000000] efi: mem135: type=10, attr=0xf, range=[0x00000000dd165000-0x00000000dd484000) (3MB)
[    0.000000] efi: mem136: type=10, attr=0xf, range=[0x00000000dd484000-0x00000000dd6d1000) (2MB)
[    0.000000] efi: mem137: type=6, attr=0x800000000000000f, range=[0x00000000dd6d1000-0x00000000dddf2000) (7MB)
[    0.000000] efi: mem138: type=6, attr=0x800000000000000f, range=[0x00000000dddf2000-0x00000000de439000) (6MB)
[    0.000000] efi: mem139: type=6, attr=0x800000000000000f, range=[0x00000000de439000-0x00000000de43d000) (0MB)
[    0.000000] efi: mem140: type=6, attr=0x800000000000000f, range=[0x00000000de43d000-0x00000000de50b000) (0MB)
[    0.000000] efi: mem141: type=5, attr=0x800000000000000f, range=[0x00000000de50b000-0x00000000de51d000) (0MB)
[    0.000000] efi: mem142: type=5, attr=0x800000000000000f, range=[0x00000000de51d000-0x00000000de566000) (0MB)
[    0.000000] efi: mem143: type=4, attr=0xf, range=[0x00000000de566000-0x00000000de567000) (0MB)
[    0.000000] efi: mem144: type=10, attr=0xf, range=[0x00000000de567000-0x00000000de76d000) (2MB)
[    0.000000] efi: mem145: type=4, attr=0xf, range=[0x00000000de76d000-0x00000000de8bf000) (1MB)
[    0.000000] efi: mem146: type=3, attr=0xf, range=[0x00000000de8bf000-0x00000000deb65000) (2MB)
[    0.000000] efi: mem147: type=4, attr=0xf, range=[0x00000000deb65000-0x00000000deb7f000) (0MB)
[    0.000000] efi: mem148: type=3, attr=0xf, range=[0x00000000deb7f000-0x00000000deb9b000) (0MB)
[    0.000000] efi: mem149: type=4, attr=0xf, range=[0x00000000deb9b000-0x00000000deba7000) (0MB)
[    0.000000] efi: mem150: type=6, attr=0x800000000000000f, range=[0x00000000deba7000-0x00000000deff4000) (4MB)
[    0.000000] efi: mem151: type=4, attr=0xf, range=[0x00000000deff4000-0x00000000df000000) (0MB)
[    0.000000] efi: mem152: type=7, attr=0xf, range=[0x0000000100000000-0x000000021f000000) (4592MB)
[    0.000000] efi: mem153: type=11, attr=0x8000000000000001, range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem154: type=11, attr=0x8000000000000001, range=[0x00000000fec01000-0x00000000fec02000) (0MB)
[    0.000000] efi: mem155: type=11, attr=0x8000000000000001, range=[0x00000000fec10000-0x00000000fec11000) (0MB)
[    0.000000] efi: mem156: type=11, attr=0x8000000000000001, range=[0x00000000fed00000-0x00000000fed01000) (0MB)
[    0.000000] efi: mem157: type=11, attr=0x8000000000000001, range=[0x00000000fed80000-0x00000000fed81000) (0MB)
[    0.000000] efi: mem158: type=11, attr=0x8000000000000001, range=[0x00000000fed81000-0x00000000fed90000) (0MB)
[    0.000000] efi: mem159: type=11, attr=0x8000000000000001, range=[0x00000000ff000000-0x0000000100000000) (16MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: System manufacturer System Product Name/A88X-PRO, BIOS 1001 04/01/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x21f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 base 0000D0000000 mask FFFFF8000000 write-back
[    0.000000]   4 base 0000D8000000 mask FFFFFC000000 write-back
[    0.000000]   5 base 0000DC000000 mask FFFFFE000000 write-back
[    0.000000]   6 base 0000DE000000 mask FFFFFF000000 write-back
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000021f000000 aka 8688M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xdf000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdf000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd770-0x000fd77f] mapped at [ffff8800000fd770]
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02980000, 0x02980fff] PGTABLE
[    0.000000] BRK [0x02981000, 0x02981fff] PGTABLE
[    0.000000] BRK [0x02982000, 0x02982fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21ee00000-0x21effffff]
[    0.000000]  [mem 0x21ee00000-0x21effffff] page 2M
[    0.000000] BRK [0x02983000, 0x02983fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21c000000-0x21edfffff]
[    0.000000]  [mem 0x21c000000-0x21edfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x21bffffff]
[    0.000000]  [mem 0x200000000-0x21bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdcd1cfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xdcbfffff] page 2M
[    0.000000]  [mem 0xdcc00000-0xdcd1cfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xde566000-0xde566fff]
[    0.000000]  [mem 0xde566000-0xde566fff] page 4k
[    0.000000] BRK [0x02984000, 0x02984fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xde76d000-0xdeba6fff]
[    0.000000]  [mem 0xde76d000-0xde7fffff] page 4k
[    0.000000]  [mem 0xde800000-0xde9fffff] page 2M
[    0.000000]  [mem 0xdea00000-0xdeba6fff] page 4k
[    0.000000] BRK [0x02985000, 0x02985fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xdeff4000-0xdeffffff]
[    0.000000]  [mem 0xdeff4000-0xdeffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x378b2000-0x37c50fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000DD15C000 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000DD15C080 000074 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000DD162CA0 00010C (v05 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20140424/tbfadt-649)
[    0.000000] ACPI: DSDT 0x00000000DD15C188 006B16 (v02 ALASKA A M I    00000000 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000DD6C6080 000040
[    0.000000] ACPI: APIC 0x00000000DD162DB0 00007E (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000DD162E30 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x00000000DD162E78 00003C (v01 ALASKA A M I    01072009 MSFT 00010013)
[    0.000000] ACPI: CRAT 0x00000000DD163ED8 000528 (v01 AMD    BANTRY   00000001 AMD  00000001)
[    0.000000] ACPI: HPET 0x00000000DD162F10 000038 (v01 ALASKA A M I    01072009 AMI  00000005)
[    0.000000] ACPI: IVRS 0x00000000DD162F48 000078 (v02 AMD    BANTRY   00000001 AMD  00000000)
[    0.000000] ACPI: BGRT 0x00000000DD162FC0 000038 (v00 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x00000000DD162FF8 000B9C (v01 AMD    BANTRY   00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 0x00000000DD163B98 00033B (v02 AMD    BANTRY   00000002 MSFT 04000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021effffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x21effffff]
[    0.000000]   NODE_DATA [mem 0x21eff7000-0x21effbfff]
[    0.000000]  [ffffea0000000000-ffffea00077fffff] PMD -> [ffff880216600000-ffff88021d7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0xdcd1cfff]
[    0.000000]   node   0: [mem 0xde566000-0xde566fff]
[    0.000000]   node   0: [mem 0xde76d000-0xdeba6fff]
[    0.000000]   node   0: [mem 0xdeff4000-0xdeffffff]
[    0.000000]   node   0: [mem 0x100000000-0x21effffff]
[    0.000000] On node 0 totalpages: 2081027
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 26 pages reserved
[    0.000000]   DMA zone: 3999 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12325 pages used for memmap
[    0.000000]   DMA32 zone: 901476 pages, LIFO batch:31
[    0.000000]   Normal zone: 16072 pages used for memmap
[    0.000000]   Normal zone: 1175552 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 1, version 33, address 0xfec01000, GSI 24-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10228210 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 72
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdcd1d000-0xdd154fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd155000-0xdd164fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd165000-0xdd6d0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd6d1000-0xde50afff]
[    0.000000] PM: Registered nosave memory: [mem 0xde50b000-0xde565fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde567000-0xde76cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xdeba7000-0xdeff3fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec01fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec02000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec11000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed80000-0xfed8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdf000000-0xfebfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88021de00000 s1920832 r8192 d20672 u2097152
[    0.000000] pcpu-alloc: s1920832 r8192 d20672 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2052548
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.16.0-rc6+ root=/dev/mapper/VG--Debian-LV--sid ro init=/bin/systemd quiet radeon.lockup_timeout=0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] AGP: Node 0: aperture [bus addr 0x00000000-0x01ffffff] (32MB)
[    0.000000] AGP: Your BIOS doesn't leave a aperture memory hole
[    0.000000] AGP: Please enable the IOMMU option in the BIOS setup
[    0.000000] AGP: This costs you 64MB of RAM
[    0.000000] AGP: Mapping aperture over RAM [mem 0xc4000000-0xc7ffffff] (65536KB)
[    0.000000] PM: Registered nosave memory: [mem 0xc4000000-0xc7ffffff]
[    0.000000] Memory: 7819496K/8324108K available (4001K kernel code, 826K rwdata, 2284K rodata, 2700K init, 14368K bss, 504612K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:33024 nr_irqs:1024 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 4100.463 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 8200.92 BogoMIPS (lpj=16401852)
[    0.000005] pid_max: default: 32768 minimum: 301
[    0.000030] ACPI: Core revision 20140424
[    0.008056] ACPI: All ACPI Tables successfully acquired
[    0.264378] Security Framework initialized
[    0.264381] SELinux:  Disabled at boot.
[    0.265632] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.268018] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.268935] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.268958] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.269582] Initializing cgroup subsys devices
[    0.269608] Initializing cgroup subsys freezer
[    0.269621] Initializing cgroup subsys net_cls
[    0.269630] Initializing cgroup subsys blkio
[    0.269639] Initializing cgroup subsys net_prio
[    0.269679] tseg: 00df000000
[    0.269681] CPU: Physical Processor ID: 0
[    0.269682] CPU: Processor Core ID: 0
[    0.269684] mce: CPU supports 7 MCE banks
[    0.269689] LVT offset 1 assigned for vector 0xf9
[    0.269696] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.269696] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512, 1GB 0
[    0.269696] tlb_flushall_shift: 6
[    0.269798] Freeing SMP alternatives memory: 12K (ffffffff81b73000 - ffffffff81b76000)
[    0.280095] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.319825] smpboot: CPU0: AMD A10-7850K Radeon R7, 12 Compute Cores 4C+8G (fam: 15, model: 30, stepping: 01)
[    0.425951] Performance Events: Fam15h core perfctr, AMD PMU driver.
[    0.425961] ... version:                0
[    0.425962] ... bit width:              48
[    0.425963] ... generic registers:      6
[    0.425964] ... value mask:             0000ffffffffffff
[    0.425965] ... max period:             00007fffffffffff
[    0.425966] ... fixed-purpose events:   0
[    0.425967] ... event mask:             000000000000003f
[    0.426767] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.427188] x86: Booting SMP configuration:
[    0.427190] .... node  #0, CPUs:      #1 #2 #3
[    0.467132] x86: Booted up 1 node, 4 CPUs
[    0.467136] smpboot: Total of 4 processors activated (32803.70 BogoMIPS)
[    0.467570] __sdt_alloc: allocated ffff8802155ea4c0 with cpus: 
[    0.467574] __sdt_alloc: allocated ffff8802155ea3c0 with cpus: 
[    0.467576] __sdt_alloc: allocated ffff8802155ea2c0 with cpus: 
[    0.467577] __sdt_alloc: allocated ffff8802155ea1c0 with cpus: 
[    0.467582] __sdt_alloc: allocated ffff8802155ea0c0 with cpus: 
[    0.467589] __sdt_alloc: allocated ffff880215798f40 with cpus: 
[    0.467591] __sdt_alloc: allocated ffff880215798e40 with cpus: 
[    0.467593] __sdt_alloc: allocated ffff880215798d40 with cpus: 
[    0.467599] __sdt_alloc: allocated ffff880215798c40 with cpus: 
[    0.467600] __sdt_alloc: allocated ffff880215798b40 with cpus: 
[    0.467602] __sdt_alloc: allocated ffff880215798a40 with cpus: 
[    0.467604] __sdt_alloc: allocated ffff880215798940 with cpus: 
[    0.467627] build_sched_domain: cpu: 0 level: SMT cpu_map: 0-3 tl->mask: 0-1
[    0.467629] build_sched_domain: cpu: 0 level: MC cpu_map: 0-3 tl->mask: 0-3
[    0.467631] build_sched_domain: cpu: 1 level: SMT cpu_map: 0-3 tl->mask: 0-1
[    0.467632] build_sched_domain: cpu: 1 level: MC cpu_map: 0-3 tl->mask: 0-3
[    0.467634] build_sched_domain: cpu: 2 level: SMT cpu_map: 0-3 tl->mask: 2-3
[    0.467635] build_sched_domain: cpu: 2 level: MC cpu_map: 0-3 tl->mask: 0-3
[    0.467637] build_sched_domain: cpu: 3 level: SMT cpu_map: 0-3 tl->mask: 2-3
[    0.467638] build_sched_domain: cpu: 3 level: MC cpu_map: 0-3 tl->mask: 0-3
[    0.467640] build_sched_groups: got group ffff8802155ea4c0 with cpus: 
[    0.467642] build_sched_groups: got group ffff8802155ea3c0 with cpus: 
[    0.467643] build_sched_groups: got group ffff8802155ea0c0 with cpus: 
[    0.467644] build_sched_groups: got group ffff880215798e40 with cpus: 
[    0.467646] build_sched_groups: got group ffff8802155ea2c0 with cpus: 
[    0.467647] build_sched_groups: got group ffff8802155ea1c0 with cpus: 
[    0.468285] devtmpfs: initialized
[    0.474492] PM: Registering ACPI NVS region [mem 0xdd165000-0xdd6d0fff] (5685248 bytes)
[    0.474688] PM: Registering ACPI NVS region [mem 0xde567000-0xde76cfff] (2121728 bytes)
[    0.475517] regulator-dummy: no parameters
[    0.475766] NET: Registered protocol family 16
[    0.476056] cpuidle: using governor ladder
[    0.476060] cpuidle: using governor menu
[    0.476125] ACPI: bus type PCI registered
[    0.476348] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.476350] PCI: not using MMCONFIG
[    0.476352] PCI: Using configuration type 1 for base access
[    0.476353] PCI: Using configuration type 1 for extended access
[    0.491522] ACPI: Added _OSI(Module Device)
[    0.491526] ACPI: Added _OSI(Processor Device)
[    0.491528] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.491529] ACPI: Added _OSI(Processor Aggregator Device)
[    0.499582] ACPI: Executed 1 blocks of module-level executable AML code
[    0.505694] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.506466] ACPI: Interpreter enabled
[    0.506473] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
[    0.506477] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
[    0.506512] ACPI: (supports S0 S3 S4 S5)
[    0.506514] ACPI: Using IOAPIC for interrupt routing
[    0.506693] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.506747] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    0.506847] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.508397] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.508850] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.509403] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.618719] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.618727] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.619104] acpi PNP0A03:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.619451] acpi PNP0A03:00: _OSC: OS now controls [AER PCIeCapability]
[    0.619887] acpi PNP0A03:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.620033] PCI host bridge to bus 0000:00
[    0.620036] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.620038] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.620040] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.620042] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.620044] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.620046] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.620048] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.620049] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xffffffff]
[    0.620077] pci 0000:00:00.0: [1022:1422] type 00 class 0x060000
[    0.620400] pci 0000:00:00.2: [1022:1423] type 00 class 0x080600
[    0.620708] pci 0000:00:02.0: [1022:1424] type 00 class 0x060000
[    0.620946] pci 0000:00:02.1: [1022:1425] type 01 class 0x060400
[    0.621040] pci 0000:00:02.1: PME# supported from D0 D3hot D3cold
[    0.621197] pci 0000:00:02.1: System wakeup disabled by ACPI
[    0.621327] pci 0000:00:03.0: [1022:1424] type 00 class 0x060000
[    0.621572] pci 0000:00:04.0: [1022:1424] type 00 class 0x060000
[    0.621856] pci 0000:00:10.0: [1022:7814] type 00 class 0x0c0330
[    0.621886] pci 0000:00:10.0: reg 0x10: [mem 0xfeb06000-0xfeb07fff 64bit]
[    0.622026] pci 0000:00:10.0: PME# supported from D0 D3hot D3cold
[    0.622160] pci 0000:00:10.0: System wakeup disabled by ACPI
[    0.622315] pci 0000:00:10.1: [1022:7814] type 00 class 0x0c0330
[    0.622344] pci 0000:00:10.1: reg 0x10: [mem 0xfeb04000-0xfeb05fff 64bit]
[    0.622482] pci 0000:00:10.1: PME# supported from D0 D3hot D3cold
[    0.622613] pci 0000:00:10.1: System wakeup disabled by ACPI
[    0.622750] pci 0000:00:11.0: [1022:7801] type 00 class 0x010601
[    0.622774] pci 0000:00:11.0: reg 0x10: [io  0xf040-0xf047]
[    0.622787] pci 0000:00:11.0: reg 0x14: [io  0xf030-0xf033]
[    0.622798] pci 0000:00:11.0: reg 0x18: [io  0xf020-0xf027]
[    0.622810] pci 0000:00:11.0: reg 0x1c: [io  0xf010-0xf013]
[    0.622822] pci 0000:00:11.0: reg 0x20: [io  0xf000-0xf00f]
[    0.622834] pci 0000:00:11.0: reg 0x24: [mem 0xfeb0c000-0xfeb0c7ff]
[    0.623096] pci 0000:00:12.0: [1022:7807] type 00 class 0x0c0310
[    0.623113] pci 0000:00:12.0: reg 0x10: [mem 0xfeb0b000-0xfeb0bfff]
[    0.623297] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.623435] pci 0000:00:12.2: [1022:7808] type 00 class 0x0c0320
[    0.623459] pci 0000:00:12.2: reg 0x10: [mem 0xfeb0a000-0xfeb0a0ff]
[    0.623568] pci 0000:00:12.2: supports D1 D2
[    0.623570] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.623689] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.623817] pci 0000:00:13.0: [1022:7807] type 00 class 0x0c0310
[    0.623833] pci 0000:00:13.0: reg 0x10: [mem 0xfeb09000-0xfeb09fff]
[    0.624015] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.624142] pci 0000:00:13.2: [1022:7808] type 00 class 0x0c0320
[    0.624166] pci 0000:00:13.2: reg 0x10: [mem 0xfeb08000-0xfeb080ff]
[    0.624275] pci 0000:00:13.2: supports D1 D2
[    0.624276] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.624394] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.624537] pci 0000:00:14.0: [1022:780b] type 00 class 0x0c0500
[    0.624815] pci 0000:00:14.2: [1022:780d] type 00 class 0x040300
[    0.624842] pci 0000:00:14.2: reg 0x10: [mem 0xfeb00000-0xfeb03fff 64bit]
[    0.624929] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.625047] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.625167] pci 0000:00:14.3: [1022:780e] type 00 class 0x060100
[    0.625451] pci 0000:00:14.4: [1022:780f] type 01 class 0x060401
[    0.625603] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.625733] pci 0000:00:15.0: [1022:43a0] type 01 class 0x060400
[    0.625842] pci 0000:00:15.0: supports D1 D2
[    0.625844] pci 0000:00:15.0: PME# supported from D0 D3hot D3cold
[    0.625973] pci 0000:00:15.0: System wakeup disabled by ACPI
[    0.626099] pci 0000:00:15.1: [1022:43a1] type 01 class 0x060400
[    0.626209] pci 0000:00:15.1: supports D1 D2
[    0.626210] pci 0000:00:15.1: PME# supported from D0 D3hot D3cold
[    0.626342] pci 0000:00:15.1: System wakeup disabled by ACPI
[    0.626467] pci 0000:00:15.2: [1022:43a2] type 01 class 0x060400
[    0.626576] pci 0000:00:15.2: supports D1 D2
[    0.626577] pci 0000:00:15.2: PME# supported from D0 D3hot D3cold
[    0.626703] pci 0000:00:15.2: System wakeup disabled by ACPI
[    0.626833] pci 0000:00:18.0: [1022:141a] type 00 class 0x060000
[    0.627058] pci 0000:00:18.1: [1022:141b] type 00 class 0x060000
[    0.627278] pci 0000:00:18.2: [1022:141c] type 00 class 0x060000
[    0.627509] pci 0000:00:18.3: [1022:141d] type 00 class 0x060000
[    0.627744] pci 0000:00:18.4: [1022:141e] type 00 class 0x060000
[    0.627962] pci 0000:00:18.5: [1022:141f] type 00 class 0x060000
[    0.628312] pci 0000:01:00.0: [1002:665c] type 00 class 0x030000
[    0.628335] pci 0000:01:00.0: reg 0x10: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.628350] pci 0000:01:00.0: reg 0x18: [mem 0xf0000000-0xf07fffff 64bit pref]
[    0.628361] pci 0000:01:00.0: reg 0x20: [io  0xe000-0xe0ff]
[    0.628371] pci 0000:01:00.0: reg 0x24: [mem 0xfea00000-0xfea3ffff]
[    0.628381] pci 0000:01:00.0: reg 0x30: [mem 0xfea40000-0xfea5ffff pref]
[    0.628465] pci 0000:01:00.0: supports D1 D2
[    0.628467] pci 0000:01:00.0: PME# supported from D1 D2 D3hot
[    0.628652] pci 0000:01:00.1: [1002:0002] type 00 class 0x040300
[    0.628671] pci 0000:01:00.1: reg 0x10: [mem 0xfea60000-0xfea63fff 64bit]
[    0.628767] pci 0000:01:00.1: supports D1 D2
[    0.628960] pci 0000:00:02.1: PCI bridge to [bus 01]
[    0.628966] pci 0000:00:02.1:   bridge window [io  0xe000-0xefff]
[    0.628970] pci 0000:00:02.1:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.628976] pci 0000:00:02.1:   bridge window [mem 0xe0000000-0xf07fffff 64bit pref]
[    0.629117] pci 0000:00:14.4: PCI bridge to [bus 02] (subtractive decode)
[    0.629128] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    0.629130] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    0.629132] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    0.629133] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.629136] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.629138] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.629140] pci 0000:00:14.4:   bridge window [mem 0xe0000000-0xffffffff] (subtractive decode)
[    0.629257] pci 0000:00:15.0: PCI bridge to [bus 03]
[    0.629415] pci 0000:04:00.0: [1b21:1042] type 00 class 0x0c0330
[    0.629450] pci 0000:04:00.0: reg 0x10: [mem 0xfe900000-0xfe907fff 64bit]
[    0.629623] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    0.635595] pci 0000:00:15.1: PCI bridge to [bus 04]
[    0.635608] pci 0000:00:15.1:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.635792] pci 0000:05:00.0: [10ec:8168] type 00 class 0x020000
[    0.635815] pci 0000:05:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.635844] pci 0000:05:00.0: reg 0x18: [mem 0xfe800000-0xfe800fff 64bit]
[    0.635864] pci 0000:05:00.0: reg 0x20: [mem 0xf0900000-0xf0903fff 64bit pref]
[    0.635988] pci 0000:05:00.0: supports D1 D2
[    0.635990] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.636068] pci 0000:05:00.0: System wakeup disabled by ACPI
[    0.643602] pci 0000:00:15.2: PCI bridge to [bus 05]
[    0.643613] pci 0000:00:15.2:   bridge window [io  0xd000-0xdfff]
[    0.643618] pci 0000:00:15.2:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.643625] pci 0000:00:15.2:   bridge window [mem 0xf0900000-0xf09fffff 64bit pref]
[    0.644780] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 6 7 10 11 14 15) *0
[    0.644888] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 6 7 10 11 14 15) *0
[    0.644999] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 6 7 10 11 14 15) *0
[    0.645109] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 10 11 14 15) *0
[    0.645201] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 6 7 10 11 14 15) *0
[    0.645277] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 11 14 15) *0
[    0.645352] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 6 7 10 11 14 15) *0
[    0.645427] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *0
[    0.645824] ACPI : EC: GPE = 0xa, I/O: command/status = 0x66, data = 0x62
[    0.646369] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.646375] vgaarb: loaded
[    0.646376] vgaarb: bridge control possible 0000:01:00.0
[    0.646752] PCI: Using ACPI for IRQ routing
[    0.649030] PCI: pci_cache_line_size set to 64 bytes
[    0.649133] e820: reserve RAM buffer [mem 0xdcd1d000-0xdfffffff]
[    0.649139] e820: reserve RAM buffer [mem 0xde567000-0xdfffffff]
[    0.649142] e820: reserve RAM buffer [mem 0xdeba7000-0xdfffffff]
[    0.649144] e820: reserve RAM buffer [mem 0xdf000000-0xdfffffff]
[    0.649145] e820: reserve RAM buffer [mem 0x21f000000-0x21fffffff]
[    0.649677] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.649681] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.651859] Switched to clocksource hpet
[    0.663212] pnp: PnP ACPI init
[    0.663257] ACPI: bus type PNP registered
[    0.663463] system 00:00: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.663482] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.663658] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.663834] system 00:02: [mem 0xfeb80000-0xfebfffff] has been reserved
[    0.663839] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.664120] system 00:03: [io  0x0290-0x029f] has been reserved
[    0.664125] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.664224] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.664451] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.664456] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.664580] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.664956] pnp 00:07: [dma 0 disabled]
[    0.665062] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.665490] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.665493] system 00:08: [io  0x040b] has been reserved
[    0.665496] system 00:08: [io  0x04d6] has been reserved
[    0.665499] system 00:08: [io  0x0c00-0x0c01] has been reserved
[    0.665501] system 00:08: [io  0x0c14] has been reserved
[    0.665503] system 00:08: [io  0x0c50-0x0c51] has been reserved
[    0.665506] system 00:08: [io  0x0c52] has been reserved
[    0.665508] system 00:08: [io  0x0c6c] has been reserved
[    0.665510] system 00:08: [io  0x0c6f] has been reserved
[    0.665512] system 00:08: [io  0x0cd0-0x0cd1] has been reserved
[    0.665514] system 00:08: [io  0x0cd2-0x0cd3] has been reserved
[    0.665517] system 00:08: [io  0x0cd4-0x0cd5] has been reserved
[    0.665519] system 00:08: [io  0x0cd6-0x0cd7] has been reserved
[    0.665521] system 00:08: [io  0x0cd8-0x0cdf] has been reserved
[    0.665523] system 00:08: [io  0x0800-0x089f] could not be reserved
[    0.665526] system 00:08: [io  0x0b20-0x0b3f] has been reserved
[    0.665528] system 00:08: [io  0x0900-0x090f] has been reserved
[    0.665530] system 00:08: [io  0x0910-0x091f] has been reserved
[    0.665532] system 00:08: [io  0xfe00-0xfefe] has been reserved
[    0.665536] system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.665538] system 00:08: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.665541] system 00:08: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.665543] system 00:08: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.665546] system 00:08: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.665548] system 00:08: [mem 0xfed00000-0xfed00fff] could not be reserved
[    0.665551] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.665555] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.665848] pnp: PnP ACPI: found 9 devices
[    0.665849] ACPI: bus type PNP unregistered
[    0.676214] pci 0000:00:02.1: PCI bridge to [bus 01]
[    0.676219] pci 0000:00:02.1:   bridge window [io  0xe000-0xefff]
[    0.676225] pci 0000:00:02.1:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.676229] pci 0000:00:02.1:   bridge window [mem 0xe0000000-0xf07fffff 64bit pref]
[    0.676235] pci 0000:00:14.4: PCI bridge to [bus 02]
[    0.676249] pci 0000:00:15.0: PCI bridge to [bus 03]
[    0.676262] pci 0000:00:15.1: PCI bridge to [bus 04]
[    0.676268] pci 0000:00:15.1:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.676277] pci 0000:00:15.2: PCI bridge to [bus 05]
[    0.676280] pci 0000:00:15.2:   bridge window [io  0xd000-0xdfff]
[    0.676285] pci 0000:00:15.2:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.676289] pci 0000:00:15.2:   bridge window [mem 0xf0900000-0xf09fffff 64bit pref]
[    0.676297] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.676298] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.676300] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.676301] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.676303] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.676304] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.676306] pci_bus 0000:00: resource 10 [mem 0xe0000000-0xffffffff]
[    0.676308] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.676309] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.676311] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xf07fffff 64bit pref]
[    0.676313] pci_bus 0000:02: resource 4 [io  0x0000-0x03af]
[    0.676314] pci_bus 0000:02: resource 5 [io  0x03e0-0x0cf7]
[    0.676316] pci_bus 0000:02: resource 6 [io  0x03b0-0x03df]
[    0.676317] pci_bus 0000:02: resource 7 [io  0x0d00-0xffff]
[    0.676319] pci_bus 0000:02: resource 8 [mem 0x000a0000-0x000bffff]
[    0.676320] pci_bus 0000:02: resource 9 [mem 0x000c0000-0x000dffff]
[    0.676322] pci_bus 0000:02: resource 10 [mem 0xe0000000-0xffffffff]
[    0.676323] pci_bus 0000:04: resource 1 [mem 0xfe900000-0xfe9fffff]
[    0.676325] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.676326] pci_bus 0000:05: resource 1 [mem 0xfe800000-0xfe8fffff]
[    0.676328] pci_bus 0000:05: resource 2 [mem 0xf0900000-0xf09fffff 64bit pref]
[    0.676495] NET: Registered protocol family 2
[    0.677181] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.678115] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    0.681223] TCP: Hash tables configured (established 65536 bind 65536)
[    0.681297] TCP: reno registered
[    0.681421] UDP hash table entries: 4096 (order: 7, 786432 bytes)
[    0.681933] UDP-Lite hash table entries: 4096 (order: 7, 786432 bytes)
[    0.682613] NET: Registered protocol family 1
[    0.852864] pci 0000:01:00.0: Boot video device
[    0.853174] PCI: CLS 64 bytes, default 64
[    0.853369] Unpacking initramfs...
[    0.914792] Freeing initrd memory: 3708K (ffff8800378b2000 - ffff880037c51000)
[    1.029176] AMD-Vi: IOMMU performance counters supported
[    1.029402] pci 0000:00:00.2: can't derive routing for PCI INT A
[    1.029405] pci 0000:00:00.2: PCI INT A: no GSI
[    1.029882] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
[    1.029884] AMD-Vi:  Extended features:  PPR GT IA PC
[    1.029929] pci 0000:00:00.2: irq 72 for MSI/MSI-X
[    1.037599] AMD-Vi: Using passthrough domain for device 0000:01:00.0
[    1.038463] AMD-Vi: Lazy IO/TLB flushing enabled
[    1.038923] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.038925] software IO TLB [mem 0xcb4b7000-0xcf4b7000] (64MB) mapped at [ffff8800cb4b7000-ffff8800cf4b6fff]
[    1.039521] perf: AMD NB counters detected
[    1.039542] perf: amd_iommu: Detected. (2 banks, 4 counters/bank)
[    1.039551] LVT offset 0 assigned for vector 0x400
[    1.039569] perf: AMD IBS detected (0x000001ff)
[    1.040375] futex hash table entries: 1024 (order: 5, 131072 bytes)
[    1.040433] Initialise system trusted keyring
[    1.040507] audit: initializing netlink subsys (disabled)
[    1.040570] audit: type=2000 audit(1406102416.688:1): initialized
[    1.041454] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.041527] zbud: loaded
[    1.041847] VFS: Disk quotas dquot_6.5.2
[    1.041877] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.042086] msgmni has been set to 15704
[    1.042608] alg: No test for stdrng (krng)
[    1.042661] bounce: pool size: 64 pages
[    1.042687] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.042698] io scheduler noop registered
[    1.042701] io scheduler deadline registered
[    1.042820] io scheduler cfq registered (default)
[    1.042823] start plist test
[    1.044206] end plist test
[    1.045517] GHES: HEST is not enabled!
[    1.045707] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.066224] 00:07: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.067420] Linux agpgart interface v0.103
[    1.067709] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.070109] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.070132] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.070640] mousedev: PS/2 mouse device common for all mice
[    1.070814] rtc_cmos 00:04: RTC can wake from S4
[    1.071059] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.071086] rtc_cmos 00:04: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.071126] ledtrig-cpu: registered to indicate activity on CPUs
[    1.071142] drop_monitor: Initializing network drop monitor service
[    1.071241] TCP: cubic registered
[    1.071352] NET: Registered protocol family 10
[    1.071888] mip6: Mobile IPv6
[    1.071899] NET: Registered protocol family 17
[    1.071923] Key type dns_resolver registered
[    1.072996] Loading compiled-in X.509 certificates
[    1.073029] registered taskstats version 1
[    1.074026] rtc_cmos 00:04: setting system clock to 2014-07-23 08:00:17 UTC (1406102417)
[    1.074204] PM: Hibernation image not present or could not be loaded.
[    1.077247] Freeing unused kernel memory: 2700K (ffffffff818d0000 - ffffffff81b73000)
[    1.077250] Write protecting the kernel read-only data: 8192k
[    1.077957] Freeing unused kernel memory: 84K (ffff8800013eb000 - ffff880001400000)
[    1.082375] Freeing unused kernel memory: 1812K (ffff88000163b000 - ffff880001800000)
[    1.100960] systemd-udevd[70]: starting version 204
[    1.142548] SCSI subsystem initialized
[    1.143663] libata version 3.00 loaded.
[    1.144652] ahci 0000:00:11.0: version 3.0
[    1.145200] ahci 0000:00:11.0: irq 73 for MSI/MSI-X
[    1.145363] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 8 ports 6 Gbps 0xff impl SATA mode
[    1.145366] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio sxs 
[    1.149456] scsi0 : ahci
[    1.150745] scsi1 : ahci
[    1.151548] scsi2 : ahci
[    1.152216] scsi3 : ahci
[    1.153484] scsi4 : ahci
[    1.154277] scsi5 : ahci
[    1.154529] scsi6 : ahci
[    1.155197] scsi7 : ahci
[    1.156358] ata1: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c100 irq 73
[    1.156362] ata2: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c180 irq 73
[    1.156365] ata3: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c200 irq 73
[    1.156368] ata4: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c280 irq 73
[    1.156370] ata5: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c300 irq 73
[    1.156372] ata6: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c380 irq 73
[    1.156375] ata7: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c400 irq 73
[    1.156377] ata8: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c480 irq 73
[    1.476940] ata6: SATA link down (SStatus 0 SControl 300)
[    1.477095] ata2: SATA link down (SStatus 0 SControl 300)
[    1.477140] ata8: SATA link down (SStatus 0 SControl 300)
[    1.477201] ata4: SATA link down (SStatus 0 SControl 300)
[    1.477236] ata7: SATA link down (SStatus 0 SControl 300)
[    1.477270] ata5: SATA link down (SStatus 0 SControl 300)
[    1.649111] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.649239] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.649964] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[    1.649968] ata1.00: ATA-9: Samsung SSD 840 PRO Series, DXM06B0Q, max UDMA/133
[    1.649970] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.650255] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[    1.650259] ata1.00: configured for UDMA/133
[    1.650505] ata3.00: ATA-8: ST500DM002-1BD142, KC43, max UDMA/133
[    1.650507] ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.650847] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD 840  6B0Q PQ: 0 ANSI: 5
[    1.652041] ata3.00: configured for UDMA/133
[    1.652202] scsi 2:0:0:0: Direct-Access     ATA      ST500DM002-1BD14 KC43 PQ: 0 ANSI: 5
[    1.660511] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    1.660550] sd 2:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.660554] sd 2:0:0:0: [sdb] 4096-byte physical blocks
[    1.660681] sd 2:0:0:0: [sdb] Write Protect is off
[    1.660684] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.660687] sd 0:0:0:0: [sda] Write Protect is off
[    1.660690] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.660733] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.660741] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.663652]  sda: sda1 sda2 sda3 sda4 sda5
[    1.665090] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.678011]  sdb: sdb1 sdb2 < sdb5 >
[    1.678973] sd 2:0:0:0: [sdb] Attached SCSI disk
[    1.861738] device-mapper: uevent: version 1.0.3
[    1.861991] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    1.866890] random: lvm urandom read with 42 bits of entropy available
[    1.981813] PM: Starting manual resume from disk
[    1.981820] PM: Hibernation image partition 254:1 present
[    1.981821] PM: Looking for hibernation image.
[    1.982091] PM: Image not found (code -22)
[    1.982093] PM: Hibernation image not present or could not be loaded.
[    1.996986] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    2.037486] tsc: Refined TSC clocksource calibration: 4100.302 MHz
[    2.065387] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    2.071807] systemd[1]: Inserted module 'autofs4'
[    2.072416] systemd[1]: Set hostname to <kaveri>.
[    2.157818] systemd[1]: Starting Syslog Socket.
[    2.157907] systemd[1]: Listening on Syslog Socket.
[    2.157919] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    2.158080] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    2.158091] systemd[1]: Starting Remote File Systems (Pre).
[    2.158107] systemd[1]: Reached target Remote File Systems (Pre).
[    2.158117] systemd[1]: Starting Delayed Shutdown Socket.
[    2.158159] systemd[1]: Listening on Delayed Shutdown Socket.
[    2.158168] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    2.158213] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    2.158222] systemd[1]: Starting LVM2 metadata daemon socket.
[    2.158277] systemd[1]: Listening on LVM2 metadata daemon socket.
[    2.158296] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    2.158395] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    2.158403] systemd[1]: Starting Paths.
[    2.158418] systemd[1]: Reached target Paths.
[    2.158490] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[    2.158821] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    2.158832] systemd[1]: Starting Journal Socket.
[    2.158956] systemd[1]: Listening on Journal Socket.
[    2.158968] systemd[1]: Starting Syslog.
[    2.158983] systemd[1]: Reached target Syslog.
[    2.159017] systemd[1]: Mounting Huge Pages File System...
[    2.160420] systemd[1]: Mounting POSIX Message Queue File System...
[    2.161850] systemd[1]: Started Set Up Additional Binary Formats.
[    2.164111] systemd[1]: Starting Load Kernel Modules...
[    2.165105] systemd[1]: Mounting Debug File System...
[    2.166849] systemd[1]: Starting Apply Kernel Variables...
[    2.168719] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    2.169807] systemd[1]: Starting Journal Service...
[    2.171223] systemd[1]: Started Journal Service.
[    2.172046] fuse init (API version 7.23)
[    2.182502] systemd-journald[183]: Vacuuming done, freed 0 bytes
[    2.272611] systemd-udevd[207]: starting version 204
[    2.343982] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    2.344042] ACPI: Power Button [PWRB]
[    2.344212] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    2.344216] ACPI: Power Button [PWRF]
[    2.356941] ACPI: acpi_idle registered with cpuidle
[    2.357028] ACPI: Video Device [VGA1] (multi-head: yes  rom: no  post: no)
[    2.357124] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    2.357528] ACPI Error: [AFN7] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    2.357534] ACPI Error: Method parse/execution failed [\_SB_.PCI0.PB21.VGA_.LCD_._BCM] (Node ffff88021d84b770), AE_NOT_FOUND (20140424/psparse-536)
[    2.357546] ACPI Error: Evaluating _BCM failed (20140424/video-384)
[    2.357847] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:03/LNXVIDEO:01/input/input4
[    2.370457] wmi: Mapper loaded
[    2.370998] ACPI: bus type USB registered
[    2.371082] usbcore: registered new interface driver usbfs
[    2.371149] usbcore: registered new interface driver hub
[    2.372488] usbcore: registered new device driver usb
[    2.380836] QUIRK: Enable AMD PLL fix
[    2.380876] xhci_hcd 0000:00:10.0: xHCI Host Controller
[    2.380991] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
[    2.381336] xhci_hcd 0000:00:10.0: irq 74 for MSI/MSI-X
[    2.381344] xhci_hcd 0000:00:10.0: irq 75 for MSI/MSI-X
[    2.381351] xhci_hcd 0000:00:10.0: irq 76 for MSI/MSI-X
[    2.381359] xhci_hcd 0000:00:10.0: irq 77 for MSI/MSI-X
[    2.381366] xhci_hcd 0000:00:10.0: irq 78 for MSI/MSI-X
[    2.385140] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.385144] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.385146] usb usb1: Product: xHCI Host Controller
[    2.385148] usb usb1: Manufacturer: Linux 3.16.0-rc6+ xhci_hcd
[    2.385151] usb usb1: SerialNumber: 0000:00:10.0
[    2.387051] acpi-cpufreq: overriding BIOS provided _PSD data
[    2.401247] hub 1-0:1.0: USB hub found
[    2.401328] hub 1-0:1.0: 2 ports detected
[    2.409901] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.410146] ehci-pci: EHCI PCI platform driver
[    2.410492] EXT4-fs (dm-0): re-mounted. Opts: errors=remount-ro
[    2.411030] [drm] Initialized drm 1.1.0 20060810
[    2.415093] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.437920] xhci_hcd 0000:00:10.0: xHCI Host Controller
[    2.437935] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
[    2.439573] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    2.439579] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.439581] usb usb2: Product: xHCI Host Controller
[    2.439584] usb usb2: Manufacturer: Linux 3.16.0-rc6+ xhci_hcd
[    2.439586] usb usb2: SerialNumber: 0000:00:10.0
[    2.446896] hub 2-0:1.0: USB hub found
[    2.446951] hub 2-0:1.0: 2 ports detected
[    2.447902] ehci-pci 0000:00:12.2: EHCI Host Controller
[    2.447921] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 3
[    2.447928] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.447942] ehci-pci 0000:00:12.2: debug port 1
[    2.448054] ehci-pci 0000:00:12.2: irq 17, io mem 0xfeb0a000
[    2.458325] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.458487] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    2.458492] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.458495] usb usb3: Product: EHCI Host Controller
[    2.458498] usb usb3: Manufacturer: Linux 3.16.0-rc6+ ehci_hcd
[    2.458501] usb usb3: SerialNumber: 0000:00:12.2
[    2.460341] hub 3-0:1.0: USB hub found
[    2.460371] hub 3-0:1.0: 5 ports detected
[    2.462177] ehci-pci 0000:00:13.2: EHCI Host Controller
[    2.462197] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 4
[    2.462207] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.462225] ehci-pci 0000:00:13.2: debug port 1
[    2.462281] ehci-pci 0000:00:13.2: irq 17, io mem 0xfeb08000
[    2.464503] [drm] radeon kernel modesetting enabled.
[    2.471977] [drm] initializing kernel modesetting (BONAIRE 0x1002:0x665C 0x1787:0x200F).
[    2.472009] [drm] register mmio base: 0xFEA00000
[    2.472010] [drm] register mmio size: 262144
[    2.472016] [drm] doorbell mmio base: 0xF0000000
[    2.472017] [drm] doorbell mmio size: 8388608
[    2.472118] radeon 0000:01:00.0: Invalid ROM contents
[    2.472218] ATOM BIOS: BONAIRE
[    2.472306] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[    2.472308] radeon 0000:01:00.0: GTT: 1024M 0x0000000040000000 - 0x000000007FFFFFFF
[    2.472310] [drm] Detected VRAM RAM=1024M, BAR=256M
[    2.472311] [drm] RAM width 128bits DDR
[    2.473838] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.475043] [TTM] Zone  kernel: Available graphics memory: 4022742 kiB
[    2.475046] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    2.475048] [TTM] Initializing pool allocator
[    2.475081] [TTM] Initializing DMA pool allocator
[    2.475503] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    2.475508] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.475511] usb usb4: Product: EHCI Host Controller
[    2.475514] usb usb4: Manufacturer: Linux 3.16.0-rc6+ ehci_hcd
[    2.475516] usb usb4: SerialNumber: 0000:00:13.2
[    2.478858] [drm] radeon: 1024M of VRAM memory ready
[    2.478863] [drm] radeon: 1024M of GTT memory ready.
[    2.478965] [drm] Loading BONAIRE Microcode
[    2.479971] hub 4-0:1.0: USB hub found
[    2.479997] hub 4-0:1.0: 5 ports detected
[    2.482162] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    2.485085] ohci-pci: OHCI PCI platform driver
[    2.485546] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.488767] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller at 0xb20
[    2.489189] [drm] radeon/BONAIRE_mc2.bin: 31792 bytes
[    2.489322] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    2.490056] [drm] Internal thermal controller with fan control
[    2.494742] [drm] probing gen 2 caps for device 1022:1425 = 733d03/e
[    2.495303] random: nonblocking pool is initialized
[    2.495425] xhci_hcd 0000:00:10.1: xHCI Host Controller
[    2.495447] xhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 5
[    2.495737] xhci_hcd 0000:00:10.1: irq 79 for MSI/MSI-X
[    2.495750] xhci_hcd 0000:00:10.1: irq 80 for MSI/MSI-X
[    2.495762] xhci_hcd 0000:00:10.1: irq 81 for MSI/MSI-X
[    2.495772] xhci_hcd 0000:00:10.1: irq 82 for MSI/MSI-X
[    2.495783] xhci_hcd 0000:00:10.1: irq 83 for MSI/MSI-X
[    2.496246] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    2.496250] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.496253] usb usb5: Product: xHCI Host Controller
[    2.496256] usb usb5: Manufacturer: Linux 3.16.0-rc6+ xhci_hcd
[    2.496258] usb usb5: SerialNumber: 0000:00:10.1
[    2.506828] [drm] radeon: dpm initialized
[    2.509104] [drm] Found VCE firmware/feedback version 40.2.2 / 15!
[    2.509149] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    2.511131] hub 5-0:1.0: USB hub found
[    2.511195] hub 5-0:1.0: 2 ports detected
[    2.511344] [drm] probing gen 2 caps for device 1022:1425 = 733d03/e
[    2.511360] [drm] PCIE gen 3 link speeds already enabled
[    2.514643] [drm] PCIE GART of 1024M enabled (table at 0x000000000078B000).
[    2.514890] radeon 0000:01:00.0: WB enabled
[    2.514919] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff880212014c00
[    2.514922] radeon 0000:01:00.0: fence driver on ring 1 use gpu addr 0x0000000040000c04 and cpu addr 0xffff880212014c04
[    2.514924] radeon 0000:01:00.0: fence driver on ring 2 use gpu addr 0x0000000040000c08 and cpu addr 0xffff880212014c08
[    2.514926] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000040000c0c and cpu addr 0xffff880212014c0c
[    2.514928] radeon 0000:01:00.0: fence driver on ring 4 use gpu addr 0x0000000040000c10 and cpu addr 0xffff880212014c10
[    2.515326] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000076c98 and cpu addr 0xffffc900055b6c98
[    2.515392] radeon 0000:01:00.0: fence driver on ring 6 use gpu addr 0x0000000040000c18 and cpu addr 0xffff880212014c18
[    2.515394] radeon 0000:01:00.0: fence driver on ring 7 use gpu addr 0x0000000040000c1c and cpu addr 0xffff880212014c1c
[    2.515399] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.515400] [drm] Driver supports precise vblank timestamp query.
[    2.515475] radeon 0000:01:00.0: irq 84 for MSI/MSI-X
[    2.515502] radeon 0000:01:00.0: radeon: using MSI.
[    2.515586] [drm] radeon: irq initialized.
[    2.516013] xhci_hcd 0000:00:10.1: xHCI Host Controller
[    2.516025] xhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 6
[    2.516572] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
[    2.516576] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.516579] usb usb6: Product: xHCI Host Controller
[    2.516581] usb usb6: Manufacturer: Linux 3.16.0-rc6+ xhci_hcd
[    2.516583] usb usb6: SerialNumber: 0000:00:10.1
[    2.526223] hub 6-0:1.0: USB hub found
[    2.526465] hub 6-0:1.0: 2 ports detected
[    2.527533] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    2.527550] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 7
[    2.527957] [drm] ring test on 0 succeeded in 2 usecs
[    2.528073] [drm] ring test on 1 succeeded in 2 usecs
[    2.528104] [drm] ring test on 2 succeeded in 2 usecs
[    2.528254] [drm] ring test on 3 succeeded in 2 usecs
[    2.528264] [drm] ring test on 4 succeeded in 2 usecs
[    2.534483] EDAC MC: Ver: 3.0.0
[    2.538846] MCE: In-kernel MCE decoding enabled.
[    2.539718] AMD64 EDAC driver v3.4.0
[    2.539781] EDAC amd64: DRAM ECC disabled.
[    2.539787] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[    2.539787]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[    2.539787]  (Note that use of the override may cause unknown side effects.)
[    2.546928] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.546956] r8169 0000:05:00.0: enabling device (0000 -> 0003)
[    2.554298] r8169 0000:05:00.0: irq 85 for MSI/MSI-X
[    2.554956] r8169 0000:05:00.0 eth0: RTL8168g/8111g at 0xffffc90005488000, d8:50:e6:4e:62:1d, XID 0c000800 IRQ 85
[    2.554959] r8169 0000:05:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    2.561619] microcode: CPU0: patch_level=0x06003104
[    2.561753] microcode: CPU1: patch_level=0x06003104
[    2.561768] microcode: CPU2: patch_level=0x06003104
[    2.561782] microcode: CPU3: patch_level=0x06003104
[    2.561933] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.569451] AVX version of gcm_enc/dec engaged.
[    2.573312] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    2.574227] [drm] ring test on 5 succeeded in 1 usecs
[    2.584279] [drm] UVD initialized successfully.
[    2.585115] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    2.585130] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 8
[    2.585229] ohci-pci 0000:00:12.0: irq 18, io mem 0xfeb0b000
[    2.585790] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    2.587062] xhci_hcd 0000:04:00.0: irq 86 for MSI/MSI-X
[    2.587072] xhci_hcd 0000:04:00.0: irq 87 for MSI/MSI-X
[    2.587079] xhci_hcd 0000:04:00.0: irq 88 for MSI/MSI-X
[    2.587086] xhci_hcd 0000:04:00.0: irq 89 for MSI/MSI-X
[    2.587094] xhci_hcd 0000:04:00.0: irq 90 for MSI/MSI-X
[    2.587387] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    2.587390] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.587392] usb usb7: Product: xHCI Host Controller
[    2.587394] usb usb7: Manufacturer: Linux 3.16.0-rc6+ xhci_hcd
[    2.587396] usb usb7: SerialNumber: 0000:04:00.0
[    2.587954] hub 7-0:1.0: USB hub found
[    2.587974] hub 7-0:1.0: 2 ports detected
[    2.588000] Error: Driver 'pcspkr' is already registered, aborting...
[    2.588326] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    2.588336] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 9
[    2.588443] usb usb9: New USB device found, idVendor=1d6b, idProduct=0003
[    2.588445] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.588447] usb usb9: Product: xHCI Host Controller
[    2.588449] usb usb9: Manufacturer: Linux 3.16.0-rc6+ xhci_hcd
[    2.588450] usb usb9: SerialNumber: 0000:04:00.0
[    2.593400] hub 9-0:1.0: USB hub found
[    2.593420] hub 9-0:1.0: 2 ports detected
[    2.601848] alg: No test for crc32 (crc32-pclmul)
[    2.602448] sound hdaudioC0D0: ALC1150: SKU not ready 0x00000000
[    2.602988] sound hdaudioC0D0: autoconfig: line_outs=3 (0x14/0x15/0x16/0x0/0x0) type:line
[    2.602992] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.602995] sound hdaudioC0D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    2.602997] sound hdaudioC0D0:    mono: mono_out=0x0
[    2.602999] sound hdaudioC0D0:    dig-out=0x11/0x1e
[    2.603001] sound hdaudioC0D0:    inputs:
[    2.603005] sound hdaudioC0D0:      Front Mic=0x19
[    2.603009] sound hdaudioC0D0:      Rear Mic=0x18
[    2.603011] sound hdaudioC0D0:      Line=0x1a
[    2.612435] kvm: Nested Virtualization enabled
[    2.612442] kvm: Nested Paging enabled
[    2.617273] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/sound/card0/hdaudioC0D0/input7
[    2.623200] input: HD-Audio Generic Front Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input8
[    2.623381] input: HD-Audio Generic Rear Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input9
[    2.623505] input: HD-Audio Generic Line as /devices/pci0000:00/0000:00:14.2/sound/card0/input10
[    2.623787] input: HD-Audio Generic Line Out Front as /devices/pci0000:00/0000:00:14.2/sound/card0/input11
[    2.623900] input: HD-Audio Generic Line Out Surround as /devices/pci0000:00/0000:00:14.2/sound/card0/input12
[    2.624037] input: HD-Audio Generic Line Out CLFE as /devices/pci0000:00/0000:00:14.2/sound/card0/input13
[    2.624578] input: HD-Audio Generic Front Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input14
[    2.643927] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    2.643931] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.643933] usb usb8: Product: OHCI PCI host controller
[    2.643934] usb usb8: Manufacturer: Linux 3.16.0-rc6+ ohci_hcd
[    2.643936] usb usb8: SerialNumber: 0000:00:12.0
[    2.644355] hub 8-0:1.0: USB hub found
[    2.644374] hub 8-0:1.0: 5 ports detected
[    2.645188] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    2.645203] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 10
[    2.645261] ohci-pci 0000:00:13.0: irq 18, io mem 0xfeb09000
[    2.694199] [drm] ring test on 6 succeeded in 19 usecs
[    2.694210] [drm] ring test on 7 succeeded in 2 usecs
[    2.694212] [drm] VCE initialized successfully.
[    2.698142] [drm] ib test on ring 0 succeeded in 0 usecs
[    2.702449] usb usb10: New USB device found, idVendor=1d6b, idProduct=0001
[    2.702452] usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.702454] usb usb10: Product: OHCI PCI host controller
[    2.702456] usb usb10: Manufacturer: Linux 3.16.0-rc6+ ohci_hcd
[    2.702458] usb usb10: SerialNumber: 0000:00:13.0
[    2.702731] [drm] ib test on ring 1 succeeded in 0 usecs
[    2.702887] [drm] ib test on ring 2 succeeded in 0 usecs
[    2.703063] [drm] ib test on ring 3 succeeded in 0 usecs
[    2.703247] [drm] ib test on ring 4 succeeded in 0 usecs
[    2.706323] FAT-fs (sda3): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[    2.719370] hub 10-0:1.0: USB hub found
[    2.719949] hub 10-0:1.0: 5 ports detected
[    2.726494] [drm] ib test on ring 5 succeeded
[    2.747564] [drm] ib test on ring 6 succeeded
[    2.748318] [drm] ib test on ring 7 succeeded
[    2.798435] [drm] Radeon Display Connectors
[    2.798439] [drm] Connector 0:
[    2.798441] [drm]   DP-1
[    2.798443] [drm]   HPD2
[    2.798446] [drm]   DDC: 0x6530 0x6530 0x6534 0x6534 0x6538 0x6538 0x653c 0x653c
[    2.798447] [drm]   Encoders:
[    2.798449] [drm]     DFP1: INTERNAL_UNIPHY2
[    2.798451] [drm] Connector 1:
[    2.798452] [drm]   HDMI-A-1
[    2.798454] [drm]   HPD3
[    2.798456] [drm]   DDC: 0x6550 0x6550 0x6554 0x6554 0x6558 0x6558 0x655c 0x655c
[    2.798457] [drm]   Encoders:
[    2.798459] [drm]     DFP2: INTERNAL_UNIPHY2
[    2.798460] [drm] Connector 2:
[    2.798462] [drm]   DVI-D-1
[    2.798463] [drm]   HPD1
[    2.798465] [drm]   DDC: 0x6560 0x6560 0x6564 0x6564 0x6568 0x6568 0x656c 0x656c
[    2.798466] [drm]   Encoders:
[    2.798468] [drm]     DFP3: INTERNAL_UNIPHY1
[    2.798469] [drm] Connector 3:
[    2.798471] [drm]   DVI-I-1
[    2.798472] [drm]   HPD6
[    2.798474] [drm]   DDC: 0x6580 0x6580 0x6584 0x6584 0x6588 0x6588 0x658c 0x658c
[    2.798475] [drm]   Encoders:
[    2.798477] [drm]     DFP4: INTERNAL_UNIPHY
[    2.798479] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    2.798850] Adding 7999484k swap on /dev/mapper/VG--Debian-LV--swap.  Priority:-1 extents:1 across:7999484k SSFS
[    2.826216] usb 5-1: new low-speed USB device number 2 using xhci_hcd
[    2.851971] [drm] fb mappable at 0xE098E000
[    2.851975] [drm] vram apper at 0xE0000000
[    2.851977] [drm] size 8294400
[    2.851978] [drm] fb depth is 24
[    2.851980] [drm]    pitch is 7680
[    2.852915] fbcon: radeondrmfb (fb0) is primary device
[    2.876516] Console: switching to colour frame buffer device 240x67
[    2.885387] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
[    2.885392] radeon 0000:01:00.0: registered panic notifier
[    2.895331] [drm] Initialized radeon 2.40.0 20080528 for 0000:01:00.0 on minor 0
[    2.895590] snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
[    2.895829] snd_hda_intel 0000:01:00.1: Handle VGA-switcheroo audio client
[    2.896061] snd_hda_intel 0000:01:00.1: irq 91 for MSI/MSI-X
[    2.949781] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:02.1/0000:01:00.1/sound/card1/input15
[    2.950515] input: HD-Audio Generic HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:02.1/0000:01:00.1/sound/card1/input16
[    2.951056] input: HD-Audio Generic HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:02.1/0000:01:00.1/sound/card1/input17
[    2.951475] input: HD-Audio Generic HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:02.1/0000:01:00.1/sound/card1/input18
[    2.951892] input: HD-Audio Generic HDMI/DP,pcm=10 as /devices/pci0000:00/0000:00:02.1/0000:01:00.1/sound/card1/input19
[    2.952337] input: HD-Audio Generic HDMI/DP,pcm=11 as /devices/pci0000:00/0000:00:02.1/0000:01:00.1/sound/card1/input20
[    2.988652] usb 5-1: New USB device found, idVendor=045e, idProduct=0752
[    2.988657] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.988660] usb 5-1: Product: Wired Keyboard 400
[    2.988662] usb 5-1: Manufacturer: Microsoft
[    2.989797] usb 5-1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    3.019910] hidraw: raw HID events driver (C) Jiri Kosina
[    3.035148] usbcore: registered new interface driver usbhid
[    3.035152] usbhid: USB HID core driver
[    3.038597] input: Microsoft Wired Keyboard 400 as /devices/pci0000:00/0000:00:10.1/usb5/5-1/5-1:1.0/0003:045E:0752.0001/input/input21
[    3.038907] Switched to clocksource tsc
[    3.040287] hid-generic 0003:045E:0752.0001: input,hidraw0: USB HID v1.11 Keyboard [Microsoft Wired Keyboard 400] on usb-0000:00:10.1-1/input0
[    3.162907] usb 7-2: new low-speed USB device number 2 using xhci_hcd
[    3.438907] usb 7-2: New USB device found, idVendor=192f, idProduct=0416
[    3.438915] usb 7-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    3.438920] usb 7-2: Product: USB Optical Mouse
[    3.439335] usb 7-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    3.444337] input: USB Optical Mouse as /devices/pci0000:00/0000:00:15.1/0000:04:00.0/usb7/7-2/7-2:1.0/0003:192F:0416.0002/input/input22
[    3.445357] hid-generic 0003:192F:0416.0002: input,hidraw1: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:04:00.0-2/input0
[    3.824436] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: errors=remount-ro
[    4.098927] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: errors=remount-ro
[    4.114831] systemd-journald[183]: Received request to flush runtime journal from PID 1
[    4.320549] RPC: Registered named UNIX socket transport module.
[    4.320553] RPC: Registered udp transport module.
[    4.320554] RPC: Registered tcp transport module.
[    4.320556] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.324118] FS-Cache: Loaded
[    4.331387] FS-Cache: Netfs 'nfs' registered for caching
[    4.340813] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    4.651452] Bluetooth: Core ver 2.19
[    4.651498] NET: Registered protocol family 31
[    4.651500] Bluetooth: HCI device and connection manager initialized
[    4.651565] Bluetooth: HCI socket layer initialized
[    4.651572] Bluetooth: L2CAP socket layer initialized
[    4.651597] Bluetooth: SCO socket layer initialized
[    4.663484] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.663488] Bluetooth: BNEP filters: protocol multicast
[    4.663499] Bluetooth: BNEP socket layer initialized
[    4.686224] r8169 0000:05:00.0 eth0: link down
[    4.686305] r8169 0000:05:00.0 eth0: link down
[    4.686462] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.471432] r8169 0000:05:00.0 eth0: link up
[    7.471453] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

--------------040501070900020109070301--
