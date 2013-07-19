Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965506Ab3GSFXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:23:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965353Ab3GSFXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:23:22 -0400
Date: Fri, 19 Jul 2013 10:53:12 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnd Bergmann <arnd@arndb.de>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 2/2] [BUGFIX] virtio/console: Add pipe_lock/unlock for
 splice_write
Message-ID: <20130719052312.GC3087@amit-x200.redhat.com>
References: <20130718231927.3664.50418.stgit@yunodevel>
 <20130718231932.3664.25089.stgit@yunodevel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718231932.3664.25089.stgit@yunodevel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) 19 Jul 2013 [08:19:32], Yoshihiro YUNOMAE wrote:
> Add pipe_lock/unlock for splice_write to avoid oops by following competition:

> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index 8722656..4a28e4c 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -936,6 +936,7 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
>  	 * pipe->nrbufs == 0 means there are no data to transfer,
>  	 * so this returns just 0 for no data.
>  	 */
> +	pipe_lock(pipe);
>  	if (!pipe->nrbufs)
>  		return 0;
>  
> @@ -953,6 +954,7 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
>  	sgl.sg = buf->sg;
>  	sg_init_table(sgl.sg, sgl.size);
>  	ret = __splice_from_pipe(pipe, &sd, pipe_to_sg);
> +	pipe_unlock(pipe);
>  	if (likely(ret > 0))
>  		ret = __send_to_port(port, buf->sg, sgl.n, sgl.len, buf, true);
>  
> 

You're not unlocking in all the error return cases.

		Amit
