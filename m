Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaEGRCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:02:04 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:33388 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaEGRCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:02:00 -0400
Date: Wed, 7 May 2014 19:01:55 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Pihet <jean.pihet@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 00/16] perf, persistent: Add persistent events
Message-ID: <20140507170155.GH32718@rric.localhost>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
 <20140506123907.GV32718@rric.localhost>
 <20140506185826.GF25013@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506185826.GF25013@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.05.14 20:58:26, Borislav Petkov wrote:
> On Tue, May 06, 2014 at 02:39:07PM +0200, Robert Richter wrote:
> > I rather would change the ioctl to
> > 
> >  id = ioctl(PERF_EVENT_IOC_SET_PERSIST, arg);
> > 
> >  arg != 0:	create persistent event (unclaim)
> >  arg == 0:	delete persistent event (claim)
> > 
> > This has the advantage that the naming is better and arg can be used
> > as parameter (e.g. event id to share a namespace).
> 
> Yep, this is better than the CLAIM/UNCLAIM thing.

Yeah, I am wondering why we didn't get this earlier. ;)

> > The unclaim ioctl *creates* a buffer with 512kB default size. The
> > reopening process must mmap with the same buffer size. This is a
> > problem as in this implementation the buffer size is fix and can not
> > be adjusted.
> 
> Why do we need it to be adjustable?

I am fine with a fixed size. But this design might not be changable in
the future without breaking the API. So its worth to think about this.
Maybe we allow the process also to create the buffer, there are 2
variants then:

 perf_event_open(...);
 mmap(..., fd, ...);
 ioctl(fd, set_persistent, 1);   /* Use existing buffer. */
 close();

 fd = perf_event_open(...);
 ioctl(fd, set_persistent, 1);   /* Create buffer with default size. */
 close();

This would solve the problem how we adjust buffer size.

This requires a way to detect buffer size. See my mail how this could
be done.

> 
> > We could let create the process the buffers and make the
> > event persistent including the current buffers.
> > 
> > Variable buffer size is a must,
> 
> Yeah, why? I'm just asking for my own understanding.

For general-purpose... Why 512k buffers are ok? Depending on the
event, smaller buffers are maybe good enough, esp. since they are
permanently enabled and use system resources. Or, at some point, 512k
is not sufficient anymore. You don't want 512k be carved in stone.

> > so the reopening process also must be
> > able to detect buffer size. Mmap buffer size could be detected by
> > mmap'ing only the header page, reading the buffer size from the header
> > and then remapping the buffer with adjusted size.
> > 
> > It would be good to have a perf tool option -P that puts events in
> > persistent state instead of starting a command:
> > 
> >  # perf record -e ... -a -P <namespace>		# create pers. events
> >  # perf record -e persistent/<namespace>/ -a	# read existing buffers
> >  # perf record -e persistent/<namespace>/ -a -k	# read and kill existing events
> > 
> > Note that no args for a command are given.
> 
> Yep, looks sane to me.

Ok.

Thanks for your commments.

-Robert
