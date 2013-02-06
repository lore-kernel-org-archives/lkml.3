Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab3BFQQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:16:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab3BFQQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:16:10 -0500
Date: Wed, 6 Feb 2013 11:15:57 -0500
From: Kyle McMartin <kmcmarti@redhat.com>
To: Stephan Mueller <stephan.mueller@atsec.com>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        rusty@rustcorp.com.au, jstancek@redhat.com,
        herbert@gondor.hengli.com.au
Subject: Re: [RFC PATCH] fips: check whether a module registering an alg or
 template is signed
Message-ID: <20130206161557.GJ3751@redacted.bos.redhat.com>
References: <20130122184357.GD6538@redacted.bos.redhat.com>
 <8615.1358940375@warthog.procyon.org.uk>
 <50FFFF48.6020608@atsec.com>
 <20130124190610.GI6538@redacted.bos.redhat.com>
 <5102781D.9000408@atsec.com>
 <20130205225830.GH3751@redacted.bos.redhat.com>
 <51120E26.7030400@atsec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51120E26.7030400@atsec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 09:02:46AM +0100, Stephan Mueller wrote:
> On 05.02.2013 23:58:30, +0100, Kyle McMartin <kyle@redhat.com> wrote:
> 
> Hi Kyle,
>

Thanks for the review, Stephan.
 
> Just reading this paragraph, there is one missing puzzle piece: the
> *entire* kernel crypto API must shut down, even if only one kernel
> module with one cipher (or block chaining mode, ...) has a broken signature.
> 
> The overall requirement is: if one self test fails, the entire FIPS
> 140-2 crypto module must become unavailable. (please note and do not get
> confused by the overload of the term "module" -- we have the KOs the
> kernel loads, and we have something called a FIPS 140-2 module which is
> the entire crypto "library" subject to a FIPS 140-2 validation)
> 
> This signature check is one self test required at runtime.
> 
> I added comments inline into the patch.
> 
> > 
> > crypto_sig_check should return 1 (and allow the registration) if any
> > of the following are true:
> > +	if (!crypto_sig_check(alg->cra_module))
> > +		return -EINVAL;
> 
> Instead of an EINVAL, the kernel either must panic(), or a global flag
> is introduced which is evaluated by every kernel crypto API call. If
> that flag is, say, false, none of the kernel crypto API calls must succeed.

Returning -EINVAL means the module does not successfully load, and
nothing is registered. I don't see why you would need to taint or panic,
if nothing untoward actually occured? I don't object to it, if it's
necessary, I just didn't think it was. If Herbert doesn't object to this
patch, I'd move the panic from kernel/module.c to here.

> > +
> >  	return crypto_set_driver_name(alg);
> >  }
> >  
> > @@ -435,6 +438,11 @@ int crypto_register_template(struct crypto_template *tmpl)
> 
> 
> I am wondering whether the modification of these two functions are
> sufficient. As I wrote in a previous email, there are a number of
> register functions the kernel crypto API exports and which are used.
> 

Between these two, I believe all codepaths that could bring in a
mode, cipher, or other cryptographic algorithm are covered.

> >  			goto out;
> >  	}

regards, Kyle
