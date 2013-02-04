Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3BDO5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:57:01 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38690 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3BDO5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:57:00 -0500
Date: Mon, 4 Feb 2013 15:51:11 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Inki Dae <inki.dae@samsung.com>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 6/7] reservation: cross-device
 reservation support
Message-ID: <20130204145111.GB5843@phenom.ffwll.local>
Mail-Followup-To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	Inki Dae <inki.dae@samsung.com>, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
 <1358253244-11453-7-git-send-email-maarten.lankhorst@canonical.com>
 <CAAQKjZPJX9Rt0LH0PMpwRSv3etNvoGh3MvNcmFpvCXTtJeeFqw@mail.gmail.com>
 <510F8602.9080806@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510F8602.9080806@canonical.com>
X-Operating-System: Linux phenom 3.8.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 10:57:22AM +0100, Maarten Lankhorst wrote:
> Op 04-02-13 08:06, Inki Dae schreef:
> >> +/**
> >> + * ticket_commit - commit a reservation with a new fence
> >> + * @ticket:    [in]    the reservation_ticket returned by
> >> + * ticket_reserve
> >> + * @entries:   [in]    a linked list of struct reservation_entry
> >> + * @fence:     [in]    the fence that indicates completion
> >> + *
> >> + * This function will call reservation_ticket_fini, no need
> >> + * to do it manually.
> >> + *
> >> + * This function should be called after a hardware command submission is
> >> + * completed succesfully. The fence is used to indicate completion of
> >> + * those commands.
> >> + */
> >> +void
> >> +ticket_commit(struct reservation_ticket *ticket,
> >> +                 struct list_head *entries, struct fence *fence)
> >> +{
> >> +       struct list_head *cur;
> >> +
> >> +       if (list_empty(entries))
> >> +               return;
> >> +
> >> +       if (WARN_ON(!fence)) {
> >> +               ticket_backoff(ticket, entries);
> >> +               return;
> >> +       }
> >> +
> >> +       list_for_each(cur, entries) {
> >> +               struct reservation_object *bo;
> >> +               bool shared;
> >> +
> >> +               reservation_entry_get(cur, &bo, &shared);
> >> +
> >> +               if (!shared) {
> >> +                       int i;
> >> +                       for (i = 0; i < bo->fence_shared_count; ++i) {
> >> +                               fence_put(bo->fence_shared[i]);
> >> +                               bo->fence_shared[i] = NULL;
> >> +                       }
> >> +                       bo->fence_shared_count = 0;
> >> +                       if (bo->fence_excl)
> >> +                               fence_put(bo->fence_excl);
> >> +
> >> +                       bo->fence_excl = fence;
> >> +               } else {
> >> +                       if (WARN_ON(bo->fence_shared_count >=
> >> +                                   ARRAY_SIZE(bo->fence_shared))) {
> >> +                               mutex_unreserve_unlock(&bo->lock);
> >> +                               continue;
> >> +                       }
> >> +
> >> +                       bo->fence_shared[bo->fence_shared_count++] = fence;
> >> +               }
> > Hi,
> >
> > I got some questions to fence_excl and fence_shared. At the above
> > code, if bo->fence_excl is not NULL then it puts bo->fence_excl and
> > sets a new fence to it. This seems like that someone that committed a
> > new fence, wants to access the given dmabuf exclusively even if
> > someone is accessing the given dmabuf.
> Yes, if there were shared fences, they had to issue a wait for the previous exclusive fence, so if you add
> (possibly hardware) wait ops on those shared fences to your command stream, it follows that you also
> waited for the previous exclusive fence implicitly.
> 
> If there is only an exclusive fence, you have to issue some explicit wait op  on it before you start the rest
> of the commands.
> > On the other hand, in case of fence_shared, someone wants to access
> > that dmabuf non-exclusively. So this case seems like that the given
> > dmabuf could be accessed by two more devices. So I guess that the
> > fence_excl could be used for write access(may need buffer sync like
> > blocking) and read access for the fence_shared(may not need buffer
> > sync). I'm not sure that I understand these two things correctly so
> > could you please give me more comments for them?
> Correct, if you create a shared fence, you still have to emit a wait op for the exclusive fence.

Just a quick note: We limit the number of non-exclusive fences to avoid
reallocating memory, which would be a bit a pain. Otoh if we support some
form of fence timeline concept, the fence core code could overwrite
redundant fences. Which would reasonable limit the total attached fence
count. Still we'd need to thread potential -ENOMEM failures through all
callers.

Do you see a use-case for more than just a few non-exclusive fences?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
