Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbaGWIm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:42:58 -0400
Received: from mout.gmx.net ([212.227.15.15]:58806 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757444AbaGWImz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:42:55 -0400
Message-ID: <1406104966.9114.42.camel@schoellingm.dzne.de>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
From: Manuel =?ISO-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Date: Wed, 23 Jul 2014 10:42:46 +0200
In-Reply-To: <1405588695-12014-1-git-send-email-tytso@mit.edu>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:3ZohXpHTpJaeBsljyY1n9MkIS2uhALTo5Wn4T96cdMpX9m1lmwJ
 ldm9fS9G9xrEvV7H2NuI6kbH1FzP9rfEixshV3zzTJrHF/m64kXSw0gTd52sMKSNgjLP8rE
 8+qEvAePInaDxorLsiJjVfaeQQwjIGXY/UaVnRTMbrV8c+OpNMt2B/Gc68dIsAoUfY6+PxE
 fMWOFyG6c4ZvFUGk/WABg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am wondering if we could improve the design of the system call a bit
to prevent programming errors.
Right now, EINVAL is returned in case of invalid flags (or in the older
version of getrandom() also if buflen is too large), EFAULT if buf is an
invalid address and EAGAIN if there is not enough entropy.

However, of course no programmer is save against programming errors.
Everybody *should* check the return value of syscalls, but sometimes it
is forgotten, and theoretically you must be stoned to death for that.

Still, we should think about how we could prevent these errors. Here is
a list of possible modifications of getrandom() and pros and cons:

1. memset(buf, 0x0, buflen) in case of an error
pros:
 - it is more obvious to the userspace programmer that the content of
buffer does *not* contain random bytes
cons:
 - in case even the zero-ed buf is not noticed by the programmer, she/he
might end up using a 100% predictable string of "random bytes". In
contrast if zero-ing the buf is ommitted, you would at least end up
using some (not-cryptographically) random bytes from somewhere in RAM.

I am aware that this memset() call should theoretically be superfluous
but it would only be executed in very rare cases where the programmer
misuses getrandom().


2. int getrandom(void **buf, size_t buflen, unsigned int flags)
                      ^^
If flags, are fine, return a pointer to a buffer of random bytes,
otherwise return a pointer to NULL.

pros:
 - it would ensure that an error in a getrandom() call cannot be
ignored.
cons:
 - not sure if a syscall should allocate memory in the name of a
userspace program
 - not a very unix-like syscall signature
 - anytime getrandom() is called, it will allocate a new buffer which
might end up in decreased performance (however, getrandom() should not
be called multiple times)


3. send a signal to the userland process that (by default) leads to an
abnormal termination of the process
Essentially an error in getrandom() could be seen as critical as a
division by 0.

pros:
 - the userspace programmer is forced to handle this error (otherwise
the signal would terminate the program)
cons:
 - adds more complexity to the userspace program that might lead to new
programming errors


These are three possibilities. Maybe one of you is more creative and can
come up with a much better idea. At the moment, I like option 2 the
best, because it forces the programmer to deal with these errors, but
probably one of you has a good point why this is not a good idea.
Handling the NULL pointer would be much easier than using signals
(option 3). However, it lead to a syscall signature that is different
from, let's say read(), because the syscall itself would allocate its
buffer.

Again, I am aware that you must always check return values, but
programming errors happen. E.g. everybody knows that you cannot trust
data that you received via network, yet heartbleed happened.
Here we have the chance to eradicate a critical programming error by
improving the syscall design and I think we should spend some time
thinking about that.


Best,

Manuel


