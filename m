Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab3LKX1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:27:37 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58508 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3LKX1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:27:34 -0500
Message-ID: <52A8F4E0.5080402@gmail.com>
Date: Thu, 12 Dec 2013 10:27:28 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Alexander Viro <viro@zeniv.linux.org.uk>
CC: Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 1/3] seq: Add a seq_overflow test.
References: <cover.1386738050.git.joe@perches.com> <f752df21274aef5c88da81d6c37d427bfe1859a2.1386738050.git.joe@perches.com>
In-Reply-To: <f752df21274aef5c88da81d6c37d427bfe1859a2.1386738050.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 16:12, Joe Perches wrote:
> seq_printf and seq_puts returns are often misused.
> 
> Instead of checking the seq_printf or seq_puts return,
> add a new seq_overflow function to test if a seq_file has
> overflowed the available buffer space.
> 
> This will eventually allow seq_printf and seq_puts to be
> converted to have a void return instead of the int return
> that is often assumed to have a size_t value instead of an
> error/no-error value.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/seq_file.c            | 15 ++++++++-------
>  include/linux/seq_file.h |  2 ++
>  2 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 1d641bb..aab0736 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -14,16 +14,17 @@
>  #include <asm/uaccess.h>
>  #include <asm/page.h>
>  
> -
> -/*
> - * seq_files have a buffer which can may overflow. When this happens a larger
> - * buffer is reallocated and all the data will be printed again.
> - * The overflow state is true when m->count == m->size.
> +/**
> + * seq_overflow - test if a seq_file has overflowed the space available
> + * @m: the seq_file handle
> + *
> + * Returns -1 when an overflow has occurred, 0 otherwise.
>   */
> -static bool seq_overflow(struct seq_file *m)
> +int seq_overflow(struct seq_file *m)
>  {
> -	return m->count == m->size;
> +	return m->count == m->size ? -1 : 0;
>  }
> +EXPORT_SYMBOL(seq_overflow);

What is the reasoning in making this return int instead of bool? Having
it return int encourages people to do:

	return seq_overflow(s);

When used in seq_file functions will return -EPERM (-1) to user-space,
which is confusing. It should probably return bool and let the caller
sort out the correct error to return.

~Ryan

