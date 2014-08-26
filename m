Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbaHZBGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 21:06:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40238 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbaHZBGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 21:06:23 -0400
Date: Mon, 25 Aug 2014 18:06:21 -0700 (PDT)
Message-Id: <20140825.180621.1003932711320755950.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, torvalds@linux-foundation.org, luto@amacapital.net,
        rostedt@goodmis.org, dborkman@redhat.com, chema@google.com,
        edumazet@google.com, a.p.zijlstra@chello.nl, brendan.d.gregg@gmail.com,
        namhyung@kernel.org, hpa@zytor.com, akpm@linux-foundation.org,
        keescook@chromium.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 net-next 1/6] net: filter: add "load 64-bit
 immediate" eBPF instruction
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409014858-1410-2-git-send-email-ast@plumgrid.com>
References: <1409014858-1410-1-git-send-email-ast@plumgrid.com>
	<1409014858-1410-2-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Aug 2014 18:06:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Mon, 25 Aug 2014 18:00:53 -0700

> add BPF_LD_IMM64 instruction to load 64-bit immediate value into a register.

I think you need to rethink this.

I understand that you want to be able to compile arbitrary C code into
eBPF, but you have to restrict strongly what data the eBPF code can get
to.

Arbitrary pointer loads is asking for trouble.

Instead I would rather you look into a model like what the quake
engine uses for it's VM.

Namely, the program can do loads and stores from/to a data section,
but all of them are validated to be in the range of the VM program's
image.

eBPF programs should only be able to access things using either:

1) Well defined entry/exit points for control transfer

2) Load/Store within a private limited data segment range used
   only by the eBPF program

I don't want the eBPF program to be able to get "out of it's box"
in any way shape or form.

And besides, you're only making this thing as an optimization right?
