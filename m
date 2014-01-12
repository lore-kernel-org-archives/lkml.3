Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbaALJUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 04:20:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52501 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbaALJU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 04:20:29 -0500
Date: Sun, 12 Jan 2014 10:20:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
Message-ID: <20140112092019.GA3664@pd.tnic>
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>
 <1389518403-7715-2-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1389518403-7715-2-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 05:20:00PM +0800, Qiaowei Ren wrote:
> An access to an invalid bound directory entry will cause a #BR
> exception. This patch hook #BR exception handler to allocate
> one bound table and bind it with that buond directory entry.
> 
> This will avoid the need of forwarding the #BR exception
> to the user space when bound directory has invalid entry.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  arch/x86/include/asm/mpx.h |   35 +++++++++++++++++++++++++++++++++
>  arch/x86/kernel/Makefile   |    1 +
>  arch/x86/kernel/mpx.c      |   44 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/traps.c    |   46 +++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 125 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/include/asm/mpx.h
>  create mode 100644 arch/x86/kernel/mpx.c

...

> diff --git a/arch/x86/kernel/mpx.c b/arch/x86/kernel/mpx.c
> new file mode 100644
> index 0000000..767b3bf
> --- /dev/null
> +++ b/arch/x86/kernel/mpx.c
> @@ -0,0 +1,44 @@
> +#include <linux/kernel.h>
> +#include <linux/syscalls.h>
> +#include <asm/processor.h>
> +#include <asm/mpx.h>
> +#include <asm/mman.h>
> +#include <asm/i387.h>
> +#include <asm/fpu-internal.h>
> +#include <asm/alternative.h>
> +
> +static bool allocate_bt(unsigned long bd_entry)
> +{
> +	unsigned long bt_size = 1UL << (MPX_L2_BITS+MPX_L2_SHIFT);
> +	unsigned long bt_addr, old_val;
> +
> +	bt_addr = sys_mmap_pgoff(0, bt_size, PROT_READ | PROT_WRITE,
> +			MAP_ANONYMOUS | MAP_PRIVATE | MAP_POPULATE, -1, 0);

Are we sure about this? We can do a possible memory allocation in
mmap_region() in this exception handler context. And yes, we do a
conditional_sti(), which makes it all the more susceptible.

Have you run this with lockdep enabled?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
