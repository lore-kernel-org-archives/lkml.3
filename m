Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab3DDK70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:59:26 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:45845 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab3DDK7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:59:24 -0400
Message-ID: <1365073152.9806.26.camel@host5.omatika.ru>
Subject: Re: [PATCH v2] wait while adding MMC host to ensure root mounts
From: Sergey Yanovich <ynvich@gmail.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Date: Thu, 04 Apr 2013 14:59:12 +0400
In-Reply-To: <515D1F4E.1080306@intel.com>
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com>
	  <1363224194-7366-1-git-send-email-ynvich@gmail.com>
	  <87620jmkoe.fsf@octavius.laptop.org>
	  <CAPDyKFp27MUOjhydLXf92vN3cua=XcX4oTJnMGfOJPpBhtwM8Q@mail.gmail.com>
	  <87ppylf429.fsf@octavius.laptop.org> <515ADEDE.3050707@intel.com>
	 <1364912689.3399.7.camel@host5.opentask.org> <515D1F4E.1080306@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 09:35 +0300, Adrian Hunter wrote:
> No,  I am booting from eMMC.

Well, in this case you should be aware, that your system is not
concurrency-safe without the patch. It may or may not boot each time
depending on the large number of factors.

> > Maybe introduce mmc_is_hosting_root() and do something like:
> > 
> > -	mmc_flush_scheduled_work();
> > +	if (mmc_is_hosting_root())
> > +		mmc_flush_scheduled_work();
> 
> No, I am booting from eMMC.  Perhaps a host capability:
> 
> 	if (host->caps2 & MMC_CAP2_ROOTWAIT)
> 		mmc_flush_scheduled_work();
> 

Neither my variant, nor yours will help to handle the increased boot
time.

The root cause is that probing several devices is done sequentially and
mmc was reporting end of its probing before it was actually happening.
My patch makes mmc report end of probing on-time. The correct way to fix
the additional delay, my patch introduces, is to rewrite the probing to
be parallel instead of sequential. I understand that it is much easier
just to revert the patch.

If the patch is reverted, something like this somewhere in
'init/do_mounts.c' could conditionally activate 'root_wait':

	if (mmc_is_hosting_root())
		root_wait = 1;

IMHO this is wrong and my patch is right, but better this than broken
mmc boot.

