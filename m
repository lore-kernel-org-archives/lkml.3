Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3KAOZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:25:57 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:53019 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3KAOZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:25:55 -0400
In-Reply-To: <20131031064015.GV4126@linux.vnet.ibm.com>
References: <20131023141948.GB3566@localhost.localdomain> <20131025173749.GG19466@laptop.lan> <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com> <20131028132634.GO19466@laptop.lan> <20131028163418.GD4126@linux.vnet.ibm.com> <20131028201735.GA15629@redhat.com> <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com> <20131030092725.GL4126@linux.vnet.ibm.com> <20131030112526.GI16117@laptop.programming.kicks-ass.net> <20131031064015.GV4126@linux.vnet.ibm.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
X-KeepSent: 2F28411B:D04C5B5A-42257C16:004E02C5;
 type=4; name=$KeepSent
To: paulmck@linux.vnet.ibm.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OF2F28411B.D04C5B5A-ON42257C16.004E02C5-42257C16.004F420C@il.ibm.com>
From: Victor Kaplansky <VICTORK@il.ibm.com>
Date: Fri, 1 Nov 2013 16:25:42 +0200
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5|July 31, 2013) at
 01/11/2013 16:25:35
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110114-8372-0000-0000-000007A42329
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote on 10/31/2013
08:40:15 AM:

> > void ubuf_read(void)
> > {
> >    u64 head, tail;
> >
> >    tail = ACCESS_ONCE(ubuf->tail);
> >    head = ACCESS_ONCE(ubuf->head);
> >
> >    /*
> >     * Ensure we read the buffer boundaries before the actual buffer
> >     * data...
> >     */
> >    smp_rmb(); /* C, matches with B */
> >
> >    while (tail != head) {
> >       obj = ubuf->data + tail;
> >       /* process obj */
> >       tail += obj->size;
> >       tail %= ubuf->size;
> >    }
> >
> >    /*
> >     * Ensure all data reads are complete before we issue the
> >     * ubuf->tail update; once that update hits, kbuf_write() can
> >     * observe and overwrite data.
> >     */
> >    smp_mb(); /* D, matches with A */
> >
> >    ubuf->tail = tail;
> > }

> > Could we replace A and C with an smp_read_barrier_depends()?
>
> C, yes, given that you have ACCESS_ONCE() on the fetch from ->tail
> and that the value fetch from ->tail feeds into the address used for
> the "obj =" assignment.

No! You must to have a full smp_rmb() at C. The race on the reader side
is not between fetch of @tail and read from address pointed by @tail.
The real race here is between a fetch of @head and read of obj from
memory pointed by @tail.

Regards,
-- Victor

