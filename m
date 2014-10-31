Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbaJaJb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:31:56 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:37442 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407AbaJaJbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:31:55 -0400
Date: Fri, 31 Oct 2014 10:31:41 +0100
From: Greg Kurz <gkurz@linux.vnet.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: pseries - port to new read API and fix stack
 corruption
Message-ID: <20141031103141.7b91c647@bahia.local>
In-Reply-To: <1414738812.21815.5.camel@concordia>
References: <20141031063233.1884.86309.stgit@bahia.local>
	<1414738812.21815.5.camel@concordia>
Organization: IBM
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14103109-0029-0000-0000-0000017189C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014 18:00:12 +1100
Michael Ellerman <mpe@ellerman.id.au> wrote:

> On Fri, 2014-10-31 at 07:50 +0100, Greg Kurz wrote:
> > The add_early_randomness() function in drivers/char/hw_random/core.c passes
> > a 16-byte buffer to pseries_rng_data_read(). Unfortunately, plpar_hcall()
> > returns four 64-bit values and trashes 16 bytes on the stack.
> 
> Hmm, thanks. I thought I'd fixed that, but I guess I never sent the patch :}
> 

Heh so many patches ! :)

> > This bug has been lying around for a long time. It got unveiled by:
> > 
> > commit d3cc7996473a7bdd33256029988ea690754e4e2a
> > Author: Amit Shah <amit.shah@redhat.com>
> > Date:   Thu Jul 10 15:42:34 2014 +0530
> > 
> >     hwrng: fetch randomness only after device init
> > 
> > It may trig a oops while loading or unloading the pseries-rng module for both
> > PowerVM and PowerKVM guests.
> > 
> > This patch does two things:
> > - pass an intermediate well sized buffer to plpar_hcall(). This is acceptalbe
> >   since we're not on a hot path.
> 
> Well probably, can you do a before and after test of dd if=/dev/hwrng ?
> 

I had to do this to be able to run the before test:

@@ -78,7 +78,7 @@ static size_t rng_buffer_size(void)
 
 static void add_early_randomness(struct hwrng *rng)
 {
-       unsigned char bytes[16];
+       unsigned char bytes[32];

I ran tests for 128 MB and 1G several times in a PowerKVM guest on a POWER8 box.

Before:

[root@fedora20-ppc64 ~]# time dd if=/dev/hwrng of=/dev/null bs=1024 count=131072
131072+0 records in
131072+0 records out
134217728 bytes (134 MB) copied, 17.0503 s, 7.9 MB/s

real    0m17.051s
user    0m0.024s
sys     0m16.797s
[root@fedora20-ppc64 ~]# time dd if=/dev/hwrng of=/dev/null bs=1024 count=1048576
1048576+0 records in
1048576+0 records out
1073741824 bytes (1.1 GB) copied, 136.374 s, 7.9 MB/s

real    2m16.376s
user    0m0.189s
sys     2m14.367s

After:

[root@fedora20-ppc64 ~]# time dd if=/dev/hwrng of=/dev/null bs=1024 count=131072
131072+0 records in
131072+0 records out
134217728 bytes (134 MB) copied, 17.0502 s, 7.9 MB/s

real    0m17.051s
user    0m0.024s
sys     0m16.797s
[root@fedora20-ppc64 ~]# time dd if=/dev/hwrng of=/dev/null bs=1024 count=1048576
1048576+0 records in
1048576+0 records out
1073741824 bytes (1.1 GB) copied, 136.432 s, 7.9 MB/s

real    2m16.433s
user    0m0.188s
sys     2m14.370s

It shows no degradation of performance.

> > Cc'ing stable as I could reproduce back to 3.15.10
> 
> The right way to CC stable for a patch that isn't yet in upstream is to add:
> 
> CC: stable@vger.kernel.org
> 
> Before your Signed-off-by. They will then pick it up once it's merged into
> Linus' tree. See Documentation/stable_kernel_rules.txt
> 
> cheers
> 

Oops... should I repost then ?

Thanks.

--
Greg

