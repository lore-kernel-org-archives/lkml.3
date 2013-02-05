Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab3BERUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:20:23 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60599 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab3BERUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:20:20 -0500
Date: Tue, 5 Feb 2013 09:20:15 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Hillf Danton <dhillf@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: next-20130117 - kernel BUG with aio
Message-ID: <20130205172015.GA27179@google.com>
References: <3544.1358774694@turing-police.cc.vt.edu>
 <CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com>
 <2553.1358890098@turing-police.cc.vt.edu>
 <20130131135952.77cf5d3a.akpm@linux-foundation.org>
 <20130201003727.GK12631@moria.home.lan>
 <5602.1360079580@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5602.1360079580@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 10:53:00AM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 31 Jan 2013 16:37:27 -0800, Kent Overstreet said:
> > On Thu, Jan 31, 2013 at 01:59:52PM -0800, Andrew Morton wrote:
> > > Did this get fixed?
> 
> > With the patches I sent you, yes - not seeing a new linux-next tree yet?
> 
> Well, it's a mixed bag at my end.  Finally got a chance to do some more
> testing, and:
> 
> 1) next-20130128 didn't show anything in dmesg, but my VirtualBox Windows 7
> images appear to livelock on the way up - the Windows throbber would keep
> going, but it never made any actual progress towards booting. (Part of the
> delay was fixing a next-20121224 environment, and then discovering it
> took Windows *two* reboot cycles to get its act back together after getting
> into that hung state).
> 
> 2_ next-20130128 plus the following 3 patches:
> 
> Subject: [PATCH 1/3] aio: Fix a null pointer deref in batch_complete_aio
> Subject: [PATCH 3/3] aio-use-cancellation-list-lazily-fix
> Subject: [PATCH 2/3] aio-kill-ki_retry-fix-fix

The "smoosh struct kiocb" patch also needs to be dropped. That causes
aio_rw_vect_retry() to check ki_nbytes/ki_left after they've been
overwritten by aio_complete(), which causes it to return an error when
it shouldn't have, which causes aio_run_iocb() to double complete the
iocb causing put_reqs_available() to be called twice and the count
screwed up.

> VirtualBox appears to be functional (I did 2 complete boot/shutdown
> sequences of both a 32-bit and 64-bit Win7 Enterprise image). *HOWEVER*,
> I saw 3 of these in dmesg:
> 
> [  668.278624] WARNING: at fs/aio.c:348 put_ioctx+0x1c0/0x241()
> 
> [  668.278652] Call Trace:
> [  668.278660]  [<ffffffff8102ed10>] warn_slowpath_common+0x7c/0x96
> [  668.278665]  [<ffffffff8102edc9>] warn_slowpath_null+0x15/0x17
> [  668.278669]  [<ffffffff8114c562>] put_ioctx+0x1c0/0x241
> [  668.278673]  [<ffffffff8114d42a>] sys_io_destroy+0x4c/0x5c
> [  668.278679]  [<ffffffff8160c112>] system_call_fastpath+0x16/0x1b
> 
> and the code there says:
> 
>         WARN_ON(atomic_read(&ctx->reqs_available) > ctx->nr);
> 
> which leaves me wondering exactly how we exited the while loop
> just above - is the intention that it loop until reqs_available == ctx->nr
> exactly?  Looks like if 'avail' is anything other than exactly 1 in
> that while loop, we can be at a state where reqs_avail == (ctx->nr -1),
> get 'avail=2', do the atomic_add, fall out of the loop, and trigger
> the WARN_ON.
> 
> Damned if I see how that can happen though....
> 
> 
> 
> 
> 
> 
> 


