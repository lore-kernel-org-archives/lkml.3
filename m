Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaHMA1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 20:27:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50293 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaHMA1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 20:27:50 -0400
Message-ID: <53EAB104.1050208@codeaurora.org>
Date: Tue, 12 Aug 2014 17:27:48 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Rob Herring <robh@kernel.org>, Laura Abbott <lauraa@codeaurora.org>,
        Liu hua <sdu.liu@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Doug Anderson <dianders@google.com>, Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Mark Salter <msalter@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/7] arm: use fixmap for text patching when text is
 RO
References: <1407867869-5194-1-git-send-email-keescook@chromium.org> <1407867869-5194-4-git-send-email-keescook@chromium.org> <53EA897D.8030901@codeaurora.org> <CAGXu5j+TPBs9h9YvVDt=g4WFykHgzcde9Ujuef=cRQAou8hZoA@mail.gmail.com>
In-Reply-To: <CAGXu5j+TPBs9h9YvVDt=g4WFykHgzcde9Ujuef=cRQAou8hZoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/14 14:47, Kees Cook wrote:
> On Tue, Aug 12, 2014 at 2:39 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> On 08/12/14 11:24, Kees Cook wrote:
>>> diff --git a/arch/arm/kernel/patch.c b/arch/arm/kernel/patch.c
>>> index 07314af47733..03dd4e39c833 100644
>>> --- a/arch/arm/kernel/patch.c
>>> +++ b/arch/arm/kernel/patch.c
>>> @@ -13,21 +16,69 @@ struct patch {
>>>       unsigned int insn;
>>>  };
>>>
>>> -void __kprobes __patch_text(void *addr, unsigned int insn)
>>> +static DEFINE_SPINLOCK(patch_lock);
>>> +
>>> +static void __kprobes *patch_map(void *addr, int fixmap, unsigned long *flags)
>>> +{
>>> +     unsigned int uintaddr = (uintptr_t) addr;
>>> +     bool module = !core_kernel_text(uintaddr);
>>> +     struct page *page;
>>> +
>>> +     if (module && IS_ENABLED(CONFIG_DEBUG_SET_MODULE_RONX))
>>> +             page = vmalloc_to_page(addr);
>>> +     else if (!module && IS_ENABLED(CONFIG_DEBUG_RODATA))
>>> +             page = virt_to_page(addr);
>>> +     else
>>> +             return addr;
>>> +
>>> +     if (flags)
>>> +             spin_lock_irqsave(&patch_lock, *flags);
>>> +
>>> +     set_fixmap(fixmap, page_to_phys(page));
>>> +
>>> +     return (void *) (__fix_to_virt(fixmap) + (uintaddr & ~PAGE_MASK));
>>> +}
>>> +
>>> +static void __kprobes patch_unmap(int fixmap, unsigned long *flags)
>>> +{
>>> +     clear_fixmap(fixmap);
>>> +
>>> +     if (flags)
>>> +             spin_unlock_irqrestore(&patch_lock, *flags);
>>> +}
>> Has the kbuildbot complained about this one yet?
>>
>>   CHECK  arch/arm/kernel/patch.c
>>   arch/arm/kernel/patch.c:47:39: warning: context imbalance in
>> 'patch_unmap' - unexpected unlock
>>
>> I guess we're going to ignore it.
> No, nothing yet from buildbot, let me do a sparse run -- I think we
> can just add annotation and we'll be okay.
>
>

Ok. I tried to move code around but sparse still complains because of
conditional locking.

---8<---

