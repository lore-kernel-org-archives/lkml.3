Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaIKRx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:53:26 -0400
Received: from mout.gmx.net ([212.227.17.21]:63932 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaIKRxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:53:25 -0400
Message-ID: <5411E149.5090305@gmx.de>
Date: Thu, 11 Sep 2014 19:52:09 +0200
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: john@johnmccutchan.com, rlove@rlove.org, eparis@parisplace.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fsnotify: don't put user context if it was never assigned
References: <1406640314-25201-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1406640314-25201-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:VdOqsTesVaClWkkpwk6FLHEjaHH+lK0Qagw0EwcUS4MoKf/zLFR
 pmybPdWDp7PZfKIM6WzLkBWQyAZj62tC/kWjpqO7zJ46sbk5KwguLKOdGPtGxWifBFzpaO1
 KRtMNaDuokEICVU5a8S3DxQjOAWHj2Wa239HdSpspM8O3AO2A/v4Bcogn+EQEPXIEBhit23
 InR6HMRESf/I45zsKL3qQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sasha,

I have CCed Jan, because he has been the only one working on this file 
in the last 18 months.

A failure path in which group->inotify_data.user is not yet assigned 
starts here:

static struct fsnotify_group *inotify_new_group(unsigned int max_events)
{
...
	oevent = kmalloc(sizeof(struct inotify_event_info), GFP_KERNEL);
	if (unlikely(!oevent)) {
		fsnotify_destroy_group(group);
		return ERR_PTR(-ENOMEM);
	}

So your check
   if (group->inotify_data.user)
is reasonable.

3.17.0-rc3 compiles with the patch applied.

Reviewed-by: Heinrich Schuchardt <xypron.glpk@gmx.de>

@Andrew
Please, add the patch to the mm-tree.

Best regards

Heinrich Schuchardt

On 29.07.2014 15:25, Sasha Levin wrote:
> On some failure paths we may attempt to free user context even
> if it wasn't assigned yet. This will cause a NULL ptr deref
> and a kernel BUG.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>   fs/notify/inotify/inotify_fsnotify.c |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
> index 43ab1e1..9c8187e 100644
> --- a/fs/notify/inotify/inotify_fsnotify.c
> +++ b/fs/notify/inotify/inotify_fsnotify.c
> @@ -165,8 +165,10 @@ static void inotify_free_group_priv(struct fsnotify_group *group)
>   	/* ideally the idr is empty and we won't hit the BUG in the callback */
>   	idr_for_each(&group->inotify_data.idr, idr_callback, group);
>   	idr_destroy(&group->inotify_data.idr);
> -	atomic_dec(&group->inotify_data.user->inotify_devs);
> -	free_uid(group->inotify_data.user);
> +	if (group->inotify_data.user) {
> +		atomic_dec(&group->inotify_data.user->inotify_devs);
> +		free_uid(group->inotify_data.user);
> +	}
>   }
>
>   static void inotify_free_event(struct fsnotify_event *fsn_event)
>

