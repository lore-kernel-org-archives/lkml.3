Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab3HWQvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:51:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab3HWQu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:50:58 -0400
Date: Fri, 23 Aug 2013 18:50:45 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, jstancek@redhat.com, keescook@chromium.org,
        peter.oberparleiter@de.ibm.com, rusty@rustcorp.com.au,
        linux-arch@vger.kernel.org, arnd@arndb.de, mgahagan@redhat.com,
        agospoda@redhat.com
Subject: Re: [RFC PATCH 1/4] gcov: move gcov structs definitions to a gcc
 version specific file
Message-ID: <20130823165045.GB2336@localhost.localdomain>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <1377247176-13537-1-git-send-email-fhrbata@redhat.com>
 <1377247176-13537-2-git-send-email-fhrbata@redhat.com>
 <52177B46.6070404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52177B46.6070404@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 05:09:58PM +0200, Peter Oberparleiter wrote:
> On 23.08.2013 10:39, Frantisek Hrbata wrote:
> > Since also the gcov structures(gcov_info, gcov_fn_info, gcov_ctr_info) can
> > change between gcc releases, as shown in gcc 4.7, they cannot be defined in a
> > common header and need to be moved to a specific gcc implemention file. This
> > also requires to make the gcov_info structure opaque for the common code and to
> > introduce simple helpers for accessing data inside gcov_info.
> 
> I've taken a similar approach in my version, although I stopped at isolating
> the code that handles the linked list. I like your version better since it's
> more consistent.

:) I also have doubts with the list "abstraction", it isn't very nice. I tried
to keep the changes as simple as possible in the generic code. I'm not sayint it
is the right approach, but your design is pretty good, so I had no urges to
change it more deeper. I'm of course open to any suggestions.

> 
> > diff --git a/kernel/gcov/gcc_3_4.c b/kernel/gcov/gcc_3_4.c
> > index ae5bb42..27bc88a 100644
> > --- a/kernel/gcov/gcc_3_4.c
> > +++ b/kernel/gcov/gcc_3_4.c
> > @@ -21,6 +21,121 @@
> >  #include <linux/vmalloc.h>
> >  #include "gcov.h"
> > 
> > +#define GCOV_COUNTERS		5
> 
> The value for GCOV_COUNTERS has been changed with GCC 4.3. Before it was 5,
> starting with GCC 4.3 the value is 8. While this is not strictly necessary, I'm
> wondering if this should be added here to prevent any unwanted side-effects.

Yes I was thinking about this two. My first idea was to use some define, maybe
in the Makefile during the gcc version check and set the number of counters
properly later based on this define. Something like

#if GCOV_GCC_VERIONS >= 0430
#define GCOV_COUNTERS 8
#elif ...

for the gcc_3_4.c implementation.

But I'm not sure what the new counters are good for and if they are really
needed for the coverage info. This would require deeper understanding what
and how the types of counters are used. At this point a simply did not change the
value for the format before gcc 4.7, because each counter type has a tag and
this should be backward compatible. We only miss the new counters. Again this is
something that probably deserves more attention. Thanks for pointing this out!

> 
> -- 
> Peter Oberparleiter
> Linux on System z Development - IBM Germany
> 

-- 
Frantisek Hrbata
