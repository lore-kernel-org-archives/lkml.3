Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaKXM3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:29:15 -0500
Received: from mail.eperm.de ([89.247.134.16]:54792 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbaKXM3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:29:14 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: crypto: user - crypto_alg_match removal
Date: Mon, 24 Nov 2014 13:29:10 +0100
Message-ID: <1480327.kK94DiIqOk@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.3-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141124072246.GX6390@secunet.com>
References: <3095384.PkgHxCg8eG@tauon> <20141124072246.GX6390@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 24. November 2014, 08:22:46 schrieb Steffen Klassert:

Hi Steffen,

> Hi Stephan.
> 
> On Sat, Nov 22, 2014 at 11:25:05PM +0100, Stephan Mueller wrote:
> > Hi Steffen, Herbert,
> > 
> > may I ask for the reasons why crypto_alg_match exists? Doesn't it
> > implement crypto_alg_lookup -- and that not even complete? Is there a
> > particular reason why this exact flag of crypto_alg_match is really
> > needed in the context of crypto_user?
> > 
> > Unless there is such valid reason, may I ask whether we can remove
> > crypto_alg_match and simply use crypto_alg_lookup in all instances where
> > crypto_alg_match is invoked using the following replacement:
> > 
> > alg = crypto_alg_lookup(p->cru_name, p->cru_type, p->cru_mask)
> > 
> > The only problem with this replacement is that p->cru_driver_name is not
> > considered with that.
> 
> With crypto_alg_lookup() we don't know whether the match is based on
> the driver or the algorithm name. That's why we have crypto_alg_match(),
> here we can ask for a driver or an algorithm match. In some situations it
> is important to have an exact match on the crypto driver name. For example
> if a user wants to instantiate or delete a certain inplementation of an
> algorithm. In this case we need to know whether this exact algorithm
> driver is registered in the system.

I understand. But going with the logic of the kernel crypto API, if one needs 
an exact match, you pick the driver name. Otherwise the generic name. 
crypto_alg_lookup returns the exact algo when you supply a driver name. It 
returns the algo with the highest prio when you supply a generic name.

I do not see a difference for the scenarios you describe. What I am worried 
about is that the logic of how a name versus a driver name is applied differs 
between the kernel crypto API and crypto_user.


> 
> > Do you think a double invocation of
> > crypto_alg_lookup should be done or that even the user space interface
> > should be changed such that cru_driver_name is removed from it?
> 
> Whatever we do, we can't remove cru_driver_name as this is exported
> to userspace and tools already use it.

That is definitely an issue. But the more I think about it, the more I see 
that we do not need to change the interface.

Something like that would work in the kernel:

if (p->cru_driver_name[0])
	alg = crypto_alg_lookup(p->cru_driver_name, p->cru_type, p->cru_mask)
else
	alg = crypto_alg_lookup(p->cru_name, p->cru_type, p->cru_mask)

-- 
Ciao
Stephan
