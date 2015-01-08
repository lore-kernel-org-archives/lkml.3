Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbbAHPWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:22:05 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:51326 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbbAHPWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:22:01 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 8 Jan 2015 10:22:37 -0500 (EST)
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: perf: PERF_FLAG_FD_OUTPUT has been broken since 2.6.35
Message-ID: <alpine.DEB.2.11.1501081014460.24664@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was working on improving the manpage by working out how the 
perf_event_open() PERF_FLAG_FD_OUTPUT flag works.

It turns out it doesn't.

In kernel/events/core.c when opening a file this is done:

        if (output_event) {
           err = perf_event_set_output(event, output_event);
           if (err)
              goto err_context;
        }

	and perf_event_set_output() does:

                if (output_event->cpu == -1 && output_event->ctx != event->ctx) {
                   goto out;
                }

	But event->ctx is always NULL; it does not get set to ctx until
	after the call to perf_event_set_output().

	It looks like this was broken back in 2.6.35 days with the change:

		commit ac9721f3f54b27a16c7e1afb2481e7ee95a70318
		Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
		Date:   Thu May 27 12:54:41 2010 +0200

		perf_events: Fix races and clean up perf_event and perf_mmap_data interaction

So is this worth fixing seeing as apparently no one uses this feature?

As an aside, added error reporting is *really* needed as I had to sprinkle
all of events/core.c with printk() calls to even begin to understand why
I was getting the EINVAL result.

Vince
