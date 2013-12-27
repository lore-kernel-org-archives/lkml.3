Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3L0WW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:22:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3L0WW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:22:56 -0500
Date: Fri, 27 Dec 2013 14:22:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: a.zummo@towertech.it, grant.likely@linaro.org, robh+dt@kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: question about drivers/rtc/rtc-cmos.c
Message-Id: <20131227142255.c6b1b7e92a8430f1bebd15af@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1312252028170.2020@localhost6.localdomain6>
References: <alpine.DEB.2.02.1312252028170.2020@localhost6.localdomain6>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Dec 2013 20:32:12 +0100 (CET) Julia Lawall <julia.lawall@lip6.fr> wrote:

> The function cmos_do_probe contains the code:
> 
> 		if (is_hpet_enabled()) {
>                         int err;
> 
>                         rtc_cmos_int_handler = hpet_rtc_interrupt;
> 			err = hpet_register_irq_handler(cmos_interrupt);
>                         if (err != 0) {
>                                 dev_warn(dev, "hpet_register_irq_handler "
>                                                 " failed in rtc_init().");
>                                 goto cleanup1;
>                         }
>                 }
> 
> Is it intentional that the error code returned by 
> hpet_register_irq_handler is put ina local variable that will not be seen 
> at label cleanup1?  The return value is retval, which is 0 at this point.

No, I'd say that's a bug.  How does this look?


From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/rtc/rtc-cmos.c: propagate hpet_register_irq_handler() failure

If hpet_register_irq_handler() fails, cmos_do_probe() will incorrectly
return 0.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure
+++ a/drivers/rtc/rtc-cmos.c
@@ -708,11 +708,9 @@ cmos_do_probe(struct device *dev, struct
 		irq_handler_t rtc_cmos_int_handler;
 
 		if (is_hpet_enabled()) {
-			int err;
-
 			rtc_cmos_int_handler = hpet_rtc_interrupt;
-			err = hpet_register_irq_handler(cmos_interrupt);
-			if (err != 0) {
+			retval = hpet_register_irq_handler(cmos_interrupt);
+			if (retval) {
 				dev_warn(dev, "hpet_register_irq_handler "
 						" failed in rtc_init().");
 				goto cleanup1;
_

