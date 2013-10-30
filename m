Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab3J3RQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:16:00 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:53995 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3J3RP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:15:59 -0400
In-Reply-To: <20131030153931.GM16117@laptop.programming.kicks-ass.net>
References: <20131025173749.GG19466@laptop.lan> <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com> <20131028132634.GO19466@laptop.lan> <20131028163418.GD4126@linux.vnet.ibm.com> <20131028201735.GA15629@redhat.com> <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com> <20131030092725.GL4126@linux.vnet.ibm.com> <20131030112526.GI16117@laptop.programming.kicks-ass.net> <OFF6C78E48.E477DB1E-ON42257C14.0050F9B3-42257C14.0051AC6D@il.ibm.com> <20131030153931.GM16117@laptop.programming.kicks-ass.net>
Subject: Re: perf events ring buffer memory barrier on powerpc
X-KeepSent: CA1DB4AC:7D4F6EEE-42257C14:0056F77D;
 type=4; name=$KeepSent
To: Peter Zijlstra <peterz@infradead.org>
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFCA1DB4AC.7D4F6EEE-ON42257C14.0056F77D-42257C14.005EB5EA@il.ibm.com>
From: Victor Kaplansky <VICTORK@il.ibm.com>
Date: Wed, 30 Oct 2013 19:14:29 +0200
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5|July 31, 2013) at
 30/10/2013 19:14:21
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103017-3548-0000-0000-000006FF6B7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote on 10/30/2013 05:39:31 PM:

> Although I suppose speculative reads are allowed -- they don't have the
> destructive behaviour speculative writes have -- and thus we could in
> fact get reorder issues.

I agree.

>
> But since it is still a dependent load in that we do that @tail vs @head
> comparison before doing other loads, wouldn't a read_barrier_depends()
> be sufficient? Or do we still need a complete rmb?

We need a complete rmb() here IMO. I think there is a fundamental
difference
between load and stores in this aspect. Load are allowed to be hoisted by
compiler or executed speculatively by HW. To prevent load "*(ubuf->data +
tail)"
to be hoisted beyond "ubuf->head" load you would need something like this:

void
ubuf_read(void)
{
        u64 head, tail;

        tail = ubuf->tail;
        head = ACCESS_ONCE(ubuf->head);

        /*
         * Ensure we read the buffer boundaries before the actual buffer
         * data...
         */

        while (tail != head) {
		    smp_read_barrier_depends();         /* for Alpha */
                obj = *(ubuf->data + head - 128);
                /* process obj */
                tail += obj->size;
                tail %= ubuf->size;
        }

        /*
         * Ensure all data reads are complete before we issue the
         * ubuf->tail update; once that update hits, kbuf_write() can
         * observe and overwrite data.
         */
        smp_mb();               /* D, matches with A */

        ubuf->tail = tail;
}

(note that "head" is part of address calculation of obj load now).

But, even in this demo example some "smp_read_barrier_depends()" before
"obj = *(ubuf->data + head - 100);" is required for architectures
like Alpha. Though, on more sane architectures "smp_read_barrier_depends()"
will be translated to nothing.


Regards,
-- Victor

