Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab3LLGCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 01:02:14 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51494 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3LLGCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 01:02:13 -0500
Message-ID: <52A9515E.5050505@hitachi.com>
Date: Thu, 12 Dec 2013 15:02:06 +0900
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
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204084551.GA31772@gmail.com> <529FBA71.6070107@hitachi.com> <20131205102127.GA19923@gmail.com> <52A137B6.6030307@hitachi.com> <20131210152811.GA1195@gmail.com> <52A7CA0A.9060009@hitachi.com> <20131211133423.GB3101@gmail.com>
In-Reply-To: <20131211133423.GB3101@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/11 22:34), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>>> So why are annotations needed at all? What can happen if an 
>>> annotation is missing and a piece of code is probed which is also 
>>> used by the kprobes code internally - do we crash, lock up, 
>>> misbehave or handle it safely?
>>
>> The kprobe has recursion detector, [...]
> 
> It's the 'current_kprobe' percpu variable, checked via 
> kprobe_running(), right?

Right. :)

>> [...] but it is detected in the kprobe exception(int3) handler, this 
>> means that if we put a probe before detecting the recursion, we'll 
>> do an infinite recursion.
> 
> So only the (presumably rather narrow) code path leading to the 
> recursion detection code has to be annotated, correct?

Yes, correct.

>> And also, even if we can detect the recursion, we can't stop the 
>> kernel, we need to skip the probe. This means that we need to 
>> recover to the main execution path by doing single step. As you may 
>> know, since the single stepping involves the debug exception, we 
>> have to avoid proving on that path too. Or we'll have an infinite 
>> recursion again.
> 
> I don't see why this is needed: if a "probing is disabled" recursion 
> flag is set the moment the first probe fires, and if it's only cleared 
> once all processing is finished, then any intermediate probes should 
> simply return early from int3 and not fire.

No, because the int3 already changes the original instruction.
This means that you cannot skip singlestep(or emulate) the
instruction which is copied to execution buffer (ainsn->insn),
even if you have such the flag.
So, kprobe requires the annotations on the singlestep path.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


