Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3DKHeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:34:04 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:59915 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3DKHeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:34:01 -0400
Message-ID: <51666763.5050102@gmail.com>
Date: Thu, 11 Apr 2013 09:33:55 +0200
From: Pawel Zawora <pzawora@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [ 03/19] reiserfs: Fix warning and inode leak when deleting inode
 with xattrs
References: <20130410225026.833809117@linuxfoundation.org> <20130410225027.171506481@linuxfoundation.org>
In-Reply-To: <20130410225027.171506481@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After 4 days  with patch  filesystem is clean  (15 mln files 
deleted/unlinked, 17 mln files created or hardlinked ), no errors in dmesg.
Test of  files ACL - passed  (tested ~100 000 files/dirs)


On 2013-04-11 00:50, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Jan Kara <jack@suse.cz>
>
> commit 35e5cbc0af240778e61113286c019837e06aeec6 upstream.
>
> After commit 21d8a15a (lookup_one_len: don't accept . and ..) reiserfs
> started failing to delete xattrs from inode. This was due to a buggy
> test for '.' and '..' in fill_with_dentries() which resulted in passing
> '.' and '..' entries to lookup_one_len() in some cases. That returned
> error and so we failed to iterate over all xattrs of and inode.
>
> Fix the test in fill_with_dentries() along the lines of the one in
> lookup_one_len().
>
> Reported-by: Pawel Zawora <pzawora@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>   fs/reiserfs/xattr.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- a/fs/reiserfs/xattr.c
> +++ b/fs/reiserfs/xattr.c
> @@ -187,8 +187,8 @@ fill_with_dentries(void *buf, const char
>   	if (dbuf->count == ARRAY_SIZE(dbuf->dentries))
>   		return -ENOSPC;
>   
> -	if (name[0] == '.' && (name[1] == '\0' ||
> -			       (name[1] == '.' && name[2] == '\0')))
> +	if (name[0] == '.' && (namelen < 2 ||
> +			       (namelen == 2 && name[1] == '.')))
>   		return 0;
>   
>   	dentry = lookup_one_len(name, dbuf->xadir, namelen);
>
>
>

