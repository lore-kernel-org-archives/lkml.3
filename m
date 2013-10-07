Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3JGACr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 20:02:47 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:51327 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab3JGACq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 20:02:46 -0400
Message-ID: <5251FA23.1080504@lwfinger.net>
Date: Sun, 06 Oct 2013 19:02:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Alex Dubov <oakad@yahoo.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] memstick: Fix memory leak in memstick_check() error path
References: <1380834798-5829-1-git-send-email-Larry.Finger@lwfinger.net> <CAHkRjk4MUOcXE6QngJYDcD1-1GMERxTusNcHr0FciU=wfFxbYA@mail.gmail.com>
In-Reply-To: <CAHkRjk4MUOcXE6QngJYDcD1-1GMERxTusNcHr0FciU=wfFxbYA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 03:54 AM, Catalin Marinas wrote:
> On 3 October 2013 22:13, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
>> index ffcb10a..0c73a45 100644
>> --- a/drivers/memstick/core/memstick.c
>> +++ b/drivers/memstick/core/memstick.c
>> @@ -415,6 +415,7 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
>>          return card;
>>   err_out:
>>          host->card = old_card;
>> +       kfree(card->dev.kobj.name);
>
> It looks weird to go into dev.kobj internals here for freeing the
> name. There is also memstick_free_card() which doesn't seem to do
> anything about the name freeing.
>
> Should memstick_alloc_card() do a device_initialise(&card->dev) and in
> memstick_free_card() (or the error path) do a put_device(&card->dev)?
> This should take care of kobj.name as well via kobject_put().

I tried several code changes that included adding a device_initialize() call, 
but all of them oopsed even when I followed the examples in other drivers. 
Adding a put_device() without the device_initialize() did not oops, but it still 
leaked the name.

We could avoid going into the dev.kobj internals if a device_free_name() routine 
existed as a companion to dev_set_name().

Larry


