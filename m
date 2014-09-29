Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaI2XoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:44:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:61415 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754770AbaI2XoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:44:17 -0400
Date: Mon, 29 Sep 2014 19:44:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/7] seq_file: Rename static bool seq_overflow to public
 bool seq_is_full
Message-ID: <20140929194407.26832810@gandalf.local.home>
In-Reply-To: <848ac7e3d1c31cddf638a8526fa3c59fa6fdeb8a.1412031505.git.joe@perches.com>
References: <20140929124246.3e39dac8@gandalf.local.home>
	<cover.1412031505.git.joe@perches.com>
	<848ac7e3d1c31cddf638a8526fa3c59fa6fdeb8a.1412031505.git.joe@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 16:08:21 -0700
Joe Perches <joe@perches.com> wrote:

> The return values of seq_printf/puts/putc are frequently misused.
> 
> Start down a path to remove all the return value uses of these
> functions.
> 
> Make the static bool seq_overflow public along with a rename of
> the function to seq_is_full.  Rename the still static
> seq_set_overflow to seq_set_full.
> 
> Update the documentation to not show return types for seq_printf
> et al.  Add a description of seq_is_full.

Actually, can you make a separate function that's public that is
seq_is_full(), where m->count >= m->size, and leave seq_overflow()
alone.

That's because I'm working on making seq_overflow be
m->count > m->size, and allow m->count == m->size not be flagged as an
overflow. I'm looking at places that hard code writing into the buffer
(outside of seq_file.c) and they too can fill the buffer exactly.

Thus, all that is needed is the seq_is_full() function added, and you
don't need to modify the seq_set_overflow() either. It makes sense for
external functions to know test for seq_is_full() as if
m->count == m->size, they can't write anymore either.

Thanks!

-- Steve


> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  Documentation/filesystems/seq_file.txt | 28 ++++++++++++++++------------
>  fs/seq_file.c                          | 28 ++++++++++++++--------------
>  include/linux/seq_file.h               |  8 ++++++++
>  3 files changed, 38 insertions(+), 26 deletions(-)
> 
> diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
> index 8ea3e90..e19c636 100644
> --- a/Documentation/filesystems/seq_file.txt
> +++ b/Documentation/filesystems/seq_file.txt
> @@ -180,27 +180,23 @@ output must be passed to the seq_file code. Some utility functions have
>  been defined which make this task easy.
>  
>  Most code will simply use seq_printf(), which works pretty much like
> -printk(), but which requires the seq_file pointer as an argument. It is
> -common to ignore the return value from seq_printf(), but a function
> -producing complicated output may want to check that value and quit if
> -something non-zero is returned; an error return means that the seq_file
> -buffer has been filled and further output will be discarded.
> +printk(), but which requires the seq_file pointer as an argument.
>  
>  For straight character output, the following functions may be used:
>  
> -	int seq_putc(struct seq_file *m, char c);
> -	int seq_puts(struct seq_file *m, const char *s);
> -	int seq_escape(struct seq_file *m, const char *s, const char *esc);
> +	seq_putc(struct seq_file *m, char c);
> +	seq_puts(struct seq_file *m, const char *s);
> +	seq_escape(struct seq_file *m, const char *s, const char *esc);
>  
>  The first two output a single character and a string, just like one would
>  expect. seq_escape() is like seq_puts(), except that any character in s
>  which is in the string esc will be represented in octal form in the output.
>  
> -There is also a pair of functions for printing filenames:
> +There are also a pair of functions for printing filenames:
>  
> -	int seq_path(struct seq_file *m, struct path *path, char *esc);
> -	int seq_path_root(struct seq_file *m, struct path *path,
> -			  struct path *root, char *esc)
> +	seq_path(struct seq_file *m, struct path *path, char *esc);
> +	seq_path_root(struct seq_file *m, struct path *path,
> +		      struct path *root, char *esc)
>  
>  Here, path indicates the file of interest, and esc is a set of characters
>  which should be escaped in the output.  A call to seq_path() will output
> @@ -209,6 +205,14 @@ root is desired, it can be used with seq_path_root().  Note that, if it
>  turns out that path cannot be reached from root, the value of root will be
>  changed in seq_file_root() to a root which *does* work.
>  
> +A function producing complicated output may want to check
> +	bool seq_is_full(struct seq_file *m);
> +and avoid further seq_<output> calls if true is returned.
> +
> +A true return from seq_is_full means that the seq_file buffer is full
> +and further output will be discarded.  The seq_show function will attempt
> +to allocate a larger buffer and retry printing.
> +
>  
>  Making it all work
>  
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 3857b72..555aed6 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -16,18 +16,18 @@
>  #include <asm/uaccess.h>
>  #include <asm/page.h>
>  
> -
>  /*
> - * seq_files have a buffer which can may overflow. When this happens a larger
> + * seq_files have a buffer which may overflow. When this happens a larger
>   * buffer is reallocated and all the data will be printed again.
>   * The overflow state is true when m->count == m->size.
>   */
> -static bool seq_overflow(struct seq_file *m)
> +bool seq_is_full(struct seq_file *m)
>  {
>  	return m->count == m->size;
>  }
> +EXPORT_SYMBOL(seq_is_full);
>  
> -static void seq_set_overflow(struct seq_file *m)
> +static void seq_set_full(struct seq_file *m)
>  {
>  	m->count = m->size;
>  }
> @@ -124,7 +124,7 @@ static int traverse(struct seq_file *m, loff_t offset)
>  			error = 0;
>  			m->count = 0;
>  		}
> -		if (seq_overflow(m))
> +		if (seq_is_full(m))
>  			goto Eoverflow;
>  		if (pos + m->count > offset) {
>  			m->from = offset - pos;
> @@ -267,7 +267,7 @@ Fill:
>  			break;
>  		}
>  		err = m->op->show(m, p);
> -		if (seq_overflow(m) || err) {
> +		if (seq_is_full(m) || err) {
>  			m->count = offs;
>  			if (likely(err <= 0))
>  				break;
> @@ -396,7 +396,7 @@ int seq_escape(struct seq_file *m, const char *s, const char *esc)
>  			*p++ = '0' + (c & 07);
>  			continue;
>  		}
> -		seq_set_overflow(m);
> +		seq_set_full(m);
>  		return -1;
>          }
>  	m->count = p - m->buf;
> @@ -415,7 +415,7 @@ int seq_vprintf(struct seq_file *m, const char *f, va_list args)
>  			return 0;
>  		}
>  	}
> -	seq_set_overflow(m);
> +	seq_set_full(m);
>  	return -1;
>  }
>  EXPORT_SYMBOL(seq_vprintf);
> @@ -557,7 +557,7 @@ int seq_bitmap(struct seq_file *m, const unsigned long *bits,
>  			return 0;
>  		}
>  	}
> -	seq_set_overflow(m);
> +	seq_set_full(m);
>  	return -1;
>  }
>  EXPORT_SYMBOL(seq_bitmap);
> @@ -573,7 +573,7 @@ int seq_bitmap_list(struct seq_file *m, const unsigned long *bits,
>  			return 0;
>  		}
>  	}
> -	seq_set_overflow(m);
> +	seq_set_full(m);
>  	return -1;
>  }
>  EXPORT_SYMBOL(seq_bitmap_list);
> @@ -702,7 +702,7 @@ int seq_puts(struct seq_file *m, const char *s)
>  		m->count += len;
>  		return 0;
>  	}
> -	seq_set_overflow(m);
> +	seq_set_full(m);
>  	return -1;
>  }
>  EXPORT_SYMBOL(seq_puts);
> @@ -736,7 +736,7 @@ int seq_put_decimal_ull(struct seq_file *m, char delimiter,
>  	m->count += len;
>  	return 0;
>  overflow:
> -	seq_set_overflow(m);
> +	seq_set_full(m);
>  	return -1;
>  }
>  EXPORT_SYMBOL(seq_put_decimal_ull);
> @@ -746,7 +746,7 @@ int seq_put_decimal_ll(struct seq_file *m, char delimiter,
>  {
>  	if (num < 0) {
>  		if (m->count + 3 >= m->size) {
> -			seq_set_overflow(m);
> +			seq_set_full(m);
>  			return -1;
>  		}
>  		if (delimiter)
> @@ -774,7 +774,7 @@ int seq_write(struct seq_file *seq, const void *data, size_t len)
>  		seq->count += len;
>  		return 0;
>  	}
> -	seq_set_overflow(seq);
> +	seq_set_full(seq);
>  	return -1;
>  }
>  EXPORT_SYMBOL(seq_write);
> diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
> index 52e0097..1f36da8 100644
> --- a/include/linux/seq_file.h
> +++ b/include/linux/seq_file.h
> @@ -43,6 +43,14 @@ struct seq_operations {
>  #define SEQ_SKIP 1
>  
>  /**
> + * seq_is_full - check if the buffer associated to seq_file is full
> + * @m: the seq_file handle
> + *
> + * Returns true if the buffer is full
> + */
> +bool seq_is_full(struct seq_file *m);
> +
> +/**
>   * seq_get_buf - get buffer to write arbitrary data to
>   * @m: the seq_file handle
>   * @bufp: the beginning of the buffer is stored here

