Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaBYKVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:21:46 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:58605 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaBYKVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:21:45 -0500
Date: Tue, 25 Feb 2014 10:21:44 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH for-next 4/4] epoll: epoll() syscall definition
Message-ID: <20140225102144.GA10176@dcvr.yhbt.net>
References: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
 <1393206162-18151-5-git-send-email-n1ght.4nd.d4y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393206162-18151-5-git-send-email-n1ght.4nd.d4y@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com> wrote:
> + * stores triggered eventpoll entries in the 'out' array. The input array is
> + * _not_ read-only, because the resulting event mask gets written back to each
> + * entry's ->ep_events field. When successful, this will be the same as before
> + * (plus EPOLLERR & EPOLLHUP). If ->ep_events gets cleared, then it is reasonable
> + * to infer that the entry's ->ep_fildes was a bad file descriptor.
> + */

> +	if (!access_ok(VERIFY_WRITE, in, inc * sizeof(struct epoll)))
> +		goto out;
> +	for (i = 0; i < inc; ++i) {
> +		int fd, io;
> +		long long id;
> +
> +		ret = -EFAULT;
> +		if (__get_user(fd, &in[i].ep_fildes) ||
> +		    __get_user(io, &in[i].ep_events) ||
> +		    __get_user(id, &in[i].ep_ident))
> +			goto out;
> +
> +		ep_control(file->private_data, fd, &io, id, 0);
> +		ret = -EFAULT;
> +		if (__put_user(io, &in[i].ep_events))
> +			goto out;

I don't think we should waste cycles writing to 'in' on success.
