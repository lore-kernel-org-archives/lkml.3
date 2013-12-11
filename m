Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab3LKCMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:12:35 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45105 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3LKCMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:12:33 -0500
Message-ID: <52A7CA0A.9060009@hitachi.com>
Date: Wed, 11 Dec 2013 11:12:26 +0900
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
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204084551.GA31772@gmail.com> <529FBA71.6070107@hitachi.com> <20131205102127.GA19923@gmail.com> <52A137B6.6030307@hitachi.com> <20131210152811.GA1195@gmail.com>
In-Reply-To: <20131210152811.GA1195@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/11 0:28), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2013/12/05 19:21), Ingo Molnar wrote:
>>>
>>> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>
>>>>> So we need both a maintainable and a sane/safe solution, and I'd 
>>>>> like to apply the whole thing at once and be at ease that the 
>>>>> solution is round. We should have done this years ago.
>>>>
>>>> For the safeness of kprobes, I have an idea; introduce a whitelist 
>>>> for dynamic events. AFAICS, the biggest unstable issue of kprobes 
>>>> comes from putting *many* probes on the functions called from 
>>>> tracers.
>>>
>>> If the number of 'noprobe' annotations is expected to explode then 
>>> maybe another approach should be considered.
>>
>> No, since this is a "quantitative" issue, the annotation helps us.

Sorry for confusion, it should be "the annotation helps us to solves
only for qualitative issue". It's my miss...

>>> For example in perf we detect recursion. Could kprobes do that and 
>>> detect hitting a probe while running kprobes code, and ignore it [do 
>>> an early return]?
>>
>> Yes, the kprobe itself already has recursion detector and it rejects
>> calling handler.
> 
> So why are annotations needed at all? What can happen if an annotation 
> is missing and a piece of code is probed which is also used by the 
> kprobes code internally - do we crash, lock up, misbehave or handle it 
> safely?

The kprobe has recursion detector, but it is detected in the kprobe
exception(int3) handler, this means that if we put a probe before
detecting the recursion, we'll do an infinite recursion.
And also, even if we can detect the recursion, we can't stop the
kernel, we need to skip the probe. This means that we need to recover
to the main execution path by doing single step. As you may know,
since the single stepping involves the debug exception, we have to
avoid proving on that path too. Or we'll have an infinite recursion
again.
This is the basic reason why the __kprobes annotation is introduced.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


