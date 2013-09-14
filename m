Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab3INA0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 20:26:09 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:44738 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab3INA0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 20:26:07 -0400
Message-ID: <5233AC6E.1040002@linux.vnet.ibm.com>
Date: Sat, 14 Sep 2013 05:53:10 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Preeti Murthy <preeti.lkml@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Stephen Boyd <sboyd@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] tick: broadcast: Deny per-cpu clockevents from being
 broadcast sources
References: <1379004640-15117-1-git-send-email-soren.brinkmann@xilinx.com> <1379004640-15117-2-git-send-email-soren.brinkmann@xilinx.com> <alpine.DEB.2.02.1309122224420.4089@ionos.tec.linutronix.de> <5232CC15.8090208@linaro.org> <CAM4v1pPQwBfQ3V6M2VGsc-Fh+VhLkQE2JZeoVc=_3kniODNEhA@mail.gmail.com> <5232EB72.9050904@linux.vnet.ibm.com> <2a29ccc9-6aea-47ca-9306-4f17d7cc2fe4@DB9EHSMHS013.ehs.local>
In-Reply-To: <2a29ccc9-6aea-47ca-9306-4f17d7cc2fe4@DB9EHSMHS013.ehs.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091400-3864-0000-0000-00000A110217
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soren,

On 09/13/2013 09:53 PM, Sören Brinkmann wrote:
> Hi Preeti,
> Thanks for the explanation but now I'm a little confused. That's a lot of
> details and I'm lacking the in depth knowledge to fully understand
> everything.
> 
> Is it correct to say, that your patch series enables per cpu devices to
> be the broadcast device - for PPC?

Not really. We have a pseudo clock device, which is registered as the
broadcast device. This clock device has all the features of an external
clock device that the broadcast framework expects from a broadcast
device like !CLOCK_FEAT_C3STOP & !FEAT_PERCPU that you introduce in your
patch.

It as though we trick the broadcast framework into believing that we
have an external device, while in reality the pseudo device is just a dummy.

So if this is a pseudo device, which gets registered as the broadcast
device, how do we program it to handle broadcast events? That is where
the per cpu device steps in. It serves as the clock source to this
pseudo device. Meaning we program the per cpu device for the next
broadcast event using a hrtimer framework that we introduce, which calls
pseudo_dev->event_handler on expiry. This is nothing but the broadcast
handler.

Therefore we are able to manage broadcast without having to have an
explicit clock device for the purpose.

> And that would mean, that even though you have a per cpu device, you'd
> deliberately not set the FEAT_PERCPU flag, because on PPC a per cpu
> timer is a valid broadcast device?

No we would set the FEAT_PERCPU for the per cpu device on PPC. As I
mentioned above this is not going to be registered as the broadcast
device. We would however not set this flag for the pseudo device, that
we register as the broadcast device.

> 
> Assuming that is not going into an utterly wrong direction: How would we
> close on this one? AFAIK, ARM does not have this capability and I guess
> it won't be added. So, should I go forward with the fix proposed by
> Thomas? Should we rename the FEAT_PERCPU flag to something else, given
> that PPC may use per cpu devices for broadcasting and the sole usage of
> that flag is to prevent such a device from becoming the broadcast device?

You can go ahead with this fix because as explained above, when we
register a broadcast device we use a pseudo device which has the
features that the broadcast framework approves. The per cpu device does
not register itself with the broadcast framework. It merely programs
itself for the next broadcast event. Hence this fix will not hinder the
broadcast support on PPC.
> 
> 	Thanks,
> 	Sören
> 
> 
Regards
Preeti U Murthy

