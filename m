Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab3AYMmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:42:10 -0500
Received: from mail.atsec.com ([195.30.99.214]:48269 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545Ab3AYMmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:42:08 -0500
Message-ID: <51027D9D.6030507@atsec.com>
Date: Fri, 25 Jan 2013 13:42:05 +0100
From: Stephan Mueller <stephan.mueller@atsec.com>
Organization: atsec information security GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Kyle McMartin <kyle@redhat.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, jstancek@redhat.com
Subject: Re: [PATCH] MODSIGN: flag modules that use cryptoapi and only panic
 if those are unsigned
References: <20130122184357.GD6538@redacted.bos.redhat.com> <8615.1358940375@warthog.procyon.org.uk> <50FFFF48.6020608@atsec.com> <20130124190610.GI6538@redacted.bos.redhat.com> <874ni6qhlq.fsf@rustcorp.com.au>
In-Reply-To: <874ni6qhlq.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.01.2013 00:36:01, +0100, Rusty Russell <rusty@rustcorp.com.au> wrote:

Hi Rusty,
> Kyle McMartin <kyle@redhat.com> writes:
>> After thinking about it a while, this seems like the best way to solve
>> the problem, although it does still kind of offend my delicate
>> sensibilities...
> 
> You're far too polite.  This patch was horrible, partial and ugly.

Well, in another email I suggested you may want to think about some
marker that the code of the module would contain, similar to the GPL
flag for the module (whose absence sets the tainted flag).
> 
> Stephan Mueller <stephan.mueller@atsec.com> wrote:
>> FIPS requires the module (in our case the static kernel binary with its
>> kernel crypto API plus all the crypto kernel modules) to be unavailable
>> if the module signature fails. That is an unconditional requirement.
> 
> "the module signature" here being the signature of any crypto module,
> I'm guessing from Kyle's awful patch.  Any crypto module, or just some?
> Presumably any module used by any crypto module, too?

Any module loading into the kernel crypto API must be caught and its
signature enforced. Thus Kyle's approach to catch the kernel crypto API
register function would be appropriate, if indeed we would catch all
crypto KOs that we want to catch -- see my remark to Kyle.

> 
> Because you can panic when a !sig_ok module registers a crypto
> algorithm.  Or you can panic when anyone registers a crypto algorithm
> after any module has failed the signature check.

I do not see the difference from a FIPS perspective. The crypto KO is
unavailable to any crypto user until it called the kernel crypto API
register function.

Thus, if a KO is loaded, its signature check failed and now lingers in
the kernel, I do not see how the main FIPS requirement is offended. Only
when the code in the KO registers with the crypto API, that is the
latest point when the kernel must stop that KO whose signature check
failed -- again from a FIPS perspective.
> 
> But it doesn't make much sense to pick on the crypto modules, since
> they're not well isolated from the rest of the kernel.

Technically, I am totally with you. That business of integrity check of
a subset of code that is loaded into the kernel realm is hard to grasp,
if you want to stop an attacker.

But that is not the focus of the FIPS test here. That test shall counter
accidental modifications (how unlikely they are). And I am fully aware
of the fact that this FIPS requirement does not make too much sense in
software implementations. Note, FIPS 140-2 mainly focuses on hardware
and has some requirements which are totally bogus for software -- this
is one of them.

Well, but if we want to be FIPS 140-2 compliant, either we meet that
requirement, or, well, you are not compliant. It is that easy. :-)

Ciao
Stephan
> 
> Thanks,
> Rusty.
> 

