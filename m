Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3IEUEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:04:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60816 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3IEUEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:04:07 -0400
Date: Thu, 5 Sep 2013 21:04:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v2 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130905200401.GU13318@ZenIV.linux.org.uk>
References: <1378407316-59852-1-git-send-email-Waiman.Long@hp.com>
 <1378407316-59852-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378407316-59852-2-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 02:55:16PM -0400, Waiman Long wrote:
> +	const char *dname = ACCESS_ONCE(dentry->d_name.name);
> +	u32 dlen = dentry->d_name.len;
> +	int error;
> +
> +	if (likely(dname == (const char *)dentry->d_iname)) {
> +		/*
> +		 * Internal dname, the string memory is valid as long
> +		 * as its length is not over the limit.
> +		 */
> +		if (unlikely(dlen > sizeof(dentry->d_iname)))
> +			return -EINVAL;
> +	} else if (!dname)
> +		return -EINVAL;
Can't happen.
> +	else {
> +		const char *ptr;
> +		u32 len;
> +
> +		/*
> +		 * External dname, need to fetch name pointer and length
> +		 * again under d_lock to get a consistent set and avoid
> +		 * racing with d_move() which will take d_lock before
> +		 * acting on the dentries.
> +		 */
> +		spin_lock(&dentry->d_lock);
> +		dname = dentry->d_name.name;
> +		dlen  = dentry->d_name.len;
> +		spin_unlock(&dentry->d_lock);
> +
> +		if (unlikely(!dname || !dlen))
> +			return -EINVAL;
Can't happen.

> +		/*
> +		 * As the length and the content of the string may not be
> +		 * valid, need to scan the string and return EINVAL if there
> +		 * is embedded null byte within the length of the string.
> +		 */
> +		for (ptr = dname, len = dlen; len; len--, ptr++) {
> +			if (*ptr == '\0')
> +				return -EINVAL;

Egads...  First of all, this is completely pointless - if you've grabbed
->d_name.name and ->d_name.len under ->d_lock, you don't *need* that crap.
At all.  The whole point of that exercise is to avoid taking ->d_lock;
_that_ is where the "read byte by byte until you hit NUL" comes from.
And if you do that, you can bloody well just go ahead and store them in
the target array *as* *you* *go*.  No reason to bother with memcpy()
afterwards.

Damnit, just grab len and name (no ->d_lock, etc.).  Check if you've got
enough space in the buffer, treat "not enough" as an overflow.  Then
proceed to copy the damn thing over there (starting at *buffer -= len)
byte by byte, stopping when you've copied len bytes *or* when the byte you've
got happens to be NUL.  Don't bother with EINVAL, etc. - just return to
caller and let rename_lock logics take care of the races.  That's it - nothing
more is needed.
