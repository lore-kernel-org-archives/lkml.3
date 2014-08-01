Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaHARPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:15:48 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:44470 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHARPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:15:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140801165607.GM18016@ZenIV.linux.org.uk>
References: <1406909172-7219-1-git-send-email-jharris@westell.com>
	<20140801165607.GM18016@ZenIV.linux.org.uk>
Date: Fri, 1 Aug 2014 13:15:45 -0400
Message-ID: <CAGMfbUPOMKVkZuZtzoN-w5pTpjHMzYhrdaM2WuBdm7RSMsNYAw@mail.gmail.com>
Subject: Re: [PATCH] jffs2: Re-enable write-buffering after filesystem sync
From: Jeff Harris <jefftharris@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Harris <jharris@westell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 12:56 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Fri, Aug 01, 2014 at 12:06:12PM -0400, Jeff Harris wrote:
>
> > +     spin_lock(&c->wbuf_dwork_lock);
> >       cancel_delayed_work_sync(&c->wbuf_dwork);
>
> Umm...  Usually ..._sync in function name is a sign of potential sleeper,
> and calling those under a spinlock is a bad idea.
>
> And looking at the definition of cancel_delayed_work_sync() turns up the
> following call chain: cancel_delayed_work_sync() -> __cancel_work_timer() ->
> flush_work() -> wait_for_completion(), which definitely isn't something
> you should ever do under a spinlock.

The jffs2_dirty_trigger function calls queue_delayed_work under the spinlock.
I suppose the flag could be reset after the cancel so the dirty
trigger would see
the false value.

>
>
> While we are at it, you follow that with
> > +     c->wbuf_queued = 0;
> > +     spin_lock(&c->wbuf_dwork_lock);
> which would be broken even if cancel_delayed_work_sync() hadn't blocked.
> That's easily fixed, of course, (s/lock/unlock/).  cancel_delayed_work_sync()
> under a spinlock is more serious...

Whoops, sorry about that.

Jeff
