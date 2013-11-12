Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3KLLcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 06:32:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33640 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab3KLLcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 06:32:33 -0500
Date: Tue, 12 Nov 2013 12:32:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/boot changes for v3.13
Message-ID: <20131112113208.GC12849@pd.tnic>
References: <20131111170558.GA12741@gmail.com>
 <CAE9FiQWrzZB+wpSXGeQTPKi2o7MKvONFkk0_POe-E+wco07Erw@mail.gmail.com>
 <20131112103422.GA12849@pd.tnic>
 <20131112112338.GA12801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131112112338.GA12801@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 12:23:38PM +0100, Ingo Molnar wrote:
> So I suspect what Yinghai tried to say if CPU0 and CPU1 are not on the
> same node we do the printout incorrectly.

I hope your translation is correct :) I'd still like to get a
confirmation from him though.

> Arguably this was a pre-existing condition, but would be nice to fix
> it now that this code has emerged out of steady bitrot! :-)
>
> How difficult would it be in your opinion?

Well, I did try a weird, non-existant configuration:

kvm ... -smp 6 -numa node,nodeid=0,cpus=0\;2\;3 -numa node,nodeid=1,cpus=1\;4\;5

and what I get is:

[    0.068574] x86: Booting SMP configuration:
[    0.069006] .... node  #1, CPUs:      #1
[    0.147005] .... node  #0, CPUs:   #2 #3 #4 #5
[    0.445273] x86: Booted up 2 nodes, 6 CPUs

Before my cleanup and after removing the "fixing up alternatives"
message which hid things, the output looked like:

[    0.069621] smpboot: Booting Node   1, Processors  #   1 OK
[    0.146006] smpboot: Booting Node   0, Processors  #   2 #   3 #   4 #   5 OK
[    0.448320] Brought up 6 CPUs

The problem is not the indentation but that the current code slaps all
cpus on the last node, in this case node 0, because announce_cpu gets
the cores one by one.

A possible fix would be to collect the topology and dump it *only*
*after* the last core has been announced.

But before we do anything, I'd like to get a concrete system which has
that issue and we can talk about it then.

> Btw., while staring at that code once more I noticed the following
> small nit, there's a pre-existing weird way of writing the -1 literal:
>
>                           if (current_node > (-1))

It came from 2eaad1fddd7450a48ad464229775f97fbfe8af36.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
