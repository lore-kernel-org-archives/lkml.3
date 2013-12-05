Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab3LECsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:48:45 -0500
Received: from ozlabs.org ([203.10.76.45]:47501 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397Ab3LECsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:48:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, keescook@chromium.org
Subject: Re: [PATCH v3 1/2] test: add minimal module for verification testing
In-Reply-To: <1386184969-29750-2-git-send-email-keescook@chromium.org>
References: <1386184969-29750-1-git-send-email-keescook@chromium.org> <1386184969-29750-2-git-send-email-keescook@chromium.org>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 05 Dec 2013 13:12:17 +1030
Message-ID: <87li00ow6u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> When doing module loading verification tests (for example, with module
> singing, or LSM hooks), it is very handy to have a module that can be

"module singing" sounds like a horrible idea!  Is the author even
musical?  I've only heard it said David Howls.

But if my ack for the patch helps:

        Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.


> built on all systems under test, isn't auto-loaded at boot, and has
> no device or similar dependencies. This creates the "test_module.ko"
> module for that purpose, which only reports its load and unload to printk.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v3:
>  - use KBUILD_MODNAME; Rusty Russell
> v2:
>  - use pr_warn, better comment, add headers explicitly, move to lib/; akpm.
> ---
>  lib/Kconfig.debug |   14 ++++++++++++++
>  lib/Makefile      |    1 +
>  lib/test_module.c |   33 +++++++++++++++++++++++++++++++++
>  3 files changed, 48 insertions(+)
>  create mode 100644 lib/test_module.c
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index db25707aa41b..81882335c625 100644
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
> +	  requested by name.
> +
> +	  If unsure, say N.
> +
>  source "samples/Kconfig"
>  
>  source "lib/Kconfig.kgdb"
> diff --git a/lib/Makefile b/lib/Makefile
> index a459c31e8c6b..b494b9af631c 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -31,6 +31,7 @@ obj-y += string_helpers.o
>  obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
>  obj-y += kstrtox.o
>  obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
> +obj-$(CONFIG_TEST_MODULE) += test_module.o
>  
>  ifeq ($(CONFIG_DEBUG_KOBJECT),y)
>  CFLAGS_kobject.o += -DDEBUG
> diff --git a/lib/test_module.c b/lib/test_module.c
> new file mode 100644
> index 000000000000..319b66f1ff61
> --- /dev/null
> +++ b/lib/test_module.c
> @@ -0,0 +1,33 @@
> +/*
> + * This module emits "Hello, world" on printk when loaded.
> + *
> + * It is designed to be used for basic evaluation of the module loading
> + * subsystem (for example when validating module signing/verification). It
> + * lacks any extra dependencies, and will not normally be loaded by the
> + * system unless explicitly requested by name.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/printk.h>
> +
> +static int __init test_module_init(void)
> +{
> +	pr_warn("Hello, world\n");
> +
> +	return 0;
> +}
> +
> +module_init(test_module_init);
> +
> +static void __exit test_module_exit(void)
> +{
> +	pr_warn("Goodbye\n");
> +}
> +
> +module_exit(test_module_exit);
> +
> +MODULE_AUTHOR("Kees Cook <keescook@chromium.org>");
> +MODULE_LICENSE("GPL");
> -- 
> 1.7.9.5
