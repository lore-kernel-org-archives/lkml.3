Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3LLUmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:42:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab3LLUmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:42:31 -0500
Message-ID: <52AA1FA8.30709@redhat.com>
Date: Thu, 12 Dec 2013 12:42:16 -0800
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and
 fixes crash bugs
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204084551.GA31772@gmail.com> <529FBA71.6070107@hitachi.com> <20131205102127.GA19923@gmail.com> <52A137B6.6030307@hitachi.com> <20131210152811.GA1195@gmail.com> <52A7CA0A.9060009@hitachi.com> <20131211133423.GB3101@gmail.com> <52A9515E.5050505@hitachi.com> <20131212140347.GA17059@gmail.com>
In-Reply-To: <20131212140347.GA17059@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 06:03 AM, Ingo Molnar wrote:
>> No, because the int3 already changes the original instruction.
>> This means that you cannot skip singlestep(or emulate) the
>> instruction which is copied to execution buffer (ainsn->insn),
>> even if you have such the flag.
>> So, kprobe requires the annotations on the singlestep path.
> I don't understand this reasoning.
> 
> Lets assume we allow a probe to be inserted in the single-step path. 
> Such a probe will be an INT3 instruction and if it hits we get a 
> recursive INT3 invocation. In that case the INT3 handler should simply 
> restore the original instruction and _leave it so_. There's no 
> single-stepping needed - the probe is confused and must be discarded.

So if you restore the original instruction, then you're essentially
creating a dynamic blacklist for the singlestep path, right?  I think
that's fine, as long as you still allow recursive probes elsewhere to
just singlestep and skip that occurrence.

It also helps with the inlining issues, since an inlined function
instance in the singlestep path can get dynamically blocked, while still
allowing inline instances elsewhere to be probed normally.  Then you
don't have to force always/never inline decisions - whatever gcc decides
to do with inlines and static functions can be dealt with.


Josh
