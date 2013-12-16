Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab3LPKxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:53:49 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35285 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3LPKxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:53:48 -0500
Message-ID: <52AEDBB4.5060502@hitachi.com>
Date: Mon, 16 Dec 2013 19:53:40 +0900
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
Subject: Re: Re: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL()
 and fixes crash bugs
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204084551.GA31772@gmail.com> <529FBA71.6070107@hitachi.com> <20131205102127.GA19923@gmail.com> <52A137B6.6030307@hitachi.com> <20131210152811.GA1195@gmail.com> <52A7CA0A.9060009@hitachi.com> <20131211133423.GB3101@gmail.com> <52A9515E.5050505@hitachi.com> <20131212140347.GA17059@gmail.com> <52AA9C55.1000103@hitachi.com>
In-Reply-To: <52AA9C55.1000103@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

(2013/12/13 14:34), Masami Hiramatsu wrote:
>>>>> And also, even if we can detect the recursion, we can't stop the 
>>>>> kernel, we need to skip the probe. This means that we need to 
>>>>> recover to the main execution path by doing single step. As you 
>>>>> may know, since the single stepping involves the debug exception, 
>>>>> we have to avoid proving on that path too. Or we'll have an 
>>>>> infinite recursion again.
>>>>
>>>> I don't see why this is needed: if a "probing is disabled" 
>>>> recursion flag is set the moment the first probe fires, and if 
>>>> it's only cleared once all processing is finished, then any 
>>>> intermediate probes should simply return early from int3 and not 
>>>> fire.
>>>
>>> No, because the int3 already changes the original instruction.
>>> This means that you cannot skip singlestep(or emulate) the
>>> instruction which is copied to execution buffer (ainsn->insn),
>>> even if you have such the flag.
>>> So, kprobe requires the annotations on the singlestep path.
>>
>> I don't understand this reasoning.
>>
>> Lets assume we allow a probe to be inserted in the single-step path. 
>> Such a probe will be an INT3 instruction and if it hits we get a 
>> recursive INT3 invocation. In that case the INT3 handler should simply
>> restore the original instruction and _leave it so_. There's no 
>> single-stepping needed - the probe is confused and must be discarded.
> 
> But how can we restore the protected kernel text?
> If we use text_poke, we also need to prohibit probing on the text_poke
> and functions called in the text_poke too. That just shifts the annotated
> area to the text_poke. :(


OK, I've checked current text_poke() and thought how we can do that.
The current text_poke() uses special fixmap to make alias pages for
avoiding kernel-text readonly protection. For protecting the fixmap
pages, we are currently using text_mutex and this is why we can't use
it in exception path. There are other minor issues, but it seems to
be fixed easily. :)

Thus, for recovering original instruction in the int3 handler,
I'd like to propose adding another text_poke like function, which
requires another fixmap page and protects it by using raw_spinlock
(to avoid tracing), and just support one-byte poke (this means it
 never across the page boundary).

Perhaps, it can be implemented inside kprobes, because it is not
useful for other subsystems.

Thank you!


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


