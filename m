Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaC2RLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:11:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaC2RLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:11:15 -0400
Date: Sat, 29 Mar 2014 18:10:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, peterz@infradead.org,
        eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 05/15 V3] perf, c2c: Rework setup code to prepare for
 features
Message-ID: <20140329171018.GA2022@krava.redhat.com>
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
 <1395689826-215033-6-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395689826-215033-6-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 03:36:56PM -0400, Don Zickus wrote:

SNIP

>  
>  static int perf_c2c__process_load_store(struct perf_c2c *c2c,
> +					struct addr_location *al,
>  					struct perf_sample *sample,
> -					struct addr_location *al)
> +					struct perf_evsel *evsel)
>  {
> -	if (c2c->raw_records)
> -		perf_sample__fprintf(sample, ' ', "raw input", al, stdout);
> +	struct mem_info *mi;
> +
> +	mi = sample__resolve_mem(sample, al);
> +	if (!mi)
> +		return -ENOMEM;

perhaps not directly related to this patchset, but I needed
attached patch to get resolved data in .bss (static), which
for some reason happened to be located in executable segment

I wonder why we need this VARIABLE/FUNCTION separation at all,
I think Arnaldo told me some archs could have same addresses
for data and functions.. will check ;-)

jirka

---
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index d9d86c6..be6d7cf 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1220,6 +1220,10 @@ static void ip__resolve_data(struct machine *machine, struct thread *thread,
 
 	thread__find_addr_location(thread, machine, m, MAP__VARIABLE, addr,
 				   &al);
+	if (!al.map)
+		thread__find_addr_location(thread, machine, m, MAP__FUNCTION, addr,
+					   &al);
+
 	ams->addr = addr;
 	ams->al_addr = al.addr;
 	ams->sym = al.sym;
