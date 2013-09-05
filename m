Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab3IEUnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:43:32 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:36851 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab3IEUn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:43:28 -0400
Message-ID: <5228ECE2.8070306@hp.com>
Date: Thu, 05 Sep 2013 16:43:14 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v2 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
References: <1378407316-59852-1-git-send-email-Waiman.Long@hp.com> <1378407316-59852-2-git-send-email-Waiman.Long@hp.com> <20130905200401.GU13318@ZenIV.linux.org.uk>
In-Reply-To: <20130905200401.GU13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 04:04 PM, Al Viro wrote:
> On Thu, Sep 05, 2013 at 02:55:16PM -0400, Waiman Long wrote:
>> +	const char *dname = ACCESS_ONCE(dentry->d_name.name);
>> +	u32 dlen = dentry->d_name.len;
>> +	int error;
>> +
>> +	if (likely(dname == (const char *)dentry->d_iname)) {
>> +		/*
>> +		 * Internal dname, the string memory is valid as long
>> +		 * as its length is not over the limit.
>> +		 */
>> +		if (unlikely(dlen>  sizeof(dentry->d_iname)))
>> +			return -EINVAL;
>> +	} else if (!dname)
>> +		return -EINVAL;
> Can't happen.
>> +	else {
>> +		const char *ptr;
>> +		u32 len;
>> +
>> +		/*
>> +		 * External dname, need to fetch name pointer and length
>> +		 * again under d_lock to get a consistent set and avoid
>> +		 * racing with d_move() which will take d_lock before
>> +		 * acting on the dentries.
>> +		 */
>> +		spin_lock(&dentry->d_lock);
>> +		dname = dentry->d_name.name;
>> +		dlen  = dentry->d_name.len;
>> +		spin_unlock(&dentry->d_lock);
>> +
>> +		if (unlikely(!dname || !dlen))
>> +			return -EINVAL;
> Can't happen.
>
>> +		/*
>> +		 * As the length and the content of the string may not be
>> +		 * valid, need to scan the string and return EINVAL if there
>> +		 * is embedded null byte within the length of the string.
>> +		 */
>> +		for (ptr = dname, len = dlen; len; len--, ptr++) {
>> +			if (*ptr == '\0')
>> +				return -EINVAL;
> Egads...  First of all, this is completely pointless - if you've grabbed
> ->d_name.name and ->d_name.len under ->d_lock, you don't *need* that crap.
> At all.  The whole point of that exercise is to avoid taking ->d_lock;
> _that_ is where the "read byte by byte until you hit NUL" comes from.
> And if you do that, you can bloody well just go ahead and store them in
> the target array *as* *you* *go*.  No reason to bother with memcpy()
> afterwards.

That is what I thought too. I am just not totally sure about it. So yes, 
I can scrap all these additional check.

As the internal dname buffer is at least 32 bytes, most dentries will 
use the internal buffer instead of allocating from kmem. IOW, the d_lock 
taking code path is unlikely to be used.

> Damnit, just grab len and name (no ->d_lock, etc.).  Check if you've got
> enough space in the buffer, treat "not enough" as an overflow.  Then
> proceed to copy the damn thing over there (starting at *buffer -= len)
> byte by byte, stopping when you've copied len bytes *or* when the byte you've
> got happens to be NUL.  Don't bother with EINVAL, etc. - just return to
> caller and let rename_lock logics take care of the races.  That's it - nothing
> more is needed.

OK, I will do that.

-Longman
