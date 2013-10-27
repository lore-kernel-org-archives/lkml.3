Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab3J0JAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 05:00:47 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:35276 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3J0JAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 05:00:45 -0400
In-Reply-To: <20131025173749.GG19466@laptop.lan>
References: <12083.1382486094@ale.ozlabs.ibm.com> <20131023141948.GB3566@localhost.localdomain> <20131025173749.GG19466@laptop.lan>
Subject: Re: perf events ring buffer memory barrier on powerpc
X-KeepSent: 1519E98D:692AF083-42257C11:002E693E;
 type=4; name=$KeepSent
To: Peter Zijlstra <peterz@infradead.org>
Cc: anton@samba.org, benh@kernel.crashing.org,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        michael@ellerman.id.au, Michael Neuling <mikey@neuling.org>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OF1519E98D.692AF083-ON42257C11.002E693E-42257C11.00317D48@il.ibm.com>
From: Victor Kaplansky <VICTORK@il.ibm.com>
Date: Sun, 27 Oct 2013 11:00:33 +0200
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5|July 31, 2013) at
 27/10/2013 11:00:23
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102709-4966-0000-0000-0000074DEB7C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote on 10/25/2013 07:37:49 PM:

> I would argue for:
>
>   READ ->data_tail         READ ->data_head
>     smp_rmb()   (A)          smp_rmb()   (C)
>   WRITE $data              READ $data
>     smp_wmb()   (B)          smp_mb()   (D)
>   STORE ->data_head        WRITE ->data_tail
>
> Where A pairs with D, and B pairs with C.

1. I agree. My only concern is that architectures which do use atomic
operations
with memory barriers, will issue two consecutive barriers now, which is
sub-optimal.

2. I think the comment in "include/linux/perf_event.h" describing
"data_head" and
"data_tail" for user space need an update as well. Current version -

        /*
         * Control data for the mmap() data buffer.
         *
         * User-space reading the @data_head value should issue an rmb(),
on
         * SMP capable platforms, after reading this value -- see
         * perf_event_wakeup().
         *
         * When the mapping is PROT_WRITE the @data_tail value should be
         * written by userspace to reflect the last read data. In this case
         * the kernel will not over-write unread data.
         */
        __u64   data_head;              /* head in the data section */
        __u64   data_tail;              /* user-space written tail */

- say nothing about the need of memory barrier before "data_tail" write.

-- Victor


