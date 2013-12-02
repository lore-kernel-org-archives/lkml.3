Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab3LBM5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:57:19 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:61498 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3LBM5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:57:13 -0500
Date: Mon, 2 Dec 2013 13:57:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@iki.fi>
Subject: Re: [PATCH 1/3] perf tools: Record total sampling time
Message-ID: <20131202125709.GA22404@gmail.com>
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
 <1385967199-3759-2-git-send-email-namhyung@kernel.org>
 <20131202124527.GB22212@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202124527.GB22212@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So basically, in the end I think it should be possible to have the 
following behavior:

   perf record -a -e cycles sleep 1

   perf report stat              # Reports as if we ran: 'perf stat -a -e cycles sleep 1'
   perf report                   # Reports the usual histogram

   perf report --stat            # Reports the perf stat output and the histogram

or so.

i.e. a perf.data file would by default always carry enough information 
to enable the extraction of the 'perf stat' data.

At that point visualizing it is purely report-time logic, it does not 
need any record-time options.

This would work for multi-event sampling as well, if we do:

   perf record -a -e cycles -e branches sleep 1

then 'perf report stat' would output the same as:

 $ perf stat -e cycles -e branches -a sleep 1

 Performance counter stats for 'system wide':

        34,174,518      cycles                    [100.00%]
         3,155,677      branches                                                    

       1.000802852 seconds time elapsed

Another neat feature this kind of workflo enables is the integration 
of --repeat to perf record, so something like:

    perf record --repeat 3 -a -e cycles -e branches sleep 1

would save 3 samples after each other, and would allow extraction of 
the statistical stability of the measurement, and 'perf report stat' 
would print the same result as a raw perf stat run would:

 $ perf stat --repeat 3 -e cycles -e branches -e instructions -a sleep 1

 Performance counter stats for 'system wide' (3 runs):

    28,975,150,642      cycles                     ( +-  0.43% ) [100.00%]
    10,740,235,371      branches                                                      ( +-  0.47% ) [100.00%]
    44,535,464,754      instructions              #    1.54  insns per cycle          ( +-  0.47% )

       1.005718027 seconds time elapsed                                          ( +-  0.43% )

Or something like that. At that point we share reporting between perf 
stat and perf report, no special ad-hoc options are needed to just 
measure and report timestamps, it would all be a 'natural' side effect 
of having perf stat.

What do you think?

Thanks,

	Ingo
