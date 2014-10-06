Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaJFQN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:13:28 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:54211 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaJFQN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:13:27 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH RFC] perf kvm stat record: print kvm specific --help output
Date: Mon,  6 Oct 2014 20:13:17 +0400
Message-Id: <1412611998-8690-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100616-2966-0000-0000-0000015DDFE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The 'perf kvm stat record' tool is an alias for 'perf record' tool.
When 'perf kvm stat record' is running with '--help' option, it prints
help output for 'perf record':


$ sudo perf kvm stat record --help
 usage: perf record [<options>] [<command>]
    or: perf record [<options>] -- <command> [<options>]

    -e, --event <event>   event selector. use 'perf list' to list available events
        --filter <filter>
                          event filter
    -p, --pid <pid>       record events on existing process id
    -t, --tid <tid>       record events on existing thread id
    -r, --realtime <n>    collect data with this RT SCHED_FIFO priority
    -D, --no-delay        collect data without buffering
    -R, --raw-samples     collect raw sample records from all opened counters
    -a, --all-cpus        system-wide collection from all CPUs
    -C, --cpu <cpu>       list of cpus to monitor
    -c, --count <n>       event period to sample
    -o, --output <file>   output file name
    .. snip ..


Some of these options can be used with 'kvm stat record', however others
can break recording (i.e. --no-samples), or don't change anything kvm related
(but they can add more details to the output file that are ignored by
'kvm stat report' and visible with 'perf report')

Plus the other 'perf kvm stat' tools have their own --help.

The patch is an proof-of-concept attempt to fix that inconsistency
by printing useful for 'perf kvm stat record' options in addition
to generic help. Like as follows:


$ sudo perf kvm stat record --help

 usage: perf kvm stat record [<options>]

    -p, --pid <pid>      record events on existing process id
    -t, --tid <tid>      record events on existing thread id
    -r, --realtime <n>   collect data with this RT SCHED_FIFO priority
        --no-buffering   collect data without buffering
    -a, --all-cpus       system-wide collection from all CPUs
    -C, --cpu <cpu>      list of cpus to monitor
    -c, --count <n>      event period to sample
    -o, --output <file>  output file name
    -i, --no-inherit     child tasks do not inherit counters
    -m, --mmap-pages <pages>
                         number of mmap data pages
    -v, --verbose        be more verbose (show counter open errors, etc)
    -q, --quiet          don't print any message
    -D, --delay <n>      ms to wait before starting measurement after program start
    -u, --uid <user>     user to profile
        --per-thread     use per-thread mmaps

Otherwise, it is the alias of 'perf record:'

 usage: perf record [<options>] [<command>]
    or: perf record [<options>] -- <command> [<options>]

    -e, --event <event>   event selector. use 'perf list' to list available events
        --filter <filter>
                          event filter
    -p, --pid <pid>       record events on existing process id
     .. here is the rest of the 'perf record' options ..


Problems:
1) I could drop some useful options.
2) Running 'perf kvm stat record' with invalid command leads to help message
  from 'perf record':


perf kvm stat record --i-want-help-from-record
  Error: unknown option `i-want-help-from-record'

 usage: perf record [<options>] [<command>]
    or: perf record [<options>] -- <command> [<options>]
    .. snip ..


Any ideas?

Thanks.


Alexander Yarygin (1):
  perf kvm stat record: print kvm specific --help output

 tools/perf/builtin-kvm.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

-- 
1.9.1

