Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaBEFIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 00:08:21 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42072 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaBEFIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 00:08:20 -0500
Message-ID: <52F1C747.5030004@gmail.com>
Date: Wed, 05 Feb 2014 13:08:23 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
        =?UTF-8?B?SMOldmFy?= =?UTF-8?B?ZCBTa2lubmVtb2Vu?= 
	<hskinnemoen@gmail.com>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] kernel/kprobes.c: move kretprobe implementation to CONFIG_KRETPROBES
 area
References: <52ECE5D8.6090209@gmail.com> <52EDB022.5070101@hitachi.com> <52EF8222.6030709@gmail.com> <52EFB8F4.6010207@hitachi.com> <52F04FA8.8040008@gmail.com> <52F077A1.3020701@gmail.com> <52F09404.3060502@hitachi.com> <52F0D7F3.7000901@gmail.com> <52F0EB30.2070401@hitachi.com> <52F0F0ED.5090005@gmail.com> <52F109AF.8040800@hitachi.com> <52F18367.2060803@gmail.com> <52F19223.5010506@hitachi.com> <52F1AB18.5040208@gmail.com> <52F1B1CE.2040204@gmail.com> <52F1C579.1080907@hitachi.com>
In-Reply-To: <52F1C579.1080907@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 01:00 PM, Masami Hiramatsu wrote:
> (2014/02/05 12:36), Chen Gang wrote:
>> > When CONFIG_KRETPROBES disabled, kretprobe implementation are useless,
>> > so need move them to CONFIG_KPROBES area.
>> > 
>> >  - move all kretprobe* to CONFIG_KPROBES area and dummy outside.
>> >  - define kretprobe_flush_task() to let kprobe_flush_task() call.
>> >  - define init_kretprobes() to let init_kprobes() call.
>> > 
>> > 
> Looks good to me ;)
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 

Thank you very much !!

:-)


>> > Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> > ---
>> >  kernel/kprobes.c | 323 +++++++++++++++++++++++++++++++------------------------
>> >  1 file changed, 181 insertions(+), 142 deletions(-)
>> > 
>> > diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> > index ceeadfc..0619536 100644
>> > --- a/kernel/kprobes.c
>> > +++ b/kernel/kprobes.c
>> > @@ -69,7 +69,6 @@
>> >  
>> >  static int kprobes_initialized;
>> >  static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
>> > -static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
>> >  
>> >  /* NOTE: change this value only with kprobe_mutex held */
>> >  static bool kprobes_all_disarmed;
>> > @@ -77,14 +76,6 @@ static bool kprobes_all_disarmed;
>> >  /* This protects kprobe_table and optimizing_list */
>> >  static DEFINE_MUTEX(kprobe_mutex);
>> >  static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
>> > -static struct {
>> > -	raw_spinlock_t lock ____cacheline_aligned_in_smp;
>> > -} kretprobe_table_locks[KPROBE_TABLE_SIZE];
>> > -
>> > -static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
>> > -{
>> > -	return &(kretprobe_table_locks[hash].lock);
>> > -}
>> >  
>> >  /*
>> >   * Normally, functions that we'd want to prohibit kprobes in, are marked
>> > @@ -1079,125 +1070,6 @@ void __kprobes kprobes_inc_nmissed_count(struct kprobe *p)
>> >  	return;
>> >  }
>> >  
>> > -void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
>> > -				struct hlist_head *head)
>> > -{
>> > -	struct kretprobe *rp = ri->rp;
>> > -
>> > -	/* remove rp inst off the rprobe_inst_table */
>> > -	hlist_del(&ri->hlist);
>> > -	INIT_HLIST_NODE(&ri->hlist);
>> > -	if (likely(rp)) {
>> > -		raw_spin_lock(&rp->lock);
>> > -		hlist_add_head(&ri->hlist, &rp->free_instances);
>> > -		raw_spin_unlock(&rp->lock);
>> > -	} else
>> > -		/* Unregistering */
>> > -		hlist_add_head(&ri->hlist, head);
>> > -}
>> > -
>> > -void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
>> > -			 struct hlist_head **head, unsigned long *flags)
>> > -__acquires(hlist_lock)
>> > -{
>> > -	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
>> > -	raw_spinlock_t *hlist_lock;
>> > -
>> > -	*head = &kretprobe_inst_table[hash];
>> > -	hlist_lock = kretprobe_table_lock_ptr(hash);
>> > -	raw_spin_lock_irqsave(hlist_lock, *flags);
>> > -}
>> > -
>> > -static void __kprobes kretprobe_table_lock(unsigned long hash,
>> > -	unsigned long *flags)
>> > -__acquires(hlist_lock)
>> > -{
>> > -	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
>> > -	raw_spin_lock_irqsave(hlist_lock, *flags);
>> > -}
>> > -
>> > -void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
>> > -	unsigned long *flags)
>> > -__releases(hlist_lock)
>> > -{
>> > -	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
>> > -	raw_spinlock_t *hlist_lock;
>> > -
>> > -	hlist_lock = kretprobe_table_lock_ptr(hash);
>> > -	raw_spin_unlock_irqrestore(hlist_lock, *flags);
>> > -}
>> > -
>> > -static void __kprobes kretprobe_table_unlock(unsigned long hash,
>> > -       unsigned long *flags)
>> > -__releases(hlist_lock)
>> > -{
>> > -	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
>> > -	raw_spin_unlock_irqrestore(hlist_lock, *flags);
>> > -}
>> > -
>> > -/*
>> > - * This function is called from finish_task_switch when task tk becomes dead,
>> > - * so that we can recycle any function-return probe instances associated
>> > - * with this task. These left over instances represent probed functions
>> > - * that have been called but will never return.
>> > - */
>> > -void __kprobes kprobe_flush_task(struct task_struct *tk)
>> > -{
>> > -	struct kretprobe_instance *ri;
>> > -	struct hlist_head *head, empty_rp;
>> > -	struct hlist_node *tmp;
>> > -	unsigned long hash, flags = 0;
>> > -
>> > -	if (unlikely(!kprobes_initialized))
>> > -		/* Early boot.  kretprobe_table_locks not yet initialized. */
>> > -		return;
>> > -
>> > -	INIT_HLIST_HEAD(&empty_rp);
>> > -	hash = hash_ptr(tk, KPROBE_HASH_BITS);
>> > -	head = &kretprobe_inst_table[hash];
>> > -	kretprobe_table_lock(hash, &flags);
>> > -	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
>> > -		if (ri->task == tk)
>> > -			recycle_rp_inst(ri, &empty_rp);
>> > -	}
>> > -	kretprobe_table_unlock(hash, &flags);
>> > -	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
>> > -		hlist_del(&ri->hlist);
>> > -		kfree(ri);
>> > -	}
>> > -}
>> > -
>> > -static inline void free_rp_inst(struct kretprobe *rp)
>> > -{
>> > -	struct kretprobe_instance *ri;
>> > -	struct hlist_node *next;
>> > -
>> > -	hlist_for_each_entry_safe(ri, next, &rp->free_instances, hlist) {
>> > -		hlist_del(&ri->hlist);
>> > -		kfree(ri);
>> > -	}
>> > -}
>> > -
>> > -static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
>> > -{
>> > -	unsigned long flags, hash;
>> > -	struct kretprobe_instance *ri;
>> > -	struct hlist_node *next;
>> > -	struct hlist_head *head;
>> > -
>> > -	/* No race here */
>> > -	for (hash = 0; hash < KPROBE_TABLE_SIZE; hash++) {
>> > -		kretprobe_table_lock(hash, &flags);
>> > -		head = &kretprobe_inst_table[hash];
>> > -		hlist_for_each_entry_safe(ri, next, head, hlist) {
>> > -			if (ri->rp == rp)
>> > -				ri->rp = NULL;
>> > -		}
>> > -		kretprobe_table_unlock(hash, &flags);
>> > -	}
>> > -	free_rp_inst(rp);
>> > -}
>> > -
>> >  /*
>> >  * Add the new probe to ap->list. Fail if this is the
>> >  * second jprobe at the address - two jprobes can't coexist
>> > @@ -1764,6 +1636,55 @@ void __kprobes unregister_jprobes(struct jprobe **jps, int num)
>> >  EXPORT_SYMBOL_GPL(unregister_jprobes);
>> >  
>> >  #ifdef CONFIG_KRETPROBES
>> > +static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
>> > +static struct {
>> > +	raw_spinlock_t lock ____cacheline_aligned_in_smp;
>> > +} kretprobe_table_locks[KPROBE_TABLE_SIZE];
>> > +
>> > +static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
>> > +{
>> > +	return &(kretprobe_table_locks[hash].lock);
>> > +}
>> > +
>> > +void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
>> > +			 struct hlist_head **head, unsigned long *flags)
>> > +__acquires(hlist_lock)
>> > +{
>> > +	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
>> > +	raw_spinlock_t *hlist_lock;
>> > +
>> > +	*head = &kretprobe_inst_table[hash];
>> > +	hlist_lock = kretprobe_table_lock_ptr(hash);
>> > +	raw_spin_lock_irqsave(hlist_lock, *flags);
>> > +}
>> > +
>> > +void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
>> > +	unsigned long *flags)
>> > +__releases(hlist_lock)
>> > +{
>> > +	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
>> > +	raw_spinlock_t *hlist_lock;
>> > +
>> > +	hlist_lock = kretprobe_table_lock_ptr(hash);
>> > +	raw_spin_unlock_irqrestore(hlist_lock, *flags);
>> > +}
>> > +
>> > +static void __kprobes kretprobe_table_lock(unsigned long hash,
>> > +	unsigned long *flags)
>> > +__acquires(hlist_lock)
>> > +{
>> > +	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
>> > +	raw_spin_lock_irqsave(hlist_lock, *flags);
>> > +}
>> > +
>> > +static void __kprobes kretprobe_table_unlock(unsigned long hash,
>> > +	unsigned long *flags)
>> > +__releases(hlist_lock)
>> > +{
>> > +	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
>> > +	raw_spin_unlock_irqrestore(hlist_lock, *flags);
>> > +}
>> > +
>> >  /*
>> >   * This kprobe pre_handler is registered with every kretprobe. When probe
>> >   * hits it will set up the return probe.
>> > @@ -1808,6 +1729,17 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
>> >  	return 0;
>> >  }
>> >  
>> > +static inline void free_rp_inst(struct kretprobe *rp)
>> > +{
>> > +	struct kretprobe_instance *ri;
>> > +	struct hlist_node *next;
>> > +
>> > +	hlist_for_each_entry_safe(ri, next, &rp->free_instances, hlist) {
>> > +		hlist_del(&ri->hlist);
>> > +		kfree(ri);
>> > +	}
>> > +}
>> > +
>> >  int __kprobes register_kretprobe(struct kretprobe *rp)
>> >  {
>> >  	int ret = 0;
>> > @@ -1885,6 +1817,26 @@ void __kprobes unregister_kretprobe(struct kretprobe *rp)
>> >  }
>> >  EXPORT_SYMBOL_GPL(unregister_kretprobe);
>> >  
>> > +static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
>> > +{
>> > +	unsigned long flags, hash;
>> > +	struct kretprobe_instance *ri;
>> > +	struct hlist_node *next;
>> > +	struct hlist_head *head;
>> > +
>> > +	/* No race here */
>> > +	for (hash = 0; hash < KPROBE_TABLE_SIZE; hash++) {
>> > +		kretprobe_table_lock(hash, &flags);
>> > +		head = &kretprobe_inst_table[hash];
>> > +		hlist_for_each_entry_safe(ri, next, head, hlist) {
>> > +			if (ri->rp == rp)
>> > +				ri->rp = NULL;
>> > +		}
>> > +		kretprobe_table_unlock(hash, &flags);
>> > +	}
>> > +	free_rp_inst(rp);
>> > +}
>> > +
>> >  void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
>> >  {
>> >  	int i;
>> > @@ -1907,7 +1859,78 @@ void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
>> >  }
>> >  EXPORT_SYMBOL_GPL(unregister_kretprobes);
>> >  
>> > +void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
>> > +				struct hlist_head *head)
>> > +{
>> > +	struct kretprobe *rp = ri->rp;
>> > +
>> > +	/* remove rp inst off the rprobe_inst_table */
>> > +	hlist_del(&ri->hlist);
>> > +	INIT_HLIST_NODE(&ri->hlist);
>> > +	if (likely(rp)) {
>> > +		raw_spin_lock(&rp->lock);
>> > +		hlist_add_head(&ri->hlist, &rp->free_instances);
>> > +		raw_spin_unlock(&rp->lock);
>> > +	} else
>> > +		/* Unregistering */
>> > +		hlist_add_head(&ri->hlist, head);
>> > +}
>> > +
>> > +static void __kprobes kretprobe_flush_task(struct task_struct *tk)
>> > +{
>> > +	struct kretprobe_instance *ri;
>> > +	struct hlist_head *head, empty_rp;
>> > +	struct hlist_node *tmp;
>> > +	unsigned long hash, flags = 0;
>> > +
>> > +	if (unlikely(!kprobes_initialized))
>> > +		/* Early boot.  kretprobe_table_locks not yet initialized. */
>> > +		return;
>> > +
>> > +	INIT_HLIST_HEAD(&empty_rp);
>> > +	hash = hash_ptr(tk, KPROBE_HASH_BITS);
>> > +	head = &kretprobe_inst_table[hash];
>> > +	kretprobe_table_lock(hash, &flags);
>> > +	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
>> > +		if (ri->task == tk)
>> > +			recycle_rp_inst(ri, &empty_rp);
>> > +	}
>> > +	kretprobe_table_unlock(hash, &flags);
>> > +	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
>> > +		hlist_del(&ri->hlist);
>> > +		kfree(ri);
>> > +	}
>> > +}
>> > +
>> > +static void __init init_kretprobes(void)
>> > +{
>> > +	int i;
>> > +
>> > +	/* FIXME allocate the probe table, currently defined statically */
>> > +	/* initialize all list heads */
>> > +	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
>> > +		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
>> > +		raw_spin_lock_init(&(kretprobe_table_locks[i].lock));
>> > +	}
>> > +
>> > +	if (kretprobe_blacklist_size) {
>> > +		/* lookup the function address from its name */
>> > +		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
>> > +			kprobe_lookup_name(kretprobe_blacklist[i].name,
>> > +					   kretprobe_blacklist[i].addr);
>> > +			if (!kretprobe_blacklist[i].addr)
>> > +				printk(KERN_WARNING
>> > +					"kretprobe: lookup failed: %s\n",
>> > +					kretprobe_blacklist[i].name);
>> > +		}
>> > +	}
>> > +}
>> > +
>> >  #else /* CONFIG_KRETPROBES */
>> > +
>> > +#define kretprobe_flush_task(p)			do {} while (0)
>> > +#define init_kretprobes()			do {} while (0)
>> > +
>> >  int __kprobes register_kretprobe(struct kretprobe *rp)
>> >  {
>> >  	return -ENOSYS;
>> > @@ -1936,8 +1959,35 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
>> >  	return 0;
>> >  }
>> >  
>> > +void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
>> > +				struct hlist_head *head)
>> > +{
>> > +}
>> > +
>> > +void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
>> > +			 struct hlist_head **head, unsigned long *flags)
>> > +__acquires(hlist_lock)
>> > +{
>> > +}
>> > +
>> > +void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
>> > +	unsigned long *flags)
>> > +__releases(hlist_lock)
>> > +{
>> > +}
>> >  #endif /* CONFIG_KRETPROBES */
>> >  
>> > +/*
>> > + * This function is called from finish_task_switch when task tk becomes dead,
>> > + * so that we can recycle any function-return probe instances associated
>> > + * with this task. These left over instances represent probed functions
>> > + * that have been called but will never return.
>> > + */
>> > +void __kprobes kprobe_flush_task(struct task_struct *tk)
>> > +{
>> > +	kretprobe_flush_task(tk);
>> > +}
>> > +
>> >  /* Set the kprobe gone and remove its instruction buffer. */
>> >  static void __kprobes kill_kprobe(struct kprobe *p)
>> >  {
>> > @@ -2073,11 +2123,8 @@ static int __init init_kprobes(void)
>> >  
>> >  	/* FIXME allocate the probe table, currently defined statically */
>> >  	/* initialize all list heads */
>> > -	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
>> > +	for (i = 0; i < KPROBE_TABLE_SIZE; i++)
>> >  		INIT_HLIST_HEAD(&kprobe_table[i]);
>> > -		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
>> > -		raw_spin_lock_init(&(kretprobe_table_locks[i].lock));
>> > -	}
>> >  
>> >  	/*
>> >  	 * Lookup and populate the kprobe_blacklist.
>> > @@ -2101,16 +2148,8 @@ static int __init init_kprobes(void)
>> >  			kb->range = size;
>> >  	}
>> >  
>> > -	if (kretprobe_blacklist_size) {
>> > -		/* lookup the function address from its name */
>> > -		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
>> > -			kprobe_lookup_name(kretprobe_blacklist[i].name,
>> > -					   kretprobe_blacklist[i].addr);
>> > -			if (!kretprobe_blacklist[i].addr)
>> > -				printk("kretprobe: lookup failed: %s\n",
>> > -				       kretprobe_blacklist[i].name);
>> > -		}
>> > -	}
>> > +	/* Initialize kretprobes */
>> > +	init_kretprobes();
>> >  
>> >  #if defined(CONFIG_OPTPROBES)
>> >  #if defined(__ARCH_WANT_KPROBES_INSN_SLOT)
>> > 
> 
> -- Masami HIRAMATSU IT Management Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory E-mail:
> masami.hiramatsu.pt@hitachi.com
> 


-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
