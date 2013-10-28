Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab3J1SRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 14:17:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab3J1SRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 14:17:10 -0400
Date: Mon, 28 Oct 2013 20:09:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131028190928.GA11449@redhat.com>
References: <12083.1382486094@ale.ozlabs.ibm.com> <20131023141948.GB3566@localhost.localdomain> <20131025173749.GG19466@laptop.lan> <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com> <20131028132634.GO19466@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028132634.GO19466@laptop.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28, Peter Zijlstra wrote:
>
> Lets add Paul and Oleg to the thread; this is getting far more 'fun'
> that it should be ;-)

Heh. All I can say is that I would like to see the authoritative answer,
you know who can shed a light ;)

But to avoid the confusion, wmb() added by this patch looks "obviously
correct" to me.

> +	 * Since the mmap() consumer (userspace) can run on a different CPU:
> +	 *
> +	 *   kernel				user
> +	 *
> +	 *   READ ->data_tail			READ ->data_head
> +	 *   smp_rmb()	(A)			smp_rmb()	(C)
> +	 *   WRITE $data			READ $data
> +	 *   smp_wmb()	(B)			smp_mb()	(D)
> +	 *   STORE ->data_head			WRITE ->data_tail
> +	 *
> +	 * Where A pairs with D, and B pairs with C.
> +	 *
> +	 * I don't think A needs to be a full barrier because we won't in fact
> +	 * write data until we see the store from userspace.

this matches the intuition, but ...

> So we simply don't
> +	 * issue the data WRITE until we observe it.

why do we need any barrier (rmb) then? how it can help to serialize with
"WRITE $data" ?

(of course there could be other reasons for this rmb(), just I can't
 really understand "A pairs with D").

And this reminds me about the memory barrier in kfifo.c which I was not
able to understand. Hmm, it has already gone away, and now I do not
understand kfifo.c at all ;) But I have found the commit, attached below.

Note that that commit added the full barrier into __kfifo_put(). And to
me it looks the same as "A" above. Following the logic above we could say
that we do not need a barrier (at least the full one), we won't in fact
write into the "unread" area until we see the store to ->out from
__kfifo_get() ?


In short. I am confused, I _feel_ that "A" has to be a full barrier, but
I can't prove this. And let me suggest the artificial/simplified example,

	bool	BUSY;
	data_t 	DATA;

	bool try_to_get(data_t *data)
	{
		if (!BUSY)
			return false;

		rmb();

		*data = DATA;
		mb();
		BUSY = false;

		return true;
	}

	bool try_to_put(data_t *data)
	{
		if (BUSY)
			return false;

		mb();	// XXXXXXXX: do we really need it? I think yes.

		DATA = *data;
		wmb();
		BUSY = true;

		return true;
	}

Again, following the description above we could turn the mb() in _put()
into barrier(), but I do not think we can rely on the contorl dependency.

Oleg.
---

commit a45bce49545739a940f8bd4ca85c3b7435564893
Author: Paul E. McKenney <paulmck@us.ibm.com>
Date:   Fri Sep 29 02:00:11 2006 -0700

    [PATCH] memory ordering in __kfifo primitives

    Both __kfifo_put() and __kfifo_get() have header comments stating that if
    there is but one concurrent reader and one concurrent writer, locking is not
    necessary.  This is almost the case, but a couple of memory barriers are
    needed.  Another option would be to change the header comments to remove the
    bit about locking not being needed, and to change the those callers who
    currently don't use locking to add the required locking.  The attachment
    analyzes this approach, but the patch below seems simpler.

    Signed-off-by: Paul E. McKenney <paulmck@us.ibm.com>
    Cc: Stelian Pop <stelian@popies.net>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index 64ab045..5d1d907 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -122,6 +122,13 @@ unsigned int __kfifo_put(struct kfifo *fifo,
 
 	len = min(len, fifo->size - fifo->in + fifo->out);
 
+	/*
+	 * Ensure that we sample the fifo->out index -before- we
+	 * start putting bytes into the kfifo.
+	 */
+
+	smp_mb();
+
 	/* first put the data starting from fifo->in to buffer end */
 	l = min(len, fifo->size - (fifo->in & (fifo->size - 1)));
 	memcpy(fifo->buffer + (fifo->in & (fifo->size - 1)), buffer, l);
@@ -129,6 +136,13 @@ unsigned int __kfifo_put(struct kfifo *fifo,
 	/* then put the rest (if any) at the beginning of the buffer */
 	memcpy(fifo->buffer, buffer + l, len - l);
 
+	/*
+	 * Ensure that we add the bytes to the kfifo -before-
+	 * we update the fifo->in index.
+	 */
+
+	smp_wmb();
+
 	fifo->in += len;
 
 	return len;
@@ -154,6 +168,13 @@ unsigned int __kfifo_get(struct kfifo *fifo,
 
 	len = min(len, fifo->in - fifo->out);
 
+	/*
+	 * Ensure that we sample the fifo->in index -before- we
+	 * start removing bytes from the kfifo.
+	 */
+
+	smp_rmb();
+
 	/* first get the data from fifo->out until the end of the buffer */
 	l = min(len, fifo->size - (fifo->out & (fifo->size - 1)));
 	memcpy(buffer, fifo->buffer + (fifo->out & (fifo->size - 1)), l);
@@ -161,6 +182,13 @@ unsigned int __kfifo_get(struct kfifo *fifo,
 	/* then get the rest (if any) from the beginning of the buffer */
 	memcpy(buffer + l, fifo->buffer, len - l);
 
+	/*
+	 * Ensure that we remove the bytes from the kfifo -before-
+	 * we update the fifo->out index.
+	 */
+
+	smp_mb();
+
 	fifo->out += len;
 
 	return len;

