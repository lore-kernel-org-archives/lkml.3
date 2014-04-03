Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaDCXxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 19:53:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:19580 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbaDCXw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 19:52:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,791,1389772800"; 
   d="scan'208";a="514476852"
Message-ID: <533DF455.4040908@linux.intel.com>
Date: Fri, 04 Apr 2014 07:52:53 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [BUG] x86: reboot doesn't reboot
References: <20140403021411.6236996f@gandalf.local.home>	<070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>	<533D001A.5030802@linux.intel.com>	<20140403094155.04cc00bc@gandalf.local.home>	<533D6BE7.3020608@zytor.com>	<20140403104721.5f6c32b6@gandalf.local.home>	<20140403111711.5bed4ff7@gandalf.local.home>	<533D7C4F.4010504@zytor.com>	<533D7C93.7080105@zytor.com>	<20140403113921.23dceb75@gandalf.local.home>	<533D8516.1040803@zytor.com>	<20140403121314.246b03a7@gandalf.local.home>	<533DED74.6050202@linux.intel.com> <20140403194018.7c67aec7@gandalf.local.home>
In-Reply-To: <20140403194018.7c67aec7@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/4 7:40, Steven Rostedt wrote:
> On Fri, 04 Apr 2014 07:23:32 +0800
> "Li, Aubrey" <aubrey.li@linux.intel.com> wrote:
> 
>> Can you please send the dmi table out?
> 
> I already did as a gz attachment to H. Peter. You were on the Cc, did
> you not receive it?
> 
Oh, I got it. This is a Preproduction machine.
When reboot failed via a method (=e or =p), there are two case.

Case 1: this method do nothing, pass the attempt chance to the next method
Case 2: this method hangs the system

I want to know if CF9 is case 1 or case 2. Could you please try the following
patch *without* any reboot parameters?

(1) If we didn't see any string, then EFI hangs your box.
(2) if we see the first string but not the second one, CF9 hangs your box
(3) if we see both, couldn't be, because BIOS works on your box.

Thanks,
-Aubrey

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 654b465..4de3027 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -547,11 +547,13 @@ static void native_machine_emergency_restart(void)
 				u8 reboot_code = reboot_mode == REBOOT_WARM ?
 					0x06 : 0x0E;
 				u8 cf9 = inb(0xcf9) & ~reboot_code;
+				pr_info("reboot via CF9...\n");
 				outb(cf9|2, 0xcf9); /* Request hard reset */
 				udelay(50);
 				/* Actually do the reset */
 				outb(cf9|reboot_code, 0xcf9);
 				udelay(50);
+				pr_info("reboot via CF9 done...\n");
 			}
 			reboot_type = BOOT_BIOS;
 			break;



