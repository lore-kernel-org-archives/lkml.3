Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbaGYHrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:47:18 -0400
Received: from ppsw-40.csi.cam.ac.uk ([131.111.8.140]:47195 "EHLO
	ppsw-40.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaGYHrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:47:15 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] ntfs: avoid incorrectly release for root inode in fill_super
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <002901cfa7af$c2024dc0$4606e940$@samsung.com>
Date: Fri, 25 Jul 2014 08:47:07 +0100
Cc: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <30788489-8F1D-416B-AF88-A547F2B66330@tuxera.com>
References: <002901cfa7af$c2024dc0$4606e940$@samsung.com>
To: Chao Yu <chao2.yu@samsung.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

NAK

This patch is incorrect.  Perhaps you failed to see the ihold() above the d_make_root() call?  That means we hold two references on the inode - one from the load_system_files()::ntfs_iget() and one from the ihold() before d_make_root().

Thus in the error code path d_make_root() does iput() which releases one reference and then we do iput() in the error handling path of ntfs_fill_super() which releases the second reference.

Best regards,

	Anton

On 25 Jul 2014, at 03:25, Chao Yu <chao2.yu@samsung.com> wrote:

> In d_make_root, when we fail to allocate dentry for root inode, we will iput
> root inode in this function.
> So we do not need to release this inode again at d_make_root's caller.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
> fs/ntfs/super.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index 6c3296e..99c5cc6 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c
> @@ -2975,7 +2975,11 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
> 			vol->secure_ino = NULL;
> 		}
> 	}
> -	iput(vol->root_ino);
> +
> +	/*
> +	 * Just set NULL value here because we have already iput root_ino
> +	 * in d_make_root.
> +	 */
> 	vol->root_ino = NULL;
> 	iput(vol->lcnbmp_ino);
> 	vol->lcnbmp_ino = NULL;

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

