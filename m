Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbbAEM7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:59:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48073 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbbAEM7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:59:48 -0500
Date: Mon, 5 Jan 2015 13:59:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86_64,entry: Fix RCX for traced syscalls
Message-ID: <20150105125943.GC19655@pd.tnic>
References: <cover.1415403984.git.luto@amacapital.net>
 <20059f41189ac95da62cc8b23709c0eaba168186.1415403984.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20059f41189ac95da62cc8b23709c0eaba168186.1415403984.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 03:58:17PM -0800, Andy Lutomirski wrote:
> The int_ret_from_sys_call and syscall tracing code disagrees with
> the sysret path as to the value of RCX.
> 
> The Intel SDM, the AMD APM, and my laptop all agree that sysret
> returns with RCX == RIP.  The syscall tracing code does not respect
> this property.
> 
> For example, this program:
> 
> int main()
> {
> 	extern const char syscall_rip[];
> 	unsigned long rcx = 1;
> 	unsigned long orig_rcx = rcx;
> 	asm ("mov $-1, %%eax\n\t"
> 	     "syscall\n\t"
> 	     "syscall_rip:"
> 	     : "+c" (rcx) : : "r11");
> 	printf("syscall: RCX = %lX  RIP = %lX  orig RCX = %lx\n",
> 	       rcx, (unsigned long)syscall_rip, orig_rcx);
> 	return 0;
> }
> 
> prints:
> syscall: RCX = 400556  RIP = 400556  orig RCX = 1
> 
> Running it under strace gives this instead:
> syscall: RCX = FFFFFFFFFFFFFFFF  RIP = 400556  orig RCX = 1

I can trigger the same even without tracing it:

syscall: RCX = FFFFFFFFFFFFFFFF  RIP = 40052C  orig RCX = 1

> This changes FIXUP_TOP_OF_STACK to match sysret, causing the test to
> show RCX == RIP even under strace.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/kernel/entry_64.S | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index df088bb03fb3..3710b8241945 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -143,7 +143,8 @@ ENDPROC(native_usergs_sysret64)
>  	movq \tmp,RSP+\offset(%rsp)
>  	movq $__USER_DS,SS+\offset(%rsp)
>  	movq $__USER_CS,CS+\offset(%rsp)
> -	movq $-1,RCX+\offset(%rsp)
> +	movq RIP+\offset(%rsp),\tmp  /* get rip */
> +	movq \tmp,RCX+\offset(%rsp)  /* copy it to rcx as sysret would do */
>  	movq R11+\offset(%rsp),\tmp  /* get eflags */
>  	movq \tmp,EFLAGS+\offset(%rsp)
>  	.endm
> --

For some reason this patch is causing ata resets on by box, see the
end of this mail. So something's not kosher yet. If I boot the kernel
without it, it all seems ok.

Btw, this change got introduced in 2002 where it used to return rIP in
%rcx before, but it got changed to return -1 for rIP for some reason.

commit af53c7a2c81399b805b6d4eff887401a5e50feef
Author: Andi Kleen <ak@muc.de>
Date:   Fri Apr 19 20:23:17 2002 -0700

    [PATCH] x86-64 architecture specific sync for 2.5.8
    
    This patch brings 2.5.8 in sync with the x86-64 2.4 development tree again
    (excluding device drivers)
    
    It has lots of bug fixes and enhancements. It only touches architecture
    specific files.

...

diff --git a/arch/x86_64/kernel/entry.S b/arch/x86_64/kernel/entry.S
index 6b98b90891f4..16c6e3faf5a7 100644
--- a/arch/x86_64/kernel/entry.S
+++ b/arch/x86_64/kernel/entry.S
@@ -5,7 +5,7 @@
  *  Copyright (C) 2000, 2001, 2002  Andi Kleen SuSE Labs
  *  Copyright (C) 2000  Pavel Machek <pavel@suse.cz>
  * 
- *  $Id: entry.S,v 1.66 2001/11/11 17:47:47 ak Exp $           
+ *  $Id$
  */
 
 /*
@@ -39,8 +39,7 @@
 #include <asm/msr.h>
 #include <asm/unistd.h>
 #include <asm/thread_info.h>
-       
-#define RIP_SYMBOL_NAME(x) x(%rip)
+#include <asm/hw_irq.h>
 
        .code64
 
@@ -67,8 +66,7 @@
        movq    \tmp,RSP(%rsp)
        movq    $__USER_DS,SS(%rsp)
        movq    $__USER_CS,CS(%rsp)
-       movq    RCX(%rsp),\tmp  /* get return address */
-       movq    \tmp,RIP(%rsp)
+       movq    $-1,RCX(%rsp)
        movq    R11(%rsp),\tmp  /* get eflags */
        movq    \tmp,EFLAGS(%rsp)
        .endm
