Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaBCRCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 12:02:38 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55542 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaBCRCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 12:02:37 -0500
Date: Mon, 3 Feb 2014 18:02:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] block: Stop abusing csd.list for fifo_time
Message-ID: <20140203170231.GC18068@localhost.localdomain>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
 <1387831171-5264-2-git-send-email-jack@suse.cz>
 <20140201164824.GA669@localhost.localdomain>
 <20140203144829.GA2542@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140203144829.GA2542@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 03:48:29PM +0100, Jan Kara wrote:
> On Sat 01-02-14 17:48:27, Frederic Weisbecker wrote:
> > On Mon, Dec 23, 2013 at 09:39:22PM +0100, Jan Kara wrote:
> > > Block layer currently abuses rq->csd.list.next for storing fifo_time.
> > > That is a terrible hack and completely unnecessary as well. Union
> > > achieves the same space saving in a cleaner way.
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > Hi Jan,
> > 
> > Taken as is, the patch is fine and it builds.
> > But later when I finally get rid of csd->list in a subsequent patch,
> > rq_fifo_clear() callers break the build.
> > 
> > This is because rq_fifo_clear() initialize the csd->list and I'm not
> > sure how to fix that leftover because I am not clear about the purpose
> > of that INIT_LIST_HEAD(): is it to reset fifo time or to prepare for
> > an IPI to be queued?
>   I'm convinced it is there to prepare IPI to be queued. So just removing
> the initialization as you did should be the right thing to do. You can
> easily verify that it is correct - you boot the kernel, switch to 'deadline'
> IO scheduler by doing
>   echo 'deadline' >/sys/block/sda/queue/scheduler
> and then do some IO. If it doesn't blow up, it is correct.

Ok that seem to work :)

> 
> > All in one it looks buggy because if this is to prepare for the IPI,
> > it's useless as csd.list is not a list head but just a node. Otherwise if it
> > is to reset fifo_time it's wrong because INIT_LIST_HEAD doesn't initialize
> > to 0.
>   Yup, I think it is useless.

Ok then I'll apply this change. I'm just moving it to a separate patch to lower
the chance of it being missed.

Thanks.
