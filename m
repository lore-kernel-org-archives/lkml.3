Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab3I3Uvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:51:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:60504 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352Ab3I3Uvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:51:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="403336857"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@linux.intel.com>, "tytso@mit.edu" <tytso@mit.edu>
Subject: RE: [PATCH 01/11] random: don't feed stack data into pool when
 interrupt regs NULL
Thread-Topic: [PATCH 01/11] random: don't feed stack data into pool when
 interrupt regs NULL
Thread-Index: AQHOvhvHmXS3Czj1skO0hGrGBJ+hn5neveiA
Date: Mon, 30 Sep 2013 20:51:43 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D1F249@ORSMSX106.amr.corp.intel.com>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1380572952-30729-2-git-send-email-andi@firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In this case fast_mix would use two uninitialized ints from the stack
> and mix it into the pool.

Is the concern here is that an attacker might know (or be able to control) what is on
the stack - and so get knowledge of what is being mixed into the pool?

> In this case set the input to 0.

And the fix is to guarantee that everyone knows what is being mixed in? (!)

Wouldn't it be better to adjust the "nbytes" parameter to

	fast_mix(..., ..., sizeof (input));

to only mix in the part of input[] that we successfully initialized?

Untested patch below.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7737b5bd26af..5c4ec0abb702 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -745,16 +745,19 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
 	__u32			input[4], cycles = get_cycles();
+	int			nbytes;
 
 	input[0] = cycles ^ jiffies;
 	input[1] = irq;
+	nbytes = 2 * sizeof(input[0]);
 	if (regs) {
 		__u64 ip = instruction_pointer(regs);
 		input[2] = ip;
 		input[3] = ip >> 32;
+		nbytes += 2 * sizeof(input[0]);
 	}
 
-	fast_mix(fast_pool, input, sizeof(input));
+	fast_mix(fast_pool, input, nbytes);
 
 	if ((fast_pool->count & 1023) &&
 	    !time_after(now, fast_pool->last + HZ))


