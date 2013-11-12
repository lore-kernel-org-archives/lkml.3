Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab3KLQVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:21:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123Ab3KLQVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:21:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1384215971.18684.172.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1384215971.18684.172.camel@dhcp-9-2-203-236.watson.ibm.com> <1384172064.18684.55.camel@dhcp-9-2-203-236.watson.ibm.com> <20131104162216.10177.98067.stgit@warthog.procyon.org.uk> <23408.1384209271@warthog.procyon.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, d.kasatkin@samsung.com, Mimi Zohar <zohar@us.ibm.com>,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Safford <safford@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/9] encrypted keys & key control op
Date: Tue, 12 Nov 2013 16:19:42 +0000
Message-ID: <1567.1384273182@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > > I'm sure there is/was a good reason for add_key() to do both.
> > 
> > Yes.  No race.
> > 
> > > > But you can't pre-search for the existence of a key and mould the
> > > > payload accordingly because that means you can race against both
> > > > add_key() and keyctl_unlink().
> > > 
> > > Would this still be the case, if you differentiated between
> > > instantiating and updating a key?
> > 
> > Yes.  Imagine, you try to add a key and it gets rejected because the key
> > already exists.  You then try to update the existing key, but that gets
> > rejected because someone unlinked the key in the meantime.  So you try and
> > add it again, but this now fails because someone added a new key.  Repeat.
> 
> A counter example would be two processes, having nothing to do with each
> other, attempt to a create a key with the same name.  Instead of each
> process getting its own key, they land up sharing the same key.
> Not only are they sharing the same key, but neither process knows that
> there is another process using the same key.  I would think this is a
> bigger problem.
> 
> Failing to create/update a key, at least to me, seems safer than having
> two apps trying to create a key with same name, but instead land up
> using the same key.

Yes.  Two keys of the same type with the same description should be able to
substitute for one another and should be able to fulfil the same roll.  Safety
should not be an issue.

> > Or add_key() could immediately displace a key someone else just added,
> > leaving them with a key ID that disappeared as soon as it was returned due
> > to an add/add race.
> 
> This is a separate issue.  If a key/keyring exists, a new key/keyring,
> with the same name, should not be created replacing the existing
> key/keyring.  It should simply fail.  (Removing a key/keyring first,
> before creating a key/keyring of the same name, is different.)

If you have a key type that's not "updateable" then you'd have to unlink it
before trying to add a new one.  This would give you a gap in time where the
key does not exist.

So, no, creating a new key with the same name *should* atomically displace an
old one if it exists - if it doesn't update it instead.  Note that keys have an
"under construction" concept so that the core can create a partially formed key
and then instantiate it at its leisure whilst using it to block those that
would like to use it.

David
