Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbaIKUn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:43:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149AbaIKUn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:43:56 -0400
Date: Thu, 11 Sep 2014 13:43:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: john@johnmccutchan.com, rlove@rlove.org, eparis@parisplace.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsnotify: don't put user context if it was never
 assigned
Message-Id: <20140911134355.21bed9dbf5a0c7a8190c748f@linux-foundation.org>
In-Reply-To: <1406640314-25201-1-git-send-email-sasha.levin@oracle.com>
References: <1406640314-25201-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014 09:25:14 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> On some failure paths we may attempt to free user context even
> if it wasn't assigned yet. This will cause a NULL ptr deref
> and a kernel BUG.

Are you able to identify "some failure paths"?  I spent some time
grepping, but it's a pain.

Please try to include such info in changelogs because reviewers (ie,
me) might want to review those callers to decide whether the bug lies
elsewhere.

> --- a/fs/notify/inotify/inotify_fsnotify.c
> +++ b/fs/notify/inotify/inotify_fsnotify.c
> @@ -165,8 +165,10 @@ static void inotify_free_group_priv(struct fsnotify_group *group)
>  	/* ideally the idr is empty and we won't hit the BUG in the callback */
>  	idr_for_each(&group->inotify_data.idr, idr_callback, group);
>  	idr_destroy(&group->inotify_data.idr);
> -	atomic_dec(&group->inotify_data.user->inotify_devs);
> -	free_uid(group->inotify_data.user);
> +	if (group->inotify_data.user) {
> +		atomic_dec(&group->inotify_data.user->inotify_devs);
> +		free_uid(group->inotify_data.user);
> +	}
>  }
>  
>  static void inotify_free_event(struct fsnotify_event *fsn_event)

