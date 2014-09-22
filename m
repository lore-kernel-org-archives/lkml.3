Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaIVLB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 07:01:59 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:33676 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaIVLB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 07:01:57 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] Fix nasty 32-bit overflow bug in buffer i/o code.
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <alpine.LSU.2.11.1409220249390.2396@eggly.anvils>
Date: Mon, 22 Sep 2014 12:01:53 +0100
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <AACB47F9-EC00-4060-BE7F-E10468C146BC@cam.ac.uk>
References: <Pine.LNX.4.64.1409220042400.2595@hermes-1.csi.cam.ac.uk> <alpine.LSU.2.11.1409212122180.1182@eggly.anvils> <B2F9905E-8D29-45A0-8A15-B4EDA2B9B6AF@cam.ac.uk> <alpine.LSU.2.11.1409220249390.2396@eggly.anvils>
To: Hugh Dickins <hughd@google.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 22 Sep 2014, at 11:36, Hugh Dickins <hughd@google.com> wrote:
> On Mon, 22 Sep 2014, Anton Altaparmakov wrote:
>> On 22 Sep 2014, at 05:43, Hugh Dickins <hughd@google.com> wrote:
>>> On Mon, 22 Sep 2014, Anton Altaparmakov wrote:
>>>> Any code that uses __getblk() and thus bread(), breadahead(), sb_bread(), 
>>>> sb_breadahead(), sb_getblk(), and calls it using a 64-bit block on a 
>>>> 32-bit arch (where "long" is 32-bit) causes an inifinite loop in 
>>>> __getblk_slow() with an infinite stream of errors logged to dmesg like 
>>>> this:
>>>> 
>>>> __find_get_block_slow() failed. block=6740375944, b_blocknr=2445408648
>>>> b_state=0x00000020, b_size=512
>>>> device sda1 blocksize: 512
>>>> 
>>>> Note how in hex block is 0x191C1F988 and b_blocknr is 0x91C1F988 i.e. the 
>>>> top 32-bits are missing (in this case the 0x1 at the top).
>>>> 
>>>> This is because grow_dev_page() was broken in commit 676ce6d5ca30: "block: 
>>>> replace __getblk_slow misfix by grow_dev_page fix" by Hugh Dickins so that 
>>>> it now has a 32-bit overflow due to shifting the block value to the right 
>>>> so it fits in 32-bits and storing the result in pgoff_t variable which is 
>>>> 32-bit and then passing the pgoff_t variable left-shifted as the block 
>>>> number which causes the top bits to get lost as the pgoff_t is not type 
>>>> cast to sector_t / 64-bit before the shift.
>>>> 
>>>> This patch fixes this issue by type casting "index" to sector_t before 
>>>> doing the left shift.
>>>> 
>>>> Note this is not a theoretical bug but has been seen in the field on a 
>>>> 4TiB hard drive with logical sector size 512 bytes.
>>>> 
>>>> This patch has been verified to fix the infinite loop problem on 3.17-rc5 
>>>> kernel using a 4TB disk image mounted using "-o loop".  Without this patch 
>>>> doing a "find /nt" where /nt is an NTFS volume causes the inifinite loop 
>>>> 100% reproducibly whilst with the patch it works fine as expected.
>>>> 
>>>> Signed-off-by: Anton Altaparmakov <aia21@cantab.net>
>>>> Cc: stable@vger.kernel.org # 3.6 3.8 3.10 3.12 3.14 3.16
>>> 
>>> Acked-by: Hugh Dickins <hughd@google.com>
>>> 
>>> Yes indeed, that's bad, and entirely my fault (though it took me a while
>>> to see how the "block = index << sizebits" which was there before was okay,
>> 
>> Ouch.  I failed to see that (I admit I did not pay too much attention to the original code - I just used "git blame" to find out which commit put that code in place - my bad).  It was never ok!  I went back to 2.6.12-rc2 (original commit to git Linus' kernel repository) and that is also affected.  That implies this is the first time anyone has used a 4TiB disk with 512 byte sectors with NTFS where Windows had previously created a file/directory with an attribute list attribute in it.  -  That is the only metadata type we use sb_bread() for and the disk image from the customer does contain it and I verified that is where the inifinite loop comes from.
> 
> Ow, that line needs some truncating itself :)
> 
> You generously interpret my words as seeing that for myself.
> No, thank you for following up: I had persuaded myself when writing
> before, that index would be promoted from pgoff_t to sector_t before
> shifting in the original assignment, but not when I passed it as arg.
> 
> I've resorted to writing a proggy to check, and it looks like I was
> earlier confused, and you are right, and that code was "always" wrong.
> 
> Not much use of 4TiB disks on 32-bit kernels I suppose.

Actually on embedded devices like broadband routers/home network NAS boxes/PVR boxes, etc it is very common to have 32-bit (on ARM/MIPS or more recently also x86) and more and more people are plugging in larger disks to store their music/videos/movies, etc...  So this is something that is on the up and going to become an increasing problem as large disks get cheaper and cheaper.

