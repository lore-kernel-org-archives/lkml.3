Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbbARPsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 10:48:45 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62598 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbARPsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 10:48:42 -0500
Message-ID: <54BBD5D7.6000802@plexistor.com>
Date: Sun, 18 Jan 2015 17:48:39 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jens Axboe <axboe@fb.com>, Tony Luck <tony.luck@gmail.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] block: Remove annoying "unknown partition table" message
References: <54AD5893.9040701@plexistor.com> <54AD59DC.4020703@plexistor.com> <CA+8MBbJbKwyJJoFy2uyNvR5La3hFac-pSh8mZBV=BnNJzKQMhg@mail.gmail.com> <54B99591.7080007@fb.com> <54BBB048.7010207@plexistor.com> <20150118151059.GA17263@infradead.org> <54BBD225.3080200@plexistor.com>
In-Reply-To: <54BBD225.3080200@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2015 05:32 PM, Boaz Harrosh wrote:
> From: Boaz Harrosh <boaz@plexistor.com>
> 
> As Christoph put it best:
>   Can we just get rid of the warnings?  It's fairly annoying as devices
>   without partitions are perfectly fine and very useful.
> 
> Me too I see this message every VM boot for ages on all my
> devices. Would love to just remove it. For me a partition-table
> is only needed for a booting BIOS, grub, and stuff.
> 
> (NOT Yet Tested)
> 
> CC: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
> ---
>  block/partitions/check.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/block/partitions/check.c b/block/partitions/check.c
> index 9ac1df7..e3a9077 100644
> --- a/block/partitions/check.c
> +++ b/block/partitions/check.c
> @@ -184,9 +184,7 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
>  	if (err)
>  	/* The partition is unrecognized. So report I/O errors if there were any */
>  		res = err;
> -	if (!res)
> -		strlcat(state->pp_buf, " unknown partition table\n", PAGE_SIZE);
> -	else if (warn_no_part)
> +	if (warn_no_part)
>  		strlcat(state->pp_buf, " unable to read partition table\n", PAGE_SIZE);
>  
>  	printk(KERN_INFO "%s", state->pp_buf);
> 

Off course that was untested crap something like:
---
diff --git a/block/partitions/check.c b/block/partitions/check.c
index 9ac1df7..16118d1 100644
--- a/block/partitions/check.c
+++ b/block/partitions/check.c
@@ -184,12 +184,12 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	if (err)
 	/* The partition is unrecognized. So report I/O errors if there were any */
 		res = err;
-	if (!res)
-		strlcat(state->pp_buf, " unknown partition table\n", PAGE_SIZE);
-	else if (warn_no_part)
-		strlcat(state->pp_buf, " unable to read partition table\n", PAGE_SIZE);
-
-	printk(KERN_INFO "%s", state->pp_buf);
+	if (res) {
+		if (warn_no_part)
+			strlcat(state->pp_buf,
+				" unable to read partition table\n", PAGE_SIZE);
+		printk(KERN_INFO "%s", state->pp_buf);
+	}
 
 	free_page((unsigned long)state->pp_buf);
 	free_partitions(state);
---
Not-Signed-off-yet: Boaz Harrosh <boaz@plexistor.com>

