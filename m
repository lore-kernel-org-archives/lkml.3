Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3JGItZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 04:49:25 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50887 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754093Ab3JGItY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 04:49:24 -0400
Date: Mon, 7 Oct 2013 09:48:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Alex Dubov <oakad@yahoo.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] memstick: Fix memory leak in memstick_check() error
 path
Message-ID: <20131007084848.GA32012@arm.com>
References: <1380834798-5829-1-git-send-email-Larry.Finger@lwfinger.net>
 <CAHkRjk4MUOcXE6QngJYDcD1-1GMERxTusNcHr0FciU=wfFxbYA@mail.gmail.com>
 <5251FA23.1080504@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5251FA23.1080504@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 01:02:43AM +0100, Larry Finger wrote:
> On 10/04/2013 03:54 AM, Catalin Marinas wrote:
> > On 3 October 2013 22:13, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> >> diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
> >> index ffcb10a..0c73a45 100644
> >> --- a/drivers/memstick/core/memstick.c
> >> +++ b/drivers/memstick/core/memstick.c
> >> @@ -415,6 +415,7 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
> >>          return card;
> >>   err_out:
> >>          host->card = old_card;
> >> +       kfree(card->dev.kobj.name);
> >
> > It looks weird to go into dev.kobj internals here for freeing the
> > name. There is also memstick_free_card() which doesn't seem to do
> > anything about the name freeing.
> >
> > Should memstick_alloc_card() do a device_initialise(&card->dev) and in
> > memstick_free_card() (or the error path) do a put_device(&card->dev)?
> > This should take care of kobj.name as well via kobject_put().
> 
> I tried several code changes that included adding a device_initialize() call, 
> but all of them oopsed even when I followed the examples in other drivers. 
> Adding a put_device() without the device_initialize() did not oops, but it still 
> leaked the name.
> 
> We could avoid going into the dev.kobj internals if a device_free_name() routine 
> existed as a companion to dev_set_name().

device_free_name() wouldn't be a bad idea.

-- 
Catalin
