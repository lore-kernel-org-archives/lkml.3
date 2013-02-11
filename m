Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab3BKLb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:31:57 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:44705 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab3BKLbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:31:55 -0500
MIME-Version: 1.0
In-Reply-To: <51187376.2060106@nvidia.com>
References: <1360406062-14982-1-git-send-email-grant.likely@secretlab.ca> <51187376.2060106@nvidia.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 11 Feb 2013 11:31:34 +0000
X-Google-Sender-Auth: uZgwUyAIyJVOXWsf8YnsI9wpGYM
Message-ID: <CACxGe6sEmcyRveM9630qyGQm21ZUhSMKTThDnO+MMu=ejfdP2w@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Fix locking on gpio debugfs files
To: Alex Courbot <acourbot@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 4:28 AM, Alex Courbot <acourbot@nvidia.com> wrote:
> On 02/09/2013 07:34 PM, Grant Likely wrote:
>>
>> The debugfs files really need to hold the gpiolib spinlock before
>> accessing the list. Otherwise chip addition/removal will cause an oops.
>>
>> Cc: Alexandre Courbot <acourbot@nvidia.com>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>
>
> Tested-by: Alexandre Courbot <acourbot@nvidia.com>
>
> Just wondering: if we manage to change this spinlock into a mutex in the
> future, wouldn't it be better to acquire it only once in gpiolib_seq_start()
> and release it in gpiolib_seq_stop()?
>
> Even though the protection introduced by this patch definitely improves the
> situation, it seems to me that chips could still be removed while being
> displayed by gpiolib_seq_show().

Probably, but need to first verify that the mutex won't end up getting
held between read() syscalls. Otherwise it would be possible to block
addition/removal by holding the file open. I cursory read of seq_file
looks like ->stop() is always called, but I would appreciate someone
more cluefull to give an opinion here.

I've also got a draft patch that turns gpio chips into first-class
kobjects which means we can do proper reference counting on them and
prevent the structure from actually disappearing while other drivers
still hold references.

g.
