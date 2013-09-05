Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab3IEPbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:31:21 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:44519 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3IEPbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:31:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130905131814.GA24274@osiris>
References: <20130905131814.GA24274@osiris>
Date: Thu, 5 Sep 2013 08:31:19 -0700
X-Google-Sender-Auth: U194YLysFOOUdaKQ3jp18xCPMBc
Message-ID: <CA+55aFyZ8xLWiPcP3jcnVApQOqAvpo_fshSvGpdpW42iRutPcQ@mail.gmail.com>
Subject: Re: [PATCH] lockref: remove cpu_relax() again
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 6:18 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
>
> *If* however the cpu_relax() makes sense on other platforms maybe we could
> add something like we have already with "arch_mutex_cpu_relax()":

I actually think it won't.

The lockref cmpxchg isn't waiting for something to change - it only
loops _if_ something has changed, and rather than cpu_relax(), we most
likely want to try to take advantage of the fact that we have the
changed data in our exclusive cacheline, and try to get our ref update
out as soon as possible.

IOW, the lockref loop is not an idle loop like a spinlock "wait for
lock to be released", it's very much an active loop of "oops,
something changed".

And there can't be any livelock, since by definition somebody else
_did_ make progress. In fact, adding the cpu_relax() probably just
makes things much less fair - once somebody else raced on you, the
cpu_relax() now makes it more likely that _another_ cpu does so too.

That said, let's see Tony's numbers are. On x86, it doesn't seem to
matter, but as Tony noticed, the variability can be quite high (for
me, the numbers tend to be quite stable when running the test program
multiple times in a loop, but then variation between boots or after
having done something else can be quite big - I suspect the cache
access patterns end up varying wildly with different dentry layout and
hash chain depth).

              Linus
