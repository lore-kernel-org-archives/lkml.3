Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3KKWer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 17:34:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab3KKWek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 17:34:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1384172064.18684.55.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1384172064.18684.55.camel@dhcp-9-2-203-236.watson.ibm.com> <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, d.kasatkin@samsung.com, Mimi Zohar <zohar@us.ibm.com>,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Safford <safford@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/9] encrypted keys & key control op
Date: Mon, 11 Nov 2013 22:34:31 +0000
Message-ID: <23408.1384209271@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > Further, the existence of encrypted_update() means that add_key() will
> > sometimes get things wrong with encrypted keys (add_key() will call
> > ->update() if a matching key already exists rather than creating a new
> > key).
> 
> I see.  The key_type structure defines a number of methods,
> including .instantiate and .update.  I would have thought that
> only .update would be allowed to update an existing key.

That is correct.  ->instantiate() is only called for a new key and ->update()
for an existing key.

> Instantiating a new key should create a new key or fail, not update a key.

That is subjective and depends on how you want your interface to work.  If you
look upon it as the "key struct" is a box with some content and the content is
switchable, then does it matter?

And, yes, ->update() should probably have been called something like replace
or reinstantiate.  The benefits of hindsight...

> I'm sure there is/was a good reason for add_key() to do both.

Yes.  No race.

> > But you can't pre-search for the existence of a key and mould the payload
> > accordingly because that means you can race against both add_key() and
> > keyctl_unlink().
> 
> Would this still be the case, if you differentiated between
> instantiating and updating a key?

Yes.  Imagine, you try to add a key and it gets rejected because the key
already exists.  You then try to update the existing key, but that gets
rejected because someone unlinked the key in the meantime.  So you try and add
it again, but this now fails because someone added a new key.  Repeat.

Or add_key() could immediately displace a key someone else just added, leaving
them with a key ID that disappeared as soon as it was returned due to an
add/add race.

The right behaviour can be argued in different ways.

> > My solution is to add a new keyctl function that allows the caller to
> > perform a type-specific operation on a key:
> > 
> > 	long keyctl_control(key_serial_t key_id,
> > 			    const char *command,
> > 			    char *reply_buffer,
> > 			    size_t reply_size);
> 
> > This would then take a NUL-terminated string indicating the command and
> > arguments and potentially return a reply up to the buffer length.
> 
> What is the usecase scenario that would require a reply_buffer?

I don't want to have to add a keyctl_control2() down the line that has a
reply_buffer if this one doesn't when someone finds a use it if it's easy
enough and small enough to provide the facility here.  This is aimed at being
a general interface rather than being specifically for encrypted keys.

David
