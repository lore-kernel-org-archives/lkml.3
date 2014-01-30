Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaA3NWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:22:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbaA3NWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:22:22 -0500
Date: Thu, 30 Jan 2014 11:22:03 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Stephan Mueller <stephan.mueller@atsec.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        lwang@redhat.com, sgrubb@redhat.com
Subject: Re: [RFC PATCH] char: random: stir the output pools differently when
 the random_write lenght allows splitting the seed
Message-ID: <20140130132203.GA19784@localhost.localdomain>
References: <42f6dc88535d5ecdab13b1376db7ccbbbc550600.1389297772.git.aquini@redhat.com>
 <1510904.XsOZgVgixq@tauon>
 <52CFDB76.2030207@ladisch.de>
 <5743525.Bz4yhBJ8Tl@tauon>
 <52CFE84A.9050107@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CFE84A.9050107@ladisch.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 01:32:10PM +0100, Clemens Ladisch wrote:
> Stephan Mueller wrote:
> > Am Freitag, 10. Januar 2014, 12:37:26 schrieb Clemens Ladisch:
> >> Stephan Mueller wrote:
> >>> Am Freitag, 10. Januar 2014, 09:13:57 schrieb Clemens Ladisch:
> >>>> Rafael Aquini wrote:
> >>>>> This patch introduces changes to the random_write method so it can
> >>>>> split the given seed and completely stir the output pools with
> >>>>> different halves of it, when seed lenght allows us doing so.
> >>>>>
> >>>>> -	ret = write_pool(&blocking_pool, buffer, count);
> >>>>> +	ret = write_pool(pool1, buffer, count1);
> >>>>>
> >>>>>  	if (ret)
> >>>>>  	
> >>>>>  		return ret;
> >>>>>
> >>>>> -	ret = write_pool(&nonblocking_pool, buffer, count);
> >>>>> +	ret = write_pool(pool2, buffer + offset, count2);
> >>>>
> >>>> Doesn't this assume that both halves of the buffer contain some
> >>>> (uncredited) entropy?  In other words, wouldn't this result in worse
> >>>> randomness for pool2 if the second half of the buffer contains just
> >>>> zero padding?
> >>>
> >>> [...]
> >>> Coming back to your concern: sure, the caller can pad any data
> >>> injected into /dev/?random with zeros.
> >>
> >> Assume that the userspace of an embedded device wants to do the same
> >> kind of initialization that a call to add_device_randomness() does, and
> >> that it has some data like "char serial_number[256]".  The padding
> >> wouldn't be done intentionally, it's just a property of the data (and
> >> it wouldn't have mattered before this patch).
> >>
> >>> But as writing to the character files is allowed to every user, this
> >>> per definition must not matter (e.g. an attacker may simply write
> >>> zeros or other known data into the character file). And the random.c
> >>> driver handles that case appropriately by not increasing the entropy
> >>> estimator when receiving data.
> >>
> >> The problem is not with the entropy estimate.
> >>
> >>> All the patch tries to achieve is to ensure that both pools are not
> >>> always mixed with the same values.
> >>
> >> Before this patch, both pools got mixed with the same values.  After
> >> this patch, both pools indeed get mixed with different values, but now
> >> one pool gets mixed with a known value if one half of the buffer
> >> happens to be known.
> >
> > Do you imply in your example above that the serial number is unknown?
> > Anything that unprivileged user space tries to inject into /dev/?random
> > should be considered data with known value.
> 
> Like the kernel's add_device_randomness() function, this example assumes
> that there is no persistent storage with a saved seed (or that it isn't
> yet available), and that mixing a device-specific value at least
> prevents multiple device instances from generating identical random
> numbers.
> 
> This indeed helps only against attackers that do not know that serial
> number.
> 
> If the data written by unprivileged users to /dev/?random were
> considered known to *all* attackers, then it wouldn't make sense to
> allow such writes at all.
> 

Sorry folks, 

Although I left this one a little behind, I'd like to follow it up and reach
some consensus.


After re-reading the whole discussion, it became clear to me that the source of
Stephan's request on splitting the seed we feed into the LRNG lies around the
fact that any unprivileged user is capable to inject data and stir the entropy
extraction pools arbitrarily.

$ ls -l /dev/{u,}random
crw-rw-rw-. 1 root root 1, 8 Jan 21 23:44 /dev/random
crw-rw-rw-. 1 root root 1, 9 Jan 21 23:44 /dev/urandom

Considering what goes within this thread, wouldn't be simpler to just remove the
privileged of writing to /dev/{u,}random from the wild world? 

Stephan, I'll repeat myself here: theoretically speaking there's no diff between
using the same seed to mix both output pools and splitting it to use its
different halves to stir the pools separately, for the /dev/{u,}random writes,
if an attacker could successfully compromise the pools by feeding them with a
known pattern seed. I understand you raised the split-the-seed point on a
security concern and that concern might eventually become a requirement.
Please, let us (me) know know if:

a) is this request based on an existent pronouncement of standardization?
b) is this (potential) pronouncement based on math proof that one could 
   compromise the LRNG internal state by feeding known seeds into /dev/{u,}random?

