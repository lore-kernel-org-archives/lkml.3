Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaL1LMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 06:12:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaL1LMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 06:12:05 -0500
Message-ID: <549FE582.8060108@suse.com>
Date: Sun, 28 Dec 2014 12:12:02 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?KOI8-R?Q?=F0=CC=C1=CD=C5=CE_=F0=C5=D4=D2=CF=D7?= 
	<plamen@petrovi.no-ip.info>,
        linux-kernel@vger.kernel.org
CC: "'Thomas Gleixner'" <tglx@linutronix.de>
Subject: Re: [BISECTED] 3.19-rc1 regression - kernel does not load in GRUB
 0.97 (GRUB Legacy)
References: <000001d01f10$85f506f0$91df14d0$@petrovi.no-ip.info> <549EB88D.20403@suse.com> <000301d0226e$bb275b50$317611f0$@petrovi.no-ip.info>
In-Reply-To: <000301d0226e$bb275b50$317611f0$@petrovi.no-ip.info>
Content-Type: multipart/mixed;
 boundary="------------060708040205050005030202"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060708040205050005030202
Content-Type: text/plain; charset=koi8-r; format=flowed
Content-Transfer-Encoding: 8bit

On 12/28/2014 08:20 AM, Пламен Петров wrote:
>> -----Original Message-----
>> From: Juergen Gross [mailto:jgross@suse.com]
>> Sent: Saturday, December 27, 2014 3:48 PM
>> To: Пламен Петров; linux-kernel@vger.kernel.org
>> Cc: 'Thomas Gleixner'
>> Subject: Re: [BISECTED] 3.19-rc1 regression - kernel does not load in GRUB
>> 0.97 (GRUB Legacy)
>>
>> On 12/24/2014 01:28 AM, Пламен Петров wrote:
>>> Hello!
>>>
>>> I use GRUB Legacy bootloader (version 0.97) on a couple machines, and
>>> where 3.18.x loads fine, 3.19-rc1 does not.
>>>
>>> While compiling I used the attached .config file accompanied by "make
>>> olddefconfig"
>>
>> Can you tell me something about the hardware (processor model)?
>> You are not booting the system under VMWare by any chance?
>
> As a matter of fact - I am compiling in a VMware Player (6.0.3
> build-1895310) virtual machine, boot testing there, and then if everything
> is OK, I transfer the monolithic kernel produced on 3 virtual machines that
> run on EXSi and 2 actual servers. So along those lines - the failing
> 3.19-rc1 never saw actual hardware - it was all tested (and bisected) inside
> a VM.

Thanks. VMWare having problems with my patch is a known issue. I've
already sent a patch working around that issue (VMWare has a bug
emulating the PAT MSR). You can either use that patch (attached for
your convenience) or use the "nopat" option.


Juergen


--------------060708040205050005030202
Content-Type: text/x-patch;
 name="0001-x86-don-t-rely-on-VMWare-emulating-PAT-MSR-correctly.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-don-t-rely-on-VMWare-emulating-PAT-MSR-correctly.pa";
 filename*1="tch"

>From 4b65fb80338c71673cabfa9fa9b0f80f5a4bc320 Mon Sep 17 00:00:00 2001
From: Juergen Gross <jgross@suse.com>
Date: Tue, 16 Dec 2014 07:43:51 +0100
Subject: [PATCH] x86: don't rely on VMWare emulating PAT MSR correctly

VMWare seems not to emulate the PAT MSR correctly: reaeding
MSR_IA32_CR_PAT returns 0 even after writing another value to it.

Detect this bug and don't use the read value if it is 0.

Commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2 ("x86: Enable PAT to
use cache mode translation tables") triggers this VMWare bug when the
kernel is booted as a VMWare guest.

Reported-by: Jongman Heo <jongman.heo@samsung.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Jongman Heo <jongman.heo@samsung.com>
---
 arch/x86/mm/pat.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index edf299c..7ac6869 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -234,8 +234,13 @@ void pat_init(void)
 	      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
 
 	/* Boot CPU check */
-	if (!boot_pat_state)
+	if (!boot_pat_state) {
 		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
+		if (!boot_pat_state) {
+			pat_disable("PAT read returns always zero, disabled.");
+			return;
+		}
+	}
 
 	wrmsrl(MSR_IA32_CR_PAT, pat);
 
-- 
2.1.2


--------------060708040205050005030202--
