Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab3AYAPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:15:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab3AYAPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:15:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130124190610.GI6538@redacted.bos.redhat.com>
References: <20130124190610.GI6538@redacted.bos.redhat.com> <20130122184357.GD6538@redacted.bos.redhat.com> <8615.1358940375@warthog.procyon.org.uk> <50FFFF48.6020608@atsec.com>
To: Kyle McMartin <kyle@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        jstancek@redhat.com, Stephan Mueller <stephan.mueller@atsec.com>
Subject: Re: [PATCH] MODSIGN: flag modules that use cryptoapi and only panic if those are unsigned
Date: Fri, 25 Jan 2013 00:14:54 +0000
Message-ID: <9620.1359072894@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin <kyle@redhat.com> wrote:

> After thinking about it a while, this seems like the best way to solve
> the problem, although it does still kind of offend my delicate
> sensibilities...
> 
> Doing this check in the crypto layer seems kind of like a layering
> violation to me (and, to be honest, I think it'd be a gross-hack getting
> from the callee back to the caller module.)
> 
> Instead, doing it in kernel/module.c and looking at the undefined symbol
> list again looks to me like an ordering problem since we're doing the
> signature check before we've even done the elf header check. We'd have
> to move the panic to a part of the module code that may not necessarily
> make sense.
> 
> Whereas checking the undefined symbol list at modpost time is fairly
> logical, and adding a new MODULE_INFO entry in the CONFIG_CRYPTO_FIPS
> case is a well understood thing to do, and should catch all the crypto
> registrations regardless of where they exist in-tree...
> 
> Seems to build and work with both values of CONFIG_CRYPTO_FIPS.
> 
> Thoughts?

You can't rely on someone trying to sneak a dodgy crypto module in to set the
flag when they build it.  The detection thus needs to be done in the kernel
during the module load.

Can you search the module image for "crypto_register_" I wonder?  If that's
there, it's a crypto module.

David
