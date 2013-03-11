Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3CKQn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:43:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab3CKQn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:43:27 -0400
Date: Mon, 11 Mar 2013 17:43:09 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCHv2] perf: Fix vmalloc ring buffer free function
Message-ID: <20130311164309.GG13679@krava.brq.redhat.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
 <1362994843.10972.40.camel@laptop>
 <20130311112105.GA9737@krava.brq.redhat.com>
 <1363019193.14933.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363019193.14933.14.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 05:26:33PM +0100, Peter Zijlstra wrote:
> On Mon, 2013-03-11 at 12:21 +0100, Jiri Olsa wrote:
> > >  pg_nr     = offset >> page_shift;
> > >  pg_offset = offset & (1 << page_shift) - 1;
> > > 
> > > You just wrecked that.
> > > 
> > > >     handle->page &= rb->nr_pages - 1;
> > 
> > here's ^^^ where the handle->page becomes 0 due to (rb->nr_pages == 0)
> 
> then that'll be &= -1, which is a nop, no?

ugh.. should have been: '..due to (rb->nr_pages == 1)' as from:

+       rb->nr_pages      = nr_pages ? 1 : 0;

if it's 0, it never make it throught the perf_output_begin

> 
> Also, you wrecked it for anything that uses some intermediate page
> order (we currently don't).

I'll put that hunk back then:

-       handle->page = offset >> (PAGE_SHIFT + page_order(rb));
+       /* page is allways 0 for CONFIG_PERF_USE_VMALLOC option */
+       handle->page = offset >> PAGE_SHIFT;

I did not know there were other plans for that, seemed useless

jirka
