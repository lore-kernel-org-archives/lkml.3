Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaCWEgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 00:36:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55045 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaCWEgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 00:36:49 -0400
Date: Sun, 23 Mar 2014 04:36:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Imre Deak <imre.deak@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: fix dpath buffer corruption for too small buffers
Message-ID: <20140323043643.GA25566@ZenIV.linux.org.uk>
References: <1394666986-24727-1-git-send-email-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394666986-24727-1-git-send-email-imre.deak@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 01:29:46AM +0200, Imre Deak wrote:
> During dentry path lookups we can end up corrupting memory if the
> destination path buffer is too small. This is because prepend_path()
> and prepend() adjust the passed buffer length unconditionally, allowing
> for the buffer length to go negative. Then a later prepend_name() call
> will receive a negative length and convert this to unsigned before
> comparing it against the source string length leading to a possible
> memory corruption preceeding the destination buffer.
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 265e0ce..4015fd9 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2833,7 +2833,8 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
>  	u32 dlen = ACCESS_ONCE(name->len);
>  	char *p;
>  
> -	if (*buflen < dlen + 1)
> +	/* make sure we don't convert a negative value to unsigned int */
> +	if (*buflen < 0 || *buflen < dlen + 1)
>  		return -ENAMETOOLONG;
>  	*buflen -= dlen + 1;

It's much easier to fix, actually.  Look at the callers of prepend_name();
when it returns a negative value, they either discard the value left in
*buflen (__dentry_path()) or pass it back to their caller and return a
negative value themselves (prepend_path()).  The same is true for
prepend_path() (discared in __d_path(), d_absolute_path(), sys_getcwd();
passed to caller with negative return value in path_with_deleted()) and
path_with_deleted() (the only caller is d_path() and it always discards).

In other words, when prepend_name() returns -ENAMETOOLONG, it is free to
leave whatever it wants in *buflen.  So let's do what prepend() does -
subtract from *buflen, then check if the result has become negative.
Generates a better code than the original, actually...
