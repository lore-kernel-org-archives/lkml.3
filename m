Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaGJQmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:42:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37820 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbaGJQmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:42:00 -0400
Date: Thu, 10 Jul 2014 18:41:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Ewout van Bekkum <ewout@google.com>
Subject: Re: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP and
 CMCI reports.
Message-ID: <20140710164151.GA5603@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-5-git-send-email-hskinnemoen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1404925766-32253-5-git-send-email-hskinnemoen@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 10:09:24AM -0700, Havard Skinnemoen wrote:
> From: Ewout van Bekkum <ewout@google.com>
> 
> machine_check_poll() was modified to use spin_lock_irqsave independently
> per bank when a valid MCE is found to prevent duplicated MCE reports by
> the CMCI and polling methods. In the common case no MCE will be found,
> so the lock is not acquired until a valid MCE is found. The status is
> reread after the lock is acquired in case the MCE was already handled by
> a different thread. A unique spinlock is used per bank number, so
> contention should be mostly limited to non-shared banks.
> 
> Signed-off-by: Ewout van Bekkum <ewout@google.com>
> Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce-internal.h |  1 +
>  arch/x86/kernel/cpu/mcheck/mce.c          | 21 ++++++++++++++++++++-
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
> index 2f0b1e8..aa6843a 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
> +++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
> @@ -19,6 +19,7 @@ struct mce_bank {
>  	unsigned char init;				/* initialise bank? */
>  	struct device_attribute attr;			/* device attribute */
>  	char			attrname[ATTR_LEN];	/* attribute name */
> +	spinlock_t poll_spinlock;			/* lock for polling */
>  };
>  
>  int mce_severity(struct mce *a, int tolerant, char **msg);
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 1ebdd34..64270d7 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -41,6 +41,8 @@
>  #include <linux/debugfs.h>
>  #include <linux/irq_work.h>
>  #include <linux/export.h>
> +#include <linux/mutex.h>
> +#include <linux/spinlock.h>
>  
>  #include <asm/processor.h>
>  #include <asm/mce.h>
> @@ -596,6 +598,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
>  {
>  	struct mce m;
>  	int i;
> +	unsigned long irq_flags;
>  
>  	this_cpu_inc(mce_poll_count);
>  
> @@ -617,14 +620,28 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
>  
>  		this_cpu_write(mce_polled_error, 1);
>  		/*
> +		 * Optimize for the common case where no MCEs are found.
> +		 */
> +		spin_lock_irqsave(&mce_banks[i].poll_spinlock, irq_flags);

This is pretty heavy - we're disabling interrupts for *every* bank and
with shorter polling intervals, this could become problematic fast.

What's wrong with doing this with cheap atomic_inc/dec_and_test?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
