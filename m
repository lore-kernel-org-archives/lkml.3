Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaIIXVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 19:21:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaIIXVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 19:21:15 -0400
Date: Tue, 9 Sep 2014 16:21:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
Message-Id: <20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz>
References: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014 23:25:28 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:

> kfree() is happy to accept NULL pointer and does nothing in such case. 
> It's reasonable to expect it to behave the same if ERR_PTR is passed to 
> it.
> 
> Inspired by a9cfcd63e8d ("ext4: avoid trying to kfree an ERR_PTR 
> pointer").
> 
> ...
>
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3612,7 +3612,7 @@ void kfree(const void *objp)
>  
>  	trace_kfree(_RET_IP_, objp);
>  
> -	if (unlikely(ZERO_OR_NULL_PTR(objp)))
> +	if (unlikely(ZERO_OR_NULL_PTR(objp) || IS_ERR(objp)))
>  		return;

kfree() is quite a hot path to which this will add overhead.  And we
have (as far as we know) no code which will actually use this at
present.

How about a new

kfree_safe(...)
{
	if (IS_ERR(...))
		return;
	if (other-stuff-when-we-think-of-it)
		return;
	kfree(...);
}

?
