Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab3CRVxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:53:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab3CRVxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:53:35 -0400
Date: Mon, 18 Mar 2013 14:53:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH 1/2] teach argv_split() to handle the mutable strings
Message-Id: <20130318145333.abecd78f3dde5e1307a7e493@linux-foundation.org>
In-Reply-To: <20130316202353.GB18613@redhat.com>
References: <20130312182210.GA15862@redhat.com>
	<CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com>
	<20130312191118.GA17439@redhat.com>
	<CA+55aFzmATkP-W0uX1a_gP7E1fwcp2Mh4537Ou2uwHDixNKPTg@mail.gmail.com>
	<20130312203514.GA23488@redhat.com>
	<20130313174641.GA28083@redhat.com>
	<20130313174705.GB28083@redhat.com>
	<20130314152819.7fb1242b493e8bad2d34671b@linux-foundation.org>
	<20130315163916.GA31995@redhat.com>
	<20130316202327.GA18613@redhat.com>
	<20130316202353.GB18613@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Mar 2013 21:23:53 +0100 Oleg Nesterov <oleg@redhat.com> wrote:

> argv_split() allocates argv[count_argc(str)] array and assumes that
> it will find the same number of arguments later. This is obviously
> wrong if this string can be changed, say, by sysctl.
> 
> With this patch argv_split() kstrndup's the whole string and does
> not split it, we simply replace the spaces with zeroes and keep the
> allocated memory in argv[-1] for argv_free(arg).
> 
> We do not use argv[0] because:
> 
> 	- str can be all-spaces or empty. In fact this case is fine,
> 	  we could kfree() it before return, but:
> 
> 	- str can have a space at the start, and we can not rely on
> 	  kstrndup(skip_arg(str)) because it can equally race if this
> 	  string is mutable.
> 
> Also, simplify count_argc() and kill the no longer used skip_arg().
> 
> ...
>
>  char **argv_split(gfp_t gfp, const char *str, int *argcp)
>  {
> -	int argc = count_argc(str);
> -	char **argv = kzalloc(sizeof(*argv) * (argc+1), gfp);
> -	char **argvp;
> -
> -	if (argv == NULL)
> -		goto out;
> -
> -	if (argcp)
> -		*argcp = argc;
> -
> -	argvp = argv;
> -
> -	while (*str) {
> -		str = skip_spaces(str);
> -
> -		if (*str) {
> -			const char *p = str;
> -			char *t;
> -
> -			str = skip_arg(str);
> +	char *argv_str;
> +	bool was_space;
> +	char **argv, **argv_ret;
> +	int argc;
> +
> +	argv_str = kstrndup(str, KMALLOC_MAX_SIZE, gfp);

hm, I think that works.

kstrndup() does kmalloc_track_caller(len+1, gfp) so your
KMALLOC_MAX_SIZE is off-by-one?


>From reading the code it is rather unobvious why things were
implemented in this fashion.  People may come along in five years and
"clean it up".  Hence we should explain, no?

--- a/lib/argv_split.c~argv_split-teach-it-to-handle-mutable-strings-fix
+++ a/lib/argv_split.c
@@ -51,6 +51,10 @@ EXPORT_SYMBOL(argv_free);
  * considered to be a single argument separator.  The returned array
  * is always NULL-terminated.  Returns NULL on memory allocation
  * failure.
+ *
+ * The source string at `str' may be undergoing concurrent alteration via
+ * userspace sysctl activity (at least).  The argv_split() implementation
+ * attempts to handle this gracefully by taking a local copy to work on.
  */
 char **argv_split(gfp_t gfp, const char *str, int *argcp)
 {
_

