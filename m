Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab3CTNE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:04:28 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37439 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab3CTNE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:04:27 -0400
Date: Wed, 20 Mar 2013 10:04:19 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 6/9] perf util: Get rid of malloc_or_die() in
 trace-event-read.c
Message-ID: <20130320130419.GC1964@ghostprotocols.net>
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
 <1363683224-28804-7-git-send-email-namhyung@kernel.org>
 <1363704602.5938.26.camel@gandalf.local.home>
 <87ehfaj2ic.fsf@sejong.aot.lge.com>
 <1363744502.6345.1.camel@gandalf.local.home>
 <871ubaixlw.fsf@sejong.aot.lge.com>
 <1363749205.6345.5.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363749205.6345.5.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 19, 2013 at 11:13:25PM -0400, Steven Rostedt escreveu:
> On Wed, 2013-03-20 at 12:00 +0900, Namhyung Kim wrote:
> > On Tue, 19 Mar 2013 21:55:02 -0400, Steven Rostedt wrote:
> > > On Wed, 2013-03-20 at 10:14 +0900, Namhyung Kim wrote:
> > >> On Tue, 19 Mar 2013 10:50:02 -0400, Steven Rostedt wrote:
> > >> > On Tue, 2013-03-19 at 17:53 +0900, Namhyung Kim wrote:
> > >> > I think I like the err += func() and check for err < 0, better.

> > >> Okay, I'll change them to err |= func() style if you're fine as Peter
> > >> suggested.

> > > += or |= I'm not picky ;-)

> > Ah, one thing I also care was the short-circuit logic.  I think we don't
> > need to call later functions if one fails, do we?

> Yeah, good point. It still looks ugly, but it does make sense.

Yes, I dislike all this += or |=, it should be normal exception
handling, just like everywhere in the kernel codebase:

	err = foo();
	if (err)
		goto out_err;

	err = bar();
	if (err)
		goto out_foo;

	err = baz();
	if (err)
		goto out_bar;

	err = new_foo();
	if (err)
		goto out_baz;

	return 0;
out_baz:
	baz_cleanup();
out_bar:
	bar_cleanup();
out_foo:
	foo_cleanup();
out_err:
	return err;

----

	That way exception handling code lies at the end of the
function, i.e. in source and binary code it has a lower chance of
polluting brain and CPU caches, and we don't need to call N functions
if we'll bail out when the one of them fails.

	I.e. nothing new here, just follow kernel coding style, move
along :-)

- Arnaldo