If (a) & (b) are true, and there's no code in the actual random.c implementation
that does not address those security claims, and the naive approach of
restricting who can actually write to /dev/{u,}random is not deemed feasible,
then something like the (ugly) hack that goes bellow would be considered
feasible? (perhaps making it conditional to fips_enabled)


Thank you all for the comments till here, and have you all a nice weekend!

Rafael
---
vers/char/random.c | 66 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 56 insertions(+), 10 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 429b75b..63e8852 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -274,6 +274,7 @@
 #define INPUT_POOL_WORDS       (1 << (INPUT_POOL_SHIFT-5))
 #define OUTPUT_POOL_SHIFT      10
 #define OUTPUT_POOL_WORDS      (1 << (OUTPUT_POOL_SHIFT-5))
+#define OUTPUT_POOL_SIZE       ((1 << OUTPUT_POOL_SHIFT) >> 3)
 #define SEC_XFER_SIZE          512
 #define EXTRACT_SIZE           10

@@ -1387,19 +1388,64 @@ write_pool(struct entropy_store *r, const char __user *buffer, size_t count)
        return 0;
 }

-static ssize_t random_write(struct file *file, const char __user *buffer,
-                           size_t count, loff_t *ppos)
+static size_t __do_random_write(const char __user *buffer, size_t count)
 {
-       size_t ret;
-
-       ret = write_pool(&blocking_pool, buffer, count);
-       if (ret)
-               return ret;
-       ret = write_pool(&nonblocking_pool, buffer, count);
+       struct entropy_store *randomwrite_pool, *output_pool1, *output_pool2;
+       __u32 *randomwrite_pool_data, *rnd_seed;
+       size_t dime, ret = -ENOMEM;
+
+       randomwrite_pool_data = kzalloc(OUTPUT_POOL_SIZE, GFP_KERNEL);
+       if (!randomwrite_pool_data)
+               goto out_0;
+
+       randomwrite_pool = kzalloc(sizeof(struct entropy_store), GFP_KERNEL);
+       if (!randomwrite_pool)
+               goto out_1;
+
+       rnd_seed = kzalloc(OUTPUT_POOL_SIZE, GFP_KERNEL);
+       if (!rnd_seed)
+               goto out_2;
+
+       /* init an auxiliary pool and give it a stir with the input bias */
+       get_random_bytes(randomwrite_pool_data, OUTPUT_POOL_SIZE);
+       spin_lock_init(&randomwrite_pool->lock);
+       randomwrite_pool->poolinfo = &poolinfo_table[1];
+       randomwrite_pool->pool = randomwrite_pool_data;
+       randomwrite_pool->name = "randomwrite_pool";
+       ret = write_pool(randomwrite_pool, buffer, count);
        if (ret)
-               return ret;
+               goto out_3;
+
+       /* flip a coin before deciding the output pool seeding order */
+       output_pool1 = &blocking_pool;
+       output_pool2 = &nonblocking_pool;
+       get_random_bytes(&dime, 1);
+       if (dime % 2) {
+               output_pool1 = &nonblocking_pool;
+               output_pool2 = &blocking_pool;
+       }
+
+       extract_entropy(randomwrite_pool, rnd_seed, OUTPUT_POOL_SIZE, 0, 0);
+       mix_pool_bytes(output_pool1, rnd_seed, OUTPUT_POOL_SIZE, NULL);

-       return (ssize_t)count;
+       extract_entropy(randomwrite_pool, rnd_seed, OUTPUT_POOL_SIZE, 0, 0);
+       mix_pool_bytes(output_pool2, rnd_seed, OUTPUT_POOL_SIZE, NULL);
+
+       ret = count;
+out_3:
+       kfree(rnd_seed);
+out_2:
+       kfree(randomwrite_pool);
+out_1:
+       kfree(randomwrite_pool_data);
+out_0:
+       return ret;
+}
+
+static ssize_t random_write(struct file *file, const char __user *buffer,
+                           size_t count, loff_t *ppos)
+{
+       return __do_random_write(buffer, count);
 }

 static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
-- 

