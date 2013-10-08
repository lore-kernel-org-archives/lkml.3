Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab3JHMW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:22:26 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:59974 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab3JHMWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:22:23 -0400
Date: Tue, 8 Oct 2013 14:22:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>, jiri@gmail.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 39/52] tools/perf/build: Automatically build in parallel,
 based on number of CPUs in the syst
Message-ID: <20131008122219.GA2678@gmail.com>
References: <5253F4D4.7070402@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5253F4D4.7070402@draigBrady.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pádraig Brady <P@draigBrady.com> wrote:

> On 10/08/2013 10:02 AM, Ingo Molnar wrote:
> > +ifeq ($(JOBS),)
> > +  JOBS := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null)
> 
> nproc is probably ubiquitous enough to use now
> (available since coreutils 8.1 (end of 2009))
> 
> As well as being more concise, it will take
> account of offline CPUs etc.

/proc/cpuinfo takes account of offline CPUs as well:

  # grep -c ^processor /proc/cpuinfo 2>/dev/null
  16

  # echo 0 > /sys/devices/system/cpu/cpu11/online
  # grep -c ^processor /proc/cpuinfo 2>/dev/null
  15

  # echo 1 > /sys/devices/system/cpu/cpu11/online
  # grep -c ^processor /proc/cpuinfo 2>/dev/null
  16

But nproc is indeed a better choice:

1)

It is scheduler syscall based and will thus will work in limited 
environments as well, for example when /proc is not mounted.

2)

It will also properly detect affinity-limited environments:

  # taskset 1 nproc
  1

3)

It is also faster than grepping /proc/cpuinfo:

  # perf stat --null --repeat 100 nproc >/dev/null
   Performance counter stats for 'nproc' (100 runs):
       0.000652928 seconds time elapsed                                          ( +-  0.53% )

versus:

  # perf stat --null --repeat 100 grep -c ^processor /proc/cpuinfo >/dev/null
    Performance counter stats for 'grep -c ^processor /proc/cpuinfo' (100 runs):
       0.001037034 seconds time elapsed                                          ( +-  0.32% )

so with 0.652 msecs versus 1.037 msecs it's about 60% faster than grep.

Thanks,

	Ingo
