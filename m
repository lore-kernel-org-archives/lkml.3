Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaBYXrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:47:02 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42139 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaBYXrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:47:00 -0500
Message-ID: <1393372009.2886.5.camel@linux-whg8.site>
Subject: Re: [RFC PATCH for-next 4/4] epoll: epoll() syscall definition
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Feb 2014 15:46:49 -0800
In-Reply-To: <20140225102144.GA10176@dcvr.yhbt.net>
References: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
	 <1393206162-18151-5-git-send-email-n1ght.4nd.d4y@gmail.com>
	 <20140225102144.GA10176@dcvr.yhbt.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 10:21 +0000, Eric Wong wrote:
> Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com> wrote:
> > + * stores triggered eventpoll entries in the 'out' array. The input array is
> > + * _not_ read-only, because the resulting event mask gets written back to each
> > + * entry's ->ep_events field. When successful, this will be the same as before
> > + * (plus EPOLLERR & EPOLLHUP). If ->ep_events gets cleared, then it is reasonable
> > + * to infer that the entry's ->ep_fildes was a bad file descriptor.
> > + */
> 
> > +	if (!access_ok(VERIFY_WRITE, in, inc * sizeof(struct epoll)))
> > +		goto out;
> > +	for (i = 0; i < inc; ++i) {
> > +		int fd, io;
> > +		long long id;
> > +
> > +		ret = -EFAULT;
> > +		if (__get_user(fd, &in[i].ep_fildes) ||
> > +		    __get_user(io, &in[i].ep_events) ||
> > +		    __get_user(id, &in[i].ep_ident))
> > +			goto out;
> > +
> > +		ep_control(file->private_data, fd, &io, id, 0);
> > +		ret = -EFAULT;
> > +		if (__put_user(io, &in[i].ep_events))
> > +			goto out;
> 
> I don't think we should waste cycles writing to 'in' on success.

Fair enough, my thought process was mainly too add some consistency to
the system call, but removing that constraint would clean up
ep_control() anyway.

