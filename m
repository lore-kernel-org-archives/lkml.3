Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaA3ROL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:14:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaA3ROI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:14:08 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
To: torvalds@linux-foundation.org
cc: dhowells@redhat.com, ghudson@mit.edu, simo@redhat.com, sgallagh@redhat.com,
        keys@linux-nfs.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: RFC: KEYS: Is this too-big a behavioural change for a system call?
From: David Howells <dhowells@redhat.com>
Date: Thu, 30 Jan 2014 17:14:00 +0000
Message-ID: <4268.1391102040@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Sent again, this time with Linus's address correct]

Hi Linus,

I've been asked by Kerberos developers to slightly change the behaviour of the
add_key() and request_key() system calls and a couple of the keyctl() functions
- and I'm wondering if you'd be okay with it.

The current behaviour can be illustrated thusly:

 (*) The add_key() syscall, for example, takes a destination keyring into which
     the newly created key will be placed.

 (*) There's a special value that can be passed as the destination keyring ID
     to indicate a process's session keyring without actually needing to know
     the ID of that keyring.

 (*) A process can have no session keyring.  If it didn't inherit one from its
     parent or if it didn't explicitly or implicitly create one, then it won't
     have one.

 (*) A process can have its session keyring pointer pointing to the default
     user-session keyring for its owner UID.

     [! A process can also have some other session keyring, but that's
     	irrelevant to this problem]

 (*) When the kernel looks up a key ID to turn it into a keyring, it calls
     lookup_user_key() and can pass a flag (KEY_LOOKUP_CREATE) to request that
     the keyring be created if it doesn't exist yet.

     Typically, KEY_LOOKUP_CREATE is set if we're going to modify the keyring
     in some way (eg. it's the destination for add_key()).  It's also possible
     for userspace to explicitly set this with:

	keyctl(KEYCTL_GET_KEYRING_ID, <id>, 1).

 (*) If a process has no session keyring or is using the user-session _and_ it
     makes a system call that requests use of the session keyring then one of
     two things happens:

     (a) If KEY_LOOKUP_CREATE set then an empty keyring will be created and
     	 assigned as this process's session keyring.

	 This will forcibly displace the user-session keyring from the session
	 pointer, even if the user explicitly joined that keyring as their
	 session.

     (b) If KEY_LOOKUP_CREATE was not set then the user-session keyring will be
     	 installed as the session keyring and then will be used as the session
     	 keyring until (a) applies.

 (*) If a process with no session keyring creates a key and attaches it to its
     session keyring, a session keyring will be created, the key will be added
     to it - and then the keyring and the key added to it will be deleted when
     the process exits.


The problem the Kerberos developers have is that they would like libkrb5 to
fall back to using the session keyring if keyctl(KEYCTL_GET_PERSISTENT) fails
with EOPNOTSUPP (say if CONFIG_PERSISTENT_KEYRINGS=n).  However, this means
that if you don't have a session keyring, kinit has one forcibly created for it
by the kernel and then your credentials cache is deleted when kinit exits.

If you have pam_keyinit properly set in your PAM configuration then this isn't
a problem for processes derived from a login shell of some sort (ssh, login, X,
etc.).

However, processes that aren't started from a PAM aware process - such as the
Kerberos developers' testfarm - don't get a session keyring unless they
explicitly create one.


Now, there are several solutions:

 (1) Don't use the session keyring as a fallback in libkrb5.

 (2) Explicitly use the user-session keyring as a fall back in libkrb5 instead
     of the session keyring.

 (3) Manually create a session keyring somewhere before it is needed.  The
     keyutils testsuite does this by running its tests from "keyctl session"

 (4) Don't implicitly create a new anonymous keyring, but always set the
     user-session keyring as a process's session keyring if the latter is
     unset.

 (5) Don't implicitly create a new anonymous keyring and don't implicitly set
     the session keyring to the user-session keyring, but rather just fall back
     to using the user-session keyring if there isn't a session keyring.

 (6) Don't implicitly create a new anonymous keyring and never use the
     user-session keyring instead, but rather reject requests with ENOKEY.

The first three don't require kernel changes.

In (5) and (6) a session keyring should still be created if userspace
explicitly asks for one with KEYCTL_GET_KEYRING_ID.


I think the best thing course would be (3).  I have reservations about using
the user and user-session keyrings:

 (*) They depend on what UID your process currently is and are thus subject to
     setuid() and SUID-exec.

 (*) I'm not keen on system daemons sharing automatically keys by the user and
     user-session keyrings - and sharing them with other root processes.

 (*) How do these interact with the SELinux?

 (*) Do you want the output of test programs dumping where everyone else can
     make use of it?


That said, I do think that the Kerberos people have a valid point.  The current
behaviour is poor.  I'm inclined to implement (5) or (6), probably (5).

This won't make any difference to most processes, ie.:

 (*) Those run from pam_keyinit-managed login shells.

 (*) Those that don't make use of libkrb5 or keyrings.


In many ways, I'd like to just get rid of the user and user-session keyrings
from the kernel entirely and have them created and maintained by pam_keyinit.
The special keyring IDs:

	KEY_SPEC_USER_KEYRING
	KEY_SPEC_USER_SESSION_KEYRING

and:

	KEY_REQKEY_DEFL_USER_KEYRING
	KEY_REQKEY_DEFL_USER_SESSION_KEYRING

would then search your session keyring for keyrings called "_uid" and
"_uid_ses" and return those.  Unfortunately, I think this is probably a
much-too-big change at this point.

Any thoughts?

Thanks,
David

