Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab3KKJcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:32:24 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:57600 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3KKJcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:32:17 -0500
Date: Mon, 11 Nov 2013 10:32:13 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jason Baron <jbaron@akamai.com>
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, paulus@samba.org,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: Make panic_timeout configurable
Message-ID: <20131111093213.GA13550@gmail.com>
References: <20131108204307.49C6AFE076@prod-mail-relay02.akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108204307.49C6AFE076@prod-mail-relay02.akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Baron <jbaron@akamai.com> wrote:

> The panic_timeout can be set via the command line option 'panic=x', or via
> /proc/sys/kernel/panic, however that is not sufficient when the panic occurs
> before we are able to set up these values. Thus, add a CONFIG_PANIC_TIMEOUT
> so that we can set the desired value from the .config, instead of carrying a
> patch for it.
> 
> The default panic_timeout value continues to be 0 - wait forever, except for
> powerpc and mips, which have been defaulted to 180 and 5 respectively. This
> is in keeping with the fact that these arches already set panic_timeout in
> their arch init code. However, I found two exceptions- one in mips and one in
> powerpc where settings didn't match these default values. In those two cases,
> I left the arch code so it continues to override. Perhaps, these cases can
> be converted to the default?
> 
> Signed-off-by: Jason Baron <jbaron@akamai.com>
> ---
>  arch/mips/netlogic/xlp/setup.c |  1 -
>  arch/mips/netlogic/xlr/setup.c |  1 -
>  arch/mips/sibyte/swarm/setup.c |  2 --
>  arch/powerpc/kernel/setup_32.c |  3 ---
>  arch/powerpc/kernel/setup_64.c |  3 ---
>  kernel/panic.c                 |  2 +-
>  lib/Kconfig.debug              | 12 ++++++++++++
>  7 files changed, 13 insertions(+), 11 deletions(-)
>
> @@ -33,7 +33,7 @@ static int pause_on_oops;
>  static int pause_on_oops_flag;
>  static DEFINE_SPINLOCK(pause_on_oops_lock);
>  
> -int panic_timeout;
> +int panic_timeout = CONFIG_PANIC_TIMEOUT;
>  EXPORT_SYMBOL_GPL(panic_timeout);
>  
>  ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index ebef88f..22b746e 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -761,6 +761,18 @@ config PANIC_ON_OOPS_VALUE
>  	default 0 if !PANIC_ON_OOPS
>  	default 1 if PANIC_ON_OOPS
>  
> +config PANIC_TIMEOUT
> +	int "panic timeout"
> +	default 0 if (!PPC && !MIPS)
> +	default 180 if PPC
> +	default 5 if MIPS

I don't think there should be such arch conditionals in the core config. 
If we introduce such a config, and if it's set by the user to anything but 
0 then it should always override whatever arch boot time hackery ...

We might also want to add a second Kconfig value, set by architectures to 
their desired default panic timeout value - instead of the runtime setting 
during arch init (which, btw., might be too late if a panic happens 
early).

This means that 'panic_timeout' should be unexported (i.e. no naked 
setting of the variable) and all arch use should go through that new 
Kconfig plus perhaps a core panic_timeout_set() function for the 
remaining, justified 'dynamic' settings of panic_timeout_set().

So this really needs better organization and more structure to become 
really clean.

Thanks,

	Ingo
