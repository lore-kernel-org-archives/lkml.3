Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3KSOqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:46:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab3KSOqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:46:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1311191637280.20384@tundra.namei.org>
References: <alpine.LRH.2.02.1311191637280.20384@tundra.namei.org> <alpine.LRH.2.02.1311071146450.31522@tundra.namei.org> <CA+5PVA7C-SSg5TyQ14kUN2SbLi-=bk6isi05xgtR5j8MC7-Uhg@mail.gmail.com> <alpine.LRH.2.02.1311191029050.20131@tundra.namei.org> <CA+55aFyp2HnMATV1v81QwZFqXcyca-RTD93=55ba37kF4ANfCw@mail.gmail.com>
To: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [GIT] Security subsystem updates for 3.13
Date: Tue, 19 Nov 2013 14:46:40 +0000
Message-ID: <31999.1384872400@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> On Mon, 18 Nov 2013, Linus Torvalds wrote:
> ...
> > If somebody wants to explain about the rationale new keys code, that might
> > help.

Okay.  There are a number of separate bits.  I'll go over the big bits and the
odd important other bit, most of the smaller bits are just fixes and cleanups.
If you want the small bits accounting for, I can do that too.

 (1) Keyring capacity expansion.

	KEYS: Consolidate the concept of an 'index key' for key access
	KEYS: Introduce a search context structure
	KEYS: Search for auth-key by name rather than target key ID
	Add a generic associative array implementation.
	KEYS: Expand the capacity of a keyring

     Several of the patches are providing an expansion of the capacity of a
     keyring.  Currently, the maximum size of a keyring payload is one page.
     Subtract a small header and then divide up into pointers, that only gives
     you ~500 pointers on an x86_64 box.  However, since the NFS idmapper uses
     a keyring to store ID mapping data, that has proven to be insufficient to
     the cause.

     Whatever data structure I use to handle the keyring payload, it can only
     store pointers to keys, not the keys themselves because several keyrings
     may point to a single key.  This precludes inserting, say, and rb_node
     struct into the key struct for this purpose.

     I could make an rbtree of records such that each record has an rb_node
     and a key pointer, but that would use four words of space per key stored
     in the keyring.  It would, however, be able to use much existing code.

     I selected instead a non-rebalancing radix-tree type approach as that
     could have a better space-used/key-pointer ratio.  I could have used the
     radix tree implementation that we already have and insert keys into it by
     their serial numbers, but that means any sort of search must iterate over
     the whole radix tree.  Further, its nodes are a bit on the capacious side
     for what I want - especially given that key serial numbers are randomly
     allocated, thus leaving a lot of empty space in the tree.

     So what I have is an associative array that internally is a radix-tree
     with 16 pointers per node where the index key is constructed from the key
     type pointer and the key description.  This means that an exact lookup by
     type+description is very fast as this tells us how to navigate directly to
     the target key.

     I made the data structure general in lib/assoc_array.c as far as it is
     concerned, its index key is just a sequence of bits that leads to a
     pointer.  It's possible that someone else will be able to make use of it
     also.  FS-Cache might, for example.


 (2) Mark keys as 'trusted' and keyrings as 'trusted only'.

	KEYS: verify a certificate is signed by a 'trusted' key
	KEYS: Make the system 'trusted' keyring viewable by userspace
	KEYS: Add a 'trusted' flag and a 'trusted only' flag
	KEYS: Separate the kernel signature checking keyring from module signing

     These patches allow keys carrying asymmetric public keys to be marked as
     being 'trusted' and allow keyrings to be marked as only permitting the
     addition or linkage of trusted keys.

     Keys loaded from hardware during kernel boot or compiled into the kernel
     during build are marked as being trusted automatically.  New keys can be
     loaded at runtime with add_key().  They are checked against the system
     keyring contents and if their signatures can be validated with keys that
     are already marked trusted, then they are marked trusted also and can
     thus be added into the master keyring.

     Patches from Mimi Zohar make this usable with the IMA keyrings also.


 (3) Remove the date checks on the key used to validate a module signature.

	X.509: Remove certificate date checks

     It's not reasonable to reject a signature just because the key that it was
     generated with is no longer valid datewise - especially if the kernel
     hasn't yet managed to set the system clock when the first module is
     loaded - so just remove those checks.


 (4) Make it simpler to deal with additional X.509 being loaded into the kernel.

	KEYS: Load *.x509 files into kernel keyring
	KEYS: Have make canonicalise the paths of the X.509 certs better to deduplicate

     The builder of the kernel now just places files with the extension ".x509"
     into the kernel source or build trees and they're concatenated by the
     kernel build and stuffed into the appropriate section.


 (5) Add support for userspace kerberos to use keyrings.

	KEYS: Add per-user_namespace registers for persistent per-UID kerberos caches
	KEYS: Implement a big key type that can save to tmpfs

     Fedora went to, by default, storing kerberos tickets and tokens in tmpfs.
     We looked at storing it in keyrings instead as that confers certain
     advantages such as tickets being automatically deleted after a certain
     amount of time and the ability for the kernel to get at these tokens more
     easily.

     To make this work, two things were needed:

     (a) A way for the tickets to persist beyond the lifetime of all a user's
     	 sessions so that cron-driven processes can still use them.

	 The problem is that a user's session keyrings are deleted when the
	 session that spawned them logs out and the user's user keyring is
	 deleted when the UID is deleted (typically when the last log out
	 happens), so neither of these places is suitable.

	 I've added a system keyring into which a 'persistent' keyring is
	 created for each UID on request.  Each time a user requests their
	 persistent keyring, the expiry time on it is set anew.  If the user
	 doesn't ask for it for, say, three days, the keyring is automatically
	 expired and garbage collected using the existing gc.  All the kerberos
	 tokens it held are then also gc'd.

     (b) A key type that can hold really big tickets (up to 1MB in size).

     	 The problem is that Active Directory can return huge tickets with lots
     	 of auxiliary data attached.  We don't, however, want to eat up huge
     	 tracts of unswappable kernel space for this, so if the ticket is
     	 greater than a certain size, we create a swappable shmem file and dump
     	 the contents in there and just live with the fact we then have an
     	 inode and a dentry overhead.  If the ticket is smaller than that, we
     	 slap it in a kmalloc()'d buffer.

David
