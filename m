Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161350AbaDPN6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:58:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161077AbaDPN6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:58:19 -0400
Date: Wed, 16 Apr 2014 15:57:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Chiang <pchiang@nvidia.com>
Cc: "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tj@kernel.org" <tj@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm : Avoid candidate task is equal to current task
Message-ID: <20140416135741.GA9407@redhat.com>
References: <1397617379-26895-1-git-send-email-pchiang@nvidia.com> <80341664FB79C2419999599F48F738410227327881@HKMAIL01.nvidia.com> <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Peter Chiang wrote:
>
> mm_update_next_owner() call from exit_mm() , and exit_mm()  change tsk->mm
> to NULL If p==c , It seems to be  impossible that mm == c->mm  (tsk->mm) .
> Because mm is non-NULL and  c->mm is NULL .

Confused, please see below.

> Fix kernel panic when finding a new owner for the mm and the new owner is
> equal to current onwer

Did you actually observe the panic ?

> diff --git a/kernel/exit.c b/kernel/exit.c index 6ed6a1d..aa98422 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -399,7 +399,7 @@ retry:
>  	 * here often
>  	 */
>  	do_each_thread(g, c) {
> -		if (c->mm == mm)
> +		if ((c != p) && (c->mm == mm))
>  			goto assign_new_owner;
>  	} while_each_thread(g, c);

p == current. This is always called with p->mm == NULL and mm != NULL.

So, if c->mm == mm then at least c->mm != NULL, and this means that
c == p is not possible?

And it seems that this is exactly what you meant above. So why do you
think we need this change?

Oleg.