>> So it appears sb_bread() and friends have always been broken on 32-bit architectures when accessing blocks outside the range 2^32 - 1 and it appears google finds lots of occurrences of such infinite loops being reported but the fixes have always been to not make the calls in the first place.  No-one seems to have recognized that there is a genuine problem here before.
>> 
>> Still my patch stands correct and should be applied to all kernel versions that have your patch and older kernels should have an equivalent patch applied to fix them, too for people who run very old kernels.
> 
> Yes, though I'm now uncertain whether your patch is a bugfix or an
> enhancement.  Definitely a bugfix, given the infinite loops.  But the
> oldest code ("index = block >> sizebits; block = index << sizebits;")
> is so clearly trying to truncate block, that I wonder what departing
> from that might be letting us in for.

Having looked at it, I think I understand the original code and intention - it is not truncating the top bits, it is truncating the bottom bits, i.e. it is rounding down so that "block" becomes the first block in the page as that is what is needed to be passed into grow_dev_page().  And the shift right followed by shift left makes those bottom bits "fall off".

A perfectly valid alternative way would be to do a logical "and" with appropriate mask to mask out the bottom bits which would have the same effect but given the shift is already done to get the page index it is probably the same amount of CPU cycles to do a shift left as to do a logical and of the original value and as the page index will be in current registers probably even more efficient than reloading the original value from the stack.

> I see Andrew did 2.6.19's intervening e5657933863f ("grow_buffers()
> infinite loop fix"): let's hope that he has a clearer head in the
> morning than I have now - there's a chance that he might think it
> safer to extend that check to exclude your case, than take your patch.

I really don't think so.  His commit added a check to ensure the block is addressable using the page cache which is good but completely unrelated to not being able to access blocks outside 32-bits.

The whole point of having CONFIG_LBDAF is to allow 64-bit values for "block" on 32-bit architectures so it cannot be the intention here to limit it to 32-bits.

This was either an oversight when CONFIG_LBDAF was added back in the day or was a bug that was introduced since when whoever wrote that code either forgot that sector_t can be 64-bit even when pgoff_t is 32-bit or they failed to notice that the compiler will not extend pgoff_t to 64-bit before doing the left shift without an explicit type cast being present.

> I hope not, that would not please you; but right now I'm ruling
> myself out of grasping the issues here!

Fair enough.  I can only hope that Linus/Andrew will agree with my understanding which I am confident is correct.  (-:

Tthe fact that reading the disk works fine with my patch applied is quite good indication that other code related paths are fine as the 64-bit value passes all the way down the stack and the correct metadata is returned from the disk sector (verified by comparing what I can read from the disk using simple "dd" command).

Best regards,

	Anton

> Hugh
> 
>> 
>>> but my passing "index << sizebits" as arg to function very much not okay).
>>> Thank you, Anton.
>> 
>> You are welcome.
>> 
>>> But I see my commit was marked for stable 3.0 3.2 3.4 3.5: so your fix
>>> is needed in 3.2 and 3.4 longterm also (the others now beyond life).
>> 
>> You are quite right.  It needs to go back to all those kernels, too.  Thank you!
>> 
>> Best regards,
>> 
>> 	Anton
>> 
>>> Hugh
>>> 
>>>> ---
>>>> 
>>>> Linus, can you please apply this?  Alternatively, Andrew, can you please 
>>>> pick this up and send it to Linus?
>>>> 
>>>> It would be good it it can be applied for 3.17 as well as to all stable 
>>>> kernels >= 3.6 as they are all broken!
>>>> 
>>>> Thanks a lot in advance!
>>>> 
>>>> Best regards,
>>>> 
>>>> 	Anton
>>>> -- 
>>>> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
>>>> Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
>>>> Linux NTFS maintainer, http://www.linux-ntfs.org/
>>>> 
>>>> diff --git a/fs/buffer.c b/fs/buffer.c
>>>> index 8f05111..3588a80 100644
>>>> --- a/fs/buffer.c
>>>> +++ b/fs/buffer.c
>>>> @@ -1022,7 +1022,8 @@ grow_dev_page(struct block_device *bdev, sector_t block,
>>>> 		bh = page_buffers(page);
>>>> 		if (bh->b_size == size) {
>>>> 			end_block = init_page_buffers(page, bdev,
>>>> -						index << sizebits, size);
>>>> +						(sector_t)index << sizebits,
>>>> +						size);
>>>> 			goto done;
>>>> 		}
>>>> 		if (!try_to_free_buffers(page))
>>>> @@ -1043,7 +1044,8 @@ grow_dev_page(struct block_device *bdev, sector_t block,
>>>> 	 */
>>>> 	spin_lock(&inode->i_mapping->private_lock);
>>>> 	link_dev_buffers(page, bh);
>>>> -	end_block = init_page_buffers(page, bdev, index << sizebits, size);
>>>> +	end_block = init_page_buffers(page, bdev, (sector_t)index << sizebits,
>>>> +			size);
>>>> 	spin_unlock(&inode->i_mapping->private_lock);
>>>> done:
>>>> 	ret = (block < end_block) ? 1 : -ENXIO;

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

