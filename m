Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaAMX3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:29:45 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41519 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaAMX3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:29:42 -0500
Date: Mon, 13 Jan 2014 15:29:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] fs: factor out common code in fget() and fget_raw()
Message-ID: <20140113232937.GQ10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140107181258.GA29288@redhat.com>
 <20140108132852.GF10038@linux.vnet.ibm.com>
 <20140108151918.GA5156@redhat.com>
 <20140109011650.GI10038@linux.vnet.ibm.com>
 <20140110153459.GA31491@redhat.com>
 <20140111063438.GY10038@linux.vnet.ibm.com>
 <20140111181908.GA7358@redhat.com>
 <20140111222737.GE10038@linux.vnet.ibm.com>
 <20140113154748.GA6496@redhat.com>
 <20140113154819.GB6496@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113154819.GB6496@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011323-7164-0000-0000-00000515B2C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 04:48:19PM +0100, Oleg Nesterov wrote:
> Apart from FMODE_PATH check fget() and fget_raw() are identical,
> shift the code into the new simple helper, __fget(fd, mask). Saves
> 160 bytes.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Not sure why local variable "file" was moved, but regardless:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  fs/file.c |   25 ++++++++-----------------
>  1 files changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index d34e59e..4ed58a3 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -637,16 +637,16 @@ void do_close_on_exec(struct files_struct *files)
>  	spin_unlock(&files->file_lock);
>  }
> 
> -struct file *fget(unsigned int fd)
> +static struct file *__fget(unsigned int fd, fmode_t mask)
>  {
> -	struct file *file;
>  	struct files_struct *files = current->files;
> +	struct file *file;
> 
>  	rcu_read_lock();
>  	file = fcheck_files(files, fd);
>  	if (file) {
>  		/* File object ref couldn't be taken */
> -		if (file->f_mode & FMODE_PATH ||
> +		if ((file->f_mode & mask) ||
>  		    !atomic_long_inc_not_zero(&file->f_count))
>  			file = NULL;
>  	}
> @@ -655,25 +655,16 @@ struct file *fget(unsigned int fd)
>  	return file;
>  }
> 
> +struct file *fget(unsigned int fd)
> +{
> +	return __fget(fd, FMODE_PATH);
> +}
>  EXPORT_SYMBOL(fget);
> 
>  struct file *fget_raw(unsigned int fd)
>  {
> -	struct file *file;
> -	struct files_struct *files = current->files;
> -
> -	rcu_read_lock();
> -	file = fcheck_files(files, fd);
> -	if (file) {
> -		/* File object ref couldn't be taken */
> -		if (!atomic_long_inc_not_zero(&file->f_count))
> -			file = NULL;
> -	}
> -	rcu_read_unlock();
> -
> -	return file;
> +	return __fget(fd, 0);
>  }
> -
>  EXPORT_SYMBOL(fget_raw);
> 
>  /*
> -- 
> 1.5.5.1
> 
> 

