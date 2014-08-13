Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaHMXZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 19:25:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48085 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaHMXZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 19:25:18 -0400
Date: Wed, 13 Aug 2014 16:25:16 -0700 (PDT)
Message-Id: <20140813.162516.1876660483788283579.davem@davemloft.net>
To: David.Laight@ACULAB.COM
Cc: ast@plumgrid.com, mingo@kernel.org, torvalds@linux-foundation.org,
        luto@amacapital.net, rostedt@goodmis.org, dborkman@redhat.com,
        chema@google.com, edumazet@google.com, a.p.zijlstra@chello.nl,
        hpa@zytor.com, akpm@linux-foundation.org, keescook@chromium.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v4 net-next 00/26] BPF syscall, maps, verifier,
 samples, llvm
From: David Miller <davem@davemloft.net>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D174760F3@AcuExch.aculab.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
	<063D6719AE5E284EB5DD2968C1650D6D174760F3@AcuExch.aculab.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Aug 2014 16:25:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 13 Aug 2014 08:52:30 +0000

> From: Of Alexei Starovoitov
>> one more RFC...
>> 
>> Major difference vs previous set is a new 'load 64-bit immediate' eBPF insn.
>> Which is first 16-byte instruction. It shows how eBPF ISA can be extended
>> while maintaining backward compatibility, but mainly it cleans up eBPF
>> program access to maps and improves run-time performance.
> 
> Wouldn't it be more sensible to follow the scheme used by a lot of cpus
> and add a 'load high' instruction (follow with 'add' or 'or').
> It still takes 16 bytes to load a 64bit immediate value, but the instruction
> size remains constant.
> There is nothing to stop any JIT software detecting the instruction pair.

The opposite argument is that JITs can expand the IMM64 load into whatever
sequence of instructions is most optimal.

My only real gripe with IMM64 loads is that it's not mainly for
loading an immediate, it's for loading a pointer.  And this
distinction is important for some JITs.

For example, on sparc64 all symbol based addresses are actually 32-bit
because of the code model we use to compile the kernel and all modules.
So if we knew this is a pointer load and it's to a symbol in a kernel
or module image, we could do a 32-bit load.
