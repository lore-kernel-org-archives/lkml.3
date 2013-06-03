Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065Ab3FCP5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:57:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39070 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab3FCP5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:57:22 -0400
Date: Mon, 3 Jun 2013 11:56:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 9/19]  Split out rate limiting from jump_label.h
Message-ID: <20130603155612.GD4224@phenom.dumpdata.com>
References: <20130601192125.5966.35563.sendpatchset@codeblue>
 <20130601192422.5966.44354.sendpatchset@codeblue>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130601192422.5966.44354.sendpatchset@codeblue>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 02, 2013 at 12:54:22AM +0530, Raghavendra K T wrote:
> Split jumplabel ratelimit

I would change the title a bit, perhaps prefix it with: "jump_label: "
> 
> From: Andrew Jones <drjones@redhat.com>
> 
> Commit b202952075f62603bea9bfb6ebc6b0420db11949 introduced rate limiting

Also please add right after the git id this:

("perf, core: Rate limit perf_sched_events jump_label patching")

> for jump label disabling. The changes were made in the jump label code
> in order to be more widely available and to keep things tidier. This is
> all fine, except now jump_label.h includes linux/workqueue.h, which
> makes it impossible to include jump_label.h from anything that
> workqueue.h needs. For example, it's now impossible to include
> jump_label.h from asm/spinlock.h, which is done in proposed
> pv-ticketlock patches. This patch splits out the rate limiting related
> changes from jump_label.h into a new file, jump_label_ratelimit.h, to
> resolve the issue.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Otherwise looks fine to me:

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  include/linux/jump_label.h           |   26 +-------------------------
>  include/linux/jump_label_ratelimit.h |   34 ++++++++++++++++++++++++++++++++++
>  include/linux/perf_event.h           |    1 +
>  kernel/jump_label.c                  |    1 +
>  4 files changed, 37 insertions(+), 25 deletions(-)
>  create mode 100644 include/linux/jump_label_ratelimit.h
> 
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> index 0976fc4..53cdf89 100644
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -48,7 +48,6 @@
>  
>  #include <linux/types.h>
>  #include <linux/compiler.h>
> -#include <linux/workqueue.h>
>  
>  #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
>  
> @@ -61,12 +60,6 @@ struct static_key {
>  #endif
>  };
>  
> -struct static_key_deferred {
> -	struct static_key key;
> -	unsigned long timeout;
> -	struct delayed_work work;
> -};
> -
>  # include <asm/jump_label.h>
>  # define HAVE_JUMP_LABEL
>  #endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
> @@ -119,10 +112,7 @@ extern void arch_jump_label_transform_static(struct jump_entry *entry,
>  extern int jump_label_text_reserved(void *start, void *end);
>  extern void static_key_slow_inc(struct static_key *key);
>  extern void static_key_slow_dec(struct static_key *key);
> -extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
>  extern void jump_label_apply_nops(struct module *mod);
> -extern void
> -jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
>  
>  #define STATIC_KEY_INIT_TRUE ((struct static_key) \
>  	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
> @@ -141,10 +131,6 @@ static __always_inline void jump_label_init(void)
>  {
>  }
>  
> -struct static_key_deferred {
> -	struct static_key  key;
> -};
> -
>  static __always_inline bool static_key_false(struct static_key *key)
>  {
>  	if (unlikely(atomic_read(&key->enabled)) > 0)
> @@ -169,11 +155,6 @@ static inline void static_key_slow_dec(struct static_key *key)
>  	atomic_dec(&key->enabled);
>  }
>  
> -static inline void static_key_slow_dec_deferred(struct static_key_deferred *key)
> -{
> -	static_key_slow_dec(&key->key);
> -}
> -
>  static inline int jump_label_text_reserved(void *start, void *end)
>  {
>  	return 0;
> @@ -187,12 +168,6 @@ static inline int jump_label_apply_nops(struct module *mod)
>  	return 0;
>  }
>  
> -static inline void
> -jump_label_rate_limit(struct static_key_deferred *key,
> -		unsigned long rl)
> -{
> -}
> -
>  #define STATIC_KEY_INIT_TRUE ((struct static_key) \
>  		{ .enabled = ATOMIC_INIT(1) })
>  #define STATIC_KEY_INIT_FALSE ((struct static_key) \
> @@ -203,6 +178,7 @@ jump_label_rate_limit(struct static_key_deferred *key,
>  #define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
>  #define jump_label_enabled static_key_enabled
>  
> +static inline int atomic_read(const atomic_t *v);
>  static inline bool static_key_enabled(struct static_key *key)
>  {
>  	return (atomic_read(&key->enabled) > 0);
> diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
> new file mode 100644
> index 0000000..1137883
> --- /dev/null
> +++ b/include/linux/jump_label_ratelimit.h
> @@ -0,0 +1,34 @@
> +#ifndef _LINUX_JUMP_LABEL_RATELIMIT_H
> +#define _LINUX_JUMP_LABEL_RATELIMIT_H
> +
> +#include <linux/jump_label.h>
> +#include <linux/workqueue.h>
> +
> +#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
> +struct static_key_deferred {
> +	struct static_key key;
> +	unsigned long timeout;
> +	struct delayed_work work;
> +};
> +#endif
> +
> +#ifdef HAVE_JUMP_LABEL
> +extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
> +extern void
> +jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
> +
> +#else	/* !HAVE_JUMP_LABEL */
> +struct static_key_deferred {
> +	struct static_key  key;
> +};
> +static inline void static_key_slow_dec_deferred(struct static_key_deferred *key)
> +{
> +	static_key_slow_dec(&key->key);
> +}
> +static inline void
> +jump_label_rate_limit(struct static_key_deferred *key,
> +		unsigned long rl)
> +{
> +}
> +#endif	/* HAVE_JUMP_LABEL */
> +#endif	/* _LINUX_JUMP_LABEL_RATELIMIT_H */
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index f463a46..a8eac60 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -48,6 +48,7 @@ struct perf_guest_info_callbacks {
>  #include <linux/cpu.h>
>  #include <linux/irq_work.h>
>  #include <linux/static_key.h>
> +#include <linux/jump_label_ratelimit.h>
>  #include <linux/atomic.h>
>  #include <linux/sysfs.h>
>  #include <linux/perf_regs.h>
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 60f48fa..297a924 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -13,6 +13,7 @@
>  #include <linux/sort.h>
>  #include <linux/err.h>
>  #include <linux/static_key.h>
> +#include <linux/jump_label_ratelimit.h>
>  
>  #ifdef HAVE_JUMP_LABEL
>  
> 
