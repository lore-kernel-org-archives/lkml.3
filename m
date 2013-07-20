Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3GTOsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 10:48:41 -0400
Received: from toccata.ens-lyon.org ([140.77.166.68]:60888 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab3GTOsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 10:48:39 -0400
Date: Sat, 20 Jul 2013 16:48:28 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [v3.11-rc1 PATCH 3/5] printk: Move braille console support into
 separate braille.[ch] files
Message-ID: <20130720144828.GG5891@type>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Joe Perches <joe@perches.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
References: <cover.1373922863.git.joe@perches.com>
 <441bf5d2de92efd3b6d43a9ea7d7a6436e486543.1373922863.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <441bf5d2de92efd3b6d43a9ea7d7a6436e486543.1373922863.git.joe@perches.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches, le Mon 15 Jul 2013 14:51:33 -0700, a écrit :
> Create files with prototypes and static inlines for braille
> support.  Make braille_console functions return 1 on success.
> 
> Corrected CONFIG_A11Y_BRAILLE_CONSOLE=n _braille_console_setup
> return value to NULL.
> 
> link:  http://lkml.kernel.org/r/1350999678-17441-1-git-send-email-ming.lei@canonical.com
> cc: Samuel Thibault <samuel.thibault@ens-lyon.org>

Reviewed-By: Samuel Thibault <samuel.thibault@ens-lyon.org>

Thanks,
Samuel

> cc: Ming Lei <ming.lei@canonical.com>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/accessibility/braille/braille_console.c |  9 +++--
>  kernel/printk/Makefile                          |  1 +
>  kernel/printk/braille.c                         | 48 +++++++++++++++++++++++++
>  kernel/printk/braille.h                         | 48 +++++++++++++++++++++++++
>  kernel/printk/printk.c                          | 44 +++++++----------------
>  5 files changed, 117 insertions(+), 33 deletions(-)
>  create mode 100644 kernel/printk/braille.c
>  create mode 100644 kernel/printk/braille.h
> 
> diff --git a/drivers/accessibility/braille/braille_console.c b/drivers/accessibility/braille/braille_console.c
> index d21167b..dc34a5b 100644
> --- a/drivers/accessibility/braille/braille_console.c
> +++ b/drivers/accessibility/braille/braille_console.c
> @@ -359,6 +359,9 @@ int braille_register_console(struct console *console, int index,
>  		char *console_options, char *braille_options)
>  {
>  	int ret;
> +
> +	if (!(console->flags & CON_BRL))
> +		return 0;
>  	if (!console_options)
>  		/* Only support VisioBraille for now */
>  		console_options = "57600o8";
> @@ -374,15 +377,17 @@ int braille_register_console(struct console *console, int index,
>  	braille_co = console;
>  	register_keyboard_notifier(&keyboard_notifier_block);
>  	register_vt_notifier(&vt_notifier_block);
> -	return 0;
> +	return 1;
>  }
>  
>  int braille_unregister_console(struct console *console)
>  {
>  	if (braille_co != console)
>  		return -EINVAL;
> +	if (!(console->flags & CON_BRL))
> +		return 0;
>  	unregister_keyboard_notifier(&keyboard_notifier_block);
>  	unregister_vt_notifier(&vt_notifier_block);
>  	braille_co = NULL;
> -	return 0;
> +	return 1;
>  }
> diff --git a/kernel/printk/Makefile b/kernel/printk/Makefile
> index 36d306d..85405bd 100644
> --- a/kernel/printk/Makefile
> +++ b/kernel/printk/Makefile
> @@ -1 +1,2 @@
>  obj-y	= printk.o
> +obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)	+= braille.o
> diff --git a/kernel/printk/braille.c b/kernel/printk/braille.c
> new file mode 100644
> index 0000000..b51087f
> --- /dev/null
> +++ b/kernel/printk/braille.c
> @@ -0,0 +1,48 @@
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/kernel.h>
> +#include <linux/console.h>
> +#include <linux/string.h>
> +
> +#include "console_cmdline.h"
> +#include "braille.h"
> +
> +char *_braille_console_setup(char **str, char **brl_options)
> +{
> +	if (!memcmp(*str, "brl,", 4)) {
> +		*brl_options = "";
> +		*str += 4;
> +	} else if (!memcmp(str, "brl=", 4)) {
> +		*brl_options = *str + 4;
> +		*str = strchr(*brl_options, ',');
> +		if (!*str)
> +			pr_err("need port name after brl=\n");
> +		else
> +			*((*str)++) = 0;
> +	}
> +
> +	return *str;
> +}
> +
> +int
> +_braille_register_console(struct console *console, struct console_cmdline *c)
> +{
> +	int rtn = 0;
> +
> +	if (c->brl_options) {
> +		console->flags |= CON_BRL;
> +		rtn = braille_register_console(console, c->index, c->options,
> +					       c->brl_options);
> +	}
> +
> +	return rtn;
> +}
> +
> +int
> +_braille_unregister_console(struct console *console)
> +{
> +	if (console->flags & CON_BRL)
> +		return braille_unregister_console(console);
> +
> +	return 0;
> +}
> diff --git a/kernel/printk/braille.h b/kernel/printk/braille.h
> new file mode 100644
> index 0000000..769d771
> --- /dev/null
> +++ b/kernel/printk/braille.h
> @@ -0,0 +1,48 @@
> +#ifndef _PRINTK_BRAILLE_H
> +#define _PRINTK_BRAILLE_H
> +
> +#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
> +
> +static inline void
> +braille_set_options(struct console_cmdline *c, char *brl_options)
> +{
> +	c->brl_options = brl_options;
> +}
> +
> +char *
> +_braille_console_setup(char **str, char **brl_options);
> +
> +int
> +_braille_register_console(struct console *console, struct console_cmdline *c);
> +
> +int
> +_braille_unregister_console(struct console *console);
> +
> +#else
> +
> +static inline void
> +braille_set_options(struct console_cmdline *c, char *brl_options)
> +{
> +}
> +
> +static inline char *
> +_braille_console_setup(char **str, char **brl_options)
> +{
> +	return NULL;
> +}
> +
> +static inline int
> +_braille_register_console(struct console *console, struct console_cmdline *c)
> +{
> +	return 0;
> +}
> +
> +static inline int
> +_braille_unregister_console(struct console *console)
> +{
> +	return 0;
> +}
> +
> +#endif
> +
> +#endif
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 4e9a982..7c4020c 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -50,6 +50,7 @@
>  #include <trace/events/printk.h>
>  
>  #include "console_cmdline.h"
> +#include "braille.h"
>  
>  /* printk's without a loglevel use this.. */
>  #define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
> @@ -1767,9 +1768,8 @@ static int __add_preferred_console(char *name, int idx, char *options,
>  	c = &console_cmdline[i];
>  	strlcpy(c->name, name, sizeof(c->name));
>  	c->options = options;
> -#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
> -	c->brl_options = brl_options;
> -#endif
> +	braille_set_options(c, brl_options);
> +
>  	c->index = idx;
>  	return 0;
>  }
> @@ -1782,20 +1782,8 @@ static int __init console_setup(char *str)
>  	char *s, *options, *brl_options = NULL;
>  	int idx;
>  
> -#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
> -	if (!memcmp(str, "brl,", 4)) {
> -		brl_options = "";
> -		str += 4;
> -	} else if (!memcmp(str, "brl=", 4)) {
> -		brl_options = str + 4;
> -		str = strchr(brl_options, ',');
> -		if (!str) {
> -			printk(KERN_ERR "need port name after brl=\n");
> -			return 1;
> -		}
> -		*(str++) = 0;
> -	}
> -#endif
> +	if (_braille_console_setup(&str, &brl_options))
> +		return 1;
>  
>  	/*
>  	 * Decode str into name, index, options.
> @@ -2289,16 +2277,10 @@ void register_console(struct console *newcon)
>  			continue;
>  		if (newcon->index < 0)
>  			newcon->index = console_cmdline[i].index;
> -#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
> -		if (console_cmdline[i].brl_options) {
> -			newcon->flags |= CON_BRL;
> -			braille_register_console(newcon,
> -					console_cmdline[i].index,
> -					console_cmdline[i].options,
> -					console_cmdline[i].brl_options);
> +
> +		if (_braille_register_console(newcon, &console_cmdline[i]))
>  			return;
> -		}
> -#endif
> +
>  		if (newcon->setup &&
>  		    newcon->setup(newcon, console_cmdline[i].options) != 0)
>  			break;
> @@ -2386,13 +2368,13 @@ EXPORT_SYMBOL(register_console);
>  int unregister_console(struct console *console)
>  {
>          struct console *a, *b;
> -	int res = 1;
> +	int res;
>  
> -#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
> -	if (console->flags & CON_BRL)
> -		return braille_unregister_console(console);
> -#endif
> +	res = _braille_unregister_console(console);
> +	if (res)
> +		return res;
>  
> +	res = 1;
>  	console_lock();
>  	if (console_drivers == console) {
>  		console_drivers=console->next;
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
> 

-- 
Samuel
After watching my newly-retired dad spend two weeks learning how to make a new
folder, it became obvious that "intuitive" mostly means "what the writer or
speaker of intuitive likes".
(Bruce Ediger, bediger@teal.csn.org, in comp.os.linux.misc, on X the
intuitiveness of a Mac interface.)
