Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab3DYOc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:32:26 -0400
Received: from relay.parallels.com ([195.214.232.42]:59722 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758770Ab3DYOcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:32:23 -0400
Message-ID: <51793DE6.3000503@parallels.com>
Date: Thu, 25 Apr 2013 18:29:58 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "miklos@szeredi.hu" <miklos@szeredi.hu>
CC: <dev@parallels.com>, <xemul@parallels.com>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <jbottomley@parallels.com>,
        <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <devel@openvz.org>, <akpm@linux-foundation.org>,
        <fengguang.wu@intel.com>
Subject: Re: [fuse-devel] [PATCH 14/14] mm: Account for WRITEBACK_TEMP in
 balance_dirty_pages
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru> <20130401104250.19027.27795.stgit@maximpc.sw.ru>
In-Reply-To: <20130401104250.19027.27795.stgit@maximpc.sw.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

04/01/2013 02:42 PM, Maxim V. Patlasov пишет:
> Make balance_dirty_pages start the throttling when the WRITEBACK_TEMP
> counter is high enough. This prevents us from having too many dirty
> pages on fuse, thus giving the userspace part of it a chance to write
> stuff properly.
>
> Note, that the existing balance logic is per-bdi, i.e. if the fuse
> user task gets stuck in the function this means, that it either
> writes to the mountpoint it serves (but it can deadlock even without
> the writeback) or it is writing to some _other_ dirty bdi and in the
> latter case someone else will free the memory for it.
>
> Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> ---
>   mm/page-writeback.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 0713bfb..c47bcd4 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1235,7 +1235,8 @@ static void balance_dirty_pages(struct address_space *mapping,
>   		 */
>   		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
>   					global_page_state(NR_UNSTABLE_NFS);
> -		nr_dirty = nr_reclaimable + global_page_state(NR_WRITEBACK);
> +		nr_dirty = nr_reclaimable + global_page_state(NR_WRITEBACK) +
> +			global_page_state(NR_WRITEBACK_TEMP);
>   
>   		global_dirty_limits(&background_thresh, &dirty_thresh);

Please drop this patch. As we discussed in LSF/MM, the fix above is 
correct, but it's not enough: we also need to ensure disregard of 
NR_WRITEBACK_TEMP when balance_dirty_pages() is called from fuse daemon. 
I'll send a separate patch-set soon.

Thanks,
Maxim
