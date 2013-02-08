Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947223Ab3BHVoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:44:19 -0500
Received: from tetsuo.zabbo.net ([50.193.208.193]:38345 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947122Ab3BHVoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:44:18 -0500
Date: Fri, 8 Feb 2013 13:44:17 -0800
From: Zach Brown <zab@zabbo.net>
To: Kent Overstreet <koverstreet@google.com>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, linux-fsdevel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Improving AIO cancellation
Message-ID: <20130208214417.GX14246@lenny.home.zabbo.net>
References: <CAOMFOmXiEUnqkoQg6bA4N3jg5ERMKoydOdmn7djkpFyfZk19cg@mail.gmail.com>
 <20130208173811.GW14246@lenny.home.zabbo.net>
 <20130208211144.GF27179@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208211144.GF27179@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We don't know if the bio was succesfully cancelled until the bio is
> completed (and this doesn't change anything about how bio completion
> works) - if it was cancelled, the bi_end_io callback will get
> -ECANCELLED or something.

Yeah, I think that's the right design.

> This is very different from the existing AIO cancellation; KIF_CANCEL
> means "this kiocb _has been cancelled_". (sort of, I was just rereading
> that code and I'm convinced it's buggy).

I don't recall the details, but the last time I looked at it I was also
convinced that it was buggy.

> What we want is a new io_cancel_sane() syscall that doesn't return
> anything, and only marks the iocb as "cancellation pending". The
> completion would still get returned via io_getevents(), and userspace
> would find out if it was cancelled or not then.

Agreed.  I wonder if we can mash those semantics in to the existing call
somehow.  This *does* have access to the iocb, so our hands aren't as
tied as we are with io_setup()'s inability to request behavioural
changes.

Maybe we mark the submitted iocbs as ASYNC_BEST_EFFORT_CANCEL and then
io_cancel() on them can return success and completion will proceeed as
normal.  Maybe much more quickly with a cancelled status but maybe not.

- z
