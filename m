Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab3BDHG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 02:06:57 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:38780 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3BDHG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 02:06:56 -0500
MIME-Version: 1.0
In-Reply-To: <1358253244-11453-7-git-send-email-maarten.lankhorst@canonical.com>
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
	<1358253244-11453-7-git-send-email-maarten.lankhorst@canonical.com>
Date: Mon, 4 Feb 2013 16:06:55 +0900
X-Google-Sender-Auth: 4whWWm9Znl6M1pUxx-AiHukFFBs
Message-ID: <CAAQKjZPJX9Rt0LH0PMpwRSv3etNvoGh3MvNcmFpvCXTtJeeFqw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 6/7] reservation: cross-device reservation support
From: Inki Dae <inki.dae@samsung.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/**
> + * ticket_commit - commit a reservation with a new fence
> + * @ticket:    [in]    the reservation_ticket returned by
> + * ticket_reserve
> + * @entries:   [in]    a linked list of struct reservation_entry
> + * @fence:     [in]    the fence that indicates completion
> + *
> + * This function will call reservation_ticket_fini, no need
> + * to do it manually.
> + *
> + * This function should be called after a hardware command submission is
> + * completed succesfully. The fence is used to indicate completion of
> + * those commands.
> + */
> +void
> +ticket_commit(struct reservation_ticket *ticket,
> +                 struct list_head *entries, struct fence *fence)
> +{
> +       struct list_head *cur;
> +
> +       if (list_empty(entries))
> +               return;
> +
> +       if (WARN_ON(!fence)) {
> +               ticket_backoff(ticket, entries);
> +               return;
> +       }
> +
> +       list_for_each(cur, entries) {
> +               struct reservation_object *bo;
> +               bool shared;
> +
> +               reservation_entry_get(cur, &bo, &shared);
> +
> +               if (!shared) {
> +                       int i;
> +                       for (i = 0; i < bo->fence_shared_count; ++i) {
> +                               fence_put(bo->fence_shared[i]);
> +                               bo->fence_shared[i] = NULL;
> +                       }
> +                       bo->fence_shared_count = 0;
> +                       if (bo->fence_excl)
> +                               fence_put(bo->fence_excl);
> +
> +                       bo->fence_excl = fence;
> +               } else {
> +                       if (WARN_ON(bo->fence_shared_count >=
> +                                   ARRAY_SIZE(bo->fence_shared))) {
> +                               mutex_unreserve_unlock(&bo->lock);
> +                               continue;
> +                       }
> +
> +                       bo->fence_shared[bo->fence_shared_count++] = fence;
> +               }

Hi,

I got some questions to fence_excl and fence_shared. At the above
code, if bo->fence_excl is not NULL then it puts bo->fence_excl and
sets a new fence to it. This seems like that someone that committed a
new fence, wants to access the given dmabuf exclusively even if
someone is accessing the given dmabuf.

On the other hand, in case of fence_shared, someone wants to access
that dmabuf non-exclusively. So this case seems like that the given
dmabuf could be accessed by two more devices. So I guess that the
fence_excl could be used for write access(may need buffer sync like
blocking) and read access for the fence_shared(may not need buffer
sync). I'm not sure that I understand these two things correctly so
could you please give me more comments for them?

Thanks,
Inki Dae

> +               fence_get(fence);
> +
> +               mutex_unreserve_unlock(&bo->lock);
> +       }
> +       reservation_ticket_fini(ticket);
> +}
> +EXPORT_SYMBOL(ticket_commit);
