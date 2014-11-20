Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbaKTVPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:15:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757077AbaKTVPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:15:11 -0500
Date: Thu, 20 Nov 2014 16:15:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH block/for-next 4/4] block: implement bio_associate_blkcg()
Message-ID: <20141120211506.GE11595@redhat.com>
References: <20141117211321.GD23126@htj.dyndns.org>
 <20141117211357.GE23126@htj.dyndns.org>
 <20141117211546.GF23126@htj.dyndns.org>
 <20141117211619.GG23126@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117211619.GG23126@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 04:16:19PM -0500, Tejun Heo wrote:
> Currently, a bio can only be associated with the io_context and blkcg
> of %current using bio_associate_current().  This is too restrictive
> for cgroup writeback support.  Implement bio_associate_blkcg() which
> associates a bio with the specified blkcg.
> 
> bio_associate_blkcg() leaves the io_context unassociated.
> bio_associate_current() is updated so that it considers a bio as
> already associated if it has a blkcg_css, instead of an io_context,
> associated with it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/bio.c         |   24 +++++++++++++++++++++++-
>  include/linux/bio.h |    3 +++
>  2 files changed, 26 insertions(+), 1 deletion(-)
> 
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1981,6 +1981,28 @@ struct bio_set *bioset_create_nobvec(uns
>  EXPORT_SYMBOL(bioset_create_nobvec);
>  
>  #ifdef CONFIG_BLK_CGROUP
> +
> +/**
> + * bio_associate_blkcg - associate a bio with the specified blkcg
> + * @bio: target bio
> + * @blkcg_css: the css of the blkcg to associate
> + *
> + * Associate @bio with the blkcg specified by @blkcg_css.  Block layer will
> + * treat @bio as if it were issued by a task which belongs to the blkcg.
> + *
> + * This function takes an extra reference of @blkcg_css which will be put
> + * when @bio is released.  The caller must own @bio and is responsible for
> + * synchronizing calls to this function.
> + */
> +int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css)
> +{
> +	if (unlikely(bio->bi_css))
> +		return -EBUSY;
> +	css_get(blkcg_css);
> +	bio->bi_css = blkcg_css;
> +	return 0;
> +}
> +
>  /**
>   * bio_associate_current - associate a bio with %current
>   * @bio: target bio
> @@ -1998,7 +2020,7 @@ int bio_associate_current(struct bio *bi
>  {
>  	struct io_context *ioc;
>  
> -	if (bio->bi_ioc)
> +	if (bio->bi_css)
>  		return -EBUSY;

Hi Tejun,

Have a query. So if somebody calls bio_associate_blkcg(), that bio will
not have io context information. That means io context information of
submitter will be used in CFQ. That will also mean that if we select
differnt thread to IO of same cgroup or use a thread to submit IO of
different cgroup, check_blkcg_changed() will be true and we will
unnecessary drop sync queue despite the fact that IO we are submitting
now is async. And everytime a submitter submits IO for a different cgroup,
it will drop its existing sync queue. Sounds suboptimal.

I guess ideally io context of original writer who wrote data in page
cache should be used. But we probably don't have that information as
we might be planning to get block cgroup information from inode of
the file being written.

Not sure what can be done about this. May be a notion of per
block cgroup per device io context and always use that io context
when bio has cgroup info but not io context info. 

Thanks
Vivek
