Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaD0SuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 14:50:01 -0400
Received: from mail.eperm.de ([89.247.134.16]:44314 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbaD0St7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 14:49:59 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Theodore Tso <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [RFC] /dev/random for in-kernel use
Date: Sun, 27 Apr 2014 20:49:48 +0200
Message-ID: <2174751.G4Kehsg85c@myon.chronox.de>
User-Agent: KMail/4.12.4 (Linux/3.13.10-200.fc20.x86_64; KDE/4.12.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

before I start, please allow me to point out that this email is not a 
discussion about entropy. There was already too much such discussion without 
any conclusion. This email shall just explore the pros and cons as well as an 
implementation of making the logic behind /dev/random available for in-kernel 
use.

With the heavy update of random.c during the 3.13 development, the re-seeding 
of the nonblocking_pool from the input_pool is now prevented for a duration of 
random_min_urandom_seed seconds. Furthermore, the nonblocking_pool can be read 
from user space such that it acts as a deterministic RNG due to the non-
blocking behavior if more data is pulled than is delivered by the noise 
sources. As the nonblocking_pool is used when a in-kernel user invokes 
get_random_bytes, the described deterministic behavior also applies to this 
function.

Now, get_random_bytes is the only function inside the kernel that can deliver 
entropy. For most use cases, the described approach is just fine. However, 
when using well defined deterministic RNGs, like the already existing ANSI 
X9.31 or the suggested SP800-90A DRBG, seeding these DRNGs from the DRNG of 
the nonblocking_pool is typically not a suggested way. This is visible in user 
space where /dev/random is preferred when seeding deterministic RNGs (see 
libgcrypt as an example).

Therefore may I propose the implementation of the blocking concept of 
/dev/random as a provider of entropy to in-kernel callers like DRNGs? I would 
recommend a function of

void get_blocking_bytes_nowait(void *buf, int nbytes,
	void (*cb)(void *buf, int buflen))

which supplements get_random_bytes that implements the following:

- one work queue that collects data from blocking_pool (or directly from the 
input_pool?) with an identical concept as random_read from 
drivers/char/random.c

- the cb function is triggered when nbytes of data is gathered by the work 
queue. The cb function is implemented by the caller to obtain the requested 
data. The returned data is supplied with buf. The caller allocates that buffer 
and supplies the pointer to that buffer in the invocation of 
get_blocking_bytes_nowait.

- any invocation of get_blocking_bytes_nowait registers the request in a list. 
The work queue processes the list in a FIFO order and removes completed 
requests until the list is empty again. The list has a set length. If the list 
length is exceeded, the cb function is called right away with buflen set to 0.

Ciao
Stephan
-- 
| Cui bono? |