@@ -76,8 +74,6 @@
        .macro RESTORE_TOP_OF_STACK tmp,offset=0
        movq   RSP-\offset(%rsp),\tmp
        movq   \tmp,PDAREF(pda_oldrsp)
-       movq   RIP-\offset(%rsp),\tmp
-       movq   \tmp,RCX-\offset(%rsp)
        movq   EFLAGS-\offset(%rsp),\tmp
        movq   \tmp,R11-\offset(%rsp)
        .endm

---

[  180.059170] ata1.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x6 frozen
[  180.066873] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.072158] ata1.00: cmd 61/08:00:a8:ac:d9/00:00:23:00:00/40 tag 0 ncq 4096 out
[  180.072158]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.086912] ata1.00: status: { DRDY }
[  180.090591] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.095846] ata1.00: cmd 61/08:08:18:ae:d9/00:00:23:00:00/40 tag 1 ncq 4096 out
[  180.095846]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.110603] ata1.00: status: { DRDY }
[  180.114283] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.119539] ata1.00: cmd 61/10:10:f0:b1:d9/00:00:23:00:00/40 tag 2 ncq 8192 out
[  180.119539]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.134292] ata1.00: status: { DRDY }
[  180.137973] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.143226] ata1.00: cmd 61/08:18:00:98:18/00:00:1d:00:00/40 tag 3 ncq 4096 out
[  180.143226]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.158105] ata1.00: status: { DRDY }
[  180.161809] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.167071] ata1.00: cmd 61/10:20:18:98:18/00:00:1d:00:00/40 tag 4 ncq 8192 out
[  180.167071]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.181822] ata1.00: status: { DRDY }
[  180.185503] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.190756] ata1.00: cmd 61/a0:28:e0:7c:5d/25:00:1d:00:00/40 tag 5 ncq 4931584 out
[  180.190756]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.205770] ata1.00: status: { DRDY }
[  180.209448] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.214692] ata1.00: cmd 61/80:30:80:a2:5d/4a:00:1d:00:00/40 tag 6 ncq 9764864 out
[  180.214692]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.229701] ata1.00: status: { DRDY }
[  180.233381] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.238631] ata1.00: cmd 61/08:38:00:ed:5d/22:00:1d:00:00/40 tag 7 ncq 4460544 out
[  180.238631]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.253647] ata1.00: status: { DRDY }
[  180.257321] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.262576] ata1.00: cmd 61/08:40:38:b8:18/00:00:1d:00:00/40 tag 8 ncq 4096 out
[  180.262576]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.277321] ata1.00: status: { DRDY }
[  180.281007] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.286263] ata1.00: cmd 61/10:48:78:b8:18/00:00:1d:00:00/40 tag 9 ncq 8192 out
[  180.286263]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.301013] ata1.00: status: { DRDY }
[  180.304693] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.309947] ata1.00: cmd 61/08:50:60:98:d8/00:00:1d:00:00/40 tag 10 ncq 4096 out
[  180.309947]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.324781] ata1.00: status: { DRDY }
[  180.328461] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.333713] ata1.00: cmd 61/08:58:18:f8:a1/00:00:20:00:00/40 tag 11 ncq 4096 out
[  180.333713]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.348550] ata1.00: status: { DRDY }
[  180.352235] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.357484] ata1.00: cmd 61/08:60:00:88:a0/00:00:20:00:00/40 tag 12 ncq 4096 out
[  180.357484]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.372318] ata1.00: status: { DRDY }
[  180.375997] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.381251] ata1.00: cmd 61/48:68:c8:ac:dc/00:00:22:00:00/40 tag 13 ncq 36864 out
[  180.381251]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.396203] ata1.00: status: { DRDY }
[  180.399882] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.405134] ata1.00: cmd 61/08:70:40:c8:9d/00:00:20:00:00/40 tag 14 ncq 4096 out
[  180.405134]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.419993] ata1.00: status: { DRDY }
[  180.423674] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.428920] ata1.00: cmd 61/08:78:58:a7:9c/00:00:20:00:00/40 tag 15 ncq 4096 out
[  180.428920]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.443989] ata1.00: status: { DRDY }
[  180.447892] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.453367] ata1.00: cmd 61/08:80:28:c5:dd/00:00:25:00:00/40 tag 16 ncq 4096 out
[  180.453367]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.469053] ata1.00: status: { DRDY }
[  180.472950] ata1.00: failed command: READ FPDMA QUEUED
[  180.478330] ata1.00: cmd 60/20:88:00:42:3c/00:00:1d:00:00/40 tag 17 ncq 16384 in
[  180.478330]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.494011] ata1.00: status: { DRDY }
[  180.497910] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.503378] ata1.00: cmd 61/10:90:80:98:d8/00:00:23:00:00/40 tag 18 ncq 8192 out
[  180.503378]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.519072] ata1.00: status: { DRDY }
[  180.522970] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.528434] ata1.00: cmd 61/08:98:88:99:d8/00:00:23:00:00/40 tag 19 ncq 4096 out
[  180.528434]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.544106] ata1.00: status: { DRDY }
[  180.547997] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.553462] ata1.00: cmd 61/08:a0:c8:99:d8/00:00:23:00:00/40 tag 20 ncq 4096 out
[  180.553462]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.569137] ata1.00: status: { DRDY }
[  180.573030] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.578508] ata1.00: cmd 61/08:a8:e0:9c:d8/00:00:23:00:00/40 tag 21 ncq 4096 out
[  180.578508]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.594221] ata1.00: status: { DRDY }
[  180.598126] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.603591] ata1.00: cmd 61/10:b0:18:9f:d8/00:00:23:00:00/40 tag 22 ncq 8192 out
[  180.603591]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.619266] ata1.00: status: { DRDY }
[  180.623157] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.628614] ata1.00: cmd 61/08:b8:78:b2:d8/00:00:23:00:00/40 tag 23 ncq 4096 out
[  180.628614]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.644286] ata1.00: status: { DRDY }
[  180.648178] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.653642] ata1.00: cmd 61/08:c0:b8:a3:d9/00:00:23:00:00/40 tag 24 ncq 4096 out
[  180.653642]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.669316] ata1.00: status: { DRDY }
[  180.673205] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.678667] ata1.00: cmd 61/08:c8:00:a5:d9/00:00:23:00:00/40 tag 25 ncq 4096 out
[  180.678667]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.694340] ata1.00: status: { DRDY }
[  180.698231] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.703690] ata1.00: cmd 61/08:d0:78:a9:d9/00:00:23:00:00/40 tag 26 ncq 4096 out
[  180.703690]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.719368] ata1.00: status: { DRDY }
[  180.723258] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.728720] ata1.00: cmd 61/08:d8:10:aa:d9/00:00:23:00:00/40 tag 27 ncq 4096 out
[  180.728720]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.744390] ata1.00: status: { DRDY }
[  180.748276] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.753737] ata1.00: cmd 61/08:e0:20:aa:d9/00:00:23:00:00/40 tag 28 ncq 4096 out
[  180.753737]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.769414] ata1.00: status: { DRDY }
[  180.773303] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.778760] ata1.00: cmd 61/10:e8:20:ab:d9/00:00:23:00:00/40 tag 29 ncq 8192 out
[  180.778760]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.794433] ata1.00: status: { DRDY }
[  180.798323] ata1.00: failed command: WRITE FPDMA QUEUED
[  180.803785] ata1.00: cmd 61/08:f0:90:ac:d9/00:00:23:00:00/40 tag 30 ncq 4096 out
[  180.803785]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  180.819455] ata1.00: status: { DRDY }
[  180.823358] ata1: hard resetting link
[  181.131630] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  181.140035] ata1.00: configured for UDMA/133
[  181.144549] ata1.00: device reported invalid CHS sector 0
[  181.150207] ata1.00: device reported invalid CHS sector 0
[  181.155843] ata1.00: device reported invalid CHS sector 0
[  181.161481] ata1.00: device reported invalid CHS sector 0
[  181.167147] ata1.00: device reported invalid CHS sector 0
[  181.172782] ata1.00: device reported invalid CHS sector 0
[  181.178407] ata1.00: device reported invalid CHS sector 0
[  181.184033] ata1.00: device reported invalid CHS sector 0
[  181.189655] ata1.00: device reported invalid CHS sector 0
[  181.195267] ata1.00: device reported invalid CHS sector 0
[  181.200882] ata1.00: device reported invalid CHS sector 0
[  181.206489] ata1.00: device reported invalid CHS sector 0
[  181.212107] ata1.00: device reported invalid CHS sector 0
[  181.217720] ata1.00: device reported invalid CHS sector 0
[  181.223326] ata1.00: device reported invalid CHS sector 0
[  181.228936] ata1.00: device reported invalid CHS sector 0
[  181.234533] ata1.00: device reported invalid CHS sector 0
[  181.240134] ata1.00: device reported invalid CHS sector 0
[  181.245726] ata1.00: device reported invalid CHS sector 0
[  181.251323] ata1.00: device reported invalid CHS sector 0
[  181.256913] ata1.00: device reported invalid CHS sector 0
[  181.262505] ata1.00: device reported invalid CHS sector 0
[  181.268087] ata1.00: device reported invalid CHS sector 0
[  181.273672] ata1.00: device reported invalid CHS sector 0
[  181.279257] ata1.00: device reported invalid CHS sector 0
[  181.284836] ata1.00: device reported invalid CHS sector 0
[  181.290416] ata1.00: device reported invalid CHS sector 0
[  181.295988] ata1.00: device reported invalid CHS sector 0
[  181.301571] ata1.00: device reported invalid CHS sector 0
[  181.307139] ata1.00: device reported invalid CHS sector 0
[  181.312708] ata1.00: device reported invalid CHS sector 0
[  181.318426] ata1: EH complete

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
