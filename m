Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab3KMIGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:06:30 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:47221 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab3KMIGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:06:19 -0500
MIME-Version: 1.0
In-Reply-To: <44678154.uI915mOzGH@vostro.rjw.lan>
References: <1384289548-26015-1-git-send-email-amit.pundir@linaro.org> <44678154.uI915mOzGH@vostro.rjw.lan>
From: Amit Pundir <amit.pundir@linaro.org>
Date: Wed, 13 Nov 2013 13:35:38 +0530
Message-ID: <CAMi1Hd06=-DrdoM7nFkOo5VFB2h7oYMc_7Y2ujop6d_vtWLgpw@mail.gmail.com>
Subject: Re: [RFC][PATCH v2] epoll: allow EPOLLWAKEUP flag if PM_SLEEP is enabled
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 November 2013 05:29, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, November 13, 2013 02:22:28 AM Amit Pundir wrote:
>> ep_create_wakeup_source() reports ENOMEM
>
> That needs to be fixed too.  I suppose we can make the wakeup_source_register()
> stub for CONFIG_PM_SLEEP unset return ERR_PTR(-ENOSYS) or something like that
> and ep_create_wakeup_source() return that instead of -ENOMEM.  It looks like
> eventpoll.c is the only user of it built for CONFIG_PM_SLEEP unset, but that
> needs to be double checked.

Instead of modifying wakeup_source_register() stub, what if I make
ep_create_wakeup_source() static inline as well and use its stub to
return -ENOSYS when CONFIG_PM_SLEEP is not set?
ep_create_wakeup_source() is used only in fs/eventpoll.c anyway.

>
>> if wakeup_source_register()
>> returns NULL. ep_create_wakeup_source() assumes that NULL is only
>> returned if we run into ENOMEM but NULL is also returned when
>> CONFIG_PM_SLEEP is disabled.
>>
>> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
>> ---
>> Changed in v2:
>> Using static inline functions instead of #ifdefs
>> ---
>>  fs/eventpoll.c                 |    3 +--
>>  include/uapi/linux/eventpoll.h |   12 ++++++++++++
>>  2 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
>> index 473e09d..10f9c43 100644
>> --- a/fs/eventpoll.c
>> +++ b/fs/eventpoll.c
>> @@ -1820,8 +1820,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>>               goto error_tgt_fput;
>>
>>       /* Check if EPOLLWAKEUP is allowed */
>> -     if ((epds.events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
>> -             epds.events &= ~EPOLLWAKEUP;
>> +     ep_epollwakeup_check(&epds.events);
>
> The "check" part of the name kind of suggests that the function will not change
> things.  What about ep_adjust_epollwakeup() or something along these lines?

I see couple of ep_set_* functions in eventpoll.c. Does it make sense
to have something like ep_set_epollwakeup()?

>
> And why don't you pass a pointer to epds to it?  Wouldn't it be cleaner this way?

Ok.

Regards,
Amit Pundir

>
>>
>>       /*
>>        * We have to check that the file structure underneath the file descriptor
>> diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
>> index 2c267bc..1d139c2 100644
>> --- a/include/uapi/linux/eventpoll.h
>> +++ b/include/uapi/linux/eventpoll.h
>> @@ -62,4 +62,16 @@ struct epoll_event {
>>  } EPOLL_PACKED;
>>
>>
>> +#ifdef CONFIG_PM_SLEEP
>> +static inline void ep_epollwakeup_check(__u32 *epev)
>> +{
>> +     if ((*epev & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
>> +             *epev &= ~EPOLLWAKEUP;
>> +}
>> +#else
>> +static inline void ep_epollwakeup_check(__u32 *epev)
>> +{
>> +     *epev &= ~EPOLLWAKEUP;
>> +}
>> +#endif
>>  #endif /* _UAPI_LINUX_EVENTPOLL_H */
>
> Thanks!
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
