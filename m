Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbaHAQ5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:57:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58458 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHAQ5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:57:05 -0400
Date: Fri, 1 Aug 2014 17:56:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Harris <jefftharris@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Harris <jharris@westell.com>
Subject: Re: [PATCH] jffs2: Re-enable write-buffering after filesystem sync
Message-ID: <20140801165607.GM18016@ZenIV.linux.org.uk>
References: <1406909172-7219-1-git-send-email-jharris@westell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406909172-7219-1-git-send-email-jharris@westell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 12:06:12PM -0400, Jeff Harris wrote:

> +	spin_lock(&c->wbuf_dwork_lock);
>  	cancel_delayed_work_sync(&c->wbuf_dwork);

Umm...  Usually ..._sync in function name is a sign of potential sleeper,
and calling those under a spinlock is a bad idea.

And looking at the definition of cancel_delayed_work_sync() turns up the
following call chain: cancel_delayed_work_sync() -> __cancel_work_timer() ->
flush_work() -> wait_for_completion(), which definitely isn't something
you should ever do under a spinlock.

While we are at it, you follow that with
> +	c->wbuf_queued = 0;
> +	spin_lock(&c->wbuf_dwork_lock);
which would be broken even if cancel_delayed_work_sync() hadn't blocked.
That's easily fixed, of course, (s/lock/unlock/).  cancel_delayed_work_sync()
under a spinlock is more serious...
