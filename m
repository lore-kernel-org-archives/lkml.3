Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaETWW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 18:22:29 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62363 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaETWW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 18:22:27 -0400
Date: Wed, 21 May 2014 00:22:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Joe Perches <joe@perches.com>
cc: Kurt Garloff <kurt@garloff.de>, Fabian Frederick <fabf@skynet.be>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Fwd: Re: [PATCH 1/1] drivers/scsi/tmscsim.c: replace shift loop
 by ilog2]
In-Reply-To: <1400605982.26709.15.camel@joe-AO725>
Message-ID: <Pine.LNX.4.64.1405210018540.8218@axis700.grange>
References: <1400605982.26709.15.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:6xcJu9DytfcscJyzXBoaNnMVb5fUBxiR8d2Vsq83CDp
 l9olXw4XVEugseqEg0QbNz/zSsT6LH6QHUqIEl4WmfzZwT8bDl
 oDnLsUQbULZUXTqlv85aJD9Ql0wOx/Uk0h1rvUWWitunUXbyqj
 vA1puQ52Cdh0tEWpUlYS4qfaIdHh4QAjIDPUiRkvJWQ7grTNuz
 ZNnYFJa//Ale0K4ySN8UTurWi3mq182w674LWHVlI75MSzozye
 6gLSpIuSRKq7Xb02qTbgkatc91xZ/mCxbcehiajeN/+OwlTpKN
 7zkVl9t9oHusYlWoRts4t7BSIti4DhjxUxGqTs+BtWeqfJ+U7S
 pPsRXifDR/1OTscD/ugAFPZe6Xh9rXr0M69eqHd5vnbPebEveH
 wGmmtEZFMoLPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, 20 May 2014, Joe Perches wrote:

> Hello Kurt.
> 
> If you're still interested in tmscim.
> 
> Your garloff@suse.de address bounces....
> 
> btw:  Your MAINTAINERS entry is out of date.
> 
> MAINTAINERS-DC390/AM53C974 SCSI driver
> MAINTAINERS:M:  Kurt Garloff <garloff@suse.de>
> MAINTAINERS:W:  http://www.garloff.de/kurt/linux/dc390/
> MAINTAINERS-M:  Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> MAINTAINERS-S:  Maintained
> MAINTAINERS-F:  drivers/scsi/tmscsim.*
> 
> -------- Forwarded Message --------
> From: Joe Perches <joe@perches.com>
> To: Fabian Frederick <fabf@skynet.be>
> Cc: linux-kernel <linux-kernel@vger.kernel.org>, Kurt Garloff
> <garloff@suse.de>, akpm <akpm@linux-foundation.org>
> Subject: Re: [PATCH 1/1] drivers/scsi/tmscsim.c: replace shift loop by
> ilog2
> 
> On Tue, 2014-05-20 at 18:48 +0200, Fabian Frederick wrote:
> > Cc: Kurt Garloff <garloff@suse.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  drivers/scsi/tmscsim.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> []
> > @@ -1611,7 +1611,7 @@ dc390_Reselect( struct dc390_acb* pACB )
> >        printk (KERN_ERR "DC390: Reselection must select host adapter: %02x!\n", lun);
> >      else
> >        lun ^= 1 << pACB->pScsiHost->this_id; /* Mask AdapterID */
> > -    id = 0; while (lun >>= 1) id++;
> > +    id = ilog2(lun);
> >      /* Get LUN */
> >      lun = DC390_read8 (ScsiFifo);
> >      if (!(lun & IDENTIFY_BASE)) printk (KERN_ERR "DC390: Resel: Expect identify message!\n");
> 
> Hey Fabian.
> 
> You've submitted several of these now.
> 
> Have you gone through all of these to make sure
> that the ilog2(<foo>) uses are always using a
> non-zero <foo>?

I think here at least, lun indeed can be 0, at least there's a test there:

    if (!(lun & (1 << pACB->pScsiHost->this_id)))
      printk (KERN_ERR "DC390: Reselection must select host adapter: %02x!\n", lun);

So, it is possible, that the "1 << this_id" bit is not set, then possibly 
it can be 0 too... Although from the hardware / SCSI PoV I'm not sure TBH. 
To be on the safe side we could at least add a check for 0 and only use 
ilog2, for != 0.

Thanks
Guennadi

> If so, that should be mentioned in the changelog.
> 
> These should probably add #include <linux/log2.h>
> 
> It would have been nicer to use a patch series
> and a cover letter so I could make this reply to
> to cover letter.
> 
> Please take the time to setup and use git send-email
> instead of sylpheed.
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
