Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab3JJUGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:06:37 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:45073 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab3JJUGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:06:36 -0400
Date: Thu, 10 Oct 2013 17:06:27 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [GIT PULL] tools/perf/build: Speed up the perf build system
Message-ID: <20131010200627.GK28369@ghostprotocols.net>
References: <20131009070149.GA32023@gmail.com>
 <20131009143830.GA28369@ghostprotocols.net>
 <20131009145157.GA27139@gmail.com>
 <20131010192608.GI28369@ghostprotocols.net>
 <20131010195014.GJ28369@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010195014.GJ28369@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 10, 2013 at 04:50:14PM -0300, Arnaldo Carvalho de Melo escreveu:
> /me scratches head, tried this on another kvm guest, ubuntu 13.04,
> x86_64, works as expected, but stumbled in another problem:
> 
> acme@ubuntu-acme:~/git/linux$ time make -C tools/perf -f tests/make
> make: Entering directory `/home/acme/git/linux/tools/perf'
> make[3]: *** No rule to make target
> `/home/git/linux/tools/lib/traceevent/trace-seq.c', needed by
> `.trace-seq.d'.  Stop.
> make[2]: ***
> [/home/acme/git/linux/tools/lib/traceevent/libtraceevent.a-clean] Error
> 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [clean] Error 2
> make: *** [make_pure] Error 2
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> 
> real	0m0.254s
> user	0m0.064s
> sys	0m0.084s
> acme@ubuntu-acme:~/git/linux$
> 
> And this does work on a RHEL6 box, continue to investigate...

Ok, if I do:

acme@ubuntu-acme:~/git/linux$ make -C tools clean
<SNIP>
make[1]: Entering directory `/home/acme/git/linux/tools/perf'
  CLEAN    libtraceevent
  CLEAN    config
make[3]: *** No rule to make target
`/home/git/linux/tools/lib/traceevent/trace-seq.c', needed by
`.trace-seq.d'.  Stop.
make[2]: ***
[/home/acme/git/linux/tools/lib/traceevent/libtraceevent.a-clean] Error
2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [clean] Error 2
make[1]: Leaving directory `/home/acme/git/linux/tools/perf'
make: *** [perf_clean] Error 2
make: Leaving directory `/home/acme/git/linux/tools'
acme@ubuntu-acme:~/git/linux$

So, if cleaning manually:

[acme@zoo linux]$ find tools -name ".*.d"
tools/lib/traceevent/.trace-seq.d
tools/lib/traceevent/.event-parse.d
tools/lib/traceevent/.parse-filter.d
tools/lib/traceevent/.kbuffer-parse.d
tools/lib/traceevent/.parse-utils.d
[acme@zoo linux]$ find tools -name ".*.d" | xargs rm
[acme@zoo linux]$ find tools -name ".*.d"
[acme@zoo linux]$

(on the NFS server, mind you)

And now trying again to clean on ubuntu (NFS client):

Works, trying again tests/make...

acme@ubuntu-acme:~/git/linux$ time make -C tools/perf -f tests/make
make: Entering directory `/home/acme/git/linux/tools/perf'
- make_pure: cd . && make -f Makefile DESTDIR=/tmp/tmp.2uwAzyGti8



-----------------------

Take a while, even more over NFS it seems, could do with some
paralelization... ;-) :-)

Anyway, letting it run and not doing anything on that source tree in any
other machine (NFS server or clients), will see..

- Arnaldo
