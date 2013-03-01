Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3CAVy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 16:54:28 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:41456 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3CAVy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 16:54:26 -0500
Message-ID: <1362174860.3221.2.camel@thor.lan>
Subject: Re: WARNING: at lib/idr.c:678 idr_find_slowpath+0x97/0xc0()
From: Peter Hurley <peter@hurleysoftware.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, markus@trippelsdorf.de,
        linux-kernel@vger.kernel.org
Date: Fri, 01 Mar 2013 16:54:20 -0500
In-Reply-To: <20130301213511.GF2481@mtj.dyndns.org>
References: <20130228090846.GA249@x4>
	 <20130301133159.0711f81a.akpm@linux-foundation.org>
	 <20130301213511.GF2481@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 13:35 -0800, Tejun Heo wrote:
> Hello, Andrew.
> 
> On Fri, Mar 01, 2013 at 01:31:59PM -0800, Andrew Morton wrote:
> > okluar passed a negative `wd' into inotify_rm_watch()?
> > 
> > I wonder why it did that.  I doubt if inotify_add_watch() ever returns
> > negative descriptors, in which case I expect that okular's call to
> > inotify_add_watch() returned -1 and an errno and okular forgot to check
> > it, and later passed that -1 back into inotify_rm_watch().
> > 
> > Anyway, I guess we need to make inotify_add_watch() refuse to return
> > negative descriptors (presumably this is already the case due to idr
> > internals) and make inotify_rm_watch() trap negative values of `wd' up
> > front.
> > 
> > I wonder how many other such gremlins the IDR checking has added.
> 
> The WARN_ON() is just for cases where someone might be doing something
> crazy with the previous behavior of ignoring high bit.  Maybe I was
> being overly paranoid and we should just drop it from idr_find().

Can we revert the __lock_timer patch as well then?

On Mon, 2013-02-25 at 17:48 -0800, Tejun Heo wrote:
On Mon, Feb 25, 2013 at 08:46:11PM -0500, Peter Hurley wrote:
> > On Mon, 2013-02-25 at 17:40 -0800, Tejun Heo wrote:
> > > On Mon, Feb 25, 2013 at 08:37:12PM -0500, Peter Hurley wrote:
> > > > Since idr is used for syscall apis (to associate 'handles' with
> > > > internal structures), don't WARN with invalid input.
> > > > 
> > > > For example, POSIX timers are identified by timer_t id. These
> > > > ids are idr values. If userspace passes a representable timer_t id
> > > > value (eg, id < 0) but which was not previous allocated (since the
> > > > current idr api does not return negative idr values), then the
> > > > syscall properly returns an error; a WARN is unnecessary and
> > > > undesirable.
> > > 
> > > WARN_ON() on negative was intentional.  Because the previous
> > > implmentation silently dropped the msb, we at least wanna know who has
> > > been passing in negative indices.  Patch for the lock_timer is already
> > > in -mm.
> > 
> > Thanks. Can you share the patch title? It's not in next-20130225.
> 
> It's this one.
> 
>  http://thread.gmane.org/gmane.linux.kernel/1444883/focus=1445094
> 

