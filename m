Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab3J1Mim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:38:42 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:45633 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab3J1Mik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:38:40 -0400
In-Reply-To: <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
References: <12083.1382486094@ale.ozlabs.ibm.com>	<20131023141948.GB3566@localhost.localdomain>
	<20131025173749.GG19466@laptop.lan> <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
X-KeepSent: B9096CCA:68AAFFFB-42257C12:0044F107;
 type=4; name=$KeepSent
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        Peter Zijlstra <peterz@infradead.org>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
From: Victor Kaplansky <VICTORK@il.ibm.com>
Date: Mon, 28 Oct 2013 14:38:29 +0200
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5|July 31, 2013) at
 28/10/2013 14:38:22
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102812-0542-0000-0000-000006E1AC65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Frederic Weisbecker <fweisbec@gmail.com>
>
> 2013/10/25 Peter Zijlstra <peterz@infradead.org>:
> > On Wed, Oct 23, 2013 at 03:19:51PM +0100, Frederic Weisbecker wrote:
> > I would argue for
> >
> >   READ ->data_tail                      READ ->data_head
> >   smp_rmb()     (A)                     smp_rmb()       (C)
> >   WRITE $data                           READ $data
> >   smp_wmb()     (B)                     smp_mb()        (D)
> >   STORE ->data_head                     WRITE ->data_tail
> >
> > Where A pairs with D, and B pairs with C.
> >
> > I don't think A needs to be a full barrier because we won't in fact
> > write data until we see the store from userspace. So we simply don't
> > issue the data WRITE until we observe it.
> >
> > OTOH, D needs to be a full barrier since it separates the data READ
from
> > the tail WRITE.
> >
> > For B a WMB is sufficient since it separates two WRITEs, and for C an
> > RMB is sufficient since it separates two READs.
>
> Hmm, I need to defer on you for that, I'm not yet comfortable with
> picking specific barrier flavours when both write and read are
> involved in a same side :)

I think you have a point :) IMO, memory barrier (A) is superfluous.
At producer side we need to ensure that "WRITE $data" is not committed to
memory
before "READ ->data_tail" had seen a new value and if the old one indicated
that
there is no enough space for a new entry. All this is already guaranteed by
control flow dependancy on single CPU - writes will not be committed to the
memory
if read value of "data_tail" doesn't specify enough free space in the ring
buffer.

Likewise, on consumer side, we can make use of natural data dependency and
memory ordering guarantee for single CPU and try to replace "smp_mb" by
a more light-weight "smp_rmb":

READ ->data_tail                      READ ->data_head
// ...                                smp_rmb()       (C)
WRITE $data                           READ $data
smp_wmb()     (B)                     smp_rmb()       (D)
						  READ $header_size
STORE ->data_head                     WRITE ->data_tail = $old_data_tail +
$header_size

We ensure that all $data is read before "data_tail" is written by doing
"READ $header_size" after
all other data is read and we rely on natural data dependancy between
"data_tail" write
and "header_size" read.

-- Victor

