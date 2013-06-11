Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab3FKWAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 18:00:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab3FKWAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 18:00:43 -0400
Date: Tue, 11 Jun 2013 15:00:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, riel@redhat.com, walken@google.com,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] ipc: don't allocate with GFP_KERNEL inside rcu read
 lock
Message-Id: <20130611150041.18036ca0597e100a1b4fb2a2@linux-foundation.org>
In-Reply-To: <1370885029.1795.7.camel@buesod1.americas.hpqcorp.net>
References: <1370880870-23833-1-git-send-email-sasha.levin@oracle.com>
	<1370885029.1795.7.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jun 2013 10:23:49 -0700 Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:

> On Mon, 2013-06-10 at 12:14 -0400, Sasha Levin wrote:
> > ipc_addid() is protected by a rcu read lock, which means we can't allocate
> > using GFP_KERNEL inside it.
> > 
> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> > ---
> > 
> > Another option would be to call idr_preload from outside the read lock,
> > but that complicates the code much more than this fix. If that's the
> > preferred method to fix it I can resend that solution instead.
> > 
> 
> This issue was reported last week by Fengguang
> (http://www.spinics.net/lists/kernel/msg1545633.html#.UbYI9qqdmV8)
> 
> Your fix looks the simplest approach, but I'm not sure if doing the
> atomic allocation would trigger some other problem, as a side effect.
> Andrew?

It will fix the issue.  But GFP_ATOMIC is much less reliable than
GFP_KERNEL and such a switch should be viewed as a lame act of last
resort.

> A third option would be to simply revert the offending commit, leaving
> the rcu locking as it originally was.

That patch has other issues, as I described yesterday.  But there are
ten follow-on patches to that one and I assume that dropping
ipc-move-rcu-lock-out-of-ipc_addid.patch will create a mess.  It will
also create a combination which hasn't been tested by anyone.

