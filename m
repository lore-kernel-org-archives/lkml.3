Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab3CIHKj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 02:10:39 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:34546 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab3CIHKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 02:10:38 -0500
Date: Sat, 9 Mar 2013 07:10:37 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: NeilBrown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: epoll: possible bug from wakeup_source activation
Message-ID: <20130309071037.GA13360@dcvr.yhbt.net>
References: <20130307112639.GA25130@dcvr.yhbt.net>
 <20130308013027.GA31830@dcvr.yhbt.net>
 <CAMP5Xgdsam2DGLshL5Uu5Q4La_nAq=u1YRNBwAxDstgCvJiqfw@mail.gmail.com>
 <20130308204944.GA27379@dcvr.yhbt.net>
 <CAMP5Xgc4-oX=-V57Mu5PARCWdfpkjck0VnZNAXH-JisvKi5tAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP5Xgc4-oX=-V57Mu5PARCWdfpkjck0VnZNAXH-JisvKi5tAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arve Hjønnevåg <arve@android.com> wrote:
> On Fri, Mar 8, 2013 at 12:49 PM, Eric Wong <normalperson@yhbt.net> wrote:
> > What happens if ep_modify calls ep_destroy_wakeup_source
> > while __pm_stay_awake is running on the same epi->ws?
> 
> Yes, that looks like a problem. I think calling
> ep_destroy_wakeup_source with ep->lock held should fix that. It is not
> clear how useful changing EPOLLWAKEUP in ep_modify is, so
> alternatively we could remove that feature and instead only allow it
> to be set in ep_insert.

ep->lock would work, but ep->lock is already a source of heavy
contention in my multithreaded+epoll webservers.

Perhaps RCU can be used?  I've no experience with RCU, but I've been
meaning to get acquainted with RCU.

Another possible solution is to only use ep->ws and add an atomic
counter to ep; so __pm_relax(ep->ws) is only called when the atomic
counter reaches zero.
