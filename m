Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaCMQ5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:57:22 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34678 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbaCMQ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:57:19 -0400
Message-ID: <1394729834.8457.58.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: RFC: 'ioctl' for keyrings
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, dmitry.kasatkin@gmail.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Safford <safford@us.ibm.com>
Date: Thu, 13 Mar 2014 12:57:14 -0400
In-Reply-To: <21625.1394725646@warthog.procyon.org.uk>
References: <21625.1394725646@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031316-1542-0000-0000-000000588B8B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 15:47 +0000, David Howells wrote: 
> Hi Linus,
> 
> I've encountered a situation where I could do with providign certain key types
> with their own operations and I'm wondering as to the best way.
> 
> The problem I've been trying to deal with is to improve quota management on
> keys and introduce LRU key discard when a quota is overrun.  This requires me
> to overhaul all the ->instantiate() and ->update() key type operations as they
> can ask for more quota.
> 
> What I want to do is to use the preparsing mechanism I introduced for
> asymmetric key handling for both operations.  This has the advantage that all
> parse errors and invalid arguments can be found upfront before we start
> allocating things that are difficult to back out of - and means that we're less
> likely to encounter ENOMEM in the type op functions.
> 
> Now, ->instantiate() is meant to set the payload on a key and ->update() is
> meant to replace the payload on a key.  There is, currently, no way to modify a
> key to some lesser extent.
> 
> However, in the process of doing this, I've come to realise that the trusted
> key type and the encrypted key type use their ->update() operations to make a
> partial alteration to a key.
> 
> Unfortunately, this does not lend itself to preparsing because the result
> depends on the key we're going to update - and we don't necessarily know the
> key yet.
> 
> Further, this behaviour is also broken because ->update() may be called by
> add_key() if it finds a matching key; but you cannot rely on add_key() adding
> vs updating because it may race with someone else doing an add_key().  To make
> matters yet more interesting, at least with encrypted_update(), the parameters
> expected in the payload depend on whether you want to create a key or alter a
> key.
> 
> I can fix this in one of a number of ways:
> 
>  (1) Provide a generic control operation (analogous with ioctl()) that allows
>      the user to make some general operation on a key (querying it, altering
>      it, interacting with hardware).
> 
>  (2) Provide an alter operation that only allows the key to be altered.
>      Looking at trusted_update(), though, I have a suspicion that this may not
>      be sufficient as that also seems to invoke an interaction with the TPM.
> 
>  (3) Provide separate, specific keyctl functions for the special operations
>      required by encrypted and trusted keys (and other key types potentially)
>      that are then validated in the core and routed to the key type.
> 
> I would prefer (2) or perhaps (3), I think.
> 
> As I understand the code, I think operations being performed from ->update()
> are:
> 
>  (a) Resealing a key with a new pcrs (trusted).
> 
>  (b) Changing the master key (encrypted).
> 
> Mimi, Dmitry: is this list right?

In addition to resealing trusted keys to a new TPM PCR value, there are
a few other options that can be modified (eg. keyauth, blobauth,
pcrlock).  Encrypted keys can be encrypted/decrypted with a new master
key (trusted or user key type).

Mimi

> Note that if I do provide some more appropriate vector, I will probably have to
> have special code for handling encrypted and trusted keyrings in the core,
> rejecting attempts to update in key_create_or_update() and redirecting them in
> key_update() in security/keys/key.c
> 
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


