Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761682Ab3DBS4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:56:45 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:33165 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3DBS4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:56:43 -0400
Message-ID: <1364928998.3399.34.camel@host5.opentask.org>
Subject: Re: [PATCH v2] wait while adding MMC host to ensure root mounts
From: Sergey Yanovich <ynvich@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Date: Tue, 02 Apr 2013 22:56:38 +0400
In-Reply-To: <CAPDyKFpOf7G_f=J=6sDdH1NQXow5uq1+rkACGGSvpEQ-LWsm4g@mail.gmail.com>
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com>
	 <1363224194-7366-1-git-send-email-ynvich@gmail.com>
	 <87620jmkoe.fsf@octavius.laptop.org>
	 <CAPDyKFp27MUOjhydLXf92vN3cua=XcX4oTJnMGfOJPpBhtwM8Q@mail.gmail.com>
	 <CAL0eWdGjPKUUcm6mStAHgHKHLABmPw7nMwDhR8D5rbvg+DPzfQ@mail.gmail.com>
	 <CAPDyKFroki00+SCLjUXYN_=+qcVZwZ2H4NJacH+d8p3dFXoLPg@mail.gmail.com>
	 <1364898904.2556.26.camel@host5.opentask.org>
	 <CAPDyKFpOf7G_f=J=6sDdH1NQXow5uq1+rkACGGSvpEQ-LWsm4g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 19:45 +0200, Ulf Hansson wrote:
> On 2 April 2013 12:35, Sergey Yanovich <ynvich@gmail.com> wrote:
> > If the system is booted using initrd and root is not on an mmc card,
> > then mmc modules can be omitted from initrd. The probing will happen
> > only after root is mounted.
> 
> This will not solve the problem when having one device intended for
> rootfs and some other for something else. Of course, as long as the
> devices uses the same mmc module. Once inserted, all devices will be
> probed.

I agree that is this special case there will be boot time regression.
However, this case is not guaranteed to boot without the patch or some
workaround.

> > If root is on an mmc, kernel needs to wait for the mmc probe.
> >
> 
> True, although your patch is preventing the parallelism and instead
> doing things in synchronized manner.

mount_root() assumes it has waited for "known devices to complete their
probing" [init/do_mounts.c:545]. The patch has brought mmc into
compliance with the assumption.

If several devices can be probed in parallel, the bus should do it, but
not the driver.

> I think we must discuss alternative solutions instead.
> 
> Like an "mmc detect flush" mechanism or a "new card device notification" event.

There are 2 events to trigger root mount:
1. all known devices complete their probing
2. 1 is true and root_wait is specified and root device is found

So I see the only fast alternative to my patch: if root is on an mmc
card, set root_wait to 'true'.

