Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3KSAk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 19:40:58 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:57047 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3KSAky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 19:40:54 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-ea-528ab395c9fe
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1384765922-24028-1-git-send-email-jaegeuk.kim@samsung.com>
In-reply-to: <1384765922-24028-1-git-send-email-jaegeuk.kim@samsung.com>
Subject: RE: [f2fs-dev] [PATCH 1/2] f2fs: clean up the do_submit_bio flow
Date: Tue, 19 Nov 2013 08:39:54 +0800
Message-id: <001001cee4c0$002595c0$0070c140$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHbe6Z+2xmVRaf77O6w5WUPjoMNBJoShmpA
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQd2pm7uCDJZN5rS4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2PfrJOMBf+kKl62
	z2BqYLwu2sXIySEhYCJxqruJFcIWk7hwbz1bFyMXh5DAdEaJLStbmCCcH4wSc770sYFUsQmo
	SCzv+M8EYosIaEv8nNvKDmIzC2RKzHk9GWySkIC7xN+7n8BsTgEPiS+9a1hAbGEBT4nr666C
	zWERUJV4ePwFmM0rYCnR9HMNO4QtKPFj8j0WiJlaEut3HmeCsOUlNq95ywxxqYLEjrOvGbsY
	OYBuMJK4OUkUokRcYuORWywTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5x
	aV66XnJ+7iZGcOA/k9rBuLLB4hCjAAejEg/vBPeuICHWxLLiytxDjBIczEoivFKzgEK8KYmV
	ValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoYl8btaJ9w4MTfuzrs
	L18ZaedazFt+SEPt0c1VX/JXrPF7lxx06dOpucJa8sZfHTdcvLHWxeZqXNU5z6bZCnN6wq+K
	tBnVBGlYdl4OLz84+Ziz5/Kb09XYukrnRFVIZy5smLhsu8sDFh2h1VuvNM/xX1/h+z5wZ90r
	5pXfNtefNHH7c8xD9ciHnUosxRmJhlrMRcWJAL5tpXp4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Monday, November 18, 2013 5:12 PM
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [PATCH 1/2] f2fs: clean up the do_submit_bio flow
> 
> This patch introduces PAGE_TYPE_OF_BIO() and cleans up do_submit_bio() with
it.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/f2fs.h    |  1 +
>  fs/f2fs/segment.c | 39 +++++++++++++++++++++------------------
>  2 files changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index fe5c2fc..1c783fd 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -351,6 +351,7 @@ enum count_type {
>   *			with waiting the bio's completion
>   * ...			Only can be used with META.
>   */
> +#define PAGE_TYPE_OF_BIO(type)	(type) > META ? META : (type)

We'd better to add parentheses for macro to avoid style problem.:)

#define PAGE_TYPE_OF_BIO(type)	((type) > META ? META : (type))

>  enum page_type {
>  	DATA,
>  	NODE,
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 1f83999..dad5f1a 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -837,32 +837,35 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
>  				enum page_type type, bool sync)
>  {
>  	int rw = sync ? WRITE_SYNC : WRITE;
> -	enum page_type btype = type > META ? META : type;
> +	enum page_type btype = PAGE_TYPE_OF_BIO(type);
> +	struct bio *bio = sbi->bio[btype];
> +	struct bio_private *p;
> +
> +	if (!bio)
> +		return;
> +
> +	sbi->bio[btype] = NULL;
> 
>  	if (type >= META_FLUSH)
>  		rw = WRITE_FLUSH_FUA;
> -
>  	if (btype == META)
>  		rw |= REQ_META;
> 
> -	if (sbi->bio[btype]) {
> -		struct bio_private *p = sbi->bio[btype]->bi_private;
> -		p->sbi = sbi;
> -		sbi->bio[btype]->bi_end_io = f2fs_end_io_write;
> +	p = bio->bi_private;
> +	p->sbi = sbi;
> +	bio->bi_end_io = f2fs_end_io_write;
> 
> -		trace_f2fs_do_submit_bio(sbi->sb, btype, sync, sbi->bio[btype]);
> +	trace_f2fs_do_submit_bio(sbi->sb, btype, sync, bio);
> 
> -		if (type == META_FLUSH) {
> -			DECLARE_COMPLETION_ONSTACK(wait);
> -			p->is_sync = true;
> -			p->wait = &wait;
> -			submit_bio(rw, sbi->bio[btype]);
> -			wait_for_completion(&wait);
> -		} else {
> -			p->is_sync = false;
> -			submit_bio(rw, sbi->bio[btype]);
> -		}
> -		sbi->bio[btype] = NULL;
> +	if (type == META_FLUSH) {
> +		DECLARE_COMPLETION_ONSTACK(wait);
> +		p->is_sync = true;
> +		p->wait = &wait;
> +		submit_bio(rw, bio);
> +		wait_for_completion(&wait);
> +	} else {
> +		p->is_sync = false;
> +		submit_bio(rw, bio);
>  	}
>  }
> 
> --
> 1.8.4.474.g128a96c
> 
> 
> ------------------------------------------------------------------------------
> DreamFactory - Open Source REST & JSON Services for HTML5 & Native Apps
> OAuth, Users, Roles, SQL, NoSQL, BLOB Storage and External API Access
> Free app hosting. Or install the open source package on any LAMP server.
> Sign up and see examples for AngularJS, jQuery, Sencha Touch and Native!
> http://pubads.g.doubleclick.net/gampad/clk?id=63469471&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

