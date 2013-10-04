Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3JDIyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 04:54:35 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47147 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3JDIyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 04:54:32 -0400
MIME-Version: 1.0
In-Reply-To: <1380834798-5829-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1380834798-5829-1-git-send-email-Larry.Finger@lwfinger.net>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 4 Oct 2013 09:54:11 +0100
X-Google-Sender-Auth: HF7hzmpJDLaew2JjjrnQrX3KD0w
Message-ID: <CAHkRjk4MUOcXE6QngJYDcD1-1GMERxTusNcHr0FciU=wfFxbYA@mail.gmail.com>
Subject: Re: [PATCH] memstick: Fix memory leak in memstick_check() error path
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Alex Dubov <oakad@yahoo.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 October 2013 22:13, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> With kernel 3.12-rc3, kemcheck reports the following leak:

That would be "kmemleak" rather than "kmemcheck" ;)

>> unreferenced object 0xffff8800ae85c190 (size 16):
>>   comm "kworker/u4:3", pid 685, jiffies 4294916336 (age 2831.760s)
>>   hex dump (first 16 bytes):
>>     6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00  memstick0.......
>>   backtrace:
>>     [<ffffffff8146a0d1>] kmemleak_alloc+0x21/0x50
>>     [<ffffffff81160720>] __kmalloc_track_caller+0x160/0x2f0
>>     [<ffffffff81237b9b>] kvasprintf+0x5b/0x90
>>     [<ffffffff8122c0c1>] kobject_set_name_vargs+0x21/0x60
>>     [<ffffffff812e7f5c>] dev_set_name+0x3c/0x40
>>     [<ffffffffa02bf918>] memstick_check+0xb8/0x340 [memstick]
>>     [<ffffffff81069862>] process_one_work+0x1d2/0x670
>>     [<ffffffff8106a88a>] worker_thread+0x11a/0x370
>>     [<ffffffff81072ea6>] kthread+0xd6/0xe0
>>     [<ffffffff81478bbc>] ret_from_fork+0x7c/0xb0
>
> This problem was introduced by commit 0252c3b "memstick: struct device -
> replace bus_id with dev_name(), dev_set_name() where the name is not freed
> in the error path.
>
> Thanks to Catalin Marinas for suggesting the fix.
>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Alex Dubov <oakad@yahoo.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  drivers/memstick/core/memstick.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
> index ffcb10a..0c73a45 100644
> --- a/drivers/memstick/core/memstick.c
> +++ b/drivers/memstick/core/memstick.c
> @@ -415,6 +415,7 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
>         return card;
>  err_out:
>         host->card = old_card;
> +       kfree(card->dev.kobj.name);

It looks weird to go into dev.kobj internals here for freeing the
name. There is also memstick_free_card() which doesn't seem to do
anything about the name freeing.

Should memstick_alloc_card() do a device_initialise(&card->dev) and in
memstick_free_card() (or the error path) do a put_device(&card->dev)?
This should take care of kobj.name as well via kobject_put().

Catalin
