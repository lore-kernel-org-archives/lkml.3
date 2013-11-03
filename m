Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3KCRgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 12:36:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:6752 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752790Ab3KCRgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 12:36:54 -0500
Date: Sun, 3 Nov 2013 12:36:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: trace: blktrace: remove redundent memcpy() in
 compat_blk_trace_setup()
Message-ID: <20131103123647.0bae8cf6@gandalf.local.home>
In-Reply-To: <52765C6B.7080608@asianux.com>
References: <52765C6B.7080608@asianux.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quick review of this patch looks fine to me.

Although, using ARRAY_SIZE() for a character string seems to me a bit
over paranoid. But I'm fine with it, as it makes sure that the string
is an array and not a pointer.

Jens,

Can you give me an Acked-by?

-- Steve


On Sun, 03 Nov 2013 22:23:39 +0800
Chen Gang <gang.chen@asianux.com> wrote:

> do_blk_trace_setup() will fully initialize 'buts.name', so can remove
> the related memcpy(). And also use BLKTRACE_BDEV_SIZE and ARRAY_SIZE
> instead of hard code number '32'.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  include/linux/blktrace_api.h |    2 +-
>  kernel/trace/blktrace.c      |    3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
> index a12f6ed..afc1343 100644
> --- a/include/linux/blktrace_api.h
> +++ b/include/linux/blktrace_api.h
> @@ -89,7 +89,7 @@ static inline int blk_trace_init_sysfs(struct device *dev)
>  #ifdef CONFIG_COMPAT
>  
>  struct compat_blk_user_trace_setup {
> -	char name[32];
> +	char name[BLKTRACE_BDEV_SIZE];
>  	u16 act_mask;
>  	u32 buf_size;
>  	u32 buf_nr;
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 7f727b3..f785aef 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -579,13 +579,12 @@ static int compat_blk_trace_setup(struct request_queue *q, char *name,
>  		.end_lba = cbuts.end_lba,
>  		.pid = cbuts.pid,
>  	};
> -	memcpy(&buts.name, &cbuts.name, 32);
>  
>  	ret = do_blk_trace_setup(q, name, dev, bdev, &buts);
>  	if (ret)
>  		return ret;
>  
> -	if (copy_to_user(arg, &buts.name, 32)) {
> +	if (copy_to_user(arg, &buts.name, ARRAY_SIZE(buts.name))) {
>  		blk_trace_remove(q);
>  		return -EFAULT;
>  	}

