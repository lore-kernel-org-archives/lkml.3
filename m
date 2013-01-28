Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab3A1Ovw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:51:52 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:63421 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab3A1Ovt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:51:49 -0500
Date: Mon, 28 Jan 2013 18:51:44 +0400
From: Vasily Kulikov <segoon@openwall.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH review 1/6] userns: Avoid recursion in put_user_ns
Message-ID: <20130128145144.GA4677@cachalot>
References: <87ehh8it9s.fsf@xmission.com>
 <877gn0it3t.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gn0it3t.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 18:19 -0800, Eric W. Biederman wrote:
> 
> When freeing a deeply nested user namespace free_user_ns calls
> put_user_ns on it's parent which may in turn call free_user_ns again.
> When -fno-optimize-sibling-calls is passed to gcc one stack frame per
> user namespace is left on the stack, potentially overflowing the
> kernel stack.  CONFIG_FRAME_POINTER forces -fno-optimize-sibling-calls
> so we can't count on gcc to optimize this code.
> 
> Remove struct kref and use a plain atomic_t.  Making the code more
> flexible and easier to comprehend.  Make the loop in free_user_ns
> explict to guarantee that the stack does not overflow with
> CONFIG_FRAME_POINTER enabled.
> 
> I have tested this fix with a simple program that uses unshare to
> create a deeply nested user namespace structure and then calls exit.
> With 1000 nesteuser namespaces before this change running my test
> program causes the kernel to die a horrible death.  With 10,000,000
> nested user namespaces after this change my test program runs to
> completion and causes no harm.
> 
> Pointed-out-by: Vasily Kulikov <segoon@openwall.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Looks sane, thanks.

Acked-by: Vasily Kulikov <segoon@openwall.com>

The second bug I've noted in the same email (OOM) looks like should be
"fixed" by using memcg to limit kernel memory.  So, I'm fine with this
side of user_ns :)

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
