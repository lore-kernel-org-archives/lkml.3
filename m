Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3EILJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 07:09:56 -0400
Received: from eu1sys200aog121.obsmtp.com ([207.126.144.151]:43449 "EHLO
	eu1sys200aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541Ab3EILJz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 07:09:55 -0400
X-Greylist: delayed 68318 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 May 2013 07:09:54 EDT
From: Stephen GALLIMORE <stephen.gallimore@st.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Stuart MENEFY <stuart.menefy@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 9 May 2013 13:09:25 +0200
Subject: RE: [RFC 5/8] ARM:stih41x: Add STiH415 SOC support
Thread-Topic: [RFC 5/8] ARM:stih41x: Add STiH415 SOC support
Thread-Index: Ac5MHa60H2QxRWCVR3+Yjen+hQeWogAfpQ6w
Message-ID: <A3BF01DB4A606149A4C20C4C4C808F6C3189F99E90@SAFEX1MAIL1.st.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <201305081818.01927.arnd@arndb.de>
 <A3BF01DB4A606149A4C20C4C4C808F6C3189E576E2@SAFEX1MAIL1.st.com>
 <201305082055.31081.arnd@arndb.de>
In-Reply-To: <201305082055.31081.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you have a better solution, or a way to generalize this that would 
> make sense for the ARM architecture as a whole, then we are more than 
> happy to change.
>
>No idea, sorry. Upon closer inspection I wonder if your code actually does anything to the hardware that causes it to wake up on an interrupt.

You are correct that it does not affect the hardware and as such it may be entirely the wrong approach to put this code here. However, as drivers or subsystems are expected to call enable/disable_irq_ wake() when appropriate it seemed a reasonable place to do it and of course in the future when we add in support for the other suspend states this is also expected to do something with the system standby controller, as is the case on other platforms. But we concede that in this first minimal version that it may look a little out of place.

To quickly summarize the issue we were trying to address, the new freeze state suspends the drivers but then rather than calling the arch suspend code simply goes to sleep on a wake queue. It is relying on wakeup source interrupt handlers actually being run (this is not the case in the other "traditional" suspend states) and that the driver or some subsystem code called as part of the driver's interrupt processing will call pm_wakeup_event() which signals the freeze wake queue and causes the generic suspend code to start going through its wakeup path. But the driver suspend code will suspend the calling of IRQ handlers, dpm_suspend_noirq() calls suspend_device_irqs(), except for those with the NO_SUSPEND flag set.

Now it is possible that we have simply tried to finesse the solution too much and that using the ASC serial device as a wakeup source was an unfortunate place to start, because most wakeup devices on a set top box have a single instance, e.g. the IR device for the remote control and you probably always want them to be a wakeup source. Maybe it would not have really mattered that much in the end if the ASC driver simply installed the interrupts for all UART ports with the flag, regardless of if the port was going to be used to wake up or not; but as I said in my previous response that solution left us feeling a bit uncomfortable which is why we went looking for another approach that was independent of the device driver and hooking into enable/disable_irq_wake() at the architecture level seemed more appropriate once we noticed it being used elsewhere. However, until you put it out there for comment it is hard to know if you have backed the right horse.

Regards,
-stephen

