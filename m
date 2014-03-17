Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbaCQJxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:53:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbaCQJxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:53:20 -0400
Date: Mon, 17 Mar 2014 10:53:17 +0100
From: Jan Kara <jack@suse.cz>
To: "dbasehore ." <dbasehore@chromium.org>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zento.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        bleung@chromium.org, sonnyrao@chromium.org,
        Luigi Semenzato <semenzato@chromium.org>
Subject: Re: [PATCH] backing_dev: Fix hung task on sync
Message-ID: <20140317095317.GD2210@quack.suse.cz>
References: <1392437537-27392-1-git-send-email-dbasehore@chromium.org>
 <20140218225548.GI31892@mtj.dyndns.org>
 <20140219092731.GA4849@quack.suse.cz>
 <20140219190139.GQ10134@htj.dyndns.org>
 <CAGAzgspTZnUh_qi=FeQ4hS4LRiexPccTyALMg3Gt1K0ZZq_MuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGAzgspTZnUh_qi=FeQ4hS4LRiexPccTyALMg3Gt1K0ZZq_MuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 15-03-14 13:22:53, dbasehore . wrote:
> Resurrecting this for further discussion about the root of the problem.
> 
> mod_delayed_work_if_later addresses the problem one way, but the
> problem is still there for mod_delayed_work.
  But flusher works care about only that one way, don't they? We always
want the flushing work to execute at min(timer so far, new time target). So
for that mod_delayed_work_if_later() works just fine.

> I think we could take
> another approach that doesn't modify the API, but still addresses
> (most of) the problem.
> 
> mod_delayed_work currently removes a work item from a workqueue if it
> is on it. Correct me if I'm wrong, but I don't think that this is
> necessarily required for mod_delayed_work to have the current
> behavior. We should be able to set the timer while a delayed_work is
> currently on a workqueue. If the delayed_work is still on the
> workqueue when the timer goes off, everything is fine. If it has left
> the workqueue, we can queue it again.
  But here you are relying on the fact that flusher works always want the
work to be executed immediately (i.e., they will be queued), or after some
fixed time T. So I agree what you suggest will work but changing the API as
Tejun described seems cleaner to me.

								Honza

> On Wed, Feb 19, 2014 at 11:01 AM, Tejun Heo <tj@kernel.org> wrote:
> > Hello, Jan.
> >
> > On Wed, Feb 19, 2014 at 10:27:31AM +0100, Jan Kara wrote:
> >>   You are the workqueue expert so you may know better ;) But the way I
> >> understand it is that queue_delayed_work() does nothing if the timer is
> >> already running. Since we queue flusher work to run either immediately or
> >> after dirty_writeback_interval we are safe to run queue_delayed_work()
> >> whenever we want it to run after dirty_writeback_interval and
> >> mod_delayed_work() whenever we want to run it immediately.
> >
> > Ah, okay, so it's always mod on immediate and queue on delayed.  Yeah,
> > that should work.
> >
> >> But it's subtle and some interface where we could say queue delayed work
> >> after no later than X would be easier to grasp.
> >
> > Yeah, I think it'd be better if we had something like
> > mod_delayed_work_if_later().  Hmm...
> >
> > Thanks.
> >
> > --
> > tejun
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
