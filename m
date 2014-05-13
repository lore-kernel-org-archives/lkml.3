Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaEMW3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:29:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaEMW3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:29:02 -0400
Date: Tue, 13 May 2014 15:29:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 17/19] fs: buffer: Do not use unnecessary atomic
 operations when discarding buffers
Message-Id: <20140513152900.ea0a58cf4a650fb0b4110e3e@linux-foundation.org>
In-Reply-To: <1399974350-11089-18-git-send-email-mgorman@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
	<1399974350-11089-18-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 10:45:48 +0100 Mel Gorman <mgorman@suse.de> wrote:

> Discarding buffers uses a bunch of atomic operations when discarding buffers
> because ...... I can't think of a reason. Use a cmpxchg loop to clear all the
> necessary flags. In most (all?) cases this will be a single atomic operations.
> 
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1485,14 +1485,18 @@ EXPORT_SYMBOL(set_bh_page);
>   */
>  static void discard_buffer(struct buffer_head * bh)
>  {
> +	unsigned long b_state, b_state_old;
> +
>  	lock_buffer(bh);
>  	clear_buffer_dirty(bh);
>  	bh->b_bdev = NULL;
> -	clear_buffer_mapped(bh);
> -	clear_buffer_req(bh);
> -	clear_buffer_new(bh);
> -	clear_buffer_delay(bh);
> -	clear_buffer_unwritten(bh);
> +	b_state = bh->b_state;
> +	for (;;) {
> +		b_state_old = cmpxchg(&bh->b_state, b_state, (b_state & ~BUFFER_FLAGS_DISCARD));
> +		if (b_state_old == b_state)
> +			break;
> +		b_state = b_state_old;
> +	}
>  	unlock_buffer(bh);
>  }
>  
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -77,6 +77,11 @@ struct buffer_head {
>  	atomic_t b_count;		/* users using this buffer_head */
>  };
>  
> +/* Bits that are cleared during an invalidate */
> +#define BUFFER_FLAGS_DISCARD \
> +	(1 << BH_Mapped | 1 << BH_New | 1 << BH_Req | \
> +	 1 << BH_Delay | 1 << BH_Unwritten)
> +

There isn't much point in having this in the header file is there?

--- a/fs/buffer.c~fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix
+++ a/fs/buffer.c
@@ -1483,6 +1483,12 @@ EXPORT_SYMBOL(set_bh_page);
 /*
  * Called when truncating a buffer on a page completely.
  */
+
+/* Bits that are cleared during an invalidate */
+#define BUFFER_FLAGS_DISCARD \
+	(1 << BH_Mapped | 1 << BH_New | 1 << BH_Req | \
+	 1 << BH_Delay | 1 << BH_Unwritten)
+
 static void discard_buffer(struct buffer_head * bh)
 {
 	unsigned long b_state, b_state_old;
@@ -1492,7 +1498,8 @@ static void discard_buffer(struct buffer
 	bh->b_bdev = NULL;
 	b_state = bh->b_state;
 	for (;;) {
-		b_state_old = cmpxchg(&bh->b_state, b_state, (b_state & ~BUFFER_FLAGS_DISCARD));
+		b_state_old = cmpxchg(&bh->b_state, b_state,
+				      (b_state & ~BUFFER_FLAGS_DISCARD));
 		if (b_state_old == b_state)
 			break;
 		b_state = b_state_old;
--- a/include/linux/buffer_head.h~fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix
+++ a/include/linux/buffer_head.h
@@ -77,11 +77,6 @@ struct buffer_head {
 	atomic_t b_count;		/* users using this buffer_head */
 };
 
-/* Bits that are cleared during an invalidate */
-#define BUFFER_FLAGS_DISCARD \
-	(1 << BH_Mapped | 1 << BH_New | 1 << BH_Req | \
-	 1 << BH_Delay | 1 << BH_Unwritten)
-
 /*
  * macro tricks to expand the set_buffer_foo(), clear_buffer_foo()
  * and buffer_foo() functions.
_

