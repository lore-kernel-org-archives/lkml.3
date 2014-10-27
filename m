Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaJ0N2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:28:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41528 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaJ0N2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:28:18 -0400
Date: Mon, 27 Oct 2014 14:28:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Burke Libbey <burke.libbey@shopify.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: Re: [PATCH] sched: reset sched_entity depth on changing parent
Message-ID: <20141027132812.GG3337@twins.programming.kicks-ass.net>
References: <20141024150746.GB25260@burke.local>
 <20141024155805.GF21513@worktop.programming.kicks-ass.net>
 <164441414171122@web11g.yandex.ru>
 <20141027120734.GA3337@twins.programming.kicks-ass.net>
 <20141027124002.GA4436@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027124002.GA4436@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 08:40:02AM -0400, Tejun Heo wrote:
> On Mon, Oct 27, 2014 at 01:07:34PM +0100, Peter Zijlstra wrote:
> > On Fri, Oct 24, 2014 at 09:18:42PM +0400, Kirill Tkhai wrote:
> > > I was seeking a places where task_group of a task may change. I can't understand
> > > how changing of parent's cgroup during fork() applies to a child.
> > 
> > I didn't know we could change cgroup on fork(), I though the idea was
> > you always inherited your parents cgroup.
> > 
> > How can this be?
> 
> Hmmm? -ENEEDMORECONTEXT but the inheriting happens at one point during
> fork in cgroup_post_fork().  The child inherits whatever the parent
> cgroup is at that point.

So Kirill is saying that there is a race between fork and attach such
that a child can end up in a different cgroup than the parent and we
need to use the cgroup_subsys::fork call to fix that up.

I was always under the impression that fork was an 'atomic' operation
from the point of cgroups, an attach (or move) would happen either
before the fork or after, not during. But I appear to be mistaken in
that assumption, going by the comments around cgroup_post_fork().
