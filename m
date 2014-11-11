Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaKKVgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:36:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46891 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbaKKVge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:36:34 -0500
Date: Tue, 11 Nov 2014 22:36:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Message-ID: <20141111213628.GP31490@pd.tnic>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A very big hmmm...

On Tue, Nov 11, 2014 at 12:56:52PM -0800, Andy Lutomirski wrote:
> This causes all non-NMI kernel entries from userspace to run on the
> normal kernel stack.

So one of the reasons #MC has its own stack is because we need a
known-good stack in such situations. What if the normal kernel stack is
corrupted too due to a #MC?

> This means that machine check recovery can happen in non-atomic
> context.  It also obviates the need for the paranoid_userspace path.
> 
> Borislav has referred to this idea as the tail wagging the dog.  I
> think that's okay -- the dog was pretty ugly.

And I still am not sure about this: so the #MC handler makes implicit
assumptions that while it is running nothing is going to interrupt it
and it can access MCA MSRs. If you switch to process context, another
#MC will preempt it and overwrite MCA MSRs. Which is a no-no.

So unless I'm missing something - and I probably am - I don't think
we can run #MC handler in process context. #MC is the highest prio
abort-type exception along with processor reset for a reason.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
