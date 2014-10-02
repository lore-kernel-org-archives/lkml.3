Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaJBS6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:58:37 -0400
Received: from mout.gmx.net ([212.227.17.22]:65463 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbaJBS6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:58:35 -0400
Message-ID: <542D9FE5.3010009@gmx.de>
Date: Thu, 02 Oct 2014 20:56:37 +0200
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: Eric Paris <eparis@redhat.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fanotify: prove that structure size is correct
References: <20140928233538.GA31345@www.outflux.net>
In-Reply-To: <20140928233538.GA31345@www.outflux.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:kR7UWz4W+k9wvG1rr/ONC7hdhnhkyGfVLOgwSuu5SWzJIN9oZV9
 NreCfFlFXPoE7qX6O16boZ95P60o3QV5R5IImCj5HKh24PIvqtPb6vJlCkF4f38hUvSzmL+
 vbVg6UK3dkQQ+76au839V6l6dor6i42t5yZ3OC5drm+b4+ZrsHlOxK6oNBz8tJ4QZpawvZe
 QoCXma/DhE4HZxqEeXkdw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 29.09.2014 01:35, Kees Cook wrote:
> When building with CONFIG_DEBUG_STRICT_USER_COPY_CHECKS, this copy_to_user
> wasn't provably correct (the length was in a variable but the structure
> wasn't). The compiler wasn't able to check that the length was being
> statically assigned, so include a BUG_ON to notice if this ever changes.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   fs/notify/fanotify/fanotify_user.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index b13992a41bd9..7bdb43222875 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -216,6 +216,7 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
>
>   	fd = fanotify_event_metadata.fd;
>   	ret = -EFAULT;
> +	BUG_ON(fanotify_event_metadata.event_len != FAN_EVENT_METADATA_LEN);


Thank you for indicating an inconsistency in fanotify_user.c

In fanotify_user.c a mismatch exists between the assumptions made in 
get_one_event() and copy_event_to_user().

According to the fanotify.7 man page:
"FAN_EVENT_METADATA_LEN - This is the minimum size (and currently the 
only size) of any event metadata."

get_one_event() assumes that the event metadata has a length of 
FAN_EVENT_METADATA_LEN and does not care about the value of event_len.

copy_event_to_user() assumes that event_len specifies the length of the 
event metadata and does not care about FAN_EVENT_METADATA_LEN.

Due to these different assumptions it cannot be proven inside 
fanotify_user.c that copy_to_user() is called correctly.

If we want such a prove inside fanotify_user.c, we should change 
get_one_event() to use the following:

// Get the event without removing it from the group.
fsnotify_event *evt = fsnotify_peek_notify_event(group);
// Check we have enough user memory to copy the event.
if (evt->event_len > count)
     return ERR_PTR(-EINVAL);
// Remove the event from the group.
fsnotify_remove_notify_event(group);
// Return the pointer we tested.
// fanotify_remove_notify_event() should return the same pointer.
return evt;

If after this change you still want a BUG_ON, pass count to 
copy_event_to_user() and write
BUG_ON(fanotify_event_metadata.event_len > count);

Best regards

Heinrich Schuchardt

>   	if (copy_to_user(buf, &fanotify_event_metadata,
>   			 fanotify_event_metadata.event_len))
>   		goto out_close_fd;
>

