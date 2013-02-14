Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab3BNKWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:22:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62409 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab3BNKWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:22:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-mm-sig@lists.linaro.org
Subject: Re: [Linaro-mm-sig] [PATCH 2/3] mutex: add support for reservation style locks
Date: Thu, 14 Feb 2013 10:22:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        a.p.zijlstra@chello.nl, x86@kernel.org,
        dri-devel@lists.freedesktop.org, robclark@gmail.com,
        tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
References: <20130207151831.2868.5146.stgit@patser.local> <20130207151838.2868.69610.stgit@patser.local>
In-Reply-To: <20130207151838.2868.69610.stgit@patser.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302141022.00297.arnd@arndb.de>
X-Provags-ID: V02:K0:TjSB4ZEbkV+jzuLBP5/D+l4JCGjyUdKOBkc975END/K
 no7UMtAn7G6ueDIaWyjnZkIzNYoFPpdAbwH5XMNGMa1koWOsbU
 FswT8AWXubFQvi2u5koq45eyy2v50LcCLAPL2Z/dYBxIrEoNrz
 6wf/d5hb1aotP0jEDS4gSBweoQVivSm+M9OGVsCSu8feTR+rkU
 Ht6nIxRunLP4gLa7KBLcxKlV810+Qkw0zm47yhf17q5sD9lxN2
 qo+UpvdAD6GN5FxPIOG5fyio+fT2wO8m/HOTuCOKpxNgDK82ei
 O0m0QgnfLr4QqpaoKuJjLy2xgjutDBQYwY+Xz1euxKT3tuWYSK
 ioppdbkxKmzFMHFVubtE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Maarten Lankhorst wrote:

Hi Maarten,

I cannot help a lot on this patch set, but there are a few things that
I noticed when reading it.

> Functions:
> ----------
> 
> mutex_reserve_lock, and mutex_reserve_lock_interruptible:
>   Lock a buffer with a reservation_id set. reservation_id must not be
>   set to 0, since this is a special value that means no reservation_id.

I think the entire description should go into a file in the Documentation
directory, to make it easier to find without looking up the git history.

For the purpose of documenting this, it feels a little strange to
talk about "buffers" here. Obviously this is what you are using the
locks for, but it sounds like that is not the only possible use
case.

>   These functions will return -EDEADLK instead of -EAGAIN if
>   reservation_id is the same as the reservation_id that's attempted to
>   lock the mutex with, since in that case you presumably attempted to
>   lock the same lock twice.

Since the user always has to check the return value, would it be
possible to provide only the interruptible kind of this function
but not the non-interruptible one? In general, interruptible locks
are obviously harder to use, but they are much user friendlier when
something goes wrong.

> mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow:
>   Similar to mutex_reserve_lock, except it won't backoff with -EAGAIN.
>   This is useful when mutex_reserve_lock failed with -EAGAIN, and you
>   unreserved all buffers so no deadlock can occur.

Are these meant to be used a lot? If not, maybe prefix them with __mutex_
instead of mutex_.

> diff --git a/include/linux/mutex.h b/include/linux/mutex.h
> index 9121595..602c247 100644
> --- a/include/linux/mutex.h
> +++ b/include/linux/mutex.h
> @@ -62,6 +62,11 @@ struct mutex {
>  #endif
>  };
>  
> +struct ticket_mutex {
> +	struct mutex base;
> +	atomic_long_t reservation_id;
> +};

Have you considered changing the meaning of the "count" member
of the mutex in the case where a ticket mutex is used? That would
let you use an unmodified structure.

	Arnd
