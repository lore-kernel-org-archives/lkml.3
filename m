Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291Ab3KZW3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 17:29:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36653 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797Ab3KZW32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 17:29:28 -0500
Message-ID: <529520AB.2020407@zytor.com>
Date: Tue, 26 Nov 2013 14:28:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vitaly Mayatskikh <v.mayatskih@gmail.com>,
        "Murty, Ravi" <ravi.murty@intel.com>, neilb@suse.de
Subject: Re: copy_from_user_*() and buffer zeroing
References: <52950D7B.304@zytor.com> <20131126135454.b5e9597a998509f1ab43cee4@linux-foundation.org>
In-Reply-To: <20131126135454.b5e9597a998509f1ab43cee4@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 01:54 PM, Andrew Morton wrote:
> 
> Nine years ago:
> 
> commit 7079f897164cb14f616c785d3d01629fd6a97719
> Author: mingo <mingo>
> Date:   Fri Aug 27 17:33:18 2004 +0000
> 
>     [PATCH] Add a few might_sleep() checks
>     
>     Add a whole bunch more might_sleep() checks.  We also enable might_sleep()
>     checking in copy_*_user().  This was non-trivial because of the "copy_*_user()
>     in atomic regions" trick would generate false positives.  Fix that up by
>     adding a new __copy_*_user_inatomic(), which avoids the might_sleep() check.
>     
>     Only i386 is supported in this patch.
> 
> 
> I can't think of any reason why __copy_from_user_inatomic() should be
> non-zeroing.  But maybe I'm missing something - this would pretty
> easily permit uninitialised data to appear in pagecache and someone
> surely would have noticed..
> 

Yes, and the might_sleep() check is indeed bypassed.

However, the non-zeroing bit is currently motivated by the following
comment:

/**
 * __copy_from_user: - Copy a block of data from user space, with less
checking.
 * @to:   Destination address, in kernel space.
 * @from: Source address, in user space.
 * @n:    Number of bytes to copy.
 *
 * Context: User context only.  This function may sleep.
 *
 * Copy data from user space to kernel space.  Caller must check
 * the specified block with access_ok() before calling this function.
 *
 * Returns number of bytes that could not be copied.
 * On success, this will be zero.
 *
 * If some data could not be copied, this function will pad the copied
 * data to the requested size using zero bytes.
 *
 * An alternate version - __copy_from_user_inatomic() - may be called from
 * atomic context and will fail rather than sleep.  In this case the
 * uncopied bytes will *NOT* be padded with zeros.  See fs/filemap.h
 * for explanation of why this is needed.
 */

This comment is only present in the 32-bit code.  fs/filemap.h of course
no longer exists, however, the original commit seems to be
01408c4939479ec46c15aa7ef6e2406be50eeeca which puts a comment in the
(now defunct mm/filemap.h).

I have to say I don't follow the explanation in that patch.  It seems
like if you're concurrently reading a buffer being written you should
expect to get any kind of mismash...

Neil, is this still an issue?

	-hpa




