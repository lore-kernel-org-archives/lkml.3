Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaJCSWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:22:23 -0400
Received: from kanga.kvack.org ([205.233.56.17]:44773 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428AbaJCSWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:22:20 -0400
Date: Fri, 3 Oct 2014 14:22:20 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Jeff Moyer <jmoyer@redhat.com>,
        Slava Pestov <sp@daterainc.com>
Subject: Re: [PATCH] aio: Fix return code of io_submit() (RFC)
Message-ID: <20141003182220.GA17057@kvack.org>
References: <1412359693-2535-1-git-send-email-kmo@daterainc.com> <542EE753.20005@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542EE753.20005@kernel.dk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 12:13:39PM -0600, Jens Axboe wrote:
> On 2014-10-03 12:08, Kent Overstreet wrote:
> >io_submit() could return -EAGAIN on memory allocation failure when it 
> >should
> >really have been returning -ENOMEM. This could confuse applications (i.e. 
> >fio)
> >since -EAGAIN means "too many requests outstanding, wait until completions 
> >have
> >been reaped" and if the application actually was tracking outstanding
> >completions this wouldn't make a lot of sense.
> >
> >NOTE:
> >
> >the man page seems to imply that the current behaviour (-EAGAIN on 
> >allocation
> >failure) has always been the case. I don't think it makes a lot of sense, 
> >but
> >this should probably be discussed more widely in case applications have 
> >somehow
> >come to rely on the current behaviour...
> 
> We can't really feasibly fix this, is my worry. Fio does track the 
> pending requests and does not get into a getevents() forever wait if it 
> gets -EAGAIN on submission. But before the fix, it would loop forever in 
> submission in -EAGAIN.

There are lots of instances in the kernel where out of memory is potentially 
exposed to the user.  If we're failing a memory allocation that is well under 
1KB, the system is probably completely hosed.

> How are applications supposed to deal with ENOMEM? I think the answer 
> here is that they can't, it would be a fatal condition. AIO must provide 
> isn't own guarantee of progress, with a mempool or similar.

I'm not sure if using a mempool is appropriate for allocations that are 
driven by userland code.  At least with an ENOMEM error, an application 
could free up some of the memory it allocated and possibly recover the 
system.

		-ben
-- 
"Thought is the essence of where you are now."
