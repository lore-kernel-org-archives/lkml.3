Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaAINQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 08:16:53 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:45078 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaAINQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 08:16:44 -0500
Subject: Re: [PATCH 03/28] perf tools: Remove symbol_conf.use_callchain
 check
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
In-Reply-To: <20140108125755.GC15464@ghostprotocols.net>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
	 <1389170793-21926-4-git-send-email-namhyung@kernel.org>
	 <20140108125755.GC15464@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jan 2014 22:16:36 +0900
Message-ID: <1389273396.1722.37.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-08 (수), 09:57 -0300, Arnaldo Carvalho de Melo:
> Em Wed, Jan 08, 2014 at 05:46:08PM +0900, Namhyung Kim escreveu:
> > The machine__resolve_callchain() is called only if symbol_conf.
> > use_callchain is set so no need to check it again.
> 
> Not really it may be called with use_callchain not set, I'm checking if
> the logic is needed (doesn't look like).

To be more precise, it's called with use_callchain not set - if "--sort
parent" was given on the command line.  But even in this case we need to
proceed the callchain traversal, if not the parent column will have
invalid results since it only sees the first entry (usually itself) and
then stops.

  $ perf report -s sym,parent
  +   2.66%  [k] rb_next                                sys_ioctl
  +   1.52%  [.] pthread_mutex_lock                     [other]
  +   0.92%  [k] page_fault                             [other]
  +   0.92%  [.] 0x00000000008dca3f                     [other]
  +   0.86%  [.] 0x0000000000a052e9                     [other]
  +   0.76%  [.] pthread_mutex_unlock                   [other]
  +   0.73%  [.] 0x0000000000976361                     [other]
  +   0.69%  [k] find_vma                               sys_mmap_pgoff

  $ perf report -s sym,parent -g none
  +   2.66%  [k] rb_next                                [other]
  +   1.52%  [.] pthread_mutex_lock                     [other]
  +   0.92%  [k] page_fault                             [other]
  +   0.92%  [.] 0x00000000008dca3f                     [other]
  +   0.86%  [.] 0x0000000000a052e9                     [other]
  +   0.76%  [.] pthread_mutex_unlock                   [other]
  +   0.73%  [.] 0x0000000000976361                     [other]
  +   0.69%  [k] find_vma                               [other]


With --children patchset, we'll need to traverse the callstack
regardless of the use_callchain anyway. So we need this patch.

Thanks,
Namhyung


