Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaIXVjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:39:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaIXVjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:39:05 -0400
Date: Wed, 24 Sep 2014 14:39:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: rdunlap@infradead.org, viro@zeniv.linux.org.uk, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@codethink.co.uk, keescook@chromium.org,
        penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [PATCH RESUBMIT 1/2] fs/seq_file: Create new function
 seq_open_init()
Message-Id: <20140924143904.b6f12611013876253d8ac50a@linux-foundation.org>
In-Reply-To: <1411557356-10673-2-git-send-email-rob.jones@codethink.co.uk>
References: <1411557356-10673-1-git-send-email-rob.jones@codethink.co.uk>
	<1411557356-10673-2-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014 12:15:55 +0100 Rob Jones <rob.jones@codethink.co.uk> wrote:

> Add a new function to help reduce boilerplate code.
> 
> This is a wrapper function for seq_open() that will simplify the code in a
> significant number of cases where seq_open() is currently called.
> 
> It's first use is in __seq_open_private(), thereby recovering most of
> the code space used by the new function.

It would be nice to include one or more of the conversions in this patch
series so we can see what the effects look like.

> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -639,28 +639,38 @@ int seq_release_private(struct inode *inode, struct file *file)
>  }
>  EXPORT_SYMBOL(seq_release_private);
>  
> +int seq_open_init(struct file *f, const struct seq_operations *ops, void *p)
> +{
> +	struct seq_file *s;
> +	int rc;
> +
> +	rc = seq_open(f, ops);
> +	if (rc)
> +		return rc;
> +
> +	s = f->private_data;
> +	s->private = p;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(seq_open_init);

A global exported-to-modules interface should be documented, please. 
Especially when it has a void* argument.  seq_file.c is patchy - some
of it is documented, some of it uses the read-programmers-mind
approach.


__seq_open_private() has
	void *private;

single_open() has
	void *data

And now seq_open_init() has
	void *p

but these all refer to the same thing.  Can we have a bit of
consistency in the naming please?  I suggest "private", to match
the seq_file field.




