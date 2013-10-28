Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3J1URM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 16:17:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab3J1URL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 16:17:11 -0400
Date: Mon, 28 Oct 2013 21:17:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131028201735.GA15629@redhat.com>
References: <12083.1382486094@ale.ozlabs.ibm.com> <20131023141948.GB3566@localhost.localdomain> <20131025173749.GG19466@laptop.lan> <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com> <20131028132634.GO19466@laptop.lan> <20131028163418.GD4126@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028163418.GD4126@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28, Paul E. McKenney wrote:
>
> On Mon, Oct 28, 2013 at 02:26:34PM +0100, Peter Zijlstra wrote:
> > --- linux-2.6.orig/kernel/events/ring_buffer.c
> > +++ linux-2.6/kernel/events/ring_buffer.c
> > @@ -87,10 +87,31 @@ static void perf_output_put_handle(struc
> >  		goto out;
> >
> >  	/*
> > -	 * Publish the known good head. Rely on the full barrier implied
> > -	 * by atomic_dec_and_test() order the rb->head read and this
> > -	 * write.
> > +	 * Since the mmap() consumer (userspace) can run on a different CPU:
> > +	 *
> > +	 *   kernel				user
> > +	 *
> > +	 *   READ ->data_tail			READ ->data_head
> > +	 *   smp_rmb()	(A)			smp_rmb()	(C)
>
> Given that both of the kernel's subsequent operations are stores/writes,
> doesn't (A) need to be smp_mb()?

Yes, this is my understanding^Wfeeling too, but I have to admit that
I can't really explain to myself why _exactly_ we need mb() here.

And let me copy-and-paste the artificial example from my previous
email,

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

(just in case, the code above obviously assumes that _get or _put
 can't race with itself, but they can race with each other).

Could you confirm that try_to_put() actually needs mb() between
LOAD(BUSY) and STORE(DATA) ?

I am sure it actually needs, but I will appreciate it if you can
explain why. IOW, how it is possible that without mb() try_to_put()
can overwrite DATA before try_to_get() completes its "*data = DATA"
in this particular case.

Perhaps this can happen if, say, reader and writer share a level of
cache or something like this...

Oleg.

