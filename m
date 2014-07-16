Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312AbaGPDmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:42:17 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53839 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933191AbaGPDmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:42:15 -0400
X-Sasl-enc: fpT07VH6iDxLWnVCllcwXeZym1Nth+v1ZqaJdV0V8e7k 1405482134
Message-ID: <1405482132.2527.26.camel@perseus.fritz.box>
Subject: Re: [PATCH 6/6] autofs4: don't take spinlock when not needed in
 autofs4_lookup_expiring
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 16 Jul 2014 11:42:12 +0800
In-Reply-To: <20140709234114.4525.70534.stgit@notabene.brown>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	 <20140709234114.4525.70534.stgit@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-10 at 09:41 +1000, NeilBrown wrote:
> If the expiring_list is empty, we can avoid a costly spinlock
> in the rcu-walk path through authfs4_d_manage.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>

I know it should be straight forward to say this is OK but I always
think twice and again about areas that are subject to race pressure,
such as the expire to mount pressure of this code.

After thinking about it for a while now I don't have any reason to think
this would be a problem. Perhaps later pressure testing will reveal
something I missed.

It occurs to me that autofs4_lookup_active() might benefit from a
similar addition. Multiple calls to ->lookup() made while the dentry is
still unhashed should have enforced ordering due to the directory
i_mutex so there shouldn't be a problem adding this. But perhaps you
haven't seen delays in that function.

Acked-by: Ian Kent <raven@themaw.net>

> ---
>  fs/autofs4/root.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> index 1ad119407e2f..774c2dab331b 100644
> --- a/fs/autofs4/root.c
> +++ b/fs/autofs4/root.c
> @@ -219,6 +219,8 @@ static struct dentry *autofs4_lookup_expiring(struct dentry *dentry,
>  	const unsigned char *str = name->name;
>  	struct list_head *p, *head;
>  
> +	if (list_empty(&sbi->expiring_list))
> +		return NULL;
>  	spin_lock(&sbi->lookup_lock);
>  	head = &sbi->expiring_list;
>  	list_for_each(p, head) {
> 
> 


