Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab3AYL2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:28:10 -0500
Received: from mail.atsec.com ([195.30.99.214]:47255 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab3AYL2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:28:08 -0500
Message-ID: <51026C45.7020508@atsec.com>
Date: Fri, 25 Jan 2013 12:28:05 +0100
From: Stephan Mueller <stephan.mueller@atsec.com>
Organization: atsec information security GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kyle McMartin <kmcmarti@redhat.com>
CC: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, jstancek@redhat.com
Subject: Re: [PATCH] MODSIGN: only panic in fips mode if sig_enforce is set
References: <20130122184357.GD6538@redacted.bos.redhat.com> <8615.1358940375@warthog.procyon.org.uk> <50FFFF48.6020608@atsec.com> <20130124145907.GG6538@redacted.bos.redhat.com>
In-Reply-To: <20130124145907.GG6538@redacted.bos.redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.01.2013 15:59:07, +0100, Kyle McMartin <kmcmarti@redhat.com> wrote:

Hi Kyle,
> On Wed, Jan 23, 2013 at 04:18:32PM +0100, Stephan Mueller wrote:
>> 3. in the cipher initialization code of the crypto API (i.e. the one
>> behind crypto_register_alg()), you check the signature check flag --
>> panic the kernel when the flag shows that the signature check failed
>>
>> This way you limit the panic on signature checks in FIPS mode to the
>> crypto modules.
>>
> 
> I was hoping we could just do what we do for driver/staging and set a
> flag in modpost for crypto modules, but it looks like since we have
> crypto modules outside of crypto/ for things like aesni, that won't
> work. Maybe that is a better choice, but it seems like an awful kludge.

There is a completely different possibility though:

The reason for the panic is the requirement that if one of the integrity
tests for the crypto components fail in FIPS mode, the crypto module
(i.e. the entire kernel crypto API) must be unavailable.

Thus, another possibility is to add a global flag that indicates whether
such a test failed.

That flag is evaluated by *every* kernel crypto API interface function
and this function rejects to do anything when that flag is set.

This way, we can get rid of the panic.

But then, we still have the problem of loading unsigned kernel modules
in FIPS mode that are not related to crypto: those would still trigger
setting that global flag if the module loader is unable to identify a
crypto module.

Hence, you idea with a flag may be the way to go: add such a crypto flag
similar to the MODULE_LICENSE("GPL") for modules. Now, the module loader
should only panic or set such a global flag for modules that are marked
with something like MODULE_TYPE("CRYPTO").

Now, all modules in crypto/ and arch/*/crypto/* (or whereever) would
have such a flag added.
> 
> --Kyle
> 
Ciao
Stephan
