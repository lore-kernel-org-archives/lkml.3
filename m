Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab3EHUY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:24:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab3EHUY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:24:56 -0400
Date: Wed, 8 May 2013 13:24:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>, Jiri Kosina <jkosina@suse.cz>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v3] bitmap: speed up bitmap_find_free_region
Message-Id: <20130508132454.5dc3770be27f6312701129a2@linux-foundation.org>
In-Reply-To: <1367914553-1999-1-git-send-email-chanho.min@lge.com>
References: <1367914553-1999-1-git-send-email-chanho.min@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 May 2013 17:15:53 +0900 Chanho Min <chanho.min@lge.com> wrote:

> In bitmap_find_free_region, If we skip the all-ones words and find bits
> in a not-all-ones word, we can improve performance of it.
> 
> For example, If bitmap_find_free_region() is called with order=0, First,
> It scans bitmap array by the increment of long type, then find 1 free bit
> within 1 long type value. In 32 bits system and 1024 bits size, in the worst
> case, We need 1024 for-loops to find 1 free bit. But, If this is applied,
> it takes 64 for-loops. Instead, It will be needed additional if-comparison
> of every word and It can take time slightly as 'Test case 3'. But, In many
> cases, It will speed up significantly.
> 
> ...
>
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -1114,14 +1114,21 @@ done:
>   */
>  int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
>  {
> -	int pos, end;		/* scans bitmap by regions of size order */
> -
> -	for (pos = 0 ; (end = pos + (1 << order)) <= bits; pos = end) {
> -		if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
> -			continue;
> -		__reg_op(bitmap, pos, order, REG_OP_ALLOC);
> -		return pos;
> -	}
> +	int pos, end, nbit, i;	/* scans bitmap by regions of size order */
> +	int nlongs = BITS_TO_LONGS(bits);
> +
> +	for (i = 0; i < nlongs; i++)
> +		if (bitmap[i] != ~0UL) {
> +			pos = i * BITS_PER_LONG;
> +			nbit = min(bits, pos + BITS_PER_LONG);
> +			for (; (end = pos + (1 << order)) <= nbit; pos = end) {
> +				if (!__reg_op(bitmap, pos, order,
> +					REG_OP_ISFREE))
> +					continue;
> +				__reg_op(bitmap, pos, order, REG_OP_ALLOC);
> +				return pos;
> +			}
> +		}
>  	return -ENOMEM;

It could be improved further by returning to the long-at-a-time search
if we failed to find a suffificiently large free region at `i'.  Oh
well, I guess we can do that later if someone cares enough.

We now have a definition of four(!) locals on a single line followed by
a head-scratching comment which doesn't really pertain to any of those
locals anyway.  Let's do this:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-bitmapc-speed-up-bitmap_find_free_region-fix

reduce scope of locals, remove barely comprehensible comment

Cc: Chanho Min <chanho.min@lge.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: anish singh <anish198519851985@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN lib/bitmap.c~lib-bitmapc-speed-up-bitmap_find_free_region-fix lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-speed-up-bitmap_find_free_region-fix
+++ a/lib/bitmap.c
@@ -1114,13 +1114,15 @@ done:
  */
 int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
 {
-	int pos, end, nbit, i;	/* scans bitmap by regions of size order */
 	int nlongs = BITS_TO_LONGS(bits);
+	int i;
 
 	for (i = 0; i < nlongs; i++)
 		if (bitmap[i] != ~0UL) {
-			pos = i * BITS_PER_LONG;
-			nbit = min(bits, pos + BITS_PER_LONG);
+			int pos = i * BITS_PER_LONG;
+			int nbit = min(bits, pos + BITS_PER_LONG);
+			int end;
+
 			for (; (end = pos + (1 << order)) <= nbit; pos = end) {
 				if (!__reg_op(bitmap, pos, order,
 					REG_OP_ISFREE))
_

