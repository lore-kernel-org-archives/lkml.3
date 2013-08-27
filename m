Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3H0Mly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:41:54 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61962 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3H0Mlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:41:52 -0400
Date: Tue, 27 Aug 2013 14:41:46 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 12/12] [RFC] perf, persistent: ioctl functions to
 control persistency
Message-ID: <20130827124146.GG15884@rric.localhost>
References: <alpine.DEB.2.02.1308221404090.26486@pianoman.cluster.toy>
 <20130823091128.GA19548@nazgul.tnic>
 <20130823094556.GB10223@rric.localhost>
 <20130823104441.GD10223@rric.localhost>
 <20130823113400.GA20310@nazgul.tnic>
 <alpine.DEB.2.02.1308231255330.7482@pianoman.cluster.toy>
 <20130823193934.GB15521@pd.tnic>
 <alpine.DEB.2.10.1308231704450.24113@vincent-weaver-1.um.maine.edu>
 <20130827115422.GD15884@rric.localhost>
 <20130827122242.GA5855@x1.alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827122242.GA5855@x1.alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, starting with your question at the end first since it might
explain the following better.

If the event is no longer persistent and if there are multiple users,
the event remains open and running until the all mmap's are munmap'ed
and the last fd is closed. After that it is released. This is done
with refcounts and already implemented.

On 27.08.13 14:22:42, Borislav Petkov wrote:
> On Tue, Aug 27, 2013 at 01:54:22PM +0200, Robert Richter wrote:
> > I got another idea for this, what about UNCLAIM and CLAIM? It is
> > exactly, what it is. A process unclaims an event telling it doesn't
> > care anymore.  Another process comes and claims the event, meaning the
> > process wants the event no longer to be shared with others and being
> > released after closing.
> 
> This still doesn't pan out because with claiming the event, you state
> that the event is *owned* by this process but with persistent events
> we want to be able to state that they can have multiple users and thus
> multiple buffer consumers, concurrently.

We still have multiple users after 'claiming' the event. The only
thing is that the event will be destroyed after all users went away.
A process (that claimed the event) was responsible for this.

> > > > 3. ioctl DETACH from it so that it is "forked in the background" so to
> > > > speak, very similar to a background job in the shell.
> > 
> > With 'detach' we move the event into the 'background' so that it is
> > still available after opening.
> 
> Ok, maybe ATTACH/DETACH is not the perfect naming for this after all.
> Maybe when we want to state the fact that the event is going to continue
> existing after closing the buffer consumer, we want to do ioctl(event,
> DONT_DESTROY) and when we want to actually get rid of it, one of the
> process does ioctl(event, DESTROY).

I still prefer claim/unclaim. ;)

> Which reminds me, what do we do when one process destroys the event but
> there are other consumers accessing it concurrently? Refcounting?

See above.

-Robert
