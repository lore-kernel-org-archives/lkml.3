Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab3IVUll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:41:41 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:43094 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab3IVUli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:41:38 -0400
Date: Sun, 22 Sep 2013 20:41:37 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Jason Baron <jbaron@akamai.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] eventpoll: Move a kmem_cache_alloc and kmem_cache_free
Message-ID: <20130922204137.GA1612@dcvr.yhbt.net>
References: <1379087642-131349-1-git-send-email-nzimmer@sgi.com>
 <5239FA69.8030202@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5239FA69.8030202@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron <jbaron@akamai.com> wrote:
>     epoll: reduce usage of global 'epmutex' lock
>
>     Epoll file descriptors that are 1 link from a wakeup source and
>     are not nested within other epoll descriptors, or pointing to
>     other epoll descriptors, don't need to check for loop creation or
>     the creation of wakeup storms. Because of this we can avoid taking
>     the global 'epmutex' in these cases. This state for the epoll file
>     descriptor is marked as 'EVENTPOLL_BASIC'. Once the epoll file
>     descriptor is attached to another epoll file descriptor it is
>     labeled as 'EVENTPOLL_COMPLEX', and full loop checking and wakeup
>     storm creation are checked using the the global 'epmutex'. It does
>     not transition back. Hopefully, this is a common usecase...

Cool.  I was thinking about doing the same thing down the line (for
EPOLL_CTL_ADD, too)

> @@ -166,6 +167,14 @@ struct epitem {
>  
>  	/* The structure that describe the interested events and the source fd */
>  	struct epoll_event event;
> +
> +	/* TODO: really necessary? */
> +	int on_list;

There's some things we can overload to avoid increasing epitem size
(.ep, .ffd.fd, ...), so on_list should be unnecessary.
