Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3HMEL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 00:11:29 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:53328 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3HMEL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 00:11:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130812172649.GB7198@localhost>
References: <1376251908-7451-1-git-send-email-nilanjan.roychowdhury@gmail.com>
	<20130812172649.GB7198@localhost>
Date: Tue, 13 Aug 2013 09:41:28 +0530
Message-ID: <CAGq6Fke=DYbK=KO6RdTD2at9NPMKcmxzOQ2TL6fBfM2UgSOfRQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mtd: mtdoops: fix for a potential memory leak in mtdoops_notify_remove
From: Nilanjan Roychowdhury <nilanjan.roychowdhury@gmail.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 10:56 PM, Ezequiel Garcia
<ezequiel.garcia@free-electrons.com> wrote:
>
> On Sun, Aug 11, 2013 at 01:11:48PM -0700, Nilanjan Roychowdhury wrote:
> > we are allocating cxt->oops_page_used using vmalloc in mtdoops_notify_add for
> > every mtd_info addition but not freeing it in mtdoops_notify_remove
> >
> > Signed-off-by: Nilanjan Roychowdhury <nilanjan.roychowdhury@gmail.com>
> > ---
> >  drivers/mtd/mtdoops.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
> > index 97bb8f6..02f49aa 100644
> > --- a/drivers/mtd/mtdoops.c
> > +++ b/drivers/mtd/mtdoops.c
> > @@ -386,6 +386,7 @@ static void mtdoops_notify_remove(struct mtd_info *mtd)
> >       cxt->mtd = NULL;
> >       flush_work(&cxt->work_erase);
> >       flush_work(&cxt->work_write);
> > +     vfree(cxt->oops_page_used);
> >  }
> >
> > --
> > 1.7.9.5
> >
>
> Have you tested this patch doing an unregister/module remove cycle?
>
> I'm not entirely sure, but I *think* you must also remove the
> vfree(cxt->oops_page_used); at mtdoops_exit(). Otherwise,
> you might call vfree() twice, the second time on a garbage pointer.
>
> The reason for this is that the unregister_mtd_user(&mtdoops_notifier);
> call in mtdoops_exit() will call the .remove callback (causing the first
> vfree() with this patch) and then call vfree() for the second time, explicitly.
> --
> Ezequiel García, Free Electrons
> Embedded Linux, Kernel and Android Engineering
> http://free-electrons.com
i did not do a module remove. I agree with your observation. I will
resubmit the patch.
