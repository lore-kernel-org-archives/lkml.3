Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab3AOSja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:39:30 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47133 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab3AOSj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:39:28 -0500
Date: Tue, 15 Jan 2013 10:39:24 -0800
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
Message-ID: <20130115183924.GF2668@htj.dyndns.org>
References: <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <Pine.LNX.4.44L0.1301151300200.11786-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301151300200.11786-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

On Tue, Jan 15, 2013 at 01:20:58PM -0500, Alan Stern wrote:
> It may not be so easy.  When the SCSI async thread probes the new disk, 
> it has to do I/O.  So it needs to use a scheduler.
> 
> But maybe it could use a built-in trivial scheduler until the proper 
> one is loaded.  Then the loading could be asynchronous.

It can be done.  Noop is always built-in and block IO can do IOs with
noop.  The problem here is that request_module() is done synchronously
during evelator_init().  We can punt that to a work item so that the
elevator is switched on load completion.  There are some nastiness
involved tho - if module probing returns before elevator switch
happens, the userland can observe elevator being switched after some
indetermined short period of time, which can, for example, break
scripts adjusting elevator knobs and etc...

I *think* it'll be best to allow scoped synchronization of async ops.
Looking into it.

Thanks.

-- 
tejun
