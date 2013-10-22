Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3JVSfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:35:52 -0400
Received: from mail-gg0-f181.google.com ([209.85.161.181]:47392 "EHLO
	mail-gg0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3JVSfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:35:47 -0400
Date: Tue, 22 Oct 2013 15:35:39 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: perf test failing for "sample parsing"
Message-ID: <20131022183539.GA18057@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

	I should've caught this when processing those patches, but
please consider running 'perf test' before and after your future patch
kits :-)

[root@sandy ~]# perf test 22
22: Test sample parsing                                    : FAILED!
[root@sandy ~]# perf test -v 22
22: Test sample parsing                                    :
--- start ---
sample format has changed - test needs updating
---- end ----
Test sample parsing: FAILED!
[root@sandy ~]#

	So I bisected it down to:

  commit fdfbbd07e91f8fe387140776f3fd94605f0c89e5
  Author: Andi Kleen <ak@linux.intel.com>
  Date:   Fri Sep 20 07:40:39 2013 -0700

      perf: Add generic transaction flags
    
      Add a generic qualifier for transaction events, as a new sample
      type that returns a flag word. This is particularly useful
      for qualifying aborts: to distinguish aborts which happen
      due to asynchronous events (like conflicts caused by another
      CPU) versus instructions that lead to an abort.
 
   extern void perf_output_sample(struct perf_output_handle *handle,
  diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
  index 009a655..da48837 100644
  --- a/include/uapi/linux/perf_event.h
  +++ b/include/uapi/linux/perf_event.h
  @@ -136,8 +136,9 @@ enum perf_event_sample_format {
   	PERF_SAMPLE_WEIGHT			= 1U << 14,
   	PERF_SAMPLE_DATA_SRC			= 1U << 15,
   	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
  +	PERF_SAMPLE_TRANSACTION			= 1U << 17,
   
  -	PERF_SAMPLE_MAX = 1U << 17,		/* non-ABI */
  +	PERF_SAMPLE_MAX = 1U << 18,		/* non-ABI */

--------------------------------------------------------------------------------------


	So I looked at tools/perf/tests/builtin-test.c for the "Test sample parsing"
string and found the test__sample_parsing function, and fixed it there,
patches sent to my perf/core branch.

	This one was harmless, but there were problems that were caught
by running 'perf test' while writing patchkits,

Thanks,

- Arnaldo
