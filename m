Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaIZJAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:00:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13177 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbaIZJAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:00:30 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-a2-54252b2bbda1
From: Chao Yu <chao2.yu@samsung.com>
To: "'NeilBrown'" <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <002801cfd892$696e39d0$3c4aad70$@samsung.com>
 <20140926103620.7c397832@notabene.brown>
In-reply-to: <20140926103620.7c397832@notabene.brown>
Subject: RE: [PATCH] md: avoid potential long delay under pers_lock
Date: Fri, 26 Sep 2014 16:59:47 +0800
Message-id: <004d01cfd968$513d6d00$f3b84700$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGG4wNqX+f5TUFyB86IvHjUIwy0SgJOudLmnJKTzfA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t9jAV1tbdUQg8nnZC0u75rDZtE+fxej
	xd75DSwOzB6bT1d7fN4kF8AUxWWTkpqTWZZapG+XwJVxb1ITc8EN3oru34/YGxg/cXUxcnJI
	CJhIXJzSxgxhi0lcuLeerYuRi0NIYBGjxPd/k5ghnB+MEt2zlrKDVLEJqEgs7/jPBGKLCMhL
	rOo7xghiMwvYSNx5MI0FxBYSSJFo3LsMbCqngKnEn0/3WEFsYQFniTnr2sDqWQRUJU6194PV
	8ApYSqzcvZ4RwhaU+DH5HgvETC2J9TuPM0HY8hKb17yFulRBYsfZ14wQN1hJTJjRxg5RIy6x
	8cgtlgmMQrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4zJ9J
	72Bc1WBxiFGAg1GJh7dhjUqIEGtiWXFl7iFGCQ5mJRFeIwXVECHelMTKqtSi/Pii0pzU4kOM
	0hwsSuK8B1utA4UE0hNLUrNTUwtSi2CyTBycUg2Ma2xZquxfX2i4Hl7i/STwh6zd7LsTejkS
	xFLWpggve/NRyyhMeb5uGmd+meiRPXXJP5ZqcHVEFP6O3f7uh4Wh3b+N3D8SQmTFqvSuLX23
	RPmnBMvMY498NLxS52euFozycc9ief1mkevi5hXxHzXZwubyeJ7bvaLtwa2e7OYH78/JeQht
	7oxRYinOSDTUYi4qTgQAhIhwKG8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Friday, September 26, 2014 8:36 AM
> To: Chao Yu
> Cc: linux-raid@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] md: avoid potential long delay under pers_lock
> 
> On Thu, 25 Sep 2014 15:28:34 +0800 Chao Yu <chao2.yu@samsung.com> wrote:
> 
> > printk may cause long time lapse if value of printk_delay in sysctl is
> > configured large by user. If register_md_personality takes long time to print in
> > spinlock pers_lock, we may encounter high CPU usage rate when there are other
> > pers_lock competitors who may be blocked to spin.
> > We can avoid this condition by moving printk out of coverage of pers_lock
> > spinlock.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  drivers/md/md.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index e02de05..5fcf215 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -7200,9 +7200,10 @@ static const struct file_operations md_seq_fops = {
> >
> >  int register_md_personality(struct md_personality *p)
> >  {
> > +	printk(KERN_INFO "md: %s personality registered for level %d\n",
> > +						p->name, p->level);
> >  	spin_lock(&pers_lock);
> >  	list_add_tail(&p->list, &pers_list);
> > -	printk(KERN_INFO "md: %s personality registered for level %d\n", p->name, p->level);
> >  	spin_unlock(&pers_lock);
> >  	return 0;
> >  }
> 
> I'm not sure I see the pressing need for this - have you noticed actual
> problems?

Haven't, I found this by code review.

Thanks,
Yu

> However it seems to make sense so I've applied it.
> 
> Thanks,
> NeilBrown

