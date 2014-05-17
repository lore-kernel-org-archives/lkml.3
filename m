Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030273AbaEQR0a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:26:30 -0400
Received: from ppsw-40.csi.cam.ac.uk ([131.111.8.140]:46877 "EHLO
	ppsw-40.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964823AbaEQR03 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:26:29 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] ntfs: Cleanup string initializations (char[] instead of char *)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=iso-8859-1
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <1400329522-17875-1-git-send-email-manuel.schoelling@gmx.de>
Date: Sat, 17 May 2014 18:26:24 +0100
Cc: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <134EE350-47BE-4403-8F39-DF587A631CE0@tuxera.com>
References: <1400329522-17875-1-git-send-email-manuel.schoelling@gmx.de>
To: =?iso-8859-1?Q?Manuel_Sch=F6lling?= <manuel.schoelling@gmx.de>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

NAK.

As Al Viro said in reply to one of your other patches, if you look at the assembler output you will see that the 'char te[] = "string"' generates dreadful code whilst the 'char *te = "string"' generates much better code thus if anything we should change all occurrences of 'char (.*)\[\] =' to "char *\1" instead...

If you think about it logically it actually makes sense, too.  In the 'char te[] = "string"' case we are telling the compiler to take a constant string "string" which will be stored both in the binary and once loaded in memory, then make a copy of it into the array "te" and that is exactly what the compiler does (if the string is short enough the compiler actually copies immediate values instead of storing the string elsewhere but that is still worse than just pointing to constant memory).  Whilst in the 'char *te = "string"' case we are telling the compiler to take a constant string (as previous case) and then assign the address of that string to the pointer variable "te".  Thus no copying takes place.  Thus one should never use the 'char te[] = "string"' form UNLESS you want to then mess about with the contents of the string in which case modifying "te[]" will work as it is a local copy but modifying "*te" will cause a crash or be ignored depending on whether you are programming in the kernel or user space because you are trying to modify a read-only memory segment...

Best regards,

	Anton

On 17 May 2014, at 13:25, Manuel Schölling <manuel.schoelling@gmx.de> wrote:

> Initializations like 'char *foo = "bar"' will create two variables: a static
> string and a pointer (foo) to that static string. Instead 'char foo[] = "bar"'
> will allocate only a declare a single variable and will end up in shorter
> assembly (according to Jeff Garzik on the KernelJanitor's TODO list).
> 
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
> ---
> fs/ntfs/inode.c |    2 +-
> fs/ntfs/super.c |    2 +-
> 2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
> index f47af5e..3975798 100644
> --- a/fs/ntfs/inode.c
> +++ b/fs/ntfs/inode.c
> @@ -2368,7 +2368,7 @@ int ntfs_truncate(struct inode *vi)
> 	ntfs_attr_search_ctx *ctx;
> 	MFT_RECORD *m;
> 	ATTR_RECORD *a;
> -	const char *te = "  Leaving file length out of sync with i_size.";
> +	const char te[] = "  Leaving file length out of sync with i_size.";
> 	int err, mp_size, size_change, alloc_change;
> 	u32 attr_len;
> 
> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index 9de2491..eb2c195 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c
> @@ -676,7 +676,7 @@ not_ntfs:
> static struct buffer_head *read_ntfs_boot_sector(struct super_block *sb,
> 		const int silent)
> {
> -	const char *read_err_str = "Unable to read %s boot sector.";
> +	const char read_err_str[] = "Unable to read %s boot sector.";
> 	struct buffer_head *bh_primary, *bh_backup;
> 	sector_t nr_blocks = NTFS_SB(sb)->nr_blocks;
> 
> -- 
> 1.7.10.4

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