diff --git a/arch/arm/kernel/patch.c b/arch/arm/kernel/patch.c
index 03dd4e39c833..f6d4de3826a0 100644
--- a/arch/arm/kernel/patch.c
+++ b/arch/arm/kernel/patch.c
@@ -18,33 +18,17 @@ struct patch {
 
 static DEFINE_SPINLOCK(patch_lock);
 
-static void __kprobes *patch_map(void *addr, int fixmap, unsigned long *flags)
+static struct page __kprobes *patch_page(void *addr)
 {
 	unsigned int uintaddr = (uintptr_t) addr;
 	bool module = !core_kernel_text(uintaddr);
-	struct page *page;
 
 	if (module && IS_ENABLED(CONFIG_DEBUG_SET_MODULE_RONX))
-		page = vmalloc_to_page(addr);
+		return vmalloc_to_page(addr);
 	else if (!module && IS_ENABLED(CONFIG_DEBUG_RODATA))
-		page = virt_to_page(addr);
-	else
-		return addr;
+		return virt_to_page(addr);
 
-	if (flags)
-		spin_lock_irqsave(&patch_lock, *flags);
-
-	set_fixmap(fixmap, page_to_phys(page));
-
-	return (void *) (__fix_to_virt(fixmap) + (uintaddr & ~PAGE_MASK));
-}
-
-static void __kprobes patch_unmap(int fixmap, unsigned long *flags)
-{
-	clear_fixmap(fixmap);
-
-	if (flags)
-		spin_unlock_irqrestore(&patch_lock, *flags);
+	return NULL;
 }
 
 void __kprobes __patch_text_real(void *addr, unsigned int insn, bool remap)
@@ -54,10 +38,18 @@ void __kprobes __patch_text_real(void *addr, unsigned int insn, bool remap)
 	bool twopage = false;
 	unsigned long flags;
 	void *waddr = addr;
+	struct page *page = NULL;
 	int size;
 
-	if (remap)
-		waddr = patch_map(addr, FIX_TEXT_POKE0, &flags);
+	if (remap) {
+		page = patch_page(addr);
+		if (page) {
+			spin_lock_irqsave(&patch_lock, flags);
+			set_fixmap(FIX_TEXT_POKE0, page_to_phys(page));
+			waddr = (void *)(__fix_to_virt(FIX_TEXT_POKE0) +
+				(uintaddr & ~PAGE_MASK));
+		}
+	}
 
 	if (thumb2 && __opcode_is_thumb16(insn)) {
 		*(u16 *)waddr = __opcode_to_mem_thumb16(insn);
@@ -69,15 +61,25 @@ void __kprobes __patch_text_real(void *addr, unsigned int insn, bool remap)
 		u16 *addrh1 = waddr + 2;
 
 		twopage = (uintaddr & ~PAGE_MASK) == PAGE_SIZE - 2;
-		if (twopage && remap)
-			addrh1 = patch_map(addr + 2, FIX_TEXT_POKE1, NULL);
+		if (twopage && remap) {
+			struct page *page2;
+
+			page2 = patch_page(addr + 2);
+			if (page2) {
+				set_fixmap(FIX_TEXT_POKE1, page_to_phys(page));
+				addrh1 = (u16 *)(__fix_to_virt(FIX_TEXT_POKE1) +
+						(uintaddr & ~PAGE_MASK));
+			} else {
+				addrh1 = addr + 2;
+			}
+		}
 
 		*addrh0 = __opcode_to_mem_thumb16(first);
 		*addrh1 = __opcode_to_mem_thumb16(second);
 
 		if (twopage && addrh1 != addr + 2) {
 			flush_kernel_vmap_range(addrh1, 2);
-			patch_unmap(FIX_TEXT_POKE1, NULL);
+			clear_fixmap(FIX_TEXT_POKE1);
 		}
 
 		size = sizeof(u32);
@@ -91,9 +93,10 @@ void __kprobes __patch_text_real(void *addr, unsigned int insn, bool remap)
 		size = sizeof(u32);
 	}
 
-	if (waddr != addr) {
+	if (page) {
 		flush_kernel_vmap_range(waddr, twopage ? size / 2 : size);
-		patch_unmap(FIX_TEXT_POKE0, &flags);
+		clear_fixmap(FIX_TEXT_POKE0);
+		spin_unlock_irqrestore(&patch_lock, flags);
 	}
 
 	flush_icache_range((uintptr_t)(addr),

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

