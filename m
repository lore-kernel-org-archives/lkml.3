Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaIFKMC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 06:12:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:36441 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaIFKL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 06:11:58 -0400
Date: Sat, 6 Sep 2014 12:11:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Behan Webster <behanw@converseincode.com>
cc: zohar@linux.vnet.ibm.com, d.kasatkin@samsung.com,
        james.l.morris@oracle.com, linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, serge@hallyn.com,
        torvalds@linux-foundation.org, Mark Charlebois <charlebm@gmail.com>,
        =?ISO-8859-15?Q?Jan-Simon_M=F6ller?= <dl9pf@gmx.de>
Subject: Re: [PATCH] security, crypto: LLVMLinux: Remove VLAIS from
 ima_crypto.c
In-Reply-To: <540A590F.1030407@converseincode.com>
Message-ID: <alpine.DEB.2.10.1409061152090.5472@nanos>
References: <1409958360-8061-1-git-send-email-behanw@converseincode.com> <alpine.DEB.2.10.1409060131260.5472@nanos> <540A590F.1030407@converseincode.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1940981619-1409998306=:5472"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1940981619-1409998306=:5472
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 5 Sep 2014, Behan Webster wrote:
> On 09/05/14 17:18, Thomas Gleixner wrote:
> > > Signed-off-by: Behan Webster <behanw@converseincode.com>
> > > Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> > > Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> > This SOB chain is completely ass backwards. See Documentation/...
> "The Signed-off-by: tag indicates that the signer was involved in the
> development of the patch, or that he/she was in the patch's delivery path."
> 
> All three of us were involved. Does that not satisfy this rule?

No. Read #12

The sign-off is a simple line at the end of the explanation for the
patch, which certifies that you wrote it or otherwise have the right to
pass it on as an open-source patch.

So the above chain says:

   Written-by:   Behan
   Passed-on-by: Mark
   Passed-on-by: Jan

That would be correct if you sent the patch to Mark, Mark sent it to
Jan and Jan finally submitted it to LKML.
 
> > > -	struct {
> > > -		struct shash_desc shash;
> > > -		char ctx[crypto_shash_descsize(tfm)];
> > > -	} desc;
> > > +	char desc[sizeof(struct shash_desc) +
> > > +		crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
> > > +	struct shash_desc *shash = (struct shash_desc *)desc;
> > That anon struct should have never happened in the first place.
> Sadly this is a design pattern used in many places through out the kernel, and
> appears to be fundamental to the crypto system. I was advised *not* to change
> it, so we haven't.
> 
> I agree that it's not a good practice.
> 
> >   Not
> > your problem, but you are not making it any better. You replace open
> > coded crap with even more unreadable crap.
> > 
> > Whats wrong with
> > 
> >        SHASH_DESC_ON_STACK(shash, tfm);
> Nothing is wrong with that. I would have actually preferred that. But it would
> have fundamentally changed a lot more code.

Errm. Why is 

#define SHASH_DESC_ON_STACK(shash, tfm)				\
	char __shash[sizeof(.....)];				\
	struct shash_desc *shash = (struct shash_desc *) __shash

requiring more fundamental than open coding the same thing a gazillion
times. You still need to change ALL usage sides of the anon struct.

So in fact you could avoid the whole code change by making it

   SHASH_DESC_ON_STACK(desc, tfm);

and do the anon struct or a proper struct magic in the macro.

> I'm not sure making fundamental changes to the crypto code in order to make
> "my favourite compiler happy" is really a better plan. I prefer smaller more
> measured steps.

What's fundamental about a change which produces the same code but
hides all the easy to get wrong mess in a single place?
 
> > or something along that line and hide all the stack allocation, type
> > conversion crap and make my favourite compiler happy in a single
> > place?
> At this point it is less about making a particular compiler happy, and more
> about making the code at least C99 compliant which enables a different
> compiler so that more people can use it to make more fundamental changes like
> you are suggesting.

Well, just blindly making it compliant is one thing. But if we do that
we really should make it better and using a macro for this is
definitely an improvement which is worthwhile to do.

Thanks,

	tglx
--8323329-1940981619-1409998306=:5472--
