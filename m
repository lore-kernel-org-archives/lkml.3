Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbaCTIO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 04:14:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261AbaCTIOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 04:14:02 -0400
Date: Thu, 20 Mar 2014 09:13:59 +0100
From: Jan Kara <jack@suse.cz>
To: Minchan Kim <minchan@kernel.org>
Cc: Jan Kara <jack@suse.cz>, John Stultz <john.stultz@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/3] Volatile Ranges (v11)
Message-ID: <20140320081359.GB32080@quack.suse.cz>
References: <1394822013-23804-1-git-send-email-john.stultz@linaro.org>
 <20140318151113.GA10724@gmail.com>
 <CALAqxLV=uRV825taKrnH2=p_kAf5f1PbQ7=J5MopFt9ATj=a3A@mail.gmail.com>
 <20140319004918.GB13475@bbox>
 <20140319101202.GE26358@quack.suse.cz>
 <20140320010954.GE16478@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140320010954.GE16478@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-03-14 10:09:54, Minchan Kim wrote:
> Hello,
> 
> On Wed, Mar 19, 2014 at 11:12:02AM +0100, Jan Kara wrote:
> > On Wed 19-03-14 09:49:18, Minchan Kim wrote:
> > > On Tue, Mar 18, 2014 at 11:07:50AM -0700, John Stultz wrote:
> > > > On Tue, Mar 18, 2014 at 8:11 AM, Minchan Kim <minchan@kernel.org> wrote:
> > > > > 1) SIGBUS
> > > > >
> > > > > It's one of the arguable issue because some user want to get a
> > > > > SIGBUS(ex, Firefox) while other want a just zero page(ex, Google
> > > > > address sanitizer) without signal so it should be option.
> > > > >
> > > > >         int vrange(start, len, VRANGE_VOLATILE|VRANGE_ZERO, &purged);
> > > > >         int vrange(start, len, VRANGE_VOLATILE|VRANGE_SIGNAL, &purged);
> > > > 
> > > > So, the zero-fill on volatile access feels like a *very* special case
> > > > to me, since a null page could be valid data in many cases. Since
> > > > support/interest for volatile ranges has been middling at best, I want
> > > > to start culling the stranger use cases. I'm open in the future to
> > > > adding a special flag or something if it really make sense, but at
> > > > this point, lets just get the more general volatile range use cases
> > > > supported.
> > > 
> > > I'm not sure it's special case. Because some user could reserve
> > > a big volatile VMA and want to use the range by circle queue for
> > > caching so overwriting could happen easily.
> > > We should call vrange(NOVOLATILE) to prevent SIGBUS right before
> > > overwriting. I feel it's unnecessary overhead and we could avoid
> > > the cost with VRANGE_ZERO.
> > > Do you think this usecase would be rare?
> >   If I understand it correctly the buffer would be volatile all the time
> > and userspace would like to opportunistically access it. Hum, but then with
> > your automatic zero-filling it could see half of the page with data and
> > half of the page zeroed out (the page got evicted in the middle of
> > userspace reading it). I don't think that's a very comfortable interface to
> > work with (you would have to very carefully verify the data you've read is
> > really valid). And frankly in most cases I'm afraid the application would
> > fail to do proper verification and crash randomly under memory pressure. So
> > I wouldn't provide VRANGE_ZERO unless I come across real people for which
> > avoiding marking the range as NONVOLATILE is a big deal and they are OK with
> > handling all the odd situations that can happen.
> 
> Plaes think following usecase.
> 
> Let's assume big volatile cacne.
> If there is request for cache, it should find a object in a cache
> and if it found, it should call vrange(NOVOLATILE) right before
> passing it to the user and investigate it was purged or not.
> If it wasn't purged, cache manager could pass the object to the user.
> But it's circular cache so if there is no request from user, cache manager
> always overwrites objects so it could encounter SIGBUS easily
> so as current sematic, cache manager always should call vrange(NOVOLATILE)
> right before the overwriting. Otherwise, it should register SIGBUS handler
> to unmark volatile by page unit. SIGH.
> 
> If we support VRANGE_ZERO, cache manager could overwrite object without
> SIGBUS handling or vrange(NOVOLATILE) call. Just need is vrange(NOVOLATILE)
> call while cache manager pass it to the user.
  OK, that makes some sense but I don't think we have to implement this
functionality in the beginning...
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
