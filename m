Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3AWVXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 16:23:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3AWVXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 16:23:00 -0500
Date: Wed, 23 Jan 2013 13:22:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] lockdep: make lockdep_assert_held() not have a return
 value
Message-Id: <20130123132259.27dcbace.akpm@linux-foundation.org>
In-Reply-To: <1358548303-21732-1-git-send-email-johannes@sipsolutions.net>
References: <1358548303-21732-1-git-send-email-johannes@sipsolutions.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2013 23:31:43 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> I recently made the mistake of writing:
> 
> foo = lockdep_dereference_protected(..., lockdep_assert_held(...));
> 
> which is clearly bogus. If lockdep is disabled in the
> config this would cause a compile failure, if it is
> enabled then it compiles and causes a puzzling warning
> about dereferencing without the correct protection.
> 
> Wrap the macro in "do { ... } while (0)" to also fail
> compile for this when lockdep is enabled.
> 
> ...
>
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -359,7 +359,9 @@ extern void lockdep_trace_alloc(gfp_t mask);
>  
>  #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
>  
> -#define lockdep_assert_held(l)	WARN_ON(debug_locks && !lockdep_is_held(l))
> +#define lockdep_assert_held(l)	do {				\
> +		WARN_ON(debug_locks && !lockdep_is_held(l));	\
> +	} while (0)
>  
>  #define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)

A sane fix would be to convert lockdep_assert_held() into a static
inline void C function.  But, alas, much of the lockdep API is designed
to work on "any type which has a field called dep_map", which was
rather a silly stunt IMO.

lockdep_depth() and lockdep_assert_held() may or may not evaluate their
argument, and this is runtime controllable.  whee.
