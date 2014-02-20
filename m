Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaBTDja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 22:39:30 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59251 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaBTDj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 22:39:29 -0500
Subject: [PATCH -tip  0/2] kprobes/x86: Fix bugs for NMI handling
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, fche@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 20 Feb 2014 12:39:24 +0900
Message-ID: <20140220033924.12285.97230.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes bugs hidden in the ancient code.

The bugs suddenly appeared when I enabled over 6,000 kprobes
and ran perf-top with --call-graph. The bugs are hidden in
the old code and it have woken up by real stress testing.

Actually, current kprobes doesn't expect an NMI handler
hits in single-stepping state (including preparation and
do_debug() handling). Moreover, the NMI handler causing
a page fault by trying to access user pages, is out of
imagination! :) But perf does it.

Thus the previous code optimistically check the current
running kprobe state, and if it is in the singlestep state,
it changes the IP address to probed address and return,
because it expects the page fault happened on the single
stepped code.
However, in fact, the perf's NMI can interrupt the
do_debug or somewhere around that and it may cause a
page fault. In this case, putting the IP address to
probed address is simply wrong. It causes unexpected
kernel crash.
To handle this correctly, this patch fixes it to ensure
the page-fault address is actually same to the single-
stepping address, and only if so, set the IP address
to the probed address.

I also found another small mistake which gives up the
recovery from reentered kprobes in single-stepping state,
but it also assumes that there is no NMI handler interrupts
in that state. It should gives up only when the nested
reentering happens.

Thanks to Ingo and Frank for encouraging me to start
stress testing with massive multiple kprobes. :)

Thank you,

---

Masami Hiramatsu (2):
      [BUGFIX]kprobes/x86: Fix page-fault handling logic
      kprobes/x86: Allow to handle reentered kprobe on singlestepping


 arch/x86/kernel/kprobes/core.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--
Signature

