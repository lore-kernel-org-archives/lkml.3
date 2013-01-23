Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3AWP2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:28:12 -0500
Received: from mail.atsec.com ([195.30.99.214]:34713 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab3AWP2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:28:10 -0500
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jan 2013 10:28:10 EST
Message-ID: <50FFFF48.6020608@atsec.com>
Date: Wed, 23 Jan 2013 16:18:32 +0100
From: Stephan Mueller <stephan.mueller@atsec.com>
Organization: atsec information security GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Kyle McMartin <kyle@redhat.com>, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, jstancek@redhat.com
Subject: Re: [PATCH] MODSIGN: only panic in fips mode if sig_enforce is set
References: <20130122184357.GD6538@redacted.bos.redhat.com> <8615.1358940375@warthog.procyon.org.uk>
In-Reply-To: <8615.1358940375@warthog.procyon.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.01.2013 12:26:15, +0100, David Howells <dhowells@redhat.com> wrote:

Hi David,

> Kyle McMartin <kyle@redhat.com> wrote:
> 
>> Commit 1d0059f3a added a test to check if the system is booted in fips
>> mode, and if so, panic the system if an unsigned module is loaded.
>> However the wording of the changelog "in signature enforcing mode" leads
>> one to assume that sig_enforce should be set for the panic to occur and
>> that these two tests are transposed.
>>
>> Move the test for -ENOKEY && !sig_enforce before the test of fips_mode,
>> so that err will be 0, and the panic will not trigger unless we've
>> explicitly disabled unsigned modules with sig_enforce set, so that
>> systemtap and 3rd party modules will work in fips mode. (This also
>> matches the behaviour by Red Hat Enterprise Linux 6.)
>>
>> Things which need to deny module loading such as secure boot already set
>> sig_enforce, so there's no issue here.
>>
>> Reported-by: Jan Stancek <jstancek@redhat.com>
>> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> Fine by me, but adding Stephan Mueller for his input.

FIPS requires the module (in our case the static kernel binary with its
kernel crypto API plus all the crypto kernel modules) to be unavailable
if the module signature fails. That is an unconditional requirement.

Now, all is a name game from here on. With your patch, the FIPS mode is
only enabled if both flags, i.e. fips_enabled *and* sig_enforce are set!
IMHO this is very misleading of the fips_enabled flag which is intended
to be the only trigger for the FIPS mode.

Hence, I would NACK the patch -- only from this point of view (i.e. I do
not have a technical argument against the patch)!

The solution to the problem IMHO is rather to somehow identify crypto
modules, i.e. modules that hook themselves into the kernel crypto API
and only panic the kernel when those integrity checks fail. Therefore,
to remove the panic() call in the module loading function when
fips_enabled is set would entail to:

1. load and sig check the module as it is done now

2. remember whether the signature check passed or failed for the loaded
module

3. in the cipher initialization code of the crypto API (i.e. the one
behind crypto_register_alg()), you check the signature check flag --
panic the kernel when the flag shows that the signature check failed

This way you limit the panic on signature checks in FIPS mode to the
crypto modules.

> 
> David
> 
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -2460,11 +2460,11 @@ static int module_sig_check(struct load_info *info)
>>  	}
>>  
>>  	/* Not having a signature is only an error if we're strict. */
>> +	if (err == -ENOKEY && !sig_enforce)
>> +		err = 0;
>>  	if (err < 0 && fips_enabled)
>>  		panic("Module verification failed with error %d in FIPS mode\n",
>>  		      err);
>> -	if (err == -ENOKEY && !sig_enforce)
>> -		err = 0;
>>  
>>  	return err;
>>  }
> 


