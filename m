Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaIYQvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:51:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54856 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbaIYQvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:51:21 -0400
X-Sasl-enc: S0kA+ml1klPyrJR5ESIJB485BH4FFuEZatu6hqtT8mnk 1411663880
Date: Thu, 25 Sep 2014 13:51:15 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Chao Yu <chao2.yu@samsung.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: avoid potential long delay under pers_lock
Message-ID: <20140925165114.GE10814@khazad-dum.debian.net>
References: <002801cfd892$696e39d0$3c4aad70$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002801cfd892$696e39d0$3c4aad70$@samsung.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Chao Yu wrote:
> printk may cause long time lapse if value of printk_delay in sysctl is
> configured large by user. If register_md_personality takes long time to print in
> spinlock pers_lock, we may encounter high CPU usage rate when there are other
> pers_lock competitors who may be blocked to spin.
> We can avoid this condition by moving printk out of coverage of pers_lock
> spinlock.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  drivers/md/md.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e02de05..5fcf215 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7200,9 +7200,10 @@ static const struct file_operations md_seq_fops = {
>  
>  int register_md_personality(struct md_personality *p)
>  {
> +	printk(KERN_INFO "md: %s personality registered for level %d\n",
> +						p->name, p->level);
>  	spin_lock(&pers_lock);
>  	list_add_tail(&p->list, &pers_list);
> -	printk(KERN_INFO "md: %s personality registered for level %d\n", p->name, p->level);
>  	spin_unlock(&pers_lock);
>  	return 0;
>  }

Wouldn't it make more sense to move the printk after the spin_unlock ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
