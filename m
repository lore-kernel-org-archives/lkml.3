Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaD1ATr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 20:19:47 -0400
Received: from imap.thunk.org ([74.207.234.97]:36057 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbaD1ATo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 20:19:44 -0400
Date: Sun, 27 Apr 2014 20:19:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [RFC] /dev/random for in-kernel use
Message-ID: <20140428001941.GA15379@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
References: <2174751.G4Kehsg85c@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2174751.G4Kehsg85c@myon.chronox.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 08:49:48PM +0200, Stephan Mueller wrote:
> With the heavy update of random.c during the 3.13 development, the re-seeding 
> of the nonblocking_pool from the input_pool is now prevented for a duration of 
> random_min_urandom_seed seconds. Furthermore, the nonblocking_pool can be read 
> from user space such that it acts as a deterministic RNG due to the non-
> blocking behavior if more data is pulled than is delivered by the noise 
> sources. As the nonblocking_pool is used when a in-kernel user invokes 
> get_random_bytes, the described deterministic behavior also applies to this 
> function.

This actually wasn't a major change.  If you are drawing sufficiently
heavily from /dev/urandom (and some crypto libraries draw _very_
heavily; the Chrome browser in particular draws from /dev/urandom
quite liberally), then you'll end up drawing from the input pool
faster than it can be filled from noise sources anyway.  So the rate
limiting wasn't making a material difference as far as the quality of
/dev/urandom and get_random_bytes() is concerned.  What it does do is
allow users of /dev/random (such as gpg key generaiton) to complete in
a reasonable time.

However, given that we're reseeding once a minute (or as needed), it's
actually not a deterministic RNG (per SP 800-90A, section 8.6.5, a
DRBG is forbidden to reseed itself automatically).

> Now, get_random_bytes is the only function inside the kernel that can deliver 
> entropy. For most use cases, the described approach is just fine. However, 
> when using well defined deterministic RNGs, like the already existing ANSI 
> X9.31 or the suggested SP800-90A DRBG, seeding these DRNGs from the DRNG of 
> the nonblocking_pool is typically not a suggested way. This is visible in user 
> space where /dev/random is preferred when seeding deterministic RNGs (see 
> libgcrypt as an example).

Well, as far as SP800-90A DRBG is concerned, using either the logical
equivalent of /dev/random or /dev/urandom is not allowed, since
neither is a "approved" entropy source.  (Then again, given that NIST
approved Dual-EC, I'm not sure how much I'm impressed by a NIST
approval, but whatever.  :-) But if your goal is to get the NIST
certification, which IMHO should only matter if you are selling to the
US government, it really can really only use RDRAND on Intel platforms
--- i.e., get_random_bytes_arch().

That being said, if some kernel module really wants to get its hands
on entropy extracted from the blocking pool, I don't see any reason
why we shouldn't deny them that functionality.


> Therefore may I propose the implementation of the blocking concept of 
> /dev/random as a provider of entropy to in-kernel callers like DRNGs? I would 
> recommend a function of
> 
> void get_blocking_bytes_nowait(void *buf, int nbytes,
> 	void (*cb)(void *buf, int buflen))

Let me make a counter proposal.  Let's instead provide a blocking
interface:

int get_blocking_random_bytes(void *buf, int nbytes);

and two helper functions:

void get_blocking_random_bytes_work(struct work_struct *work);
void get_blocking_random_bytes_cb(struct *workqueue_struct *wq,
     				  struct *random_work rw,
				  void *buf, int nbytes,
				  void (*cb)(void *buf, int buflen));

If a caller really needs to use the non-blocking variant, it can do
this:

static struct random_work my_random_work;

	...
	get_blocking_random_bytes_cb(NULL, &my_random_work, buf, nbytes, cb);
	...

There are two benefits of doing it this way.  First of all, we don't
have to have a fixed number of queued random bytes, since it's up to
the caller to allocate the struct random_work.

Secondly, if a module tries to use use this interface, if there is an
attempt to unload the module, it can do this to cancel the /dev/random
read request:

	cancel_work_sync(&my_random_work.rw_work);


With the original get_blocking_bytes_nowait() proposal, there is no
way to cancel the callback request, so the module would have to do
something much more complicated.  It would have to wire up a struct
completion mechanism, and then call completion_done() from the
callback function, and use wait_for_completion() in the module_exit()
function, which is more complicated.

Furthermore, for a DRBG, if it is going to be seeding itself from its
module_init() function, and then explicitly via an ioctl() request,
then it can use the simpler blocking interface directly.

Cheers,

						- Ted

P.S.  The sample implementation of the helper functions:

struct random_work {
       struct work	rw_work;
       void		*rw_buf;
       int		rw_len;
       void		(*rw_cb)(void *buf, int buflen);
}
       
void get_blocking_random_bytes_work(struct work_struct *work)
{
	struct random_work *rw = container_of(work, struct random_work,
	       		       	 	      rw_work);
	int ret;

	ret = get_blocking_random_bytes(rw->buf, rw->len);
	if (rw->cb)
		rw->cb(rw->rw_buf, ret);
}

void get_blocking_random_bytes_cb(struct *workqueue_struct *wq,
     				  struct *random_work rw,
				  void *buf, int nbytes,
				  void (*cb)(void *buf, int buflen))
{

	rw->rw_buf = buf;
	rw->rw_len = nbytes
	rw->rw_cb = cb;
	INIT_WORK(&work->work, get_blocking_random_bytes_work);
	if (wq)
		queue_work(wq, &work->work);
	else
		schedule_work(&work->work);
}

