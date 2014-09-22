Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaIVKiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:38:22 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:65151 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaIVKiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:38:19 -0400
Date: Mon, 22 Sep 2014 03:36:30 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Anton Altaparmakov <aia21@cam.ac.uk>
cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Fix nasty 32-bit overflow bug in buffer i/o code.
In-Reply-To: <B2F9905E-8D29-45A0-8A15-B4EDA2B9B6AF@cam.ac.uk>
Message-ID: <alpine.LSU.2.11.1409220249390.2396@eggly.anvils>
References: <Pine.LNX.4.64.1409220042400.2595@hermes-1.csi.cam.ac.uk> <alpine.LSU.2.11.1409212122180.1182@eggly.anvils> <B2F9905E-8D29-45A0-8A15-B4EDA2B9B6AF@cam.ac.uk>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014, Anton Altaparmakov wrote:

> Hi Hugh,
> 
> On 22 Sep 2014, at 05:43, Hugh Dickins <hughd@google.com> wrote:
> > On Mon, 22 Sep 2014, Anton Altaparmakov wrote:
> >> Any code that uses __getblk() and thus bread(), breadahead(), sb_bread(), 
> >> sb_breadahead(), sb_getblk(), and calls it using a 64-bit block on a 
> >> 32-bit arch (where "long" is 32-bit) causes an inifinite loop in 
> >> __getblk_slow() with an infinite stream of errors logged to dmesg like 
> >> this:
> >> 
> >> __find_get_block_slow() failed. block=6740375944, b_blocknr=2445408648
> >> b_state=0x00000020, b_size=512
> >> device sda1 blocksize: 512
> >> 
> >> Note how in hex block is 0x191C1F988 and b_blocknr is 0x91C1F988 i.e. the 
> >> top 32-bits are missing (in this case the 0x1 at the top).
> >> 
> >> This is because grow_dev_page() was broken in commit 676ce6d5ca30: "block: 
> >> replace __getblk_slow misfix by grow_dev_page fix" by Hugh Dickins so that 
> >> it now has a 32-bit overflow due to shifting the block value to the right 
> >> so it fits in 32-bits and storing the result in pgoff_t variable which is 
> >> 32-bit and then passing the pgoff_t variable left-shifted as the block 
> >> number which causes the top bits to get lost as the pgoff_t is not type 
> >> cast to sector_t / 64-bit before the shift.
> >> 
> >> This patch fixes this issue by type casting "index" to sector_t before 
> >> doing the left shift.
> >> 
> >> Note this is not a theoretical bug but has been seen in the field on a 
> >> 4TiB hard drive with logical sector size 512 bytes.
> >> 
> >> This patch has been verified to fix the infinite loop problem on 3.17-rc5 
> >> kernel using a 4TB disk image mounted using "-o loop".  Without this patch 
> >> doing a "find /nt" where /nt is an NTFS volume causes the inifinite loop 
> >> 100% reproducibly whilst with the patch it works fine as expected.
> >> 
> >> Signed-off-by: Anton Altaparmakov <aia21@cantab.net>
> >> Cc: stable@vger.kernel.org # 3.6 3.8 3.10 3.12 3.14 3.16
> > 
> > Acked-by: Hugh Dickins <hughd@google.com>
> > 
> > Yes indeed, that's bad, and entirely my fault (though it took me a while
> > to see how the "block = index << sizebits" which was there before was okay,
> 
> Ouch.  I failed to see that (I admit I did not pay too much attention to the original code - I just used "git blame" to find out which commit put that code in place - my bad).  It was never ok!  I went back to 2.6.12-rc2 (original commit to git Linus' kernel repository) and that is also affected.  That implies this is the first time anyone has used a 4TiB disk with 512 byte sectors with NTFS where Windows had previously created a file/directory with an attribute list attribute in it.  -  That is the only metadata type we use sb_bread() for and the disk image from the customer does contain it and I verified that is where the inifinite loop comes from.

Ow, that line needs some truncating itself :)

