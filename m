Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbbAOXKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 18:10:55 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:45174 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbbAOXKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 18:10:54 -0500
Date: Thu, 15 Jan 2015 23:10:51 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Jason Baron <jbaron@akamai.com>
Cc: akpm@linux-foundation.org, famz@redhat.com, nzimmer@sgi.com,
        viro@zeniv.linux.org.uk, davidel@xmailserver.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] epoll: introduce epoll connected components
 (remove the epmutex)
Message-ID: <20150115231051.GA24252@dcvr.yhbt.net>
References: <cover.1421337657.git.jbaron@akamai.com>
 <f0053e978dfddd6fa9a5c72c69d9353d219fc4b9.1421337657.git.jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0053e978dfddd6fa9a5c72c69d9353d219fc4b9.1421337657.git.jbaron@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron <jbaron@akamai.com> wrote:
> I've done a bit of performance evaluation on a dual socket, 10 core, hyper
> threading enabled box: Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz. For the
> simple epfdN->epfdN->pipefdN topology case where each thread has its
> own unique files and is doing EPOLL_CTL_ADD and EPOLL_CTL_DEL on the pipefd,
> I see an almost 300% improvement. This is obviously a very contrived case,
> but shows the motivation for this patch.

Any improvements for non-contrived cases? :)

> +++ b/include/linux/fs.h
> @@ -835,6 +835,9 @@ struct file {
>  	/* Used by fs/eventpoll.c to link all the hooks to this file */
>  	struct list_head	f_ep_links;
>  	struct list_head	f_tfile_llink;
> +	/* connected component */
> +	struct list_head	f_ep_cc_link;
> +	struct ep_cc __rcu	*f_ep_cc;
>  #endif /* #ifdef CONFIG_EPOLL */

This size increase worries me.  Perhaps this can be a separately
allocated struct to avoid penalizing non-epoll users?

	struct file_eventpoll {
		struct list_head	f_ep_links;
		struct list_head	f_tfile_llink;
		/* connected component */
		struct list_head	f_ep_cc_link;
		struct ep_cc __rcu	*f_ep_cc;
	};

But I wish Linux never allowed nesting epoll in the first place :/
