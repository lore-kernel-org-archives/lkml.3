Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaEJSVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 14:21:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:53628 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaEJSVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 14:21:43 -0400
Date: Sat, 10 May 2014 20:21:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 08/19] qspinlock: Make a new qnode structure to
 support virtualization
Message-ID: <20140510182134.GH13658@twins.programming.kicks-ass.net>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-9-git-send-email-Waiman.Long@hp.com>
 <20140508190459.GQ2844@laptop.programming.kicks-ass.net>
 <536D7C28.8010609@hp.com>
 <20140510141417.GF30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="brEuL7wsLY8+TuWz"
Content-Disposition: inline
In-Reply-To: <20140510141417.GF30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--brEuL7wsLY8+TuWz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 10, 2014 at 04:14:17PM +0200, Peter Zijlstra wrote:
> On Fri, May 09, 2014 at 09:08:56PM -0400, Waiman Long wrote:
> > On 05/08/2014 03:04 PM, Peter Zijlstra wrote:
> > >On Wed, May 07, 2014 at 11:01:36AM -0400, Waiman Long wrote:
> > >>  /*
> > >>+ * To have additional features for better virtualization support, it=
 is
> > >>+ * necessary to store additional data in the queue node structure. So
> > >>+ * a new queue node structure will have to be defined and used here.
> > >>+ */
> > >>+struct qnode {
> > >>+	struct mcs_spinlock mcs;
> > >>+};
> > >You can ditch this entire patch; its pointless, just add a new
> > >DEFINE_PER_CPU for the para-virt muck.
> >=20
> > Yes, I can certainly merge it to the next one in the series. I break it=
 out
> > to make each individual patch smaller, more single-purpose and easier to
> > review.
>=20
> No, don't merge it, _drop_ it. Wrapping things in a struct generates a
> ton of pointless change.
>=20
> Put the new data in a new DEFINE_PER_CPU and leave the existing code as
> is.

So I had a look at the resulting code:

struct qnode {
	struct mcs_spinlock mcs;
#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
	int		lsteal_mask;	/* Lock stealing frequency mask	*/
	u32		prev_tail;	/* Tail code of previous node	*/
#ifndef CONFIG_PARAVIRT_SPINLOCKS
	struct qnode   *qprev;		/* Previous queue node addr	*/
#endif
#endif
	struct pv_qvars pv;		/* For para-virtualization	*/
};

With all the bells and whistles on (say an enterprise distro), that
single node will now fill an entire cacheline on its own.

That means that the normal case for normal people who stay the heck away
=66rom virt shit will very often hit _3_ cachelines for their spin_lock().

1 - the cacheline that has the spinlock_t in,
2 - the cacheline that has node[0].count in to find which node to use
3 - the cacheline that has the actual right node in

That's of course complete and utter crap.

Not to mention that the final result of those 19 patches is going to
take me days to untangle :-(

Days I don't really have because I get to go hunt bugs in existing code
before thinking about adding shiny new stuff.

--brEuL7wsLY8+TuWz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbm4mAAoJEHZH4aRLwOS6gUIQAIu9exSfTPzCbSZRj4Uf3OLI
SPeMnqNGtwDh9KzOVL7CxEMQPDWCvJoUO19enOeJngTa/PH6BTgwOQhM8jo9oHeZ
KuDketiRXM19OBZYuHouLj9i3wt7nAOCnF9JPqbZZVbHWJ5EG1+O/48Pt6ekNwCB
R5HNJ3JrsyOUkFtQwArC1DrEmgkigaQQ5yypjqPs5ogn2gnC/ZFB2NRpLUh7qm7Q
USKhawxbfSmB7Pp3pdxSaMyFGBHheX+vKtDQUUo3Z3r9UxcIl4pJHwIbHEXdYW41
Qswhq1nmCXdTfdOh0gyxaeqDihe7rZ4JNeK0UDl0Vhh85caepw2o5lkWb8Rd0p5H
S0vGKJP4VC3NKBsJiLBvExbV4eVSUbykA4r8ssxriCmoqyBfFAemSqLBwjC26raQ
s+5SH+PvMuY9XDnnMIHuo1JqLFROygEOURx8NAkKAgGdX/kQAkmAA6iTINB42dkS
kyQcLhB8QX4zJ9pMxxzoUvjUY95xQAUwUlUH/+Z3BzYAC/J56cSkDXe7qnKsbMkk
lw733sVCP8qzCnH1H+ChGEeIbiyQl2scB7JxxWQTo7PfxBfvViDMbztcSFMIZvMU
JuLn9QP07g3rPvbkvul2d9hOcLZG2dmTW1HNptqeT8w+/N3AZ5jjBDJcnY5V2Mp2
tR3f7z0PjWeFUPpnD7SR
=V3N9
-----END PGP SIGNATURE-----

--brEuL7wsLY8+TuWz--
