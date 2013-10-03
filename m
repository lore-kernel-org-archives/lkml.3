Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3JCUws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:52:48 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:54134 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab3JCUwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:52:46 -0400
MIME-Version: 1.0
In-Reply-To: <20131003204142.GL13318@ZenIV.linux.org.uk>
References: <E1VRcGm-0008Er-EO@ZenIV.linux.org.uk>
	<CA+55aFzeDP6J4ekdn4-85yoXzX3xmEp_qc3npvqepJM+MFn=6Q@mail.gmail.com>
	<20131003105130.GE13318@ZenIV.linux.org.uk>
	<CA+55aFzh+n_2fs=aWcT_5gnLC_pWSHqQPJeQ+fg=+Xw7ib9=dQ@mail.gmail.com>
	<20131003174439.GG13318@ZenIV.linux.org.uk>
	<CA+55aFy5kA7ubyetouWsB0OnB5mMRAoyQ-4kbQsCVWARFaf9MA@mail.gmail.com>
	<20131003194351.GK13318@ZenIV.linux.org.uk>
	<CA+55aFw-Yp7xEG3cnU1hcVXAHNGkCoomm0NsUt_Adf=mrauSHw@mail.gmail.com>
	<20131003204142.GL13318@ZenIV.linux.org.uk>
Date: Thu, 3 Oct 2013 13:52:45 -0700
X-Google-Sender-Auth: 9V_CTYappPYIUIWxnuYPv4FtR5U
Message-ID: <CA+55aFybjMDwdfV2uoGL=8U4c1tytjMwk4sU187e6ha2xQ=3+Q@mail.gmail.com>
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 1:41 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> The problem is this:
> A = 1, B = 1
> CPU1:
> A = 0
> <full barrier>
> synchronize_rcu()
> read B
>
> CPU2:
> rcu_read_lock()
> B = 0
> read A
>
> Are we guaranteed that we won't get both of them seeing ones, in situation
> when that rcu_read_lock() comes too late to be noticed by synchronize_rcu()?

Yeah, I think we should be guaranteed that, because the
synchronize_rcu() will guarantee that all other CPU's go through an
idle period. So the "read A" on CPU2 cannot possibly see a 1 _unless_
it happens so early that synchronize_rcu() definitely sees it (ie it's
a "preexisting reader" by definition), in which case synchronize_rcu()
will be waiting for a subsequent idle period, in which case the B=0 on
CPU2 is not only guaranteed to happen but also be visible out, so the
"read B" on CPU1 will see 0. And that's true even if CPU2 doesn't have
an explicit memory barrier, because the "RCU idle" state implies that
it has gone through a barrier.

So I don't see how they could possibly see ones. Modulo terminal bugs
in synchronize_barrier() (which can be very slow, but for umount I
wouldn't worry). Or modulo my brain being fried.

                  Linus
