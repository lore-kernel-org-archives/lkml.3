Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab3LCVgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:36:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab3LCVgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:36:36 -0500
Date: Tue, 3 Dec 2013 13:36:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] test: add minimal module for verification testing
Message-Id: <20131203133634.e3e4264d7e027c858c0c9268@linux-foundation.org>
In-Reply-To: <1386106054-27636-2-git-send-email-keescook@chromium.org>
References: <1386106054-27636-1-git-send-email-keescook@chromium.org>
	<1386106054-27636-2-git-send-email-keescook@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Dec 2013 13:27:33 -0800 Kees Cook <keescook@chromium.org> wrote:

> When doing module loading verification tests (for example, with module
> singing, or LSM hooks), it is very handy to have a module that can be
> built on all systems under test, isn't auto-loaded at boot, and has
> no device or similar dependencies. This creates the "test_module.ko"
> module for that purpose, which only reports its load and unload to printk.
> 
> --- /dev/null
> +++ b/kernel/test_module.c
> @@ -0,0 +1,26 @@
> +/*
> + * "hello world" kernel module
> + */
> +
> +#define pr_fmt(fmt) "test_module: " fmt
> +
> +#include <linux/module.h>

It really should have a whole bunch more includes, rather than relying
on winning the nested include lottery.

> +static int __init test_module_init(void)
> +{
> +	pr_info("Hello, world\n");

pr_info is maybe too low a facility level?  Pretty much the whole point
of the module is to print this message, so let's ensure that it is visible.

> +	return 0;
> +}
> +
> +module_init(test_module_init);
> +
> +static void __exit test_module_exit(void)
> +{
> +	pr_info("Goodbye\n");
> +}
> +
> +module_exit(test_module_exit);
> +
> +MODULE_AUTHOR("Kees Cook <keescook@chromium.org>");
> +MODULE_LICENSE("GPL");
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index db25707aa41b..20abc92032e0 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1578,6 +1578,20 @@ config DMA_API_DEBUG
>  	  This option causes a performance degredation.  Use only if you want
>  	  to debug device drivers. If unsure, say N.
>  
> +config TEST_MODULE
> +	tristate "Test module loading with 'hello world' module"
> +	default n
> +	depends on m
> +	help
> +	  This builds the "test_module" module that emits "Hello, world"
> +	  on printk when loaded. It is designed to be used for basic
> +	  evaluation of the module loading subsystem (for example when
> +	  validating module verification). It lacks any extra dependencies,
> +	  and will not normally be loaded by the system unless explicitly
> +	  request by name.

Would be useful to have a comment along these lines in test_module.c,
so readers know why it exists.

