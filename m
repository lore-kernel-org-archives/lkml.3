Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaAMXh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:37:26 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47539 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaAMXhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:37:24 -0500
Date: Mon, 13 Jan 2014 15:37:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] fs: __fget_light() can use __fget() in slow path
Message-ID: <20140113233720.GS10038@linux.vnet.ibm.com>
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
 <20140113154906.GD6496@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113154906.GD6496@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011323-6688-0000-0000-0000057E5330
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 04:49:06PM +0100, Oleg Nesterov wrote:
> The slow path in __fget_light() can use __fget() to avoid the
> code duplication. Saves 232 bytes.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  fs/file.c |   14 +++-----------
>  1 files changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index 50c1208..771578b 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -694,17 +694,9 @@ struct file *__fget_light(unsigned int fd, fmode_t mask, int *fput_needed)
>  		if (file && (file->f_mode & mask))
>  			file = NULL;
>  	} else {
> -		rcu_read_lock();
> -		file = fcheck_files(files, fd);
> -		if (file) {
> -			if (!(file->f_mode & mask) &&
> -			    atomic_long_inc_not_zero(&file->f_count))
> -				*fput_needed = 1;
> -			else
> -				/* Didn't get the reference, someone's freed */
> -				file = NULL;
> -		}
> -		rcu_read_unlock();
> +		file = __fget(fd, mask);
> +		if (file)
> +			*fput_needed = 1;
>  	}
> 
>  	return file;
> -- 
> 1.5.5.1
> 
> 

