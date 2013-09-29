Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab3I2HWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 03:22:50 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:42110 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3I2HWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 03:22:47 -0400
MIME-Version: 1.0
In-Reply-To: <6939844.AIXnPB8Wdj@vostro.rjw.lan>
References: <CAF1_xX2=BYkEn3ycM4smREqk-ioGbvu8Ea4or22U-jBdKmDKGA@mail.gmail.com>
	<CAF1_xX0suiHSgqWRBrA66qc1A_32Xq08hOikM2VSwQOEgRH-RA@mail.gmail.com>
	<6939844.AIXnPB8Wdj@vostro.rjw.lan>
Date: Sun, 29 Sep 2013 09:22:45 +0200
Message-ID: <CAF1_xX0zQriGMKvH8aLs4GhmCnLGSd7C2ESTvsOQvB7q22Mk8Q@mail.gmail.com>
Subject: Re: Fwd: [v3.12-rc1] [regression] PM / hibernate: Create memory
 bitmaps after freezing user space
From: Ronald <ronald645@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached patch fixes the issue. Both methods function as they did
before. Thanks for the superfast fix!

2013/9/29 Rafael J. Wysocki <rjw@rjwysocki.net>:
> On Saturday, September 28, 2013 08:18:18 PM Ronald wrote:
>> [ resend, forgot to disable HTML (sorry!) ]
>>
>> Dear kernel developers,
>>
>> Commit 8fd37a4c9 (PM / hibernate: Create memory bitmaps after freezing
>> user space) causes resume to fail.
>>
>> Only, when using the s2disk utility (through pm-hibernate).
>>
>> Not when I do:
>>
>> echo -n "disk" > /sys/power/state
>>
>> Reverting the commit did not work.
>>
>> I am using a encrypted LUKS partition with a temporary key that is
>> functioning as the swap device used for the suspend image.
>>
>> Awaiting further orders....
>
> I'm traveling now, so I can't really test things, but I think I know what the
> problem is.
>
> Can you please check if the appended patch makes any difference for you?
>
> Rafael
>
>
> ---
>  kernel/power/snapshot.c |    5 ++++-
>  kernel/power/user.c     |    5 +++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> Index: linux-pm/kernel/power/snapshot.c
> ===================================================================
> --- linux-pm.orig/kernel/power/snapshot.c
> +++ linux-pm/kernel/power/snapshot.c
> @@ -743,7 +743,10 @@ int create_basic_memory_bitmaps(void)
>         struct memory_bitmap *bm1, *bm2;
>         int error = 0;
>
> -       BUG_ON(forbidden_pages_map || free_pages_map);
> +       if (forbidden_pages_map && free_pages_map)
> +               return 0;
> +       else
> +               BUG_ON(forbidden_pages_map || free_pages_map);
>
>         bm1 = kzalloc(sizeof(struct memory_bitmap), GFP_KERNEL);
>         if (!bm1)
> Index: linux-pm/kernel/power/user.c
> ===================================================================
> --- linux-pm.orig/kernel/power/user.c
> +++ linux-pm/kernel/power/user.c
> @@ -82,6 +82,9 @@ static int snapshot_open(struct inode *i
>                 data->swap = -1;
>                 data->mode = O_WRONLY;
>                 error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
> +               if (!error)
> +                       error = create_basic_memory_bitmaps();
> +
>                 if (error)
>                         pm_notifier_call_chain(PM_POST_RESTORE);
>         }
>
