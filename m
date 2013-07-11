Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3GKCNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 22:13:04 -0400
Received: from fenja.rhi.hi.is ([130.208.165.103]:46363 "EHLO fenja.rhi.hi.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab3GKCNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 22:13:01 -0400
Date: Thu, 11 Jul 2013 01:53:14 +0000
From: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: 3.10.0-rc7: rtc_cmos.o: No linking because of missing
 CONFIG_HPET  [PATCH]
Message-ID: <20130711015314.GA6001@rhi.hi.is>
References: <20130629204217.GA2589@rhi.hi.is>
 <51D14128.3040608@suse.cz>
 <51D14E78.7040309@ladisch.de>
 <20130702194947.GA4240@rhi.hi.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130702194947.GA4240@rhi.hi.is>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 07:49:47PM +0000, Bjarni Ingi Gislason wrote:
> On Mon, Jul 01, 2013 at 11:40:08AM +0200, Clemens Ladisch wrote:
> > > On 29.6.2013 22:42, Bjarni Ingi Gislason wrote:
> > >>   The file "drivers/rtc/rtc_cmos.c" needs CONFIG_HPET to get linked.
> > >>
> > >> rtc-cmos.c:(.text+0x16f214): undefined reference to `hpet_rtc_interrupt'
> > 
> > CONFIG_HPET enables drivers/char/hpet.c and nothing else; it does not
> > affect the HPET RTC emulation.
> > 
> > You are probably searching for CONFIG_HPET_EMULATE_RTC.
> > 
> 
>   Sorry.  I selected (configured) "HPET_TIMER" to fix the compilation
> and linking (which automatically includes HPET_EMULATE_RTC).
> 

  This patch fixes the linking error and comments out one unused
fuction.

--- rtc-cmos.c-original	2013-06-22 19:47:31.000000000 +0000
+++ rtc-cmos.c	2013-07-10 20:42:32.000000000 +0000
@@ -121,11 +121,12 @@ static inline int hpet_set_periodic_freq
 	return 0;
 }
 
-static inline int hpet_rtc_dropped_irq(void)
-{
-	return 0;
-}
-
+/* Not used in this file, but mentioned in include-file <asm/hpet.h>
+ * static inline int hpet_rtc_dropped_irq(void)
+ * {
+ *	return 0;
+ *  }
+ */
 static inline int hpet_rtc_timer_init(void)
 {
 	return 0;
@@ -700,6 +701,11 @@ cmos_do_probe(struct device *dev, struct
 	if (is_valid_irq(rtc_irq)) {
 		irq_handler_t rtc_cmos_int_handler;
 
+/* if CONFIG_HPET_EMULATE_RTC is false, "is_hpet_enabled()" is defined to
+ * return zero (false).
+ */
+
+#ifdef CONFIG_HPET_EMULATE_RTC
 		if (is_hpet_enabled()) {
 			int err;
 
@@ -711,6 +717,7 @@ cmos_do_probe(struct device *dev, struct
 				goto cleanup1;
 			}
 		} else
+#endif /* CONFIG_HPET_EMULATE_RTC */
 			rtc_cmos_int_handler = cmos_interrupt;
 
 		retval = request_irq(rtc_irq, rtc_cmos_int_handler,

-- 
Bjarni I. Gislason
