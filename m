Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbaD1PNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:13:11 -0400
Received: from ppsw-40.csi.cam.ac.uk ([131.111.8.140]:55286 "EHLO
	ppsw-40.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbaD1PNJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:13:09 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH 1/1] fs/ntfs/mft.c: fix 2 sparse warnings
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <20140427121219.02069e58cd40f1b78e8b5971@skynet.be>
Date: Mon, 28 Apr 2014 16:13:06 +0100
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6E770B36-E0D6-4B98-B1AB-DE92E456BD72@tuxera.com>
References: <20140427121219.02069e58cd40f1b78e8b5971@skynet.be>
To: Fabian Frederick <fabf@skynet.be>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK.

I do not see why this is needed.  Not all sparse warnings need fixing.

What is so bad about a variable length array that we need to incur kmalloc overhead on each call?  I would have thought the CPU overhead of the kmalloc is a lot larger than any CPU overhead of a variable length array...

The array size is tiny - basically on all volumes mft_record_size is 1024 and blocksize is either 512 or 1024 thus the array size is either 1 or 2 pointers.  The reason it is dynamic is just in case Microsoft change their mind and increase the mft_record_size in a future NTFS/Windows version to something bigger than 1024 bytes, the current code would still cope fine.

Note mft_record_size is the "on disk inode size" thus it will never be much bigger and unlikely to ever change from the 1024 really.  A very long time ago when NTFS was being developed Microsoft used 2048 bytes but quickly changed it to 1024 as most inodes do not need anywhere near that much space for an inode.

Best regards,

	Anton

On 27 Apr 2014, at 11:12, Fabian Frederick <fabf@skynet.be> wrote:

> fs/ntfs/mft.c:471:33: warning: Variable length array is used.
> fs/ntfs/mft.c:676:33: warning: Variable length array is used.
> 
> This is untested.
> 
> Cc: Anton Altaparmakov <anton@tuxera.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> fs/ntfs/mft.c | 17 ++++++++++++-----
> 1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
> index 3014a36..eddb739 100644
> --- a/fs/ntfs/mft.c
> +++ b/fs/ntfs/mft.c
> @@ -468,7 +468,7 @@ int ntfs_sync_mft_mirror(ntfs_volume *vol, const unsigned long mft_no,
> 	struct page *page;
> 	unsigned int blocksize = vol->sb->s_blocksize;
> 	int max_bhs = vol->mft_record_size / blocksize;
> -	struct buffer_head *bhs[max_bhs];
> +	struct buffer_head **bhs;
> 	struct buffer_head *bh, *head;
> 	u8 *kmirr;
> 	runlist_element *rl;
> @@ -478,11 +478,14 @@ int ntfs_sync_mft_mirror(ntfs_volume *vol, const unsigned long mft_no,
> 
> 	ntfs_debug("Entering for inode 0x%lx.", mft_no);
> 	BUG_ON(!max_bhs);
> -	if (unlikely(!vol->mftmirr_ino)) {
> +	bhs = kmalloc(max_bhs * sizeof(struct buffer_head *), GFP_NOFS);
> +	if (unlikely(!bhs || !vol->mftmirr_ino)) {
> 		/* This could happen during umount... */
> 		err = ntfs_sync_mft_mirror_umount(vol, mft_no, m);
> -		if (likely(!err))
> +		if (likely(!err)) {
> +			kfree(bhs);
> 			return err;
> +		}
> 		goto err_out;
> 	}
> 	/* Get the page containing the mirror copy of the mft record @m. */
> @@ -632,6 +635,7 @@ err_out:
> 				"after umounting to correct this.", -err);
> 		NVolSetErrors(vol);
> 	}
> +	kfree(bhs);
> 	return err;
> }
> 
> @@ -673,7 +677,7 @@ int write_mft_record_nolock(ntfs_inode *ni, MFT_RECORD *m, int sync)
> 	unsigned int blocksize = vol->sb->s_blocksize;
> 	unsigned char blocksize_bits = vol->sb->s_blocksize_bits;
> 	int max_bhs = vol->mft_record_size / blocksize;
> -	struct buffer_head *bhs[max_bhs];
> +	struct buffer_head **bhs;
> 	struct buffer_head *bh, *head;
> 	runlist_element *rl;
> 	unsigned int block_start, block_end, m_start, m_end;
> @@ -689,7 +693,8 @@ int write_mft_record_nolock(ntfs_inode *ni, MFT_RECORD *m, int sync)
> 	 * There is no danger of races since the caller is holding the locks
> 	 * for the mft record @m and the page it is in.
> 	 */
> -	if (!NInoTestClearDirty(ni))
> +	bhs = kmalloc(max_bhs * sizeof(struct buffer_head *), GFP_NOFS);
> +	if (!bhs || !NInoTestClearDirty(ni))
> 		goto done;
> 	bh = head = page_buffers(page);
> 	BUG_ON(!bh);
> @@ -820,6 +825,7 @@ int write_mft_record_nolock(ntfs_inode *ni, MFT_RECORD *m, int sync)
> 		goto err_out;
> 	}
> done:
> +	kfree(bhs);
> 	ntfs_debug("Done.");
> 	return 0;
> cleanup_out:
> @@ -840,6 +846,7 @@ err_out:
> 		err = 0;
> 	} else
> 		NVolSetErrors(vol);
> +	kfree(bhs);
> 	return err;
> }
