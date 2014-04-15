Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaDOLzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:55:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63862 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDOLzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:55:50 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-97-534d1beccc79
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Tejun Heo'" <tj@kernel.org>, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-ide@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_samsung_cf: fix ata_host_activate() failure handling
Date: Tue, 15 Apr 2014 13:45:34 +0200
Message-id: <2600390.JXZXrjzsbS@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <000801cf4d48$54c45210$fe4cf630$%han@samsung.com>
References: <6050762.sdUI3gZZlK@amdc1032>
 <000801cf4d48$54c45210$fe4cf630$%han@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jQd030r7BBo0fZC0mrTvAZHF54SVW
	i94FV9ksNj2+xmpxbMcjoNiuOWwWM87vY7L4tfwoowOHx99VL5g9Nq3qZPPYvKTeo2/LKkaP
	z5vkAlijuGxSUnMyy1KL9O0SuDImvepgKzjHXfFh6w/GBsYFnF2MnBwSAiYSH5+fZ4WwxSQu
	3FvP1sXIxSEkMJ1RYvKNP6wQTguTxOczX5hAqtgErCQmtq9iBLFFBFQkPq8/DtbBLPCBUeLW
	vG6whLCAn8T751dZQGwWAVWJKfv/gMV5BTQlVk+cBTZIVMBTYsf2lWwgNqeAncTO9XfA6oUE
	YiUW3DjLBlEvKPFj8j2wOLOAvMS+/VNZIWwtifU7jzNNYBSYhaRsFpKyWUjKFjAyr2IUTS1I
	LihOSs810itOzC0uzUvXS87P3cQIDvhn0jsYVzVYHGIU4GBU4uGd8M47WIg1say4MvcQowQH
	s5II70du32Ah3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1MLUotgskwcnFIN
	jG7sy3Z0fVKo6HYt0/eNS92oJZvNtOjoia+bE6V33Y/d77lqmY7WgVNcmeaMHn3Prz0+v0w2
	/aOLS8WpwiMGFtFqDD1JnMK3qpZY86ralD4t2dJzx5aFo4JLd/9OxZ2zFH7tqTEp1XpVHndW
	ikFhbujHtAqRLEu/ms4Z4s3B5Wmutrox0S+VWIozEg21mIuKEwHLZsaVdAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Tejun, could you please also pick this one?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Tuesday, April 01, 2014 10:18:46 AM Jingoo Han wrote:
> On Tuesday, April 01, 2014 2:53 AM, Tejun Heo wrote:
> > 
> > Add missing clk_disable() call to ata_host_activate() failure path.
> > 
> > Cc: Ben Dooks <ben-linux@fluff.org>
> > Cc: Kukjin Kim <kgene.kim@samsung.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> 
> Reviewed-by: Jingoo Han <jg1.han@samsung.com>
> 
> Best regards,
> Jingoo Han
> 
> > ---
> >  drivers/ata/pata_samsung_cf.c |   10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > Index: b/drivers/ata/pata_samsung_cf.c
> > ===================================================================
> > --- a/drivers/ata/pata_samsung_cf.c	2014-03-14 16:45:04.344724378 +0100
> > +++ b/drivers/ata/pata_samsung_cf.c	2014-03-31 18:31:58.083631437 +0200
> > @@ -594,9 +594,13 @@ static int __init pata_s3c_probe(struct
> > 
> >  	platform_set_drvdata(pdev, host);
> > 
> > -	return ata_host_activate(host, info->irq,
> > -			info->irq ? pata_s3c_irq : NULL,
> > -			0, &pata_s3c_sht);
> > +	ret = ata_host_activate(host, info->irq,
> > +				info->irq ? pata_s3c_irq : NULL,
> > +				0, &pata_s3c_sht);
> > +	if (ret)
> > +		goto stop_clk;
> > +
> > +	return 0;
> > 
> >  stop_clk:
> >  	clk_disable(info->clk);
> > 
> > --

