Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3LDX14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:27:56 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55263 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3LDX1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:27:53 -0500
Message-ID: <529FBA71.6070107@hitachi.com>
Date: Thu, 05 Dec 2013 08:27:45 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and
 fixes crash bugs
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204084551.GA31772@gmail.com>
In-Reply-To: <20131204084551.GA31772@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/04 17:45), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Hi,
>> Here is the version 4 of NOKPORBE_SYMBOL series.
>>
>> In this version, I removed the cleanup patches and
>> add bugfixes I've found, since those bugs will be
>> critical.
>>
>> Rest of the cleanup and visible blacklists will be proposed later in 
>> another series.
> 
> Ok, let me make it clear: we need _both_ the conceptual cleanups and 
> the bug fixes.

I see. Why I split this out is because it includes an RFC patch,
and for easier review. I still have a series of cleanups :)

> Right now kprobes are restricted to root, and they are unsafe and 
> buggy, and rather fundamentally so, because probing cannot be done 
> safely without potentially crashing the kernel. So there's no 
> 'regression' to be fixed, it's mostly about pre-existing bugs - so 
> there's no requirement for them to come before maintainability 
> cleanups.

OK, I think the kprobe is like a strong medicine, not a toy,
since it can intercept most of the kernel functions which
may process a sensitive user private data. Thus even if we
fix all bugs and make it safe, I don't think we can open
it for all users (of course, there should be a knob to open
for any or restricted users.)

> So we need both a maintainable and a sane/safe solution, and I'd like 
> to apply the whole thing at once and be at ease that the solution is 
> round. We should have done this years ago.

For the safeness of kprobes, I have an idea; introduce a whitelist
for dynamic events. AFAICS, the biggest unstable issue of kprobes
comes from putting *many* probes on the functions called from tracers.

It doesn't crash the kernel but slows down so much, because every
probes hit many other nested miss-hit probes. This gives us a big
performance impact. However, on the other side, this kind of feature
can be used *for debugging* static trace events by dynamic one if we
carefully use a small number of probes on such functions. :)

Thus, I think we can restrict users from probing such functions by
using a whitelist which ftrace does already have;
 available_filter_functions :)

Then, I'd like to propose this new whitelist feature in kprobe-tracer
(not raw kprobe itself). And a sysctl knob for disabling the whitelist.
That knob will be /proc/sys/debug/kprobe-event-whitelist and disabling
it will mark kernel tainted so that we can check it from bug reports.

> So could you please send a whole series that I can apply to -tip as a 
> work in progress tree, and then we can see what is left to be solved?

Sure. :) BTW, would I better fold the cleanups for reducing the number of
patches?

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


