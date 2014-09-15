Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbaIOSpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:45:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:44789 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbaIOSpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:45:43 -0400
Date: Mon, 15 Sep 2014 15:45:38 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH RFC] perf kvm stat live: cache mmap()ed events
Message-ID: <20140915184538.GG11199@kernel.org>
References: <1410539263-25857-1-git-send-email-yarygin@linux.vnet.ibm.com>
 <5415B6B9.2040607@gmail.com>
 <874mw9vy69.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874mw9vy69.fsf@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 15, 2014 at 04:57:34PM +0400, Alexander Yarygin escreveu:
> David Ahern <dsahern@gmail.com> writes:
> > On 9/12/14, 10:27 AM, Alexander Yarygin wrote:
> >> During mmap() process 'perf kvm stat live' gets a pointer to events and
> >> passes them to the session queue. Events are stored in shared memory and
> >> eventually they will be overwritten by the kernel. The problem is, that
> >> when events come too fast, old events can be overwritten before they
> >> have been processed that can lead to perf crash.
> >>
> >> To prevent that happening, we can copy upcoming events and pass a copy
> >> to the session queue. There is a safe place to copy event: before
> >> perf_evlist__mmap_consume() is executed. There are 3 places to free it:
> >> when event is processed, when it's lost and on exit, if it's turned out
> >> unprocessed.

> > Did you see what I proposed a year ago:
> > https://lkml.org/lkml/2013/9/6/388

> > The intent is to keep the copy generic and not local a command since
> > conceptually other live commands need the same.

> Yes, your patch works fine. But as far as I understand, right now only
> the 'perf kvm stat live' is infected: other 'live' tools were fixed by
> the patch "PERF: The tail position of the event buffer should only be modified
> after actually use that event." and since they don't use ordered queue
> they don't need a copying. That's why I came up with 'perf kvm stat
> live' specific approach. Maybe I missed something...
> 
> Anyhow, having >30K events is a quite usual situation on s390 and the
> 'perf kvm stat live' command hardly works there, so it would be good to
> have at least some working solution. Any ideas? :)

I don't have a problem solving this on some tool where the problem
happens and then, when some other tool hits the same problem, then one
looks at existing tools, figures out if some tool-specific solution can
be reused, moves it to common code, possibly improving it in the
process, and reuses it.

Sometimes trying to make it general from day one may lead to
overengineering :-)

With that said, David's patch looks clean and small enough, so if that
solves your problem, please let me know if I can apply it and your
Tested-by/Any-other-tags, ok?

- Arnaldo
