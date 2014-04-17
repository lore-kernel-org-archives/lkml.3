Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaDQOSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:18:34 -0400
Received: from www.meduna.org ([92.240.244.38]:32887 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbaDQOS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:18:29 -0400
Message-ID: <534FE2A8.2030203@meduna.org>
Date: Thu, 17 Apr 2014 16:18:16 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>, zbr@ioremap.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: Re: w1-gpio: sleeping function called from invalid context
References: <534E97C8.5090407@meduna.org> <534ED833.6020303@windriver.com>
In-Reply-To: <534ED833.6020303@windriver.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-04-17 16:18:22
X-Connected-IP: 95.105.163.217:43604
X-Message-Linecount: 95
X-Body-Linecount: 80
X-Message-Size: 3401
X-Body-Size: 2679
X-Received-Count: 1
X-Recipient-Count: 4
X-Local-Recipient-Count: 4
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.04.2014 21:21, Paul Gortmaker wrote:

>   static void w1_write_bit(struct w1_master *dev, int bit)
>   {
>         unsigned long flags = 0;
> 
>         if(w1_disable_irqs) local_irq_save(flags);

Well, it is actually the w1_read_bit that does the writing

static u8 w1_read_bit(struct w1_master *dev)
{
	int result;
	unsigned long flags = 0;

	/* sample timing is critical here */
	local_irq_save(flags);
...

The timing is indeed sensitive - just commenting out gets rid
of the error but also makes the connected device not to appear
(at least when compiled into the kernel and many things run
concurrently at boot). Raising the priority of the master thread
makes it work (but obviously not necessarily 100% reliable,
the timings needed are comparable to jitter caused by interrupts).

The root of the problem is probably that the w1-gpio does
tricks with the direction to communicate with the 1-wire bus.
A normal gpio get/set value does not need to lock anything
(there are special _cansleep versions for pins beyond controllers
that can sleep), but manipulating the pin direction does. To me
it looks the 1-wire is only possible under RT with real
open drain ports.

Maybe the gpiod_direction_input/output could be split to do the
stuff without locking - but I understand that this has to be
carefully designed.

For the record: the following makes things work in my environment:

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index fa932c2..2223c87 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -1011,6 +1011,11 @@ int w1_process(void *data)
         * time can be calculated in jiffies once.
         */
        const unsigned long jtime = msecs_to_jiffies(w1_timeout * 1000);
+       static struct sched_param sp = {
+               .sched_priority = 55
+       };
+
+       sched_setscheduler(current, SCHED_RR, &sp);

        while (!kthread_should_stop()) {
                if (dev->search_count) {
diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index e10acc2..7065486 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -170,14 +170,14 @@ static u8 w1_read_bit(struct w1_master *dev)
        unsigned long flags = 0;

        /* sample timing is critical here */
-       local_irq_save(flags);
+       if(w1_disable_irqs) local_irq_save(flags);
        dev->bus_master->write_bit(dev->bus_master->data, 0);
        w1_delay(6);
        dev->bus_master->write_bit(dev->bus_master->data, 1);
        w1_delay(9);

        result = dev->bus_master->read_bit(dev->bus_master->data);
-       local_irq_restore(flags);
+       if(w1_disable_irqs) local_irq_restore(flags);

        w1_delay(55);

-- 
                                   Stano

