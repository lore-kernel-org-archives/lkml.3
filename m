Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaDZUJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 16:09:55 -0400
Received: from nm2-vm7.bullet.mail.ir2.yahoo.com ([212.82.96.87]:33702 "EHLO
	nm2-vm7.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbaDZUJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 16:09:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s1024; d=yahoo.fr;
	b=TPW6Zm/X1Tc1NHtrFSKBYl+60RJn0I007l3dsjDB24d/ax9All5+pKWDYEHc9VRwIEE8tL/IYsLz58l0N2oGKS9hmMhhsxsYJWELXpoDh7fA/onrOKyBHFxRglIK1cECOQYgJZzeKjg6VyUxc2xEE8thZ8thvCL9g6Y4NJUZQ0Y=;
X-Yahoo-Newman-Id: 988338.71880.bm@smtp150.mail.ir2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7xma1_8VM1mJbE73HvxlPQpdWKY40lMOJazdTXgyrNH2.my
 Xbu3bQS3PyGit.jqlme17aJW3DAWk8MTw.f9C8rM10CjQ7Ej4AbF_vC_v727
 nW.ysR43.4ygxwTOHzNFIzbMeYRsda7EPuNSZLV3ecgVNLbPYxsC3dLKsgtW
 vnRRjYdou8ktIWOM944hJuzxoaw9nWpLN1pyQfnfmJ0GkEpWrl2CcHgzTSE7
 6jvebWCYxCgMbNiQPJdWqqrZmU62xkN9NSamFFReed7.m2J1FI5Ef9z0DT2W
 RZO7Zep1eCIzwbCYlCsV4d9vDaQ.6NMHfo77EahsSWOCQoplT484kAEHJeVt
 rfSVNH18uAwqHwZxhdu7ppmpjEdGDumC7OIqBrxwS9M.Q9qgAtc373TkEfni
 8NEQbUjzdBAUSIRH9UxWQDeKKbPq3DzjuUCppACQ69KkO8hopANPCI.6zGJx
 0gR6.8rQUuhd_47WdiwTpj3Wb2DAD4fJ7.Tp7RfdaFFXJ94tZ7QDZEkulCYh
 KZ1zho03Y2VP39XnhOD8LLnkci81BQihBtGk-
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
X-Rocket-Received: from [192.168.0.4] (lionel_debroux@82.122.199.38 with plain [188.125.69.59])
        by smtp150.mail.ir2.yahoo.com with SMTP; 26 Apr 2014 20:09:51 +0000 UTC
Message-ID: <535C128D.3070604@yahoo.fr>
Date: Sat, 26 Apr 2014 22:09:49 +0200
From: Lionel Debroux <lionel_debroux@yahoo.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mateusz Guzik <mguzik@redhat.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drm: make variable named "refcount" atomic, like most
 refcounts in the kernel.
References: <248367.21250.bm@smtp144.mail.ir2.yahoo.com> <20140426170305.GA17562@mguzik.redhat.com>
In-Reply-To: <20140426170305.GA17562@mguzik.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Apr 26, 2014 at 06:06:15PM +0200, Lionel Debroux wrote:
> > Based on PaX.
> >
> > ---
> >
> > From 7c712cadd97d43d03ff3d7ca04fd85bd8c6eb34a Mon Sep 17 00:00:00
> > 2001
> > From: Lionel Debroux <lionel_debroux@yahoo.fr>
> > Date: Sat, 26 Apr 2014 15:53:55 +0200
> > Subject: drm: make variable named "refcount" atomic, like most
> > refcounts in the kernel.
> >
> > Extracted from the PaX patch.
> >
> >
> [snip]
> >  	mutex_lock(&item->mutex);
> > -	BUG_ON(item->refcount == 0);
> > +	BUG_ON(atomic_read(&item->refcount) == 0);
> >  	BUG_ON(ref->object != item->object);
> > -	if (--item->refcount == 0) {
> > +	if (atomic_dec_and_test(&item->refcount)) {
> >  		ref->release(ref);
> >  		item->object = NULL;
> >  	}
> 
> I believe this change is in grsecurity so that overflow detector can
> be used,
That's my understanding as well.
> there is clearly no reason to use mere atomic ops.
Yeah, sorry. At least, you're stating it in a nice way.

> It may be that kernel devs would accept a patch implementing generic
> refcount manipulation primitives without atomicity guarantees, which
> could be used in cases like this.
> 
> Then atomic and non-atomic versions could be used to detect
> overflows and overputs at least in debug kernels.
That's a more constructive suggestion indeed, on a useful feature :)

As a hobbyist, once in a while, I wade through PaX/grsec, I read /
extract / submit hunks which are (or at least could be) relevant to
mainline (occasionally failing at picking the right hunks, as shown here
- my earlier patches were alright).
Getting the change you're mentioning merged (should it be considered
desirable in the first place) is probably above my time budget, sadly...


Regards,
Lionel.
