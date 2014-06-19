Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934667AbaFSVLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:11:52 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:55756
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934434AbaFSVLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:11:51 -0400
Date: Thu, 19 Jun 2014 16:11:47 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
In-Reply-To: <20140619204634.GB9814@mtj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1406191608290.5484@gentwo.org>
References: <20140612135630.GA23606@htj.dyndns.org> <alpine.DEB.2.11.1406171401350.22064@gentwo.org> <20140617194017.GO4669@linux.vnet.ibm.com> <alpine.DEB.2.11.1406191540240.4002@gentwo.org> <20140619204634.GB9814@mtj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Tejun Heo wrote:

> On Thu, Jun 19, 2014 at 03:42:07PM -0500, Christoph Lameter wrote:
> > In that case special care needs to be taken to get this right. True.
> >
> > I typically avoid these scenarios by sending an IPI with a pointer to the
> > data structure. The modification is done by the cpu for which the per cpu
> > data is local.
> >
> > Maybe rewrite the code to avoid writing to other processors percpu data
> > would be the right approach?
>
> It depends on the specific use case but in general no.  IPIs would be
> far more expensive than making use of proper barriers in vast majority
> of cases especially when the "hot" side is data dependency barrier,
> IOW, nothing.  Also, we are talking about extremely low frequency
> events like init and recycling after reinit.  Regular per-cpu
> operation isn't really the subject here.

The aim of having percpu data is to have the ability for a processor to
access memory dedicated to that processor in the fastest way possible by
avoiding synchronization. You are beginning to add synchronization
elements into the accesses of a processor to memory dedicated to its sole
use.

Remote write events are contrary to that design and are exceedingly rare.
An IPI is justifiable for such a rare event. At least in my use cases I
have always found that to be sufficient. Well, I designed the data
structures in a way that made this possible because of the design criteria
that did not allow me remote write access to other processors per cpu
data.

