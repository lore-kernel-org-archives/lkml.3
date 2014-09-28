Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaI1Vnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 17:43:33 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:32772 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaI1Vnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 17:43:31 -0400
Date: Sun, 28 Sep 2014 14:43:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        "maintainer:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>,
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] drivers/md: Use rcu_dereference() for accessing
 rcu pointer
Message-ID: <20140928214325.GH5015@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1411916712-17631-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411916712-17631-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092821-6688-0000-0000-000005283D88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 11:05:04AM -0400, Pranith Kumar wrote:
> Got Paul's email wrong the first time.
> 
> The map field in 'struct mapped_device' is an rcu pointer. Use rcu_dereference()
> while accessing it.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

OK, I now have all three queued (including the extraneous first line of
the commit log above...), will see what 0day thinks of it.

							Thanx, Paul

> ---
>  drivers/md/dm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 746411b..fbdf0bb 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2211,7 +2211,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
> 
>  	merge_is_optional = dm_table_merge_is_optional(t);
> 
> -	old_map = md->map;
> +	old_map = rcu_dereference(md->map);
>  	rcu_assign_pointer(md->map, t);
>  	md->immutable_target_type = dm_table_get_immutable_target_type(t);
> 
> @@ -2230,7 +2230,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
>   */
>  static struct dm_table *__unbind(struct mapped_device *md)
>  {
> -	struct dm_table *map = md->map;
> +	struct dm_table *map = rcu_dereference(md->map);
> 
>  	if (!map)
>  		return NULL;
> @@ -2624,7 +2624,7 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
>  		goto out_unlock;
>  	}
> 
> -	map = md->map;
> +	map = rcu_dereference(md->map);
> 
>  	/*
>  	 * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
> @@ -2718,7 +2718,7 @@ int dm_resume(struct mapped_device *md)
>  	if (!dm_suspended_md(md))
>  		goto out;
> 
> -	map = md->map;
> +	map = rcu_dereference(md->map);
>  	if (!map || !dm_table_get_size(map))
>  		goto out;
> 
> -- 
> 1.9.1
> 

