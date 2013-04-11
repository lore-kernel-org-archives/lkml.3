Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935627Ab3DKAo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:44:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43792 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934600Ab3DKAoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:44:55 -0400
Date: Thu, 11 Apr 2013 02:44:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@sr71.net>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/5] clean up checks against "high_memory" variable
Message-ID: <20130411004449.GB17544@pd.tnic>
References: <20130410233249.7FFCB63B@viggo.jf.intel.com>
 <20130410233250.FF8E7E2D@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130410233250.FF8E7E2D@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 04:32:50PM -0700, Dave Hansen wrote:
> 
> We have a new debugging check on x86 that has caught a number
> of long-standing bugs.  However, there is a _bit_ of collateral
> damage with things that call __pa(high_memory).
> 
> We are now checking that any addresses passed to __pa() are
> *valid* and can be dereferenced.
> 
> "high_memory", however, is not valid.  It marks the start of
> highmem, and isn't itself a valid pointer.  But, those users
> are really just asking "is this vaddr mapped"?  So, give them
> a helper that does that, plus is also kind to our new
> debugging check.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

FWIW,

this one already fixes the BUG below I'm seeing when booting 32-bit
Atom guests in qemu.

Tested-by: Borislav Petkov <bp@suse.de>

More testing tomorrow.

[   57.035880] ------------[ cut here ]------------
[   57.036190] kernel BUG at arch/x86/mm/physaddr.c:79!
[   57.036190] invalid opcode: 0000 [#1] PREEMPT SMP 
[   57.036190] Modules linked in:
[   57.036190] Pid: 2555, comm: wdm Tainted: G S      W    3.9.0-rc6+ #5 Bochs Bochs
[   57.036190] EIP: 0060:[<c10321b1>] EFLAGS: 00010206 CPU: 56
[   57.036190] EIP is at __phys_addr+0x71/0x80
[   57.036190] EAX: 00000000 EBX: 373fe000 ECX: 0000000c EDX: 00000000
[   57.036190] ESI: 00000000 EDI: 00002000 EBP: ec509f40 ESP: ec509f3c
[   57.036190]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   57.036190] CR0: 8005003b CR2: b7620b48 CR3: 2f5b5000 CR4: 000006d0
[   57.036190] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   57.036190] DR6: ffff0ff0 DR7: 00000400
[   57.036190] Process wdm (pid: 2555, ti=ec508000 task=ec500000 task.ti=ec508000)
[   57.036190] Stack:
[   57.036190]  00002000 ec509f64 c1304268 ec570000 ec50e300 bf87299c 00002000 ec50e300
[   57.036190]  c1304240 00002000 ec509f8c c1120276 ec509f98 00000000 ed540314 c1304240
[   57.036190]  ec570000 ec50e300 00000000 08065294 ec509fac c1120488 ec509f98 00000000
[   57.036190] Call Trace:
[   57.036190]  [<c1304268>] read_mem+0x28/0xf0
[   57.036190]  [<c1304240>] ? write_mem+0xf0/0xf0
[   57.036190]  [<c1120276>] vfs_read+0x86/0x140
[   57.036190]  [<c1304240>] ? write_mem+0xf0/0xf0
[   57.036190]  [<c1120488>] sys_read+0x48/0x90
[   57.036190]  [<c15231fe>] sysenter_do_call+0x12/0x36
[   57.036190] Code: 39 0b c2 81 c2 00 00 80 00 39 d0 72 cc 8b 15 2c 4c 74 c1 81 ea 00 a0 a4 00 81 e2 00 00 c0 ff 81 ea 00 20 00 00 39 d0 73 b0 0f 0b <0f> 0b 0f 0b 8d 74 26 00 8d bc 27 00 00 00 00 55 89 e5 53 3e 8d
[   57.036190] EIP: [<c10321b1>] __phys_addr+0x71/0x80 SS:ESP 0068:ec509f3c
[   57.619214] ---[ end trace 4e05f3724c460358 ]---

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
