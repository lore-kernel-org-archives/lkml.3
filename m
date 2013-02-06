Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab3BFRpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:45:50 -0500
Received: from mail.atsec.com ([195.30.99.214]:34150 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab3BFRpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:45:47 -0500
Message-ID: <511296C9.8010102@atsec.com>
Date: Wed, 06 Feb 2013 18:45:45 +0100
From: Stephan Mueller <stephan.mueller@atsec.com>
Organization: atsec information security GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kyle McMartin <kmcmarti@redhat.com>
CC: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        rusty@rustcorp.com.au, jstancek@redhat.com,
        herbert@gondor.hengli.com.au
Subject: Re: [RFC PATCH] fips: check whether a module registering an alg or
 template is signed
References: <20130122184357.GD6538@redacted.bos.redhat.com> <8615.1358940375@warthog.procyon.org.uk> <50FFFF48.6020608@atsec.com> <20130124190610.GI6538@redacted.bos.redhat.com> <5102781D.9000408@atsec.com> <20130205225830.GH3751@redacted.bos.redhat.com> <51120E26.7030400@atsec.com> <20130206161557.GJ3751@redacted.bos.redhat.com>
In-Reply-To: <20130206161557.GJ3751@redacted.bos.redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.02.2013 17:15:57, +0100, Kyle McMartin <kmcmarti@redhat.com> wrote:

Hi Kyle,
> On Wed, Feb 06, 2013 at 09:02:46AM +0100, Stephan Mueller wrote:
>> On 05.02.2013 23:58:30, +0100, Kyle McMartin <kyle@redhat.com> wrote:
>>
>> Hi Kyle,
>>
> 
> Thanks for the review, Stephan.
>  
>> Just reading this paragraph, there is one missing puzzle piece: the
>> *entire* kernel crypto API must shut down, even if only one kernel
>> module with one cipher (or block chaining mode, ...) has a broken signature.
>>
>> The overall requirement is: if one self test fails, the entire FIPS
>> 140-2 crypto module must become unavailable. (please note and do not get
>> confused by the overload of the term "module" -- we have the KOs the
>> kernel loads, and we have something called a FIPS 140-2 module which is
>> the entire crypto "library" subject to a FIPS 140-2 validation)
>>
>> This signature check is one self test required at runtime.
>>
>> I added comments inline into the patch.
>>
>>>
>>> crypto_sig_check should return 1 (and allow the registration) if any
>>> of the following are true:
>>> +	if (!crypto_sig_check(alg->cra_module))
>>> +		return -EINVAL;
>>
>> Instead of an EINVAL, the kernel either must panic(), or a global flag
>> is introduced which is evaluated by every kernel crypto API call. If
>> that flag is, say, false, none of the kernel crypto API calls must succeed.
> 
> Returning -EINVAL means the module does not successfully load, and
> nothing is registered. I don't see why you would need to taint or panic,
> if nothing untoward actually occured? I don't object to it, if it's

Unfortunately there has already something terrible happened: an
additional piece of code loaded into the FIPS 140-2 module could not be
loaded because a self test failed. This is a terrible accident in FIPS
140-2 speak. :-)

That means, the FIPS 140-2 module, aka kernel crypto API must become
unavailable. As one self test failed, the entire module must become
unavailable.

I am sorry, but there is no way around it. Just to quote the relevant
part from the FIPS 140-2 specification, section 4.9:

If a cryptographic module fails a self-test, the module shall enter an
error state and output an error indicator
via the status output interface. The cryptographic module shall not
perform any cryptographic operations
while in an error state. All data output via the data output interface
shall be inhibited when an error state
exists.


==> the signature test we are discussing here is one of these self
tests, in particular a conditional self test defined in section 4.9.2 of
the FIPS 140-2 standard.

> necessary, I just didn't think it was. If Herbert doesn't object to this
> patch, I'd move the panic from kernel/module.c to here.

I am perfectly happy with the move of the code.

> 
>>> +
>>>  	return crypto_set_driver_name(alg);
>>>  }
>>>  
>>> @@ -435,6 +438,11 @@ int crypto_register_template(struct crypto_template *tmpl)
>>
>>
>> I am wondering whether the modification of these two functions are
>> sufficient. As I wrote in a previous email, there are a number of
>> register functions the kernel crypto API exports and which are used.
>>
> 
> Between these two, I believe all codepaths that could bring in a
> mode, cipher, or other cryptographic algorithm are covered.

Ok, I believe you as I did not trace the code. I just wanted to point
out this issue :-)

But note, if a real FIPS 140-2 validation is conducted, we will trace
the code ;-)
> 
>>>  			goto out;
>>>  	}
> 
> regards, Kyle
> 
Ciao
Stephan


