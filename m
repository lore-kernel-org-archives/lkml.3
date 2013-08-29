Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3H2DaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 23:30:24 -0400
Received: from mdfmta005.mxout.tch.inty.net ([91.221.169.46]:51435 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754918Ab3H2DaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 23:30:22 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Aug 2013 23:30:22 EDT
Message-ID: <521EBEE3.1020309@lougher.demon.co.uk>
Date: Thu, 29 Aug 2013 04:24:19 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Manish Sharma <manishrma@gmail.com>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/1] Squashfs: Optimized uncompressed buffer loop
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MDF-HostID: 18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Manish Sharma <manishrma@gmail.com> wrote:
>
>Merged the two for loops. We might get a little gain by overlapping
>wait_on_bh and the memcpy operations.
>
>>---
>fs/squashfs/block.c |    9 +++------
> 1 file changed, 3 insertions(+), 6 deletions(-)
>
>diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
>index fb50652..5012f98 100644
>--- a/fs/squashfs/block.c
>+++ b/fs/squashfs/block.c
>@@ -169,12 +169,6 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
>		 */
>		int i, in, pg_offset = 0;
>
>-		for (i = 0; i < b; i++) {
>-			wait_on_buffer(bh[i]);
>-			if (!buffer_uptodate(bh[i]))
>-				goto block_release;
>-		}
>-
>		for (bytes = length; k < b; k++) {
>			in = min(bytes, msblk->devblksize - offset);
>			bytes -= in;
>@@ -185,6 +179,9 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
>				}
>				avail = min_t(int, in, PAGE_CACHE_SIZE -
>						pg_offset);
>+				wait_on_buffer(bh[k]);
>+				if (!buffer_uptodate(bh[k]))
>+					goto block_release;


Two points:

1.  I understand what you're trying to do here (merging the two loops
is a good thing), but this patch is in the wrong place.  It should be
in the outer loop rather than the inner loop.

The outer loop cycles through the buffer heads, one buffer head per
iteration.  The inner loop copies the buffer head to the pages, and
this can loop copying the same buffer head to multiple pages in the
case there's not enough bytes in the page (if you want to know why,
it's because we start off copying from an offset in the first buffer
head).

So it's not a good idea to have the wait_on_buffer() in the inner loop,
as we can unnecessarily call it multiple times on the same buffer head.
The wait_on_buffer() should be in the outer loop where we know it will
only be called once per buffer head.

I have checked the fixed patch into the "tmp" branch on my squashfs-next
repository on git.kernel.org here:

https://git.kernel.org/cgit/linux/kernel/git/pkl/squashfs-next.git/commit/?h=tmp&id=5839f00feea122fb773d8520e5cfb16464fb89d5

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index fb50652..63a5ab8d 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -169,15 +169,12 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
  		 */
  		int i, in, pg_offset = 0;

-		for (i = 0; i < b; i++) {
-			wait_on_buffer(bh[i]);
-			if (!buffer_uptodate(bh[i]))
-				goto block_release;
-		}
-
  		for (bytes = length; k < b; k++) {
  			in = min(bytes, msblk->devblksize - offset);
  			bytes -= in;
+			wait_on_buffer(bh[k]);
+			if (!buffer_uptodate(bh[k]))
+				goto block_release;
  			while (in) {
  				if (pg_offset == PAGE_CACHE_SIZE) {
  					page++;

Please send a revised v2 patch with this fix.  Thanks.

2. Your emailer corrupted the patch ...  This is a common occurrence with
modern (wysiwyg) emailers.  Please see

https://www.kernel.org/doc/Documentation/email-clients.txt

these days it's probably best to use git send-email.

In case you're curious, this is how the emailer corrupted the patch.
Your patch has

$ cat -vt /tmp/1-1-Squashfs-Optimized-uncompressed-buffer-loop.patch
diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
[SNIP]

@@ -169,12 +169,6 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
^I^I */
^I^Iint i, in, pg_offset = 0;

-^I^Ifor (i = 0; i < b; i++) {
-^I^I^Iwait_on_buffer(bh[i]);
-^I^I^Iif (!buffer_uptodate(bh[i]))
-^I^I^I^Igoto block_release;
-^I^I}
-
^I^Ifor (bytes = length; k < b; k++) {
^I^I^Iin = min(bytes, msblk->devblksize - offset);
^I^I^Ibytes -= in;
[SNIP]

This should have been


@@ -169,12 +169,6 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
<space>^I^I */
<space>^I^Iint i, in, pg_offset = 0;

-^I^Ifor (i = 0; i < b; i++) {
-^I^I^Iwait_on_buffer(bh[i]);
-^I^I^Iif (!buffer_uptodate(bh[i]))
-^I^I^I^Igoto block_release;
-^I^I}
-
<space>^I^Ifor (bytes = length; k < b; k++) {
<space>^I^I^Iin = min(bytes, msblk->devblksize - offset);
<space>^I^I^Ibytes -= in;

where <space> should be read as " ",  i.e. it has eliminated the leading
space before the tabs.

Phillip

ps Manish, you will have received an earlier version of this email
sent via gmail (where I received the patch email).  Unfortunately Google
has forced everyone onto its new compose, and this appears to now send
html, which fsdevel and lkml sensibly rejected.

