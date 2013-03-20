Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab3CTML1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:11:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46563 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998Ab3CTMLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:11:24 -0400
Date: Wed, 20 Mar 2013 12:11:11 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@redhat.com, feng.tang@intel.com,
        acme@redhat.com
Subject: Perf tool won't build without libnewt
Message-ID: <20130320121111.GB16485@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I attempted to cross-build v3.9-rc3's perf tool for an arm system today, and
got the following out of the build system:

CHK libnewt
Makefile:655: newt not found, disables TUI support. Please install newt-devel or libnewt-dev
[...]
builtin-report.c: In function ‘__cmd_report’:
builtin-report.c:478:15: error: ‘K_SWITCH_INPUT_DATA’ undeclared (first use in this function)
builtin-report.c:478:15: note: each undeclared identifier is reported only once for each function it appears in
builtin-report.c: In function ‘cmd_report’:
builtin-report.c:821:13: error: ‘K_SWITCH_INPUT_DATA’ undeclared (first use in this function)
make: *** [builtin-report.o] Error 1
make: *** Waiting for unfinished jobs....

I've bisected this down to ad0de0971b: "perf report: Enable the runtime
switching of perf data file".

It looks like when NEWT_SUPPORT is defined, builtin-report.c gets
K_SWITCH_INPUT_DATA via util/hist.h, which includes ui/keysyms.h. When
NEWT_SUPPORT isn't defined, util/hist.t doesn't include ui/keysyms.h and the
build fails. I'm able to reproduce the problem on my x86 desktop by
uninstalling libnewt-dev.

As far as I can see, we can't just always include ui/keysyms.h as it includes
libslang.h (which may or may not be present if libnewt isn't, and we don't
check for it independently). I'm not sure what the best way to fix this would
be.

Thanks,
Mark.
