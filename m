Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaEMGuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:50:03 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:33685 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaEMGuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:50:01 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1405121140210.6261@ionos.tec.linutronix.de>
References: <cover.1399886467.git.viresh.kumar@linaro.org>
	<df571ff25b510bd0263b194bfdcbaf1b476a2a03.1399886467.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1405121140210.6261@ionos.tec.linutronix.de>
Date: Tue, 13 May 2014 12:20:01 +0530
Message-ID: <CAKohpo=zHjFdrz4Ce1Zg4q+6V6rCapEh-6-HRCqp0gYwSkK7sw@mail.gmail.com>
Subject: Re: [RFC 1/2] clockevents: return 'int' from clockevents_set_mode()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 May 2014 15:49, Thomas Gleixner <tglx@linutronix.de> wrote:
> Does that handle_return_value() mean that you sprinkle WARN_ONs all
> over the place?

Yeah, probably it should have been done this way:

-               dev->set_mode(mode, dev);
+               if (dev->set_dev_mode) {
+                       int ret = dev->set_dev_mode(mode, dev);
+
+                       /* Currently available modes are not expected to fail */
+                       if (WARN_ON(ret))
+                               return ret;
+               } else {
+                       dev->set_mode(mode, dev);
+               }
+

My fault and a big one :(

> Does it mean, that you change the return value
> semantics of functions which happen to call clock_events_set_mode()
> just because it now has a return value?

I didn't do it, probably yet another bad/confusing log by me :(

>> All other are updated to return error codes.

When I read it now, I can see why it was confusing :(.
What I meant was:

"routines which had capability to return errors would now return them on
failure of clockevents_set_mode() as well.."

But even that isn't required and handling should be added only to callers
of clockevents_set_mode() which are issuing ONESHOT_STOPPED ..

> Find someone competent who reviews your patches, deals with you and
> when they make sense sends them to me.

I will make sure to get some Reviewed-by/Signed-off-by for my patches
from someone with good understanding of these frameworks before
sending them out again..

Sorry for the noise :(

--
viresh
