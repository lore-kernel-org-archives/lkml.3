Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab3KARwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 13:52:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab3KARwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 13:52:13 -0400
Date: Fri, 1 Nov 2013 18:53:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 12/13] tracing/uprobes: Add more fetch functions
Message-ID: <20131101175334.GA27088@redhat.com>
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org> <1383029621-7384-13-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383029621-7384-13-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29, Namhyung Kim wrote:
>
> +static unsigned long get_user_stack_nth(struct pt_regs *regs, unsigned int n)
> +{
> +	struct vm_area_struct *vma;
> +	unsigned long addr = user_stack_pointer(regs);
> +	bool valid = false;
> +	unsigned long ret = 0;
> +
> +	down_read(&current->mm->mmap_sem);
> +	vma = find_vma(current->mm, addr);
> +	if (vma && vma->vm_start <= addr) {
> +		if (within_user_stack(vma, addr, n))
> +			valid = true;
> +	}
> +	up_read(&current->mm->mmap_sem);
> +
> +	addr = adjust_stack_addr(addr, n);
> +
> +	if (valid && copy_from_user(&ret, (void __force __user *)addr,
> +				    sizeof(ret)) == 0)
> +		return ret;
> +	return 0;
> +}

Namhyung, I am just curious, why do we need find_vma/within_user_stack?
copy_from_user() should fail or expand the stack. Yes, we can actually
look into the wrong vma, but do we really care?

> +static void __user *get_user_vaddr(unsigned long addr, struct trace_uprobe *tu)
> +{
> +	unsigned long pgoff = addr >> PAGE_SHIFT;
> +	struct vm_area_struct *vma;
> +	struct address_space *mapping;
> +	unsigned long vaddr = 0;
> +
> +	if (tu == NULL) {
> +		/* A NULL tu means that we already got the vaddr */
> +		return (void __force __user *) addr;
> +	}
> +
> +	mapping = tu->inode->i_mapping;
> +
> +	mutex_lock(&mapping->i_mmap_mutex);
> +	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
> +		if (vma->vm_mm != current->mm)
> +			continue;
> +		if (!(vma->vm_flags & VM_READ))
> +			continue;
> +
> +		vaddr = offset_to_vaddr(vma, addr);
> +		break;
> +	}
> +	mutex_unlock(&mapping->i_mmap_mutex);
> +
> +	WARN_ON_ONCE(vaddr == 0);
> +	return (void __force __user *) vaddr;

So. If I understand correctly, @addr cat only read the memory mmaped
to the probed binary, and we need to translate the address... And in
general we can't read the data from bss.

Right?

I'll probably ask another question about this later...

> +static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
> +					void *addr, void *dest, void *priv)
> +{
> +	long ret;
> +	u32 rloc = *(u32 *)dest;
> +	int maxlen = get_rloc_len(rloc);
> +	u8 *dst = get_rloc_data(dest);
> +	void __user *vaddr = get_user_vaddr((unsigned long)addr, priv);
> +	void __user *src = vaddr;
> +
> +	if (!maxlen)
> +		return;
> +
> +	do {
> +		ret = copy_from_user(dst, src, sizeof(*dst));
> +		dst++;
> +		src++;
> +	} while (dst[-1] && ret == 0 && (src - vaddr) < maxlen);

Can't we use strncpy_from_user() ?

> +static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
> +					   void *addr, void *dest, void *priv)
> +{
> +	int ret, len = 0;
> +	u8 c;
> +	void __user *vaddr = get_user_vaddr((unsigned long)addr, priv);
> +
> +	do {
> +		ret = __copy_from_user_inatomic(&c, vaddr + len, 1);

Hmm. I guess I need to actually apply this series ;)

Why inatomic? it seems that this is for uprobes, no? And perhaps
strnlen_user() should work just fine?

Oleg.

