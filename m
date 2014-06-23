Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaFWJTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:19:19 -0400
Received: from mx0.aculab.com ([213.249.233.131]:60697 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751014AbaFWJTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:19:16 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Chema Gonzalez'" <chema@google.com>,
        Alexei Starovoitov <ast@plumgrid.com>
CC: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        "Jiri Olsa" <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 0/2] split BPF out of core networking
Thread-Topic: [PATCH v2 net-next 0/2] split BPF out of core networking
Thread-Index: AQHPjKbK6dVMO1jaiEqNK8n4efRtEJt+baHA
Date: Mon, 23 Jun 2014 09:18:42 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1726087E@AcuExch.aculab.com>
References: <1401692506-7796-1-git-send-email-ast@plumgrid.com>
	<538C3C94.3080206@redhat.com>
	<CAMEtUuzkjZCsReWH9cZs8AU0mJjZH9YOdCBTWusxe6-NZ9mQ=g@mail.gmail.com>
	<538CAEA6.4060307@redhat.com>
	<CAMEtUuwxJOgYgFjg9deQZOffeg6-JUGZXZ1Rj344eQmriQ0F0Q@mail.gmail.com>
	<538D8DAA.7090105@redhat.com>
	<CAMEtUuw8uyCGeLeUB0PXm5cCpqcsjPLZt6y9FcKjapbVPjWTuw@mail.gmail.com>
	<538E319B.3000606@redhat.com>
	<CAMEtUuzsHJioXZtuGje6UmwZmcmDZEn8PdkkYanA9j1sp242+Q@mail.gmail.com>
	<CA+ZOOTOfq705CbUjx9ppw4gLxJ8JFCaFsphwhAS+NskHVjd86Q@mail.gmail.com>
	<CAMEtUuxU_FKL4TJ2wJtOngean2RjjJxBbYpxNjJQKjA7HtU2Bg@mail.gmail.com>
 <CA+ZOOTOjRmj-C0tncH=j4ZJj8aMMVF1RLK-gQiSB6RG=G5Xo7w@mail.gmail.com>
In-Reply-To: <CA+ZOOTOjRmj-C0tncH=j4ZJj8aMMVF1RLK-gQiSB6RG=G5Xo7w@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5N9JMoG017121

From: Chema Gonzalez
...
> 4.5. BPF_ST|BPF_MEM
> Operation: *(size *) (dst_reg + off16) = imm32
> 
> This insn encodes 2 immediate values (the offset and the imm32 value)
> in the insn, and actually forces the sock_filter_int 64-bit struct to
> have both a 16-bit offset field and a 32-bit immediate field). In
> fact, it's the only instructions that uses .off and .imm at the same
> time (for all other instructions, at least one of the fields is always
> 0).
> 
> This did not exist in classic BPF (where BPF_ST|BPF_MEM actually did
> "mem[pc->k] = A;"). In fact, it's rare to find an ISA that allows
> encoding 2 immediate values in a single insn. My impression (after
> checking the x86 JIT implementation, which works on the eBPF code) is
> that this was added as an x86 optimization, because x86 allows
> encoding 2 values (offset and immediate) by using the displacement and
> immediate suffixes. I wonder whether the ISA would be more readable if
> we did this in 2 insn, one to put dst_reg+off16 in a temporary
> register, and the second a simpler BPF_STX|BPF_MEM. Then we could use
> the same space for the immediate and offset fields.

One option is to add code to the x86 JIT to detect the two instruction
sequence and generate a single instruction.

Thinks further, the JIT might be easier to write if there is a temporary
register that is defined to be only valid for the next instruction (or two).
Then the JIT can completely optimise away any assignments to it without
requiring a full analysis of the entire program.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
