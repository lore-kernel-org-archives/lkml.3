Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3GAOIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:08:55 -0400
Received: from dmz-mailsec-scanner-6.mit.edu ([18.7.68.35]:61503 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535Ab3GAOIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:08:54 -0400
X-AuditID: 12074423-b7f168e00000095a-1b-51d18d75d40d
Date: Mon, 1 Jul 2013 10:08:48 -0400
From: Greg Price <price@MIT.EDU>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf report: Fix bug in case "--no-call-graph -p foo"
Message-ID: <20130701140848.GD22203@biohazard-cafe.mit.edu>
References: <20121207072726.GY22203@biohazard-cafe.mit.edu>
 <20130111052736.GG3054@ghostprotocols.net>
 <20130623031720.GW22203@biohazard-cafe.mit.edu>
 <871u7p3bjb.fsf@sejong.aot.lge.com>
 <20130626222500.GZ22203@biohazard-cafe.mit.edu>
 <87obas176f.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obas176f.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsUixG6nolvaezHQoK1N2OJi20U2iwOPD7BY
	zHzdzWRxedccNotLBxYwWTQt28riwOZx5SmHx+kePY+ds+6ye2xa1cnm8X7fVTaPz5vkAtii
	uGxSUnMyy1KL9O0SuDJeXv3BWnBPqmJZ2zTmBsbVol2MnBwSAiYSi+4cZIOwxSQu3FsPZHNx
	CAnsY5TY0rqEBcLZwCjxe/kCdgjnE6PEvoWT2UFaWARUJJZ3bwCz2QQUJH7MX8cMYosIqEms
	XH8LrJtZ4BGjxMKLi8ASwgJuEp9XHANr4BWwlvhxfCYrxNQZTBITOycyQSQEJU7OfMICYjML
	aEnc+PcSKM4BZEtLLP/HARLmFDCQePXkDiOILQp0xLX97WwTGAVnIemehaR7FkL3AkbmVYyy
	KblVurmJmTnFqcm6xcmJeXmpRbpmermZJXqpKaWbGMHR4KK8g/HPQaVDjAIcjEo8vAumXwgU
	Yk0sK67MPcQoycGkJMqb1H0xUIgvKT+lMiOxOCO+qDQntfgQowQHs5II701voBxvSmJlVWpR
	PkxKmoNFSZz32dOzgUIC6YklqdmpqQWpRTBZGQ4OJQle9R6gRsGi1PTUirTMnBKENBMHJ8hw
	HqDhXiA1vMUFibnFmekQ+VOMilLivPwgCQGQREZpHlwvLFm9YhQHekWYVwqkigeY6OC6XwEN
	ZgIazNt6DmRwSSJCSqqBsejNTIXOVw6tE4Qy/pc/8+tRMHvae26WbrKV1y39v11VVYKnk5P6
	pzsrSzwPkDq1TqKvJo07ovFjl4Ysn+GMk3unHNF4r3Rv0YRL145NC1+21n59WBFfWUVowOlD
	b2QWa2oaZcf3ePTp7I4NrsuLqW+yV+5YJ/wrJjWuJPRwlXrrhKqGablKLMUZiYZazEXFiQDy
	ULxMMQMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop in machine__resolve_callchain_sample, which examines each
element of the callchain for several purposes, contains an optimization
which is intended to bail out early in case we have found the "parent"
and we aren't using the callchain for anything else.

But since v2.6.31-rc4~3^2~45 we have displayed callchains by default
when they are present, which makes that situation unusual.  And in
fact in v2.6.31-rc4~3^2~63 we had already broken this optimization so
that it completely messes up the output if it applies: if we're
looking for the parent and not otherwise using the callchain, we bail
out after the first entry which we can resolve to a symbol, even if it
doesn't match the parent pattern (as it usually won't.)  So it must
really be unusual to see this optimization apply, or someone would
have fixed the bug by now.

Therefore just kill the optimization.

Example before this patch:

    $ perf report -p ^vm_ 2>- | grep Event
    # Event count (approx.): 6392784226

    $ perf report -p ^vm_ --no-call-graph 2>- | grep Event
    # Event count (approx.): 54639399

After this patch:

    $ perf report -p ^vm_ 2>- | grep Event
    # Event count (approx.): 6392784226

    $ perf report -p ^vm_ --no-call-graph 2>- | grep Event
    # Event count (approx.): 6392784226

Reported-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/871u7p3bjb.fsf@sejong.aot.lge.com
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Greg Price <price@mit.edu>
---

The relevant previous thread:

On Thu, Jun 27, 2013 at 01:58:16PM +0900, Namhyung Kim wrote:
> On Wed, 26 Jun 2013 18:25:01 -0400, Greg Price wrote:
> > On Wed, Jun 26, 2013 at 10:28:56AM +0900, Namhyung Kim wrote:
> >> On Sat, 22 Jun 2013 23:17:20 -0400, Greg Price wrote:
> >> > +			}
> >> >  			if (!symbol_conf.use_callchain)
> >> >  				break;
> >> pp
> >> This is unrelated to this patch, but why is this line needed?  I guess
> >> this check should be done before calling this function.
> >
> > Hmm.  We actually can get into this function when
> > !symbol_conf.use_callchain, if we're using say --sort=parent.  But I'm
> > still somewhat puzzled, because in that case it looks like we'll break
> > the loop after the first address with a symbol, even if we didn't find
> > the 'parent' there, which seems like it wouldn't serve the purpose.
> 
> Right, that's what I want to say.
> 
> We already have the check before calling this function so breaking the
> loop after checking only first callchain node looks strange.  If we
> don't want to see callchains but only parents, it should either check
> every callchain nodes or fail out as an unsupported operation IMHO.

Cheers,
Greg


 tools/perf/util/machine.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 4618e03..3bd8912 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1217,8 +1217,6 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 				*root_al = al;
 				callchain_cursor_reset(&callchain_cursor);
 			}
-			if (!symbol_conf.use_callchain)
-				break;
 		}
 
 		err = callchain_cursor_append(&callchain_cursor,
-- 
1.8.2
