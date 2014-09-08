Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaIHDuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 23:50:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:52110 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbaIHDuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 23:50:24 -0400
Date: Sun, 7 Sep 2014 20:50:24 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2] f2fs: Remove lock from check_valid_map
Message-ID: <20140908035024.GA13009@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <1410059104-9060-1-git-send-email-ying.huang@intel.com>
 <1410061110-31081-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410061110-31081-1-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Sep 07, 2014 at 11:38:30AM +0800, Huang Ying wrote:
> Only one bit is read in check_valid_map, holding a lock to do that
> doesn't help anything except decreasing performance.
> 
> Signed-off-by: Huang, Ying <ying.huang@intel.com>
> ---
> 
> v2: Fixed a build warning.
> 
> ---
>  fs/f2fs/gc.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -378,14 +378,11 @@ static void put_gc_inode(struct list_hea
>  static int check_valid_map(struct f2fs_sb_info *sbi,
>  				unsigned int segno, int offset)
>  {
> -	struct sit_info *sit_i = SIT_I(sbi);
>  	struct seg_entry *sentry;
>  	int ret;
>  
> -	mutex_lock(&sit_i->sentry_lock);
>  	sentry = get_seg_entry(sbi, segno);
>  	ret = f2fs_test_bit(offset, sentry->cur_valid_map);
> -	mutex_unlock(&sit_i->sentry_lock);
>  	return ret;

The f2fs_test_bit is not atomic, so I'm not sure this is a good approach.
How about introducing rw_semaphore?

>  }
>  
