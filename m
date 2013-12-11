Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab3LKNe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:34:29 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53407 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3LKNe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:34:28 -0500
Date: Wed, 11 Dec 2013 14:34:23 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and
 fixes crash bugs
Message-ID: <20131211133423.GB3101@gmail.com>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
 <20131204084551.GA31772@gmail.com>
 <529FBA71.6070107@hitachi.com>
 <20131205102127.GA19923@gmail.com>
 <52A137B6.6030307@hitachi.com>
 <20131210152811.GA1195@gmail.com>
 <52A7CA0A.9060009@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A7CA0A.9060009@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> > So why are annotations needed at all? What can happen if an 
> > annotation is missing and a piece of code is probed which is also 
> > used by the kprobes code internally - do we crash, lock up, 
> > misbehave or handle it safely?
> 
> The kprobe has recursion detector, [...]

It's the 'current_kprobe' percpu variable, checked via 
kprobe_running(), right?

> [...] but it is detected in the kprobe exception(int3) handler, this 
> means that if we put a probe before detecting the recursion, we'll 
> do an infinite recursion.

So only the (presumably rather narrow) code path leading to the 
recursion detection code has to be annotated, correct?

> And also, even if we can detect the recursion, we can't stop the 
> kernel, we need to skip the probe. This means that we need to 
> recover to the main execution path by doing single step. As you may 
> know, since the single stepping involves the debug exception, we 
> have to avoid proving on that path too. Or we'll have an infinite 
> recursion again.

I don't see why this is needed: if a "probing is disabled" recursion 
flag is set the moment the first probe fires, and if it's only cleared 
once all processing is finished, then any intermediate probes should 
simply return early from int3 and not fire.

What am I missing?

Thanks,

	Ingo
