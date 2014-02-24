Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaBXRY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:24:56 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38430 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbaBXRYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:24:55 -0500
Date: Mon, 24 Feb 2014 17:24:41 +0000
From: Will Deacon <will.deacon@arm.com>
To: adrian.hunter@intel.com, jolsa@redhat.com, acme@redhat.com,
        a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [perf tool] record failure with 3.14-rc4
Message-ID: <20140224172440.GF2553@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

If I try to run perf record as a non-root user, I end up with the following
(unhelpful) error:

  $ perf record -e cycles ls
  [...]
  Not enough memory for reading perf file header

This is because the addresses in /proc/kallsyms always read as 0x0 when
viewed by a non-privileged user, causing kallsyms__get_function_start to
return 0x0 in args.start. machine__create_kernel_maps then treats this as
an error an returns -1 to perf_session__create_kernel_maps, causing
perf_session__new to fail and perf to exit.

The perf tool code in 3.13 is perfectly happy creating maps at 0x0, but I
can see this has changed quite substantially in the recent merge window.

Any ideas? We could fix kallsyms__get_function_start to return < 0 on
failure then fix the checks in the callers. Adrian?

Will
