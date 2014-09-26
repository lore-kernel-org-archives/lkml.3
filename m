Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaIZI6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:58:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25739 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaIZI6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:58:04 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-1c-54252a9988d8
From: Chao Yu <chao2.yu@samsung.com>
To: "'Henrique de Moraes Holschuh'" <hmh@hmh.eng.br>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <002801cfd892$696e39d0$3c4aad70$@samsung.com>
 <20140925165114.GE10814@khazad-dum.debian.net>
In-reply-to: <20140925165114.GE10814@khazad-dum.debian.net>
Subject: RE: [PATCH] md: avoid potential long delay under pers_lock
Date: Fri, 26 Sep 2014 16:56:44 +0800
Message-id: <004c01cfd967$fa1012d0$ee303870$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGG4wNqX+f5TUFyB86IvHjUIwy0SgEolAbAnJu2j6A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jQd2ZWqohBsdfClqs/72SxeLyrjls
	Fu3zdzFa7J3fwOLA4vH7AKPH5tPVHp83yQUwR3HZpKTmZJalFunbJXBlbN22k7ngvEDFraXN
	jA2MS3i7GDk5JARMJA63zmCHsMUkLtxbz9bFyMUhJDCdUWLLnwVMEM4PRol3H3axgFSxCahI
	LO/4zwRiiwgYSXyac4EVxGYW8Ja4Nf0wM4gtJJAl0bn7FdhUTgFrifN3+thAbGEBZ4k569oY
	QWwWAVWJ/mOXgGZycPAKWEq8mAcW5hUQlPgx+R4LxEgtifU7jzNB2PISm9e8ZYY4VEFix9nX
	jCCtIgJWEtMfeUKUiEtsPHKLZQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07M
	LS7NS9dLzs/dxAgO+mfSOxhXNVgcYhTgYFTi4W1YoxIixJpYVlyZe4hRgoNZSYTXSEE1RIg3
	JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVANjpL7vNmtVK4vZ
	b/datZyw1REzkGRevJ7P/IPtUcGNh9sWP882W8Lv+rBhKve23eej7bINeX4e3ex6oEJi9Rf+
	PJ4HVtsL/CU3MMWmHlfNO+tjl9UpzWEfETjhwcX1M1fU3lta/Xa5xueqSek3oh88lBbOkFYW
	009e1qRdG++4dNXh9su/MqSUWIozEg21mIuKEwHyGC61dgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Henrique de Moraes Holschuh [mailto:hmh@hmh.eng.br]
> Sent: Friday, September 26, 2014 12:51 AM
> To: Chao Yu
> Cc: neilb@suse.de; linux-raid@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] md: avoid potential long delay under pers_lock
> 
> On Thu, 25 Sep 2014, Chao Yu wrote:
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
> Wouldn't it make more sense to move the printk after the spin_unlock ?

As original printk msg in {,un}register_md_personality shows '{,un}registered'
which means the main job is done before printk, it's better to move the printk
after spin_unlock in both {,un}register_md_personality. But IMHO, it's another
minor issue, should we fix in this patch?

Thanks,
Yu

> 
> --
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh

