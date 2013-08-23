Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab3HWIyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:54:14 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53936 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3HWIyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:54:12 -0400
Message-ID: <52172330.4030000@hitachi.com>
Date: Fri, 23 Aug 2013 17:54:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] kprobes: add new dma insn slot cache for s390
References: <1377086465-6471-1-git-send-email-heiko.carstens@de.ibm.com> <521575C2.7050504@hitachi.com> <20130822055254.GA4293@osiris> <5216E59B.20109@hitachi.com> <20130823080949.GA4282@osiris>
In-Reply-To: <20130823080949.GA4282@osiris>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/23 17:09), Heiko Carstens wrote:
> On Fri, Aug 23, 2013 at 01:31:23PM +0900, Masami Hiramatsu wrote:
>> (2013/08/22 14:52), Heiko Carstens wrote:
>>> Therefore I need to different insn slot caches, where the slots are either
>>> allocated with __get_free_page(GFP_KERNEL | GFP_DMA) (for the kernel image)
>>> or module_alloc(PAGE_SIZE) for modules.
>>>
>>> I can't have a single cache which satifies both areas.
>>
>> Oh, I see.
>> Indeed, that enough reason to add a new cache... By the way, is there
>> any way to implement it without new kconfig like DMAPROBE and dma flag?
>> AFAICS, since such flag is strongly depends on the s390 arch, I don't
>> like to put it in kernel/kprobes.c.
>>
>> Perhaps, we can make insn slot more generic, e.g. create new slot type
>> with passing page allocator.
> 
> Something like below?
> (only compile tested and on top of the previous patches).

Yes! this is exactly what I thought :)

> I'm not sure, since that would expose struct kprobe_insn_cache.

That is OK, since it is required for some arch.
Could you update the series with this change?

Thank you!

