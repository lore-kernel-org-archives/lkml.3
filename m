Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbbANMua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:50:30 -0500
Received: from mail.kernel.org ([198.145.29.136]:34478 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbbANMu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:50:29 -0500
Date: Wed, 14 Jan 2015 09:50:25 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Wang Nan <wangnan0@huawei.com>, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com, namhyung@kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH v2] perf: fix dwarf unwind using libunwind.
Message-ID: <20150114125025.GA3691@kernel.org>
References: <20150113091928.GA2160@krava.brq.redhat.com>
 <1421203007-75799-1-git-send-email-wangnan0@huawei.com>
 <20150114115749.GB6369@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114115749.GB6369@krava.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 14, 2015 at 12:57:49PM +0100, Jiri Olsa escreveu:
> On Wed, Jan 14, 2015 at 10:36:47AM +0800, Wang Nan wrote:
> > Perf tool fails to unwind user stack if the event raises in a shared
> 
> SNIP
> 
> > +
> >  __attribute__ ((noinline))
> >  static int krava_3(struct thread *thread)
> >  {
> > -	return unwind_thread(thread);
> > +	struct thread *array[2] = {thread, thread};
> > +	void *fp = &bsearch;
> > +	/*
> > +	 * make _bsearch a volatile function pointer to
> > +	 * prevent potential optimization, which may expand
> > +	 * bsearch and call compare directly from this function,
> > +	 * instead of libc shared object.
> > +	 */
> > +	void *(*volatile _bsearch)(void *, void *, size_t,
> > +			size_t, int (*)(void *, void *));
> > +
> > +	_bsearch = fp;
> > +	_bsearch(array, &thread, 2, sizeof(struct thread **), compare);
> > +	return global_unwind_retval;
> >  }
> 
> ah, I've got confused with the NO_LIBUNWIND_DEBUG_FRAME name
> and got the impression that we could use it in the tests/make
> as another compile option test..
> 
> but your change is even better ;-) thanks for updating this test
> 
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied to perf/urgent.

- Arnaldo
