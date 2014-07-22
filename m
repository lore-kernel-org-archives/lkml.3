Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaGVBC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 21:02:28 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33428 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbaGVBC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 21:02:27 -0400
X-Sasl-enc: OvOUo/bjENUYQ55n72o6CTYDdhK6wFe1jXGnCHs1VCvl 1405990942
Message-ID: <1405990940.28229.4.camel@localhost>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: George Spelvin <linux@horizon.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu
Date: Tue, 22 Jul 2014 03:02:20 +0200
In-Reply-To: <1405956426.2319.37.camel@localhost>
References: <20140721112102.19300.qmail@ns.horizon.com>
	 <1405956426.2319.37.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 2014-07-21 at 17:27 +0200, Hannes Frederic Sowa wrote:
> On Mo, 2014-07-21 at 07:21 -0400, George Spelvin wrote:
> > > I don't like partial reads/writes and think that a lot of people get
> > > them wrong, because they often only check for negative return values.
> > 
> > The v1 patch, which did it right IMHO, didn't do partial reads in the
> > case we're talking about:
> > 
> > +	if (count > 256)
> > +		return -EINVAL;
> 
> I checked and unfortunately it does not; 256 bytes is way too large to
> guarantee non-existence of partial reads. On a typical older system
> without rdrand/rdseed you would have to limit the amount of bytes to
> extract to about 32. That's way too low. That said, the 512 bytes check
> only in case of extracting bytes from blocking pool would serve no
> purpose.

Ted, would it make sense to specifiy a 512 byte upper bound limit for
random entropy extraction (I am not yet convinced to do that for
urandom) and in case the syscall should block we make sure that we
extract the amount of bytes the user requested?

Having a quick look maybe something like this? Only compile tested and
maybe can still be simplified. It guarantees we don't do a partial write
to user space for sub 512 bytes requests.

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 2721543..c0db6f5 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1345,8 +1345,14 @@ static int arch_random_refill(void)
 	return n;
 }
 
+enum blocking_mode {
+	NONBLOCKING,
+	SYSCALL_BLOCK,
+	DEV_RANDOM_BLOCK
+};
+
 static ssize_t
-_random_read(int nonblock, char __user *buf, size_t nbytes)
+_random_read(enum blocking_mode mode, char __user *buf, size_t nbytes)
 {
 	ssize_t n;
 
@@ -1361,7 +1367,7 @@ _random_read(int nonblock, char __user *buf, size_t nbytes)
 		trace_random_read(n*8, (nbytes-n)*8,
 				  ENTROPY_BITS(&blocking_pool),
 				  ENTROPY_BITS(&input_pool));
-		if (n > 0)
+		if (mode != SYSCALL_BLOCK && n > 0)
 			return n;
 
 		/* Pool is (near) empty.  Maybe wait and retry. */
@@ -1370,7 +1376,7 @@ _random_read(int nonblock, char __user *buf, size_t nbytes)
 		if (arch_random_refill())
 			continue;
 
-		if (nonblock)
+		if (mode == NONBLOCKING)
 			return -EAGAIN;
 
 		wait_event_interruptible(random_read_wait,
@@ -1384,7 +1390,8 @@ _random_read(int nonblock, char __user *buf, size_t nbytes)
 static ssize_t
 random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	return _random_read(file->f_flags & O_NONBLOCK, buf, nbytes);
+	return _random_read(file->f_flags & O_NONBLOCK ? NONBLOCKING :
+			    DEV_RANDOM_BLOCK, buf, nbytes);
 }
 
 static ssize_t
@@ -1534,8 +1541,6 @@ const struct file_operations urandom_fops = {
 SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 		unsigned int, flags)
 {
-	int r;
-
 	if (flags & ~(GRND_NONBLOCK|GRND_RANDOM))
 		return -EINVAL;
 
@@ -1543,7 +1548,8 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 		count = INT_MAX;
 
 	if (flags & GRND_RANDOM)
-		return _random_read(flags & GRND_NONBLOCK, buf, count);
+		return _random_read(flags & GRND_NONBLOCK ? NONBLOCKING :
+				    SYSCALL_BLOCK, buf, count);
 
 	if (unlikely(nonblocking_pool.initialized == 0)) {
 		if (flags & GRND_NONBLOCK)

Bye,
Hannes


