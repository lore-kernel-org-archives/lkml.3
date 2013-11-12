Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3KLA0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:26:39 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:59076 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3KLA0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:26:20 -0500
Message-ID: <1384215971.18684.172.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC][PATCH 0/9] encrypted keys & key control op
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: d.kasatkin@samsung.com, Mimi Zohar <zohar@us.ibm.com>,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Safford <safford@linux.vnet.ibm.com>
Date: Mon, 11 Nov 2013 19:26:11 -0500
In-Reply-To: <23408.1384209271@warthog.procyon.org.uk>
References: <1384172064.18684.55.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
	 <23408.1384209271@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111200-0928-0000-0000-0000034E7AE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-11 at 22:34 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > > Further, the existence of encrypted_update() means that add_key() will
> > > sometimes get things wrong with encrypted keys (add_key() will call
> > > ->update() if a matching key already exists rather than creating a new
> > > key).
> > 
> > I see.  The key_type structure defines a number of methods,
> > including .instantiate and .update.  I would have thought that
> > only .update would be allowed to update an existing key.
> 
> That is correct.  ->instantiate() is only called for a new key and ->update()
> for an existing key.
> 
> > Instantiating a new key should create a new key or fail, not update a key.
> 
> That is subjective and depends on how you want your interface to work.  If you
> look upon it as the "key struct" is a box with some content and the content is
> switchable, then does it matter?

I think it does.  (Example below)

> And, yes, ->update() should probably have been called something like replace
> or reinstantiate.  The benefits of hindsight...

I don't have a problem with the existing name.

> > I'm sure there is/was a good reason for add_key() to do both.
> 
> Yes.  No race.
> 
> > > But you can't pre-search for the existence of a key and mould the payload
> > > accordingly because that means you can race against both add_key() and
> > > keyctl_unlink().
> > 
> > Would this still be the case, if you differentiated between
> > instantiating and updating a key?
> 
> Yes.  Imagine, you try to add a key and it gets rejected because the key
> already exists.  You then try to update the existing key, but that gets
> rejected because someone unlinked the key in the meantime.  So you try and add
> it again, but this now fails because someone added a new key.  Repeat.

A counter example would be two processes, having nothing to do with each
other, attempt to a create a key with the same name.  Instead of each
process getting its own key, they land up sharing the same key.
Not only are they sharing the same key, but neither process knows that
there is another process using the same key.  I would think this is a
bigger problem.

Failing to create/update a key, at least to me, seems safer than having
two apps trying to create a key with same name, but instead land up
using the same key.

> Or add_key() could immediately displace a key someone else just added, leaving
> them with a key ID that disappeared as soon as it was returned due to an
> add/add race.

This is a separate issue.  If a key/keyring exists, a new key/keyring,
with the same name, should not be created replacing the existing
key/keyring.  It should simply fail.  (Removing a key/keyring first,
before creating a key/keyring of the same name, is different.)

Mimi

> The right behaviour can be argued in different ways.

> > > My solution is to add a new keyctl function that allows the caller to
> > > perform a type-specific operation on a key:
> > > 
> > > 	long keyctl_control(key_serial_t key_id,
> > > 			    const char *command,
> > > 			    char *reply_buffer,
> > > 			    size_t reply_size);
> > 
> > > This would then take a NUL-terminated string indicating the command and
> > > arguments and potentially return a reply up to the buffer length.
> > 
> > What is the usecase scenario that would require a reply_buffer?
> 
> I don't want to have to add a keyctl_control2() down the line that has a
> reply_buffer if this one doesn't when someone finds a use it if it's easy
> enough and small enough to provide the facility here.  This is aimed at being
> a general interface rather than being specifically for encrypted keys.
> 
> David
> 


