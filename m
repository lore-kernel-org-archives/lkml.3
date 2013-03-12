Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab3CLAoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:44:46 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:59283 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab3CLAop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:44:45 -0400
Date: Tue, 12 Mar 2013 00:44:45 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: NeilBrown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: epoll: possible bug from wakeup_source activation
Message-ID: <20130312004445.GA5151@dcvr.yhbt.net>
References: <20130307112639.GA25130@dcvr.yhbt.net>
 <20130308013027.GA31830@dcvr.yhbt.net>
 <CAMP5Xgdsam2DGLshL5Uu5Q4La_nAq=u1YRNBwAxDstgCvJiqfw@mail.gmail.com>
 <20130308204944.GA27379@dcvr.yhbt.net>
 <CAMP5Xgc4-oX=-V57Mu5PARCWdfpkjck0VnZNAXH-JisvKi5tAg@mail.gmail.com>
 <20130309071037.GA13360@dcvr.yhbt.net>
 <CAMP5Xgdy9hJE1JCHYN2iK9W3UQvmgBGHH_9Jy2-mQyNxkHGwTQ@mail.gmail.com>
 <20130312001722.GB973@dcvr.yhbt.net>
 <CAMP5Xgcr97gcD6noP=vkTN7jLrhNGZ2VLVMkOKx+puoP8AiJDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP5Xgcr97gcD6noP=vkTN7jLrhNGZ2VLVMkOKx+puoP8AiJDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arve Hjønnevåg <arve@android.com> wrote:
> On Mon, Mar 11, 2013 at 5:17 PM, Eric Wong <normalperson@yhbt.net> wrote:
> > Arve Hjønnevåg <arve@android.com> wrote:
> >> On Fri, Mar 8, 2013 at 11:10 PM, Eric Wong <normalperson@yhbt.net> wrote:
> >> > Arve Hjønnevåg <arve@android.com> wrote:
> >> >> On Fri, Mar 8, 2013 at 12:49 PM, Eric Wong <normalperson@yhbt.net> wrote:
> >> >> > What happens if ep_modify calls ep_destroy_wakeup_source
> >> >> > while __pm_stay_awake is running on the same epi->ws?
> >> >>
> >> >> Yes, that looks like a problem. I think calling
> >> >> ep_destroy_wakeup_source with ep->lock held should fix that. It is not
> >> >> clear how useful changing EPOLLWAKEUP in ep_modify is, so
> >> >> alternatively we could remove that feature and instead only allow it
> >> >> to be set in ep_insert.
> >> >
> >> > ep->lock would work, but ep->lock is already a source of heavy
> >> > contention in my multithreaded+epoll webservers.
> >>
> >> This should not have any significant impact on that since you would be
> >> adding a lock to a code path that is, as far as I know, unused.
> >>
> >> > Perhaps RCU can be used?  I've no experience with RCU, but I've been
> >> > meaning to get acquainted with RCU.
> >>
> >> That adds code to the common path however. The wakeup_source is not
> >> touch without holding one of the locks so holding both locks before
> >> deleting it seems like a simpler solution.
> >
> > True.  However, I've been looking into eliminating ep->lock in more
> > places (maybe entirely)[1].
> >
> > I don't think the current overhead of RCU in epoll is significant,
> > either.
> >
> >
> > [1] I'll be testing Mathieu's wait-free concurrent queue soon:
> >     http://mid.gmane.org/20130311213602.GB9829@Krystal
> 
> OK, but is there any way you could use the same locking scheme for the
> wakeup_source and the queue?

Probably, yes.  I think I can just use ep->mtx and ignore the mutex
included with wfcq_head, need to protect the rbtree while dequeueing.
