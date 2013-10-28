Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3J1KCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:02:05 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:34101 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3J1KCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:02:03 -0400
MIME-Version: 1.0
In-Reply-To: <20131025173749.GG19466@laptop.lan>
References: <12083.1382486094@ale.ozlabs.ibm.com>
	<20131023141948.GB3566@localhost.localdomain>
	<20131025173749.GG19466@laptop.lan>
Date: Mon, 28 Oct 2013 11:02:01 +0100
Message-ID: <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/25 Peter Zijlstra <peterz@infradead.org>:
> On Wed, Oct 23, 2013 at 03:19:51PM +0100, Frederic Weisbecker wrote:
> I would argue for:
>
>   READ ->data_tail                      READ ->data_head
>   smp_rmb()     (A)                     smp_rmb()       (C)
>   WRITE $data                           READ $data
>   smp_wmb()     (B)                     smp_mb()        (D)
>   STORE ->data_head                     WRITE ->data_tail
>
> Where A pairs with D, and B pairs with C.
>
> I don't think A needs to be a full barrier because we won't in fact
> write data until we see the store from userspace. So we simply don't
> issue the data WRITE until we observe it.
>
> OTOH, D needs to be a full barrier since it separates the data READ from
> the tail WRITE.
>
> For B a WMB is sufficient since it separates two WRITEs, and for C an
> RMB is sufficient since it separates two READs.

Hmm, I need to defer on you for that, I'm not yet comfortable with
picking specific barrier flavours when both write and read are
involved in a same side :)
