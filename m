Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab3CPPnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 11:43:52 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:33592 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab3CPPnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 11:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <1363441844.2023.17.camel@joe-AO722>
References: <1363441844.2023.17.camel@joe-AO722>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 16 Mar 2013 09:43:29 -0600
Message-ID: <CAErSpo4xN9K+aasX-3v-1PeAJpF+3Vg1WrxFaAKNUA43N3bWBw@mail.gmail.com>
Subject: Re: [RFC PATCH] seq_file: Use seq_puts when seq_printf has only a
 format with no args
To: Joe Perches <joe@perches.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 7:50 AM, Joe Perches <joe@perches.com> wrote:
> Instead of converting the 800 or so uses of seq_printf with
> a constant format (without a % substitution) to seq_puts,
> maybe there's another way to slightly speed up these outputs.
>
> Taking a similar approach to commit abd84d60eb
> ("tracing: Optimize trace_printk() with one arg to use trace_puts()")
> use the preprocessor to convert seq_printf(seq, "string constant")
> to seq_puts(seq, "string constant")
>
> By stringifying __VA_ARGS__, we can, at compile time, determine
> the number of args that are being passed to seq_printf() and
> call seq_puts or seq_printf appropriately.
>
> The actual function definition for seq_printf must now
> be enclosed in parenthesis to avoid further macro expansion.

This is certainly a neat trick.

But I don't really like the fact that it complicates things for every
future code reader, especially when a trivial change in the caller
would accomplish the same thing.  Do you have any idea how much
performance we would gain in exchange for the complication?

Checkpatch could look for additions of seq_printf() with constant formats.

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/seq_file.c            |  7 ++++++-
>  include/linux/seq_file.h | 24 ++++++++++++++++++++++++
>  2 files changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 38bb59f..d3a957d 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -405,7 +405,12 @@ int seq_vprintf(struct seq_file *m, const char *f, va_list args)
>  }
>  EXPORT_SYMBOL(seq_vprintf);
>
> -int seq_printf(struct seq_file *m, const char *f, ...)
> +/*
> + * seq_printf is also a macro that expands to seq_printf or seq_puts.
> + * This means that the actual function definition must be in parenthesis
> + * to prevent the preprocessor from expanding this function name again.
> + */
> +int (seq_printf)(struct seq_file *m, const char *f, ...)
>  {
>         int ret;
>         va_list args;
> diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
> index 68a04a3..7255f01 100644
> --- a/include/linux/seq_file.h
> +++ b/include/linux/seq_file.h
> @@ -7,6 +7,7 @@
>  #include <linux/mutex.h>
>  #include <linux/cpumask.h>
>  #include <linux/nodemask.h>
> +#include <linux/stringify.h>
>
>  struct seq_operations;
>  struct file;
> @@ -92,6 +93,29 @@ int seq_write(struct seq_file *seq, const void *data, size_t len);
>  __printf(2, 3) int seq_printf(struct seq_file *, const char *, ...);
>  __printf(2, 0) int seq_vprintf(struct seq_file *, const char *, va_list args);
>
> +/*
> + * A little optimization trick is done here. If there's only one
> + * argument, there's no need to scan the string for printf formats.
> + * seq_puts() will suffice. But how can we take advantage of
> + * using seq_puts() when seq_printf() has only one argument?
> + * By stringifying the args and checking the size we can tell
> + * whether or not there are args. __stringify(__VA_ARGS__) will
> + * turn into "" with a size of 1 when there are no args, anything
> + * else will be bigger. All we need to do is define a string to this,
> + * and then take its size and compare to 1. If it's bigger, use
> + * seq_printf() otherwise, optimize it to seq_puts(). Then just
> + * let gcc optimize the rest.  The actual function definition of
> + * seq_printf must be (seq_printf) to prevent further macro expansion.
> + */
> +#define seq_printf(seq, fmt, ...)                              \
> +do {                                                           \
> +       char va_args[] = __stringify(__VA_ARGS__);              \
> +       if (sizeof(va_args) > 1)                                \
> +               seq_printf(seq, fmt, ##__VA_ARGS__);            \
> +       else                                                    \
> +               seq_puts(seq, fmt);                             \
> +} while (0)
> +
>  int seq_path(struct seq_file *, const struct path *, const char *);
>  int seq_dentry(struct seq_file *, struct dentry *, const char *);
>  int seq_path_root(struct seq_file *m, const struct path *path,
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