You generously interpret my words as seeing that for myself.
No, thank you for following up: I had persuaded myself when writing
before, that index would be promoted from pgoff_t to sector_t before
shifting in the original assignment, but not when I passed it as arg.

I've resorted to writing a proggy to check, and it looks like I was
earlier confused, and you are right, and that code was "always" wrong.

Not much use of 4TiB disks on 32-bit kernels I suppose.

> 
> So it appears sb_bread() and friends have always been broken on 32-bit architectures when accessing blocks outside the range 2^32 - 1 and it appears google finds lots of occurrences of such infinite loops being reported but the fixes have always been to not make the calls in the first place.  No-one seems to have recognized that there is a genuine problem here before.
> 
> Still my patch stands correct and should be applied to all kernel versions that have your patch and older kernels should have an equivalent patch applied to fix them, too for people who run very old kernels.

Yes, though I'm now uncertain whether your patch is a bugfix or an
enhancement.  Definitely a bugfix, given the infinite loops.  But the
oldest code ("index = block >> sizebits; block = index << sizebits;")
is so clearly trying to truncate block, that I wonder what departing
from that might be letting us in for.

I see Andrew did 2.6.19's intervening e5657933863f ("grow_buffers()
infinite loop fix"): let's hope that he has a clearer head in the
morning than I have now - there's a chance that he might think it
safer to extend that check to exclude your case, than take your patch.

I hope not, that would not please you; but right now I'm ruling
myself out of grasping the issues here!

Hugh

> 
> > but my passing "index << sizebits" as arg to function very much not okay).
> > Thank you, Anton.
> 
> You are welcome.
> 
> > But I see my commit was marked for stable 3.0 3.2 3.4 3.5: so your fix
> > is needed in 3.2 and 3.4 longterm also (the others now beyond life).
> 
> You are quite right.  It needs to go back to all those kernels, too.  Thank you!
> 
> Best regards,
> 
> 	Anton
> 
> > Hugh
> > 
> >> ---
> >> 
> >> Linus, can you please apply this?  Alternatively, Andrew, can you please 
> >> pick this up and send it to Linus?
> >> 
> >> It would be good it it can be applied for 3.17 as well as to all stable 
> >> kernels >= 3.6 as they are all broken!
> >> 
> >> Thanks a lot in advance!
> >> 
> >> Best regards,
> >> 
> >> 	Anton
> >> -- 
> >> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
> >> Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
> >> Linux NTFS maintainer, http://www.linux-ntfs.org/
> >> 
> >> diff --git a/fs/buffer.c b/fs/buffer.c
> >> index 8f05111..3588a80 100644
> >> --- a/fs/buffer.c
> >> +++ b/fs/buffer.c
> >> @@ -1022,7 +1022,8 @@ grow_dev_page(struct block_device *bdev, sector_t block,
> >> 		bh = page_buffers(page);
> >> 		if (bh->b_size == size) {
> >> 			end_block = init_page_buffers(page, bdev,
> >> -						index << sizebits, size);
> >> +						(sector_t)index << sizebits,
> >> +						size);
> >> 			goto done;
> >> 		}
> >> 		if (!try_to_free_buffers(page))
> >> @@ -1043,7 +1044,8 @@ grow_dev_page(struct block_device *bdev, sector_t block,
> >> 	 */
> >> 	spin_lock(&inode->i_mapping->private_lock);
> >> 	link_dev_buffers(page, bh);
> >> -	end_block = init_page_buffers(page, bdev, index << sizebits, size);
> >> +	end_block = init_page_buffers(page, bdev, (sector_t)index << sizebits,
> >> +			size);
> >> 	spin_unlock(&inode->i_mapping->private_lock);
> >> done:
> >> 	ret = (block < end_block) ? 1 : -ENXIO;
> 
> -- 
> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
> University of Cambridge Information Services, Roger Needham Building
> 7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK
> 
> 
