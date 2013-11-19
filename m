Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab3KSF1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:27:34 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31101 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3KSF1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:27:31 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-83-528af6c2dcc0
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1384765922-24028-1-git-send-email-jaegeuk.kim@samsung.com>
In-reply-to: <1384765922-24028-1-git-send-email-jaegeuk.kim@samsung.com>
Subject: RE: [f2fs-dev] [PATCH 1/2] f2fs: clean up the do_submit_bio flow
Date: Tue, 19 Nov 2013 13:25:57 +0800
Message-id: <001401cee4e8$09cf01b0$1d6d0510$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHbe6Z+2xmVRaf77O6w5WUPjoMNBJoS1RTA
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jAd1D37qCDJYv47e4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2Py59XMBSdlKlZe
	vMbSwNgi3sXIySEhYCLx4N5OZghbTOLCvfVsXYxcHEICixglnm/dBeX8YJSYMecWO0gVm4CK
	xPKO/0wgtoiAtsTPua1gcWaBTIk5ryezgthCAu4Sf+9+ArM5BTwkvvSuYQGxhQU8Ja6vu8oG
	YrMIqEosm/IALM4rYCkx+dV7VghbUOLH5HssEDO1JNbvPM4EYctLbF7zFupSBYkdZ18zQtxg
	JPH08wM2iBpxiY1HbrFMYBSahWTULCSjZiEZNQtJywJGllWMoqkFyQXFSem5RnrFibnFpXnp
	esn5uZsYwaH/THoH46oGi0OMAhyMSjy8E9y7goRYE8uKK3MPMUpwMCuJ8EpeAQrxpiRWVqUW
	5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgbDyVVvbpn9G8C+a5O/59
	3Wxl3d5eK1Rk1j3x3K89EhtvGQelrey5wJPkGXHc12mfTbz+JwdPiT9Xn2/fZ7Bt5R2L3OKW
	Sh+/TaqPZYNa9ytbqrw1XcH/PfmuTNBfk2XWSb4iaf0/Hm9hfzTNc0J19NqUov///28wPZZ2
	Zq41J9PMgnkMez1WKLEUZyQaajEXFScCAEvxppN5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Monday, November 18, 2013 5:12 PM
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [PATCH 1/2] f2fs: clean up the do_submit_bio flow
> 
> This patch introduces PAGE_TYPE_OF_BIO() and cleans up do_submit_bio() with it.
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

->f2fs_submit_bio()
	: enum page_type btype = PAGE_TYPE_OF_BIO(type);
	->do_submit_bio()
		: enum page_type btype = PAGE_TYPE_OF_BIO(type);

Could we remove PAGE_TYPE_OF_BIO or use f2fs_bug_on to instead
in do_submit_bio()? because it looks redundant , and also 
submit_write_page() will not pass the type which is larger than META.

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

