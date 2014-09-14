Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaINOMG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 10:12:06 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37265 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaINOME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 10:12:04 -0400
Message-ID: <5415A22F.2010900@gmail.com>
Date: Sun, 14 Sep 2014 17:11:59 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
CC: willy@linux.intel.com
Subject: Re: [PATCH v10 07/21] Replace XIP read and write with DAX I/O
References: <cover.1409110741.git.matthew.r.wilcox@intel.com> <8fac9e35ef81c93d15f4ab393b187c26e09c5366.1409110741.git.matthew.r.wilcox@intel.com>
In-Reply-To: <8fac9e35ef81c93d15f4ab393b187c26e09c5366.1409110741.git.matthew.r.wilcox@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 06:45 AM, Matthew Wilcox wrote:
> Use the generic AIO infrastructure instead of custom read and write
> methods.  In addition to giving us support for AIO, this adds the missing
> locking between read() and truncate().
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  MAINTAINERS        |   6 ++
>  fs/Makefile        |   1 +
>  fs/dax.c           | 195 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext2/file.c     |   6 +-
>  fs/ext2/inode.c    |   8 +-
>  include/linux/fs.h |  18 ++++-
>  mm/filemap.c       |   6 +-
>  mm/filemap_xip.c   | 234 -----------------------------------------------------
>  8 files changed, 229 insertions(+), 245 deletions(-)
>  create mode 100644 fs/dax.c
> 
<>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 90effcd..19bdb68 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1690,8 +1690,7 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
>  	loff_t *ppos = &iocb->ki_pos;
>  	loff_t pos = *ppos;
>  
> -	/* coalesce the iovecs and go direct-to-BIO for O_DIRECT */
> -	if (file->f_flags & O_DIRECT) {
> +	if (io_is_direct(file)) {
>  		struct address_space *mapping = file->f_mapping;
>  		struct inode *inode = mapping->host;
>  		size_t count = iov_iter_count(iter);
> @@ -2579,8 +2578,7 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	if (err)
>  		goto out;
>  
> -	/* coalesce the iovecs and go direct-to-BIO for O_DIRECT */
> -	if (unlikely(file->f_flags & O_DIRECT)) {
> +	if (io_is_direct(file)) {
>  		loff_t endbyte;
>  
>  		written = generic_file_direct_write(iocb, from, pos);

Hi Matthew

As pointed out by Dave Chinner, I think we must add the below hunks to this patch.
I do not see a case where it is allowed with current DAX code for any FS to
enable both DAX access/mmap in parallel to any buffered read/write.

Do we want to also put a
	WARN_ON(IS_DAX(inode));

In generic_perform_write and/or in extX->write_begin() ?

----
diff --git a/mm/filemap.c b/mm/filemap.c
index 19bdb68..22210c9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1719,7 +1719,8 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		 * and return.  Otherwise fallthrough to buffered io for
 		 * the rest of the read.
 		 */
-		if (retval < 0 || !iov_iter_count(iter) || *ppos >= size) {
+		if (retval < 0 || !iov_iter_count(iter) || *ppos >= size ||
+		    IS_DAX(inode)) {
 			file_accessed(file);
 			goto out;
 		}
@@ -2582,7 +2583,7 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		loff_t endbyte;
 
 		written = generic_file_direct_write(iocb, from, pos);
-		if (written < 0 || written == count)
+		if (written < 0 || written == count || IS_DAX(inode))
 			goto out;
 
 		/*
----

Thanks
Boaz

