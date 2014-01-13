Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaAMXcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:32:45 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:44552 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaAMXcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:32:42 -0500
Date: Mon, 13 Jan 2014 15:32:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] fs: factor out common code in fget_light() and
 fget_raw_light()
Message-ID: <20140113233237.GR10038@linux.vnet.ibm.com>
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
 <20140113154840.GC6496@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113154840.GC6496@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011323-0928-0000-0000-0000055E4F8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 04:48:40PM +0100, Oleg Nesterov wrote:
> Apart from FMODE_PATH check fget_light() and fget_raw_light() are
> identical, shift the code into the new helper, __fget_light(fd, mask).
> Saves 208 bytes.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  fs/file.c |   33 +++++++++------------------------
>  1 files changed, 9 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index 4ed58a3..50c1208 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -683,21 +683,21 @@ EXPORT_SYMBOL(fget_raw);
>   * The fput_needed flag returned by fget_light should be passed to the
>   * corresponding fput_light.
>   */
> -struct file *fget_light(unsigned int fd, int *fput_needed)
> +struct file *__fget_light(unsigned int fd, fmode_t mask, int *fput_needed)
>  {
> -	struct file *file;
>  	struct files_struct *files = current->files;
> +	struct file *file;
> 
>  	*fput_needed = 0;
>  	if (atomic_read(&files->count) == 1) {
>  		file = __fcheck_files(files, fd);
> -		if (file && (file->f_mode & FMODE_PATH))
> +		if (file && (file->f_mode & mask))
>  			file = NULL;
>  	} else {
>  		rcu_read_lock();
>  		file = fcheck_files(files, fd);
>  		if (file) {
> -			if (!(file->f_mode & FMODE_PATH) &&
> +			if (!(file->f_mode & mask) &&
>  			    atomic_long_inc_not_zero(&file->f_count))
>  				*fput_needed = 1;
>  			else
> @@ -709,30 +709,15 @@ struct file *fget_light(unsigned int fd, int *fput_needed)
> 
>  	return file;
>  }
> +struct file *fget_light(unsigned int fd, int *fput_needed)
> +{
> +	return __fget_light(fd, FMODE_PATH, fput_needed);
> +}
>  EXPORT_SYMBOL(fget_light);
> 
>  struct file *fget_raw_light(unsigned int fd, int *fput_needed)
>  {
> -	struct file *file;
> -	struct files_struct *files = current->files;
> -
> -	*fput_needed = 0;
> -	if (atomic_read(&files->count) == 1) {
> -		file = __fcheck_files(files, fd);
> -	} else {
> -		rcu_read_lock();
> -		file = fcheck_files(files, fd);
> -		if (file) {
> -			if (atomic_long_inc_not_zero(&file->f_count))
> -				*fput_needed = 1;
> -			else
> -				/* Didn't get the reference, someone's freed */
> -				file = NULL;
> -		}
> -		rcu_read_unlock();
> -	}
> -
> -	return file;
> +	return __fget_light(fd, 0, fput_needed);
>  }
> 
>  void set_close_on_exec(unsigned int fd, int flag)
> -- 
> 1.5.5.1
> 
> 

