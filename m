Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaGKW1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:27:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaGKW1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:27:34 -0400
Date: Fri, 11 Jul 2014 15:27:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, mhocko@suse.cz,
        linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
        fengguang.wu@intel.com, jweiner@redhat.com
Subject: Re: [PATCH] mm/page-writeback.c: fix divide by zero in
 bdi_dirty_limits
Message-Id: <20140711152732.de78603744cd861497eca5dc@linux-foundation.org>
In-Reply-To: <20140711081656.15654.19946.stgit@localhost.localdomain>
References: <20140711081656.15654.19946.stgit@localhost.localdomain>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014 12:18:27 +0400 Maxim Patlasov <MPatlasov@parallels.com> wrote:

> Under memory pressure, it is possible for dirty_thresh, calculated by
> global_dirty_limits() in balance_dirty_pages(), to equal zero.

Under what circumstances?  Really small values of vm_dirty_bytes?

> Then, if
> strictlimit is true, bdi_dirty_limits() tries to resolve the proportion:
> 
>   bdi_bg_thresh : bdi_thresh = background_thresh : dirty_thresh
> 
> by dividing by zero.
> 
> ...
>
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1306,9 +1306,9 @@ static inline void bdi_dirty_limits(struct backing_dev_info *bdi,
>  	*bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
>  
>  	if (bdi_bg_thresh)
> -		*bdi_bg_thresh = div_u64((u64)*bdi_thresh *
> -					 background_thresh,
> -					 dirty_thresh);
> +		*bdi_bg_thresh = dirty_thresh ? div_u64((u64)*bdi_thresh *
> +							background_thresh,
> +							dirty_thresh) : 0;

This introduces a peculiar discontinuity:

if dirty_thresh==3, treat it as 3
if dirty_thresh==2, treat it as 2
if dirty_thresh==1, treat it as 1
if dirty_thresh==0, treat it as infinity

Would it not make more sense to change global_dirty_limits() to convert
0 to 1?  With an appropriate comment, obviously.


Or maybe the fix lies elsewhere.  Please do tell us how this zero comes
about.

