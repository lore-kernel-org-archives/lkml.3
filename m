Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab3DWQUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:20:35 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:47619 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab3DWQUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:20:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAG6tG3xc3RHD7sZXaEbg1vLRhFj+6d1wY=us4BfxBfi5y0o4zg@mail.gmail.com>
References: <CAJsYZ5kk=J_Sc7w5dbMbkWWv8dXEU0ojKjEKNqH=Q6Tf2f7mQg@mail.gmail.com>
	<20130422142218.GA26760@mwanda>
	<CAG6tG3xc3RHD7sZXaEbg1vLRhFj+6d1wY=us4BfxBfi5y0o4zg@mail.gmail.com>
Date: Tue, 23 Apr 2013 21:50:34 +0530
Message-ID: <CAJsYZ5nQg9g73r5yLicq6gAGbKEXVAFqtF2av=heeNtrNSPSWg@mail.gmail.com>
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

>ashmem originally did not support read or write operations, just mmap,
>which is all 99% of users want. The original concurrency model with
>per-mapping ashmem_mutex's works fine there.

The situation I'm reporting here does not involve read/write. This is
to do with ashmem_mmap and ashmem_shrink.
The following is the control flow that could lead to dead lock
 ashmem_mmap
      |
      ----> ashmem_mutex acquired
      |
      -----> shmem_file_setup
                |
                ------> several calls that leads to __alloc_pages
                |     Now assuming that low memory condition is hit,
we could enter into reclaim path
                ..... ---------> shrink_slab (calls all the shrinker functions)
                   |
                    -----> ashmem_shrink --- Tries to acquire the same
ashmem_mutex that is taken
                              in this same path while in ashmem_mmap
leading to dead lock.

I'm unable to think of a straight forward way to fix this. If you have
any suggestions please provide the same.
If we are unable to solve this too with minor mods, as suggested by
Dan we have to re-look at the locking in this driver.

Warm Regards,
Shankar


On Mon, Apr 22, 2013 at 8:13 PM, Robert Love <rlove@google.com> wrote:
> On Mon, Apr 22, 2013 at 10:22 AM, Dan Carpenter
> <dan.carpenter@oracle.com> wrote:
>> Read Al's email again:  https://lkml.org/lkml/2013/3/20/458
>>
>> I don't know much about VFS locking, but the ashmem locking seems
>> pretty bogus to me.  Why can't multiple threads read() at the same
>> time?
>
> ashmem originally did not support read or write operations, just mmap,
> which is all 99% of users want. The original concurrency model with
> per-mapping ashmem_mutex's works fine there. It is only with the later
> addition of read and write that locking becomes a cluster. If there
> isn't an obvious way to refactor the locking, I'd suggest removing
> read and write.
>
>        Robert
