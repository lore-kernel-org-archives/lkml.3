Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbaAIMMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:12:25 -0500
Received: from mail-gg0-f171.google.com ([209.85.161.171]:33622 "EHLO
	mail-gg0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaAIMMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:12:14 -0500
Date: Thu, 9 Jan 2014 09:12:06 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch] perf tools: perf list broken on ARM
Message-ID: <20140109121206.GA30069@ghostprotocols.net>
References: <alpine.DEB.2.10.1312301536150.28814@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1401081629200.4410@vincent-weaver-1.um.maine.edu>
 <871u0hd0x4.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u0hd0x4.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 09, 2014 at 05:17:27PM +0900, Namhyung Kim escreveu:
> Hi Vince,
> 
> On Wed, 8 Jan 2014 16:30:17 -0500 (EST), Vince Weaver wrote:
> > just checking on the status of this patch.  Am I sending it to the wrong 
> > place?  Did it get lost in the post-holiday e-mail purges?  
> >
> > The bug is annoying if you're trying to use perf on ARM systems.
> 
> Right, acme, would you please merge this?

I will, but having a patch authored by someone and Acked-by that same
person looks weird, so, to clarify, this was written by Vince, acked by
you, right?

- Arnaldo
 
> Thanks,
> Namhyung
> 
> >
> > On Mon, 30 Dec 2013, Vince Weaver wrote:
> >
> >> 
> >> "perf list" listing of hardware events doesn't work on older ARM devices.
> >> The change enabling event detection:
> >> 
> >>  commit b41f1cec91c37eeea6fdb15effbfa24ea0a5536b
> >>  Author: Namhyung Kim <namhyung.kim@lge.com>
> >>  Date:   Tue Aug 27 11:41:53 2013 +0900
> >> 
> >>      perf list: Skip unsupported events
> >> 
> >> 
> >> uses the following code in tools/perf/util/parse-events.c:
> >> 
> >>         struct perf_event_attr attr = {
> >>                 .type = type,
> >>                 .config = config,
> >>                 .disabled = 1,
> >>                 .exclude_kernel = 1,
> >>         };
> >> 
> >> On ARM machines pre-dating the Cortex-A15 this doesn't work, as
> >> these machines don't support .exclude_kernel.  So starting with 3.12
> >> "perf list" does not report any hardware events at all on older
> >> machines (seen on Rasp-Pi, Pandaboard, Beagleboard, etc).
> >> 
> >> This version of the patch makes changes suggested by Namhyung Kim
> >> to check for EACCESS and retry (instead of just dropping
> >> the exclude_kernel) so we can properly handle machines where 
> >> /proc/sys/kernel/perf_event_paranoid is set to 2.
> >> 
> >> Reported-by: Chad Paradis <chad.paradis@umit.maine.edu>
> >> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
> >> Acked-by: Namhyung Kim <namhyung@kernel.org>
> >> 
> >> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> >> index 6de6f89..1fa98b9 100644
> >> --- a/tools/perf/util/parse-events.c
> >> +++ b/tools/perf/util/parse-events.c
> >> @@ -1082,12 +1082,12 @@ int is_valid_tracepoint(const char *event_string)
> >>  static bool is_event_supported(u8 type, unsigned config)
> >>  {
> >>  	bool ret = true;
> >> +	int open_return;
> >>  	struct perf_evsel *evsel;
> >>  	struct perf_event_attr attr = {
> >>  		.type = type,
> >>  		.config = config,
> >>  		.disabled = 1,
> >> -		.exclude_kernel = 1,
> >>  	};
> >>  	struct {
> >>  		struct thread_map map;
> >> @@ -1099,7 +1099,20 @@ static bool is_event_supported(u8 type, unsigned config)
> >>  
> >>  	evsel = perf_evsel__new(&attr);
> >>  	if (evsel) {
> >> -		ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
> >> +		open_return = perf_evsel__open(evsel, NULL, &tmap.map);
> >> +		ret = open_return >= 0;
> >> +
> >> +		if (open_return == -EACCES) {
> >> +			/*
> >> +			 * This happens if the paranoid value
> >> +			 * /proc/sys/kernel/perf_event_paranoid is set to 2
> >> +			 * Re-run with exclude_kernel set; we don't do that
> >> +			 * by default as some ARM machines do not support it.
> >> +			 *
> >> +			 */
> >> +			evsel->attr.exclude_kernel = 1;
> >> +			ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
> >> +		}
> >>  		perf_evsel__delete(evsel);
> >>  	}
> >>  
> >> 
> >
> > Vince Weaver
> > vincent.weaver@maine.edu
> > http://www.eece.maine.edu/~vweaver/
