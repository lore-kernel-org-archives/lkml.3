Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaFBOMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:12:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbaFBOMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:12:50 -0400
Date: Mon, 2 Jun 2014 16:12:20 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>
Subject: Re: Fw: Re: [PATCH 1/1] powerpc/perf: Adjust callchain based on
 DWARF debug info
Message-ID: <20140602141219.GB7861@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140530155925.GF7427@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 05:59:25PM +0200, Jiri Olsa wrote:
> On Fri, May 30, 2014 at 08:50:19AM -0700, Sukadev Bhattiprolu wrote:
> > Jiri Olsa [jolsa@redhat.com] wrote:
> > | On Fri, May 16, 2014 at 02:03:33PM -0700, Sukadev Bhattiprolu wrote:
> > | > Hi Arnaldo, Jiri
> > | > 
> > | > Do you have any comments on this patch ? Pls let me know if you need
> > | > me to resend this. The TODO is for a less frequent case and can be
> > | > addressed independently.
> > | 
> > | hi,
> > | I can take it, but it does not apply to my perf/core,
> > | there're some ARM related unwind changes already:
> > |   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> > | 
> > | please resend updated patch
> > 
> > Jiri,
> > 
> > I resent the patch. Can you please let me know if you have any
> > comments ?
> > 
> > 	https://lkml.org/lkml/2014/5/22/695
> 
> sry, got distracted.. yep, that one seems looks ok now, I'll queue it
> 

so.. I tried some performance test and looks like this
adds some considerable penalty also for archs != powerpc

test data:
  $ sudo ./perf record -a -g -F 50000 # perf.data size is ~1.1GB

before your patch:

 Performance counter stats for './perf.old report --stdio' (5 runs):

    60,345,248,146      cycles                     ( +-  0.50% ) █▁▁▂▂
    72,766,496,819      instructions              #    1.21  insns per cycle          ( +-  0.00% ) █▁▄▁▅

      19.930324523 seconds time elapsed                                          ( +-  1.07% ) █▄▁▁▁

with your patch:
    62,559,079,470      cycles                     ( +-  2.10% ) ▁▁▂▁█
    72,649,781,930      instructions              #    1.16  insns per cycle          ( +-  0.00% ) ▄▃▅█▁

      23.355028944 seconds time elapsed                                          ( +-  9.85% ) ▁▁▁▂█


I think the issue is following hunk (I havent verified with record/report):

@@ -1300,14 +1301,25 @@ static int machine__resolve_callchain_sample(struct machine *machine,
                return 0;
        }
 
+       /*
+        * Based on DWARF debug information, some architectures skip
+        * some of the callchain entries saved by the kernel.
+        */
+       skip_slot = arch_skip_callchain_idx(machine, thread, chain);
+
        for (i = 0; i < chain_nr; i++) {
                u64 ip;
                struct addr_location al;
 
-               if (callchain_param.order == ORDER_CALLEE)
+               if (callchain_param.order == ORDER_CALLEE) {
+                       if (i == skip_slot)
+                               continue;
                        ip = chain->ips[i];
-               else
+               } else {
+                       if ((int)(chain->nr - i - 1) == skip_slot)
+                               continue;
                        ip = chain->ips[chain->nr - i - 1];
+               }


could you please change this, so it's nop for arch != powerpc
via #ifdef I guess.. or some other smart way ;-)

adding some other folks and lkml to the loop

thanks,
jirka
