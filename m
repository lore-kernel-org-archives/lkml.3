Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab3DYONM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:13:12 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:63059 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256Ab3DYONL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:13:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAJsYZ5mpukCM6TpFb27tJt6G7ZufugEP4kx8wzGxhRwAO46cCw@mail.gmail.com>
References: <CAJsYZ5kk=J_Sc7w5dbMbkWWv8dXEU0ojKjEKNqH=Q6Tf2f7mQg@mail.gmail.com>
	<20130422142218.GA26760@mwanda>
	<CAG6tG3xc3RHD7sZXaEbg1vLRhFj+6d1wY=us4BfxBfi5y0o4zg@mail.gmail.com>
	<CAJsYZ5nQg9g73r5yLicq6gAGbKEXVAFqtF2av=heeNtrNSPSWg@mail.gmail.com>
	<CAG6tG3zcOdkA5QOBhaDzmMvcFSCwbfRAyKuRwXdn6ipOJhTVZQ@mail.gmail.com>
	<CAJsYZ5mpukCM6TpFb27tJt6G7ZufugEP4kx8wzGxhRwAO46cCw@mail.gmail.com>
Date: Thu, 25 Apr 2013 19:43:10 +0530
Message-ID: <CAJsYZ5mZrZ7BsfSm-dMZPCBAdcYO=ijD2FcBPkDiijRwS2WU1g@mail.gmail.com>
Subject: Re: [BUG] staging: android: ashmem: Deadlock during ashmem_shrink
From: Shankar Brahadeeswaran <shankoo77@gmail.com>
To: Robert Love <rlove@google.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, devel@driverdev.osuosl.org,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anjana V Kumar <anjanavk12@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, my deadlock demonstration got messed up.

Process P1:
Creates ashmem region, Shares the fd to P2 via binder API, does an mmap
and from ashmem_mmap releases the ashmem_mutex before shm_file_setup
and sleeps within shmem_file_setup

Process P2:
Gets the fd, does an mmap on it. Since mutex is available and since asma->file
is still NULL, proceeds to call shm_file_setup again (releases the mutex before
doing so).

Now based on who returns last, one of them would overwrite the asma->file
with the others

The desired behavior is that one of them does shmem_file_setup and the other
process uses it.


On Thu, Apr 25, 2013 at 7:24 PM, Shankar Brahadeeswaran
<shankoo77@gmail.com> wrote:
> Hi Robert,
> Thanks for the feedback.
>
>> This doesn't look insurmountable. It isn't necessary AFAICT to hold
>> ashmem_mutex across shmem_file_setup.
>
> I thought it may not be a good idea to do so and hence thought its
> difficult to fix.
> Dropping the lock in-between mmap may not be any issue if the user land code
> follows a given sequence. But assuming that the following sequence of event
> happens, it would lead to other races.
>
> Process P1                                          Process P2
> --------------                                           --------------
> Creates ashmem region                       .....
>
> Shares the fd to P2 via binder             Gets the fd
>
> Does an mmap                                     Does an mmap
>
> Releases the mutex before                  Procees with ashmem_mmap
> since mutex is
> shmem_file_setup and sleeps             available, checks for a
> asma->file, still NUL
> within shmem_file_setup                      so this also calls
> shmem_file_setup.
>
> The expected behavior is, one of them does the shmem_file_setup, puts
> it in asma->file
> The other process would just do get_file. With the original code
> (without dropping the
> mutex in-between) this would have been the behavior.
> So IMHO dropping the lock in between could lead to other race conditions.
>
> Also, there are other places in the code where ashmem_mutex is held and memory
> allocation functions are called, ex:- range_alloc, calls kmem_cache_zalloc
>
> Since ashmem_shrink holds the ashmem_mutex, any where from ashmem driver
> if  a memory allocation function is called with the ashmem_mutex held
> &&
> if there is a low memory condition that leads to shrinkers being called
> we'll hit the deadlock.
>
> I'm trying to see if the ashmem_shrink should really hold the ashmem_mutex,
> but looks like its necessary.
>
> Warm Regards,
> Shankar
>
> On Tue, Apr 23, 2013 at 10:54 PM, Robert Love <rlove@google.com> wrote:
>> On Tue, Apr 23, 2013 at 12:20 PM, Shankar Brahadeeswaran
>> <shankoo77@gmail.com> wrote:
>>
>>> I'm unable to think of a straight forward way to fix this. If you have
>>> any suggestions please provide the same.
>>> If we are unable to solve this too with minor mods, as suggested by
>>> Dan we have to re-look at the locking in this driver.
>>
>> This doesn't look insurmountable. It isn't necessary AFAICT to hold
>> ashmem_mutex across shmem_file_setup.
>>
>> Patch attached (untested).
>>
>>            Robert
