Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaLOKWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:22:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbaLOKWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:22:41 -0500
Date: Mon, 15 Dec 2014 12:22:27 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 00/18] uaccess: fix sparse warning on get_user for
 bitwise types
Message-ID: <20141215102227.GA26178@redhat.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
 <1418604052.19970.6.camel@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418604052.19970.6.camel@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:40:52AM +1100, Michael Ellerman wrote:
> On Sun, 2014-12-14 at 18:51 +0200, Michael S. Tsirkin wrote:
> > At the moment, if p and x are both tagged as bitwise types,
> > get_user(x, p) produces a sparse warning on many architectures.
> > This is because *p on these architectures is loaded into long
> > (typically using asm), then cast back to typeof(*p).
> > 
> > When typeof(*p) is a bitwise type (which is uncommon), such a cast needs
> > __force, otherwise sparse produces a warning.
> 
> What does __force actually mean? Force the cast even though it's a bitfield? Or
> does it mean more than that?

It's not a bitfield = it's a bitwise integer.
Once you tag a typedef as bitwise, casts to and from
an untypedefed integer cause sparse warnings.

> ie. are we loosing the ability to detect any actual errors by adding force?
> 
> cheers

I think we aren't:
get_user(x, p) should be equivalent to x = *p except it
validates the pointer is to userspace memory,
and can handle pagefaults.

Sparse warnings are triggered because these macros use
an untyped integer internally.

Note that we are casting to typeof(*p) not typeof(x).
Even with the cast, if x and *p are of different types we should get the
warning, so I think we are not loosing the ability to detect any actual
errors.


-- 
MST
