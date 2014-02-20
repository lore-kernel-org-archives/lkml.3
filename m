Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbaBTSRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:17:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640AbaBTSRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:17:47 -0500
Message-ID: <530646C8.1070206@redhat.com>
Date: Thu, 20 Feb 2014 13:17:44 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Mateusz Guzik <mguzik@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kref: oops on zero or negative refcount
References: <1392918299-673-1-git-send-email-mguzik@redhat.com> <20140220181440.GA31506@redhat.com>
In-Reply-To: <20140220181440.GA31506@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 01:14 PM, Dave Jones wrote:
> On Thu, Feb 20, 2014 at 06:44:59PM +0100, Mateusz Guzik wrote:
>  > In use after free situations, it is possible for one thread to write to
>  > memory that has just been reallocated to a new user. This could open up
>  > potential security issues.
>  > 
>  > diff --git a/include/linux/kref.h b/include/linux/kref.h
>  > index 484604d..c3f8a0a 100644
>  > --- a/include/linux/kref.h
>  > +++ b/include/linux/kref.h
>  > @@ -43,8 +43,10 @@ static inline void kref_get(struct kref *kref)
>  >  	/* If refcount was 0 before incrementing then we have a race
>  >  	 * condition when this kref is freeing by some other thread right now.
>  >  	 * In this case one should use kref_get_unless_zero()
>  > +	 *
>  > +	 * Terminate the current thread to stop potential security exploits.
>  >  	 */
>  > -	WARN_ON_ONCE(atomic_inc_return(&kref->refcount) < 2);
>  > +	BUG_ON(atomic_inc_return(&kref->refcount) < 2);
> 
> This isn't "terminating the thread", this is "lock up the box".

Only if kref_get holds a lock while encountering a refcount
underflow, right?

-- 
All rights reversed
