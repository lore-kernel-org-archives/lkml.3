Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab3J2Pix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:38:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757884Ab3J2Piv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:38:51 -0400
Date: Tue, 29 Oct 2013 16:40:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/13] uprobes: allow arch access to xol slot
Message-ID: <20131029154006.GA22344@redhat.com>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-4-git-send-email-dave.long@linaro.org> <20131019163627.GA7837@redhat.com> <52671265.2020107@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52671265.2020107@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22, David Long wrote:
>
> On 10/19/13 12:36, Oleg Nesterov wrote:
>>
>> How about
>>
>> 	void __weak arch_uprobe_xol_copy(...)
>> 	{
>> 		copy_to_page(...);
>> 	}
>>
>> then just
>>
>> 	- copy_to_page(...);
>> 	+ arch_uprobe_xol_copy(...);
>>
>> ?
>>
>
> I was trying to avoid duplicating the VM calls in the
> architecture-specific implementations,

Yes, I understand... But this uglifies the generic code.

> but maybe that is the cleaner way
> to do it after all.  I've made changes as suggested above.

Thanks. and this uglifies arm code I guess ;)


David. Perhaps we can avoid the new hook altogether? What if we do
the simple change below (it ignores powerpc) ?

Then arm can add "unsigned long ixol[2]" into its arch_uprobe, and
arch_uprobe_analyze_insn() can initialize this member correctly.

What do you think?

Oleg.

--- x/arch/x86/include/asm/uprobes.h
+++ x/arch/x86/include/asm/uprobes.h
@@ -35,7 +35,10 @@ typedef u8 uprobe_opcode_t;
 
 struct arch_uprobe {
 	u16				fixups;
-	u8				insn[MAX_UINSN_BYTES];
+	union {
+		u8			insn[MAX_UINSN_BYTES];
+		u8			ixol[MAX_UINSN_BYTES];
+	}
 #ifdef CONFIG_X86_64
 	unsigned long			rip_rela_target_address;
 #endif
--- x/kernel/events/uprobes.c
+++ x/kernel/events/uprobes.c
@@ -1264,7 +1264,8 @@ static unsigned long xol_get_insn_slot(s
 		return 0;
 
 	/* Initialize the slot */
-	copy_to_page(area->page, xol_vaddr, uprobe->arch.insn, MAX_UINSN_BYTES);
+	copy_to_page(area->page, xol_vaddr,
+			uprobe->arch.ixol, sizeof(uprobe->arch.ixol));
 	/*
 	 * We probably need flush_icache_user_range() but it needs vma.
 	 * This should work on supported architectures too.

