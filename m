Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbaJCSbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:31:52 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35750 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbaJCSbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:31:50 -0400
Date: Fri, 3 Oct 2014 11:31:47 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Jeff Moyer <jmoyer@redhat.com>,
        Slava Pestov <sp@daterainc.com>
Subject: Re: [PATCH] aio: Fix return code of io_submit() (RFC)
Message-ID: <20141003183147.GE17903@daterainc.com>
References: <1412359693-2535-1-git-send-email-kmo@daterainc.com>
 <542EE753.20005@kernel.dk>
 <20141003182220.GA17057@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003182220.GA17057@kvack.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 02:22:20PM -0400, Benjamin LaHaise wrote:
> On Fri, Oct 03, 2014 at 12:13:39PM -0600, Jens Axboe wrote:
> > How are applications supposed to deal with ENOMEM? I think the answer 
> > here is that they can't, it would be a fatal condition. AIO must provide 
> > isn't own guarantee of progress, with a mempool or similar.
> 
> I'm not sure if using a mempool is appropriate for allocations that are 
> driven by userland code.  At least with an ENOMEM error, an application 
> could free up some of the memory it allocated and possibly recover the 
> system.

I guess it's going to depend on the application... some applications really want
to always make forward progress (much like a lot of code in the kernel), so
they're going to want the mempool semantics and we in the kernel are in a much
better position to implement that correctly (think of all the applications that
are just going to sleep and retry on -ENOMEM).

we kind of want another flag in the syscall args that's the moral equivalent of
MSG_DONTWAIT but for memory allocations; it'd translate into "mempool +
GFP_KERNEL, or GFP_NOWAIT".

not that I'm actually going to implement that :)
