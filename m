Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbaDKO6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:58:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759006AbaDKO6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:58:36 -0400
Date: Fri, 11 Apr 2014 16:57:54 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jmario@redhat.com,
        fowles@inreach.com, peterz@infradead.org, eranian@google.com,
        andi.kleen@intel.com
Subject: Re: [PATCH 05/15 V3] perf, c2c: Rework setup code to prepare for
 features
Message-ID: <20140411145754.GA22707@krava.brq.redhat.com>
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
 <1395689826-215033-6-git-send-email-dzickus@redhat.com>
 <20140329171018.GA2022@krava.redhat.com>
 <87ob0cw9na.fsf@sejong.aot.lge.com>
 <20140408141107.GT8488@redhat.com>
 <87eh17uwzj.fsf@sejong.aot.lge.com>
 <20140409013658.GA8488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409013658.GA8488@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 09:36:58PM -0400, Don Zickus wrote:
> On Wed, Apr 09, 2014 at 10:12:32AM +0900, Namhyung Kim wrote:
> > On Tue, 8 Apr 2014 10:11:07 -0400, Don Zickus wrote:
> > > On Tue, Apr 08, 2014 at 04:41:29PM +0900, Namhyung Kim wrote:
> > >> On Sat, 29 Mar 2014 18:10:18 +0100, Jiri Olsa wrote:
> > >> > On Mon, Mar 24, 2014 at 03:36:56PM -0400, Don Zickus wrote:
> > >> >
> > >> > SNIP
> > >> >
> > >> >>  
> > >> >>  static int perf_c2c__process_load_store(struct perf_c2c *c2c,
> > >> >> +					struct addr_location *al,
> > >> >>  					struct perf_sample *sample,
> > >> >> -					struct addr_location *al)
> > >> >> +					struct perf_evsel *evsel)
> > >> >>  {
> > >> >> -	if (c2c->raw_records)
> > >> >> -		perf_sample__fprintf(sample, ' ', "raw input", al, stdout);
> > >> >> +	struct mem_info *mi;
> > >> >> +
> > >> >> +	mi = sample__resolve_mem(sample, al);
> > >> >> +	if (!mi)
> > >> >> +		return -ENOMEM;
> > >> >
> > >> > perhaps not directly related to this patchset, but I needed
> > >> > attached patch to get resolved data in .bss (static), which
> > >> > for some reason happened to be located in executable segment
> > >> 
> > >> Wasn't it a read-only/const data?
> > >
> > > I believe it had the 'x' bit set.  Or the kernel was not passing any
> > > protection bits, so it defaulted to MAP_FUNCTION?
> > 
> > The perf treats a mapping as a data mapping (MAP_VARIABLE) by default if
> > the 'x' bit is not set.  As Jiri said its a static data, I guessed it's
> > a const data (set to 0?) and moved into .rodata section and then to the
> > text segment.

it was not initialized static data, .. not sure why it ended up
in text segment, because I dont see it anymore :-)

> 
> Unfortunately, his patch will be needed eventually, if not for his reason,
> I had a java JAR file example that was pulling data addresses out of a
> shared memory region with the protection bits set to 'rwx' (in the
> /proc/<pid>/maps area).  I was losing lots of samples until I came up with
> a more complicated hack.

also, I think nothing prevents user from mapping memory as 'rwx'
and load/store data there.. we should be able to handle this case

jirka
