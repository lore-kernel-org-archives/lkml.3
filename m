Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab3GMQ6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 12:58:30 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51360 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3GMQ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 12:58:28 -0400
Message-ID: <51E18730.2020105@hitachi.com>
Date: Sun, 14 Jul 2013 01:58:24 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v6 01/14] spinlock: A new lockref structure for lockless
 update of refcount
References: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com> <1373332204-10379-2-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1373332204-10379-2-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2013/07/09 10:09), Waiman Long wrote:> +/**
> + * lockref_put_or_lock - decrements count unless count <= 1 before decrement
> + * @lockcnt: pointer to lockref structure
> + * Return: 1 if count updated successfully or 0 if count <= 1 and lock taken
> + *
> + * The only difference between lockref_put_or_lock and lockref_put is that
> + * the former function will hold the lock on return while the latter one
> + * will free it on return.
> + */
> +static __always_inline int lockref_put_or_locked(struct lockref *lockcnt)

Here is a function name typo. _locked should be _lock.
And also, I think we should take a note here to tell this function does *not*
guarantee lockcnt->refcnt == 0 or 1 until unlocked if this returns 0.

> +{
> +	spin_lock(&lockcnt->lock);
> +	if (likely(lockcnt->refcnt > 1)) {
> +		lockcnt->refcnt--;
> +		spin_unlock(&lockcnt->lock);
> +		return 1;
> +	}
> +	return 0;
> +}

Using this implementation guarantees lockcnt->refcnt == 0 or 1 until unlocked
if this returns 0.

However, the below one looks not guarantee it. Since lockref_add_unless
and spinlock are not done atomically, there is a chance for someone
to increment it right before locking.

Or, I missed something?

> +/**
> + * lockref_put_or_lock - Decrements count unless the count is <= 1
> + *			 otherwise, the lock will be taken
> + * @lockcnt: pointer to struct lockref structure
> + * Return: 1 if count updated successfully or 0 if count <= 1 and lock taken
> + */
> +int
> +lockref_put_or_lock(struct lockref *lockcnt)
> +{
> +	if (lockref_add_unless(lockcnt, -1, 1))
> +		return 1;
> +	spin_lock(&lockcnt->lock);
> +	return 0;
> +}

BTW, it looks that your dcache patch knows this and keeps double check for
the case of lockcnt->refcnt > 1 in dput().

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

