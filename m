Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaLZJqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:46:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbaLZJqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:46:02 -0500
Message-ID: <549D2E51.3040200@redhat.com>
Date: Fri, 26 Dec 2014 17:45:53 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alex Gartrell <agartrell@fb.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next 1/2] socket: Allow external sockets to use socket
 syscalls
References: <1419576624-8999-1-git-send-email-agartrell@fb.com> <1419576624-8999-2-git-send-email-agartrell@fb.com>
In-Reply-To: <1419576624-8999-2-git-send-email-agartrell@fb.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/26/2014 02:50 PM, Alex Gartrell wrote:
> Currently the "is-socket" test for a file compares the ops table pointer,
> which is static and local to the socket.c.  Instead, this adds a flag for
> private_data_is_socket.  This is an exceptionally long commit message for a
> two-line patch.
>
> Signed-off-by: Alex Gartrell <agartrell@fb.com>
> ---
>  include/linux/fs.h | 2 +-
>  net/socket.c       | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index bb29b02..d162476 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -809,7 +809,7 @@ struct file {
>  #endif
>  	/* needed for tty driver, and maybe others */
>  	void			*private_data;
> -
> +	bool			private_data_is_socket : 1;
>  #ifdef CONFIG_EPOLL
>  	/* Used by fs/eventpoll.c to link all the hooks to this file */
>  	struct list_head	f_ep_links;
> diff --git a/net/socket.c b/net/socket.c
> index 8809afc..cd853be 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -388,6 +388,7 @@ struct file *sock_alloc_file(struct socket *sock, int flags, const char *dname)
>  	sock->file = file;
>  	file->f_flags = O_RDWR | (flags & O_NONBLOCK);
>  	file->private_data = sock;
> +	file->private_data_is_socket = true;

This is only safe if all user of sock_alloc_file() have full support for
each method in proto_ops.
>  	return file;
>  }
>  EXPORT_SYMBOL(sock_alloc_file);
> @@ -411,7 +412,7 @@ static int sock_map_fd(struct socket *sock, int flags)
>  
>  struct socket *sock_from_file(struct file *file, int *err)
>  {
> -	if (file->f_op == &socket_file_ops)
> +	if (file->private_data_is_socket)
>  		return file->private_data;	/* set in sock_map_fd */
>  
>  	*err = -ENOTSOCK;

Not sure it's the best method, how about a dedicated f_op to do this?