> 
>  arch/Kconfig               |  7 -------
>  arch/s390/Kconfig          |  1 -
>  arch/s390/kernel/kprobes.c | 20 ++++++++++++++++++
>  include/linux/kprobes.h    | 14 ++++++++-----
>  kernel/kprobes.c           | 51 ++++++++++++++++------------------------------
>  5 files changed, 47 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 7010d68..1feb169 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -76,13 +76,6 @@ config OPTPROBES
>  	depends on KPROBES && HAVE_OPTPROBES
>  	depends on !PREEMPT
>  
> -config DMAPROBES
> -	bool
> -	help
> -	  Architectures may want to put kprobes instruction slots into
> -	  the dma memory region. E.g. s390 has the kernel image in the
> -	  dma memory region but the module area far away.
> -
>  config KPROBES_ON_FTRACE
>  	def_bool y
>  	depends on KPROBES && HAVE_KPROBES_ON_FTRACE
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index ce389a9..8a4cae7 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -96,7 +96,6 @@ config S390
>  	select ARCH_WANT_IPC_PARSE_VERSION
>  	select BUILDTIME_EXTABLE_SORT
>  	select CLONE_BACKWARDS2
> -	select DMAPROBES if KPROBES
>  	select GENERIC_CLOCKEVENTS
>  	select GENERIC_CPU_DEVICES if !SMP
>  	select GENERIC_SMP_IDLE_THREAD
> diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
> index bc1071c..cb7ac9e 100644
> --- a/arch/s390/kernel/kprobes.c
> +++ b/arch/s390/kernel/kprobes.c
> @@ -37,6 +37,26 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  
>  struct kretprobe_blackpoint kretprobe_blacklist[] = { };
>  
> +DEFINE_INSN_CACHE_OPS(dmainsn);
> +
> +static void *alloc_dmainsn_page(void)
> +{
> +	return (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
> +}
> +
> +static void free_dmainsn_page(void *page)
> +{
> +	free_page((unsigned long)page);
> +}
> +
> +struct kprobe_insn_cache kprobe_dmainsn_slots = {
> +	.mutex = __MUTEX_INITIALIZER(kprobe_dmainsn_slots.mutex),
> +	.alloc = alloc_dmainsn_page,
> +	.free = free_dmainsn_page,
> +	.pages = LIST_HEAD_INIT(kprobe_dmainsn_slots.pages),
> +	.insn_size = MAX_INSN_SIZE,
> +};
> +
>  static int __kprobes is_prohibited_opcode(kprobe_opcode_t *insn)
>  {
>  	switch (insn[0] >> 8) {
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index a5290f6..4e96827 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -266,7 +266,15 @@ extern int arch_init_kprobes(void);
>  extern void show_registers(struct pt_regs *regs);
>  extern void kprobes_inc_nmissed_count(struct kprobe *p);
>  
> -struct kprobe_insn_cache;
> +struct kprobe_insn_cache {
> +	struct mutex mutex;
> +	void *(*alloc)(void);	/* allocate insn page */
> +	void (*free)(void *);	/* free insn page */
> +	struct list_head pages; /* list of kprobe_insn_page */
> +	size_t insn_size;	/* size of instruction slot */
> +	int nr_garbage;
> +};
> +
>  extern kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c);
>  extern void __free_insn_slot(struct kprobe_insn_cache *c,
>  			     kprobe_opcode_t *slot, int dirty);
> @@ -321,10 +329,6 @@ extern int proc_kprobes_optimization_handler(struct ctl_table *table,
>  
>  #endif /* CONFIG_OPTPROBES */
>  
> -#ifdef CONFIG_DMAPROBES
> -DEFINE_INSN_CACHE_OPS(dmainsn);
> -#endif
> -
>  #ifdef CONFIG_KPROBES_ON_FTRACE
>  extern void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
>  				  struct ftrace_ops *ops, struct pt_regs *regs);
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 3b8b073..a0d367a 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -112,9 +112,9 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
>  struct kprobe_insn_page {
>  	struct list_head list;
>  	kprobe_opcode_t *insns;		/* Page of instruction slots */
> +	struct kprobe_insn_cache *cache;
>  	int nused;
>  	int ngarbage;
> -	bool dma_alloc;
>  	char slot_used[];
>  };
>  
> @@ -122,14 +122,6 @@ struct kprobe_insn_page {
>  	(offsetof(struct kprobe_insn_page, slot_used) +	\
>  	 (sizeof(char) * (slots)))
>  
> -struct kprobe_insn_cache {
> -	struct mutex mutex;
> -	struct list_head pages;	/* list of kprobe_insn_page */
> -	size_t insn_size;	/* size of instruction slot */
> -	int nr_garbage;
> -	bool dma_alloc;
> -};
> -
>  static int slots_per_page(struct kprobe_insn_cache *c)
>  {
>  	return PAGE_SIZE/(c->insn_size * sizeof(kprobe_opcode_t));
> @@ -141,12 +133,23 @@ enum kprobe_slot_state {
>  	SLOT_USED = 2,
>  };
>  
> +static void *alloc_insn_page(void)
> +{
> +	return module_alloc(PAGE_SIZE);
> +}
> +
> +static void free_insn_page(void *page)
> +{
> +	module_free(NULL, page);
> +}
> +
>  struct kprobe_insn_cache kprobe_insn_slots = {
>  	.mutex = __MUTEX_INITIALIZER(kprobe_insn_slots.mutex),
> +	.alloc = alloc_insn_page,
> +	.free = free_insn_page,
>  	.pages = LIST_HEAD_INIT(kprobe_insn_slots.pages),
>  	.insn_size = MAX_INSN_SIZE,
>  	.nr_garbage = 0,
> -	.dma_alloc = false,
>  };
>  static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c);
>  
> @@ -192,10 +195,7 @@ kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
>  	 * kernel image and loaded module images reside. This is required
>  	 * so x86_64 can correctly handle the %rip-relative fixups.
>  	 */
> -	if (c->dma_alloc)
> -		kip->insns = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
> -	else
> -		kip->insns = module_alloc(PAGE_SIZE);
> +	kip->insns = c->alloc();
>  	if (!kip->insns) {
>  		kfree(kip);
>  		goto out;
> @@ -205,7 +205,7 @@ kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
>  	kip->slot_used[0] = SLOT_USED;
>  	kip->nused = 1;
>  	kip->ngarbage = 0;
> -	kip->dma_alloc = c->dma_alloc;
> +	kip->cache = c;
>  	list_add(&kip->list, &c->pages);
>  	slot = kip->insns;
>  out:
> @@ -227,10 +227,7 @@ static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
>  		 */
>  		if (!list_is_singular(&kip->list)) {
>  			list_del(&kip->list);
> -			if (kip->dma_alloc)
> -				free_page((unsigned long)kip->insns);
> -			else
> -				module_free(NULL, kip->insns);
> +			kip->cache->free(kip->insns);
>  			kfree(kip);
>  		}
>  		return 1;
> @@ -291,23 +288,11 @@ out:
>  /* For optimized_kprobe buffer */
>  struct kprobe_insn_cache kprobe_optinsn_slots = {
>  	.mutex = __MUTEX_INITIALIZER(kprobe_optinsn_slots.mutex),
> +	.alloc = alloc_insn_page,
> +	.free = free_insn_page,
>  	.pages = LIST_HEAD_INIT(kprobe_optinsn_slots.pages),
>  	/* .insn_size is initialized later */
>  	.nr_garbage = 0,
> -	.dma_alloc = false,
> -};
> -#endif
> -#ifdef CONFIG_DMAPROBES
> -/*
> - * Special buffer for architectures which require insn slots
> - * to be in the GFP_DMA memory range.
> - */
> -struct kprobe_insn_cache kprobe_dmainsn_slots = {
> -	.mutex = __MUTEX_INITIALIZER(kprobe_dmainsn_slots.mutex),
> -	.pages = LIST_HEAD_INIT(kprobe_dmainsn_slots.pages),
> -	.insn_size = MAX_INSN_SIZE,
> -	.nr_garbage = 0,
> -	.dma_alloc = true,
>  };
>  #endif
>  #endif
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


