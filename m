Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbaAJVr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 16:47:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaAJVrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 16:47:25 -0500
Date: Fri, 10 Jan 2014 19:47:09 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Stephan Mueller <stephan.mueller@atsec.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH] char: random: stir the output pools differently when
 the random_write lenght allows splitting the seed
Message-ID: <20140110214708.GA24523@localhost.localdomain>
References: <42f6dc88535d5ecdab13b1376db7ccbbbc550600.1389297772.git.aquini@redhat.com>
 <52CFABC5.5030806@ladisch.de>
 <1510904.XsOZgVgixq@tauon>
 <52CFDB76.2030207@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CFDB76.2030207@ladisch.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 12:37:26PM +0100, Clemens Ladisch wrote:
> Stephan Mueller wrote:
> > Am Freitag, 10. Januar 2014, 09:13:57 schrieb Clemens Ladisch:
> >> Rafael Aquini wrote:
> >>> This patch introduces changes to the random_write method so it can
> >>> split the given seed and completely stir the output pools with
> >>> different halves of it, when seed lenght allows us doing so.
> >>>
> >>> -	ret = write_pool(&blocking_pool, buffer, count);
> >>> +	ret = write_pool(pool1, buffer, count1);
> >>>  	if (ret)
> >>>  		return ret;
> >>> -	ret = write_pool(&nonblocking_pool, buffer, count);
> >>> +	ret = write_pool(pool2, buffer + offset, count2);
> >>
> >> Doesn't this assume that both halves of the buffer contain some
> >> (uncredited) entropy?  In other words, wouldn't this result in worse
> >> randomness for pool2 if the second half of the buffer contains just
> >> zero padding?
> >
> > [...]
> > Coming back to your concern: sure, the caller can pad any data injected
> > into /dev/?random with zeros.
> 
> Assume that the userspace of an embedded device wants to do the same
> kind of initialization that a call to add_device_randomness() does, and
> that it has some data like "char serial_number[256]".  The padding
> wouldn't be done intentionally, it's just a property of the data (and it
> wouldn't have mattered before this patch).
> 
> > But as writing to the character files is allowed to every user, this
> > per definition must not matter (e.g. an attacker may simply write
> > zeros or other known data into the character file). And the random.c
> > driver handles that case appropriately by not increasing the entropy
> > estimator when receiving data.
> 
> The problem is not with the entropy estimate.
> 
> > All the patch tries to achieve is to ensure that both pools are not
> > always mixed with the same values.
> 
> Before this patch, both pools got mixed with the same values.  After
> this patch, both pools indeed get mixed with different values, but now
> one pool gets mixed with a known value if one half of the buffer happens
> to be known.
>

Yeah, nice catch. I haven't thought about it. Theoretically speaking there's no
big difference between using the same seed to mix both output pools and split the
seed to use its different halves to mix the pools separately in this case.
Supposing an attacker could successfully compromise the blocking pool
(/dev/random) by injecting a known pattern seed into /dev/urandom, a split seed
would also not be able to do any greater good for us, as the attacker can surely
handcraft an input that shows the same pattern on both halves.


I'm wondering if doing something like initializing an extra structentropy_store, 
fill in its pool with 'OUTPUT_POOL_SIZE' get_random_bytes(), stir this extra pool
with whatever came in as seed from userland and extract two seeds from this pool
to then separately stir the output pools would be something more feasible here, 
or would it just be considered too much for too little... 

if the approach above is sth worth to pursue, I'll come up with something next week.

Thank you all for the comments till here, and have you all a nice weekend!
-- Rafael
