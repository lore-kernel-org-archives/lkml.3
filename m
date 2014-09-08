Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaIHLeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:34:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60561 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaIHLe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:34:29 -0400
Date: Mon, 8 Sep 2014 13:34:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 02/22] perf: Add AUX area to ring buffer for raw data
 streams
Message-ID: <20140908113422.GD6758@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-3-git-send-email-alexander.shishkin@linux.intel.com>
 <20140908070242.GS19379@twins.programming.kicks-ass.net>
 <87lhpuuztj.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1JjBgabntlVVpGew"
Content-Disposition: inline
In-Reply-To: <87lhpuuztj.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1JjBgabntlVVpGew
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 02:16:56PM +0300, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
>=20
> > On Wed, Aug 20, 2014 at 03:35:59PM +0300, Alexander Shishkin wrote:
> >> From: Peter Zijlstra <peterz@infradead.org>
> >>=20
> >> This patch introduces "AUX space" in the perf mmap buffer, intended for
> >> exporting high bandwidth data streams to userspace, such as instruction
> >> flow traces.
> >>=20
> >> AUX space is a ring buffer, defined by aux_{offset,size} fields in the
> >> user_page structure, and read/write pointers aux_{head,tail}, which ab=
ide
> >> by the same rules as data_* counterparts of the main perf buffer.
> >>=20
> >> In order to allocate/mmap AUX, userspace needs to set up aux_offset to
> >> such an offset that will be greater than data_offset+data_size and
> >> aux_size to be the desired buffer size. Both need to be page aligned.
> >> Then, same aux_offset and aux_size should be passed to mmap() call and
> >> if everything adds up, you should have an AUX buffer as a result.
> >>=20
> >> Pages that are mapped into this buffer also come out of user's mlock
> >> rlimit plus perf_event_mlock_kb allowance.
> >>=20
> >> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> >> ---
> >
> >> +void rb_free_aux(struct ring_buffer *rb, struct perf_event *event)
> >> +{
> >> +	struct perf_event *iter;
> >> +	int pg;
> >> +
> >> +	if (rb->aux_priv) {
> >> +		/* disable all potential writers before freeing */
> >> +		rcu_read_lock();
> >> +		list_for_each_entry_rcu(iter, &rb->event_list, rb_entry)
> >> +			perf_event_disable(iter);
> >> +		rcu_read_unlock();
> >
> > Hmm, I cannot remember this from the last time; and its not explained
> > why this was added.
> >
> > This would change semantics between munmap of a buffer with and without
> > AUX bits in.=20
>=20
> Indeed, but this seems fair: if an event is generating AUX data while we
> unmap the AUX buffer, there is no reason to keep it on, because chances
> are, AUX data is the only thing this event is generating. The
> alternative would be to have a separate callback for this, but then
> again, that would race with other pmu callbacks, since it would be
> called from munmap() path. I should add an elaborate comment about this.
>=20
> Does this sound reasonable?

Well, the same is true for regular buffers, if you munmap() them while
in use the events are pointless.

Still we keep them enabled, we simply skip generating output.

I would much like not to create deviating behaviour if you don't
absolutely have to. In both cases its an explicit user request, so you
don't need to go hold hands. He did it, he gets to keep whatever pieces
it generates.

--1JjBgabntlVVpGew
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDZQ+AAoJEHZH4aRLwOS6/vQQALTsuMTPDd2ezefgLkaBHsy3
xH4tN9cpQSCwBozQV29xZtRtrrAfo1nzHU1sVoENz1rIYsPic328AqOfEe0E8q2k
DVxExuWFAEO1KZTOWEumrWjxgFaXsBMXagtf0awTtFYjEJAb/S4HBaqI3jW6VgyC
pId3IUjPmja1iwsHzcR8/X2GwDnh8DBLzlwlbPPTGi/ZwwEJnMiAdgwDjI0QiAPg
lHXMZ4erGrDHCDdYd0nLhNW7rmkwJoBmM4QWEGlN4vAV8JJ7Fs8SUMxxRd8jzYDu
jMTXtigK18AeaDCxSg+LVKTpi7P9dRlX3/IHdsJfpZQplLq3JRxe8eDpR91wN9m/
OA+QTVK0qTzbLQ9Kgy/q5XG+Em42TGQHKSljN6uWrUa9ZoKgQKHp8jQI3huv6ZOc
CaLm3LwA6+XiyOkVpgMjY6ql69zLVeDPmEnaA1qxeM0zM0k8lp9/85oyPO0FF7C3
vcS1x7rIWSOuVq5wieNOFn+kZRkxjSRX8tFUK2X0H1dig2xKiSNTBtdBE0LS7oDP
gmEJlzaS2c1FvGVQCWQpYxmPPvWG2Gk/cxzIFp3h/Dr7kDzJy1LiW6fUIKVCf8/E
qe+20izCH0bTxsRvJnQ5B/FAr5qNp4YEX3JD9ArcHCTbPsewq3t+3nOnhisjb1f4
q1Px8kQYe1J9Ygn+hOM+
=PEiw
-----END PGP SIGNATURE-----

--1JjBgabntlVVpGew--
