Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717Ab3GDHTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:19:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933686Ab3GDHTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:19:36 -0400
Date: Thu, 4 Jul 2013 00:19:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-Id: <20130704001940.556438c3.akpm@linux-foundation.org>
In-Reply-To: <20130703044901.GI14996@dastard>
References: <20130701120037.GA6196@quack.suse.cz>
	<20130702062954.GA14996@dastard>
	<20130702081937.GA31770@quack.suse.cz>
	<20130702123835.GF14996@dastard>
	<20130702140508.GB31770@quack.suse.cz>
	<CA+55aFwZHOUCYvojbP9q3D5MDgCH7GttkUGiJerra9uyduFLKw@mail.gmail.com>
	<20130702165752.GA12179@quack.suse.cz>
	<CA+55aFxSY76aWEC04yREjFObPF3ZJFMHdczoT=yGmSpsg5hhyg@mail.gmail.com>
	<20130703030759.GG14996@dastard>
	<CA+55aFxN2-qZwBywE3b+RYyPLg1-ru5ZwJLHLohy0KJ0fD0vqA@mail.gmail.com>
	<20130703044901.GI14996@dastard>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jul 2013 14:49:01 +1000 Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Jul 02, 2013 at 08:28:42PM -0700, Linus Torvalds wrote:
> > On Tue, Jul 2, 2013 at 8:07 PM, Dave Chinner <david@fromorbit.com> wrote:
> > >>
> > >> Then that test would become
> > >>
> > >>         if (wbc->sync_mode == WB_SYNC_SINGLE) {
> > >>
> > >> instead, and now "sync_mode" would actually describe what mode of
> > >> syncing the caller wants, without that hacky special "we know what the
> > >> caller _really_ meant by looking at *which* caller it is".
> > >
> > > The problem is that all the code that currently looks for
> > > WB_SYNC_ALL for it's behavioural cue during writeback now has
> > > multiple different modes they have to handle.  IOWs, it's not a
> > > straight forward conversion process. WB_SYNC_ALL reaches right down
> > > into filesystem ->writepages implementations and they all need to be
> > > changed if we make up a new sync_mode behaviour.
> > 
> > I have to admit that I absolutely detest our current "sync_mode" to
> > begin with, so I'd personally be happy to see some major surgery in
> > this area.

Forgive me, I was young.

> 
> > WB_SYNC_NONE semantics would presumably be "just
> > start writeout" (so it would become WB_SYNC_WRITE), while WB_SYNC_ALL
> > would become (WB_SYNC_BEFORE | WB_SYNC_WRITE | WB_SYNC_AFTER), but
> > then the "for_sync" case would remove WB_SYNC_AFTER, because it does
> > its own waiting after.
> 
> Not exactly. WB_SYNC_NONE currently means "best effort writeback"

Yup.  WB_SYNC_NONE means "this is for memory cleaning" and WB_SYNC_ALL
means "this is for data integrity".  They're two quite different
concepts whose implementations share a ton of code.

That being said, yes, sync_mode is pretty dorky and switching to a set
of very carefully defined flags makes sense.

