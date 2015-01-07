Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbbAGKrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:47:05 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:36344 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbAGKrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:47:03 -0500
Message-ID: <54AD0E54.9060900@huawei.com>
Date: Wed, 7 Jan 2015 18:45:40 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Hillf Danton <hillf.zj@alibaba-inc.com>
CC: <linux@arm.linux.org.uk>, <mingo@redhat.com>, <x86@kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>, <lizefan@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 07/11] kprobes: introduces macros for allocing early
 kprobe resources.
References: <1420616086-42692-1-git-send-email-wangnan0@huawei.com> <1420616151-43023-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1420616151-43023-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.54AD0E65.00CB,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 8f9725a1b6c9bb632df1432497f07145
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/7 15:35, Wang Nan wrote:
> Introduces macros to genearte common early kprobe related resource
> allocator.
> 
> All early kprobe related resources are statically allocated during
> linking for each early kprobe slot. For each type of resource, a bitmap
> is used to track allocation. __DEFINE_EKPROBE_ALLOC_OPS defines alloc
> and free handler for them. The range of the resource and the bitmap
> should be provided for allocaing and freeing. DEFINE_EKPROBE_ALLOC_OPS
> defines bitmap and the array used by it.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  include/linux/kprobes.h | 69 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
> 
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index b0265f9..9a18188 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -270,6 +270,75 @@ extern void show_registers(struct pt_regs *regs);
>  extern void kprobes_inc_nmissed_count(struct kprobe *p);
>  extern bool arch_within_kprobe_blacklist(unsigned long addr);
>  
> +#ifdef CONFIG_EARLY_KPROBES
> +
> +#define NR_EARLY_KPROBES_SLOTS	CONFIG_NR_EARLY_KPROBES_SLOTS
> +#define ALIGN_UP(v, a)	(((v) + ((a) - 1)) & ~((a) - 1))
> +#define EARLY_KPROBES_BITMAP_SZ	ALIGN_UP(NR_EARLY_KPROBES_SLOTS, BITS_PER_LONG)
> +
> +#define __ek_in_range(v, s, e)	(((v) >= (s)) && ((v) < (e)))
> +#define __ek_buf_sz(s, e)	((void *)(e) - (void *)(s))
> +#define __ek_elem_sz_b(s, e)	(__ek_buf_sz(s, e) / NR_EARLY_KPROBES_SLOTS)
> +#define __ek_elem_sz(s, e)	(__ek_elem_sz_b(s, e) / sizeof(s[0]))
> +#define __ek_elem_idx(v, s, e)	(__ek_buf_sz(s, v) / __ek_elem_sz_b(s, e))
> +#define __ek_get_elem(i, s, e)	(&((s)[__ek_elem_sz(s, e) * (i)]))
> +#define __DEFINE_EKPROBE_ALLOC_OPS(__t, __name)				\
> +static inline __t *__ek_alloc_##__name(__t *__s, __t *__e, unsigned long *__b)\
> +{									\
> +	int __i = find_next_zero_bit(__b, NR_EARLY_KPROBES_SLOTS, 0);	\
> +	if (__i >= NR_EARLY_KPROBES_SLOTS)				\
> +		return NULL;						\
> +	set_bit(__i, __b);						\
> +	return __ek_get_elem(__i, __s, __e);				\
> +}									\
> +static inline int __ek_free_##__name(__t *__v, __t *__s, __t *__e, unsigned long *__b)	\
> +{									\
> +	if (!__ek_in_range(__v, __s, __e))				\
> +		return 0;						\
> +	clear_bit(__ek_elem_idx(__v, __s, __e), __b);			\
> +	return 1;							\
> +}
> +
> +#define DEFINE_EKPROBE_ALLOC_OPS(__t, __name, __static)			\
> +__static __t __ek_##__name##_slots[NR_EARLY_KPROBES_SLOTS];		\
> +__static unsigned long __ek_##__name##_bitmap[EARLY_KPROBES_BITMAP_SZ];	\
> +__DEFINE_EKPROBE_ALLOC_OPS(__t, __name)					\
> +static inline __t *ek_alloc_##__name(void)				\
> +{									\
> +	return __ek_alloc_##__name(&((__ek_##__name##_slots)[0]),	\
> +			&((__ek_##__name##_slots)[NR_EARLY_KPROBES_SLOTS]),\
> +			(__ek_##__name##_bitmap));			\
> +}									\
> +static inline int ek_free_##__name(__t *__s)				\
> +{									\
> +	return __ek_free_##__name(__s, &((__ek_##__name##_slots)[0]),	\
> +			&((__ek_##__name##_slots)[NR_EARLY_KPROBES_SLOTS]),\
> +			(__ek_##__name##_bitmap));			\
> +}
> +
> +
> +#else
> +#define __DEFINE_EKPROBE_ALLOC_OPS(__t, __name)				\
> +static inline __t *__ek_alloc_##__name(__t *__s, __t *__e, unsigned long *__b)\
> +{									\
> +	return NULL;							\
> +}									\
> +static inline int __ek_free_##__name(__t *__v, __t *__s, __t *__e, unsigned long *__b)\
> +{									\
> +	return 0;							\
> +}
> +
> +#define DEFINE_EKPROBE_ALLOC_OPS(__t, __name, __static)			\
> +static inline __t *ek_alloc_##__name(void)				\
> +{									\
> +	return NULL;							\
> +}									\
> +static inline void ek_free_##__name(__t *__s)				\
> +{									\
> +}
> +

Sorry, here is a small problem. Should be:
static inline int ek_free_##__name(__t *__s)				\
{									\
	return 0;							\
}

> +#endif
> +
>  struct kprobe_insn_cache {
>  	struct mutex mutex;
>  	void *(*alloc)(void);	/* allocate insn page */
> 


