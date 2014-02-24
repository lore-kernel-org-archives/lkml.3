Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaBXCjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 21:39:17 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54634 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaBXCjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 21:39:16 -0500
Message-ID: <530AB0CD.6090602@hitachi.com>
Date: Mon, 24 Feb 2014 11:39:09 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, fche@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -tip  0/2] kprobes/x86: Fix bugs for NMI handling
References: <20140220033924.12285.97230.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140220033924.12285.97230.stgit@ltc230.yrl.intra.hitachi.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Should I resend this series to your kernel.org address?

Thank you,

(2014/02/20 12:39), Masami Hiramatsu wrote:
> The following series fixes bugs hidden in the ancient code.
> 
> The bugs suddenly appeared when I enabled over 6,000 kprobes
> and ran perf-top with --call-graph. The bugs are hidden in
> the old code and it have woken up by real stress testing.
> 
> Actually, current kprobes doesn't expect an NMI handler
> hits in single-stepping state (including preparation and
> do_debug() handling). Moreover, the NMI handler causing
> a page fault by trying to access user pages, is out of
> imagination! :) But perf does it.
> 
> Thus the previous code optimistically check the current
> running kprobe state, and if it is in the singlestep state,
> it changes the IP address to probed address and return,
> because it expects the page fault happened on the single
> stepped code.
> However, in fact, the perf's NMI can interrupt the
> do_debug or somewhere around that and it may cause a
> page fault. In this case, putting the IP address to
> probed address is simply wrong. It causes unexpected
> kernel crash.
> To handle this correctly, this patch fixes it to ensure
> the page-fault address is actually same to the single-
> stepping address, and only if so, set the IP address
> to the probed address.
> 
> I also found another small mistake which gives up the
> recovery from reentered kprobes in single-stepping state,
> but it also assumes that there is no NMI handler interrupts
> in that state. It should gives up only when the nested
> reentering happens.
> 
> Thanks to Ingo and Frank for encouraging me to start
> stress testing with massive multiple kprobes. :)
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (2):
>       [BUGFIX]kprobes/x86: Fix page-fault handling logic
>       kprobes/x86: Allow to handle reentered kprobe on singlestepping
> 
> 
>  arch/x86/kernel/kprobes/core.c |   16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> --
> Signature
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


