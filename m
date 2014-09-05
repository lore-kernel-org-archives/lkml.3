Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbaIEIbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:31:24 -0400
Received: from mx0.aculab.com ([213.249.233.131]:39146 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752447AbaIEIbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:31:20 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'paulmck@linux.vnet.ibm.com'" <paulmck@linux.vnet.ibm.com>,
        Peter Hurley <peter@hurleysoftware.com>
CC: Jakub Jelinek <jakub@redhat.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "Miroslav Franc" <mfranc@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: RE: bit fields && data tearing
Thread-Topic: bit fields && data tearing
Thread-Index: AQHPyL7OJXKiC/P/tUa9IYpE5+LVuZvyNPcQ
Date: Fri, 5 Sep 2014 08:30:03 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17487F66@AcuExch.aculab.com>
References: <54079B70.4050200@hurleysoftware.com>
 <1409785893.30640.118.camel@pasglop>
 <21512.10628.412205.873477@gargle.gargle.HOWL>
 <20140904090952.GW17454@tucnak.redhat.com>
 <540859EC.5000407@hurleysoftware.com>
 <20140904175044.4697aee4@alan.etchedpixels.co.uk>
 <5408C0AB.6050801@hurleysoftware.com>
 <20140905001751.GL5001@linux.vnet.ibm.com>
 <1409883098.5078.14.camel@jarvis.lan> <5409243C.4080704@hurleysoftware.com>
 <20140905040645.GO5001@linux.vnet.ibm.com>
In-Reply-To: <20140905040645.GO5001@linux.vnet.ibm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s858VamJ015726

From: Paul E. McKenney
> On Thu, Sep 04, 2014 at 10:47:24PM -0400, Peter Hurley wrote:
> > Hi James,
> >
> > On 09/04/2014 10:11 PM, James Bottomley wrote:
> > > On Thu, 2014-09-04 at 17:17 -0700, Paul E. McKenney wrote:
> > >> +And there are anti-guarantees:
> > >> +
> > >> + (*) These guarantees do not apply to bitfields, because compilers often
> > >> +     generate code to modify these using non-atomic read-modify-write
> > >> +     sequences.  Do not attempt to use bitfields to synchronize parallel
> > >> +     algorithms.
> > >> +
> > >> + (*) Even in cases where bitfields are protected by locks, all fields
> > >> +     in a given bitfield must be protected by one lock.  If two fields
> > >> +     in a given bitfield are protected by different locks, the compiler's
> > >> +     non-atomic read-modify-write sequences can cause an update to one
> > >> +     field to corrupt the value of an adjacent field.
> > >> +
> > >> + (*) These guarantees apply only to properly aligned and sized scalar
> > >> +     variables.  "Properly sized" currently means "int" and "long",
> > >> +     because some CPU families do not support loads and stores of
> > >> +     other sizes.  ("Some CPU families" is currently believed to
> > >> +     be only Alpha 21064.  If this is actually the case, a different
> > >> +     non-guarantee is likely to be formulated.)
> > >
> > > This is a bit unclear.  Presumably you're talking about definiteness of
> > > the outcome (as in what's seen after multiple stores to the same
> > > variable).
> >
> > No, the last conditions refers to adjacent byte stores from different
> > cpu contexts (either interrupt or SMP).
> >
> > > The guarantees are only for natural width on Parisc as well,
> > > so you would get a mess if you did byte stores to adjacent memory
> > > locations.
> >
> > For a simple test like:
> >
> > struct x {
> > 	long a;
> > 	char b;
> > 	char c;
> > 	char d;
> > 	char e;
> > };
> >
> > void store_bc(struct x *p) {
> > 	p->b = 1;
> > 	p->c = 2;
> > }
> >
> > on parisc, gcc generates separate byte stores
> >
> > void store_bc(struct x *p) {
> >    0:	34 1c 00 02 	ldi 1,ret0
> >    4:	0f 5c 12 08 	stb ret0,4(r26)
> >    8:	34 1c 00 04 	ldi 2,ret0
> >    c:	e8 40 c0 00 	bv r0(rp)
> >   10:	0f 5c 12 0a 	stb ret0,5(r26)
> >
> > which appears to confirm that on parisc adjacent byte data
> > is safe from corruption by concurrent cpu updates; that is,
> >
> > CPU 0                | CPU 1
> >                      |
> > p->b = 1             | p->c = 2
> >                      |
> >
> > will result in p->b == 1 && p->c == 2 (assume both values
> > were 0 before the call to store_bc()).
> 
> What Peter said.  I would ask for suggestions for better wording, but
> I would much rather be able to say that single-byte reads and writes
> are atomic and that aligned-short reads and writes are also atomic.
> 
> Thus far, it looks like we lose only very old Alpha systems, so unless
> I hear otherwise, I update my patch to outlaw these very old systems.

People with old Alphas can run NetBSD instead, along with those who have real VAXen :-)

I've seen gcc generate 32bit accesses for 16bit structure members on arm.
It does this because of the more limited range of the offsets for the 16bit access.
OTOH I don't know if it ever did this for writes - so it may be moot.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
