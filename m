Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968Ab3CIEJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 23:09:42 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52950 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760321Ab3CIEJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 23:09:41 -0500
MIME-Version: 1.0
In-Reply-To: <20130308204944.GA27379@dcvr.yhbt.net>
References: <20130307112639.GA25130@dcvr.yhbt.net>
	<20130308013027.GA31830@dcvr.yhbt.net>
	<CAMP5Xgdsam2DGLshL5Uu5Q4La_nAq=u1YRNBwAxDstgCvJiqfw@mail.gmail.com>
	<20130308204944.GA27379@dcvr.yhbt.net>
Date: Fri, 8 Mar 2013 20:09:40 -0800
Message-ID: <CAMP5Xgc4-oX=-V57Mu5PARCWdfpkjck0VnZNAXH-JisvKi5tAg@mail.gmail.com>
Subject: Re: epoll: possible bug from wakeup_source activation
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: NeilBrown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 12:49 PM, Eric Wong <normalperson@yhbt.net> wrote:
> Arve Hjønnevåg <arve@android.com> wrote:
>> On Thu, Mar 7, 2013 at 5:30 PM, Eric Wong <normalperson@yhbt.net> wrote:
>> > Eric Wong <normalperson@yhbt.net> wrote:
>> >> Hi Arve, looking at commit 4d7e30d98939a0340022ccd49325a3d70f7e0238
>> >> (epoll: Add a flag, EPOLLWAKEUP, to prevent suspend ...)
>> >>
>> >> I think the reason for using ep->ws instead of epi->ws in the unlikely
>> >> ovflist case applies to the likely rdllist case, too.  Since epi->ws is
>> >> only protected by ep->mtx, it can also be deactivated while inside
>> >> ep_poll_callback.
>> >>
>> >> So something like the following patch might be necessary
>> >> (shown here with extra context):
>> >>
>> >> --- a/fs/eventpoll.c
>> >> +++ b/fs/eventpoll.c
>> >> @@ -968,39 +968,45 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
>> >>       if (unlikely(ep->ovflist != EP_UNACTIVE_PTR)) {
>> >>               if (epi->next == EP_UNACTIVE_PTR) {
>> >>                       epi->next = ep->ovflist;
>> >>                       ep->ovflist = epi;
>> >>                       if (epi->ws) {
>> >>                               /*
>> >>                                * Activate ep->ws since epi->ws may get
>> >>                                * deactivated at any time.
>> >>                                */
>> >>                               __pm_stay_awake(ep->ws);
>> >>                       }
>> >>
>> >>               }
>> >
>> > Thinking about this more, it looks like the original ep->ovflist case of
>> > using ep->ws is unnecessary.
>> >
>> > ep->ovflist != EP_UNACTIVE_PTR can only happen while ep->mtx is held (in
>> > ep_scan_ready_list); which means ep_modify+friends cannot remove epi->ws.
>> >
>>
>> The callback function in ep_scan_ready_list can call __pm_relax on it though.
>>
>> > ep_poll_callback holding ep->lock means ep_poll_callback prevents
>> > ep_scan_ready_list from setting ep->ovflist = EP_UNACTIVE_PTR and
>> > releasing ep->mtx.
>>
>> This code is reached when ep_scan_ready_list has set ep->ovflist to
>> NULL before releasing ep->lock. Since the callback function can call
>> __pm_relax on epi->ws without holding ep->lock we call __pm_stay_awake
>> in ep->ws here (the callback does not call __pm_relax on that).
>
> Thanks for the explanation.  I got "deactivate" and "destroy"
> mixed up.  However, I'm still concerned about the "destroy" case:
>
>> >
>> >>               goto out_unlock;
>> >>       }
>> >>
>> >>       /* If this file is already in the ready list we exit soon */
>> >>       if (!ep_is_linked(&epi->rdllink)) {
>> >>               list_add_tail(&epi->rdllink, &ep->rdllist);
>> >> -             __pm_stay_awake(epi->ws);
>> >> +             if (epi->ws) {
>> >> +                     /*
>> >> +                      * Activate ep->ws since epi->ws may get
>> >> +                      * deactivated at any time.
>> >> +                      */
>> >> +                     __pm_stay_awake(ep->ws);
>> >> +             }
>> >>       }
>> >
>> > I still think ep->ws needs to be used in the common ep->rdllist case.
>>
>> ep_scan_ready_list calls __pm_relax on ep->ws when it is done, so this
>> will not work. ep->ws is not a "ep->rdllist not empty wakeup_source is
>> is a "ep_scan_ready_list is running" wakeup_source.
>
> What happens if ep_modify calls ep_destroy_wakeup_source
> while __pm_stay_awake is running on the same epi->ws?

Yes, that looks like a problem. I think calling
ep_destroy_wakeup_source with ep->lock held should fix that. It is not
clear how useful changing EPOLLWAKEUP in ep_modify is, so
alternatively we could remove that feature and instead only allow it
to be set in ep_insert.

-- 
Arve Hjønnevåg
