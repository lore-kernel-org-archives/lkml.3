Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaJCSV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:21:57 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:52252 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJCSVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:21:54 -0400
Date: Fri, 3 Oct 2014 11:21:51 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        Zach Brown <zab@zabbo.net>, Jeff Moyer <jmoyer@redhat.com>,
        Slava Pestov <sp@daterainc.com>
Subject: Re: [PATCH] aio: Fix return code of io_submit() (RFC)
Message-ID: <20141003182151.GD17903@daterainc.com>
References: <1412359693-2535-1-git-send-email-kmo@daterainc.com>
 <542EE753.20005@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542EE753.20005@kernel.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 12:13:39PM -0600, Jens Axboe wrote:
> On 2014-10-03 12:08, Kent Overstreet wrote:
> >io_submit() could return -EAGAIN on memory allocation failure when it should
> >really have been returning -ENOMEM. This could confuse applications (i.e. fio)
> >since -EAGAIN means "too many requests outstanding, wait until completions have
> >been reaped" and if the application actually was tracking outstanding
> >completions this wouldn't make a lot of sense.
> >
> >NOTE:
> >
> >the man page seems to imply that the current behaviour (-EAGAIN on allocation
> >failure) has always been the case. I don't think it makes a lot of sense, but
> >this should probably be discussed more widely in case applications have somehow
> >come to rely on the current behaviour...
> 
> We can't really feasibly fix this, is my worry. Fio does track the pending
> requests and does not get into a getevents() forever wait if it gets -EAGAIN
> on submission. But before the fix, it would loop forever in submission in
> -EAGAIN.
> 
> How are applications supposed to deal with ENOMEM? I think the answer here
> is that they can't, it would be a fatal condition. AIO must provide isn't
> own guarantee of progress, with a mempool or similar.

Well, even though the AIO code doesn't currently return -ENOMEM we definitely do
have random other driver/filesystem code that will return -ENOMEM if a random
GFP_KERNEL allocation fails (e.g. the dio code, if allocating a struct dio
fails). So I think there's precedent for this, and having it be a fatal error
when the system is under major memory pressure is not a crazy thing to do too.

But OTOH maybe we should just use a mempool there.

The argument against making it a mempool would be "we don't want io_submit() to
block; even if that's not the case today, we at least have a chance of fixing it
with the current setup. If we can't allocate memory for our asynchronous state,
we really can't do anything there except block or fail".

I'm not sure I have strong feelings one way or the other.
