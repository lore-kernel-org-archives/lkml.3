Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3I0XTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 19:19:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:46142 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab3I0XTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 19:19:37 -0400
Message-ID: <1380323960.27811.67.camel@pasglop>
Subject: Re: Please revert 928bea964827d7824b548c1f8e06eccbbc4d0d7d
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sat, 28 Sep 2013 09:19:20 +1000
In-Reply-To: <CAE9FiQWm7ALPO5k_2nV+fuZw4oNNiw+_PEx8EWkb52ymN+EYUg@mail.gmail.com>
References: <1380270519.27811.10.camel@pasglop>
	 <CAE9FiQVkW7d7vFx_kPJG-FEvO71SZjZmpR+dnwVm61wkYK=0YA@mail.gmail.com>
	 <CA+55aFyDfMdAeaniQwkoeW6F-xd3JxrzGYwtFb6N9+NA6aRCMg@mail.gmail.com>
	 <1380318405.27811.37.camel@pasglop>
	 <CAE9FiQXXvkfTak6oEpUog_RYs_Gwpdji7N5UJ=R11Q61==N97A@mail.gmail.com>
	 <1380321480.27811.53.camel@pasglop>
	 <CAE9FiQWm7ALPO5k_2nV+fuZw4oNNiw+_PEx8EWkb52ymN+EYUg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-27 at 15:56 -0700, Yinghai Lu wrote:

> ok, please if you are ok attached one instead. It will print some warning about
> driver skipping pci_set_master, so we can catch more problem with drivers.

Except that the message is pretty cryptic :-) Especially since the
driver causing the message to be printed is not the one that did
the mistake in the first place, it's the next one coming up that
trips the warning.

In any case, the root cause is indeed the PCIe port driver:

We don't have ACPI, so pcie_port_platform_notify() isn't implemented,
and pcie_ports_auto is true, so we end up with capabilities set to 0.

Thus the port driver bails out before calling pci_set_master(). The fix
is to call pci_set_master() unconditionally. However that lead me to
find to a few interesting oddities in that port driver code:

 - If capabilities is 0, it returns after enabling the device and
doesn't disable it. But if it fails for any other reason later on (such
as failing to enable interrupts), it *will* disable the device. This is
inconsistent. In fact, if it had disabled the device as a result of the
0 capabilities, the problem would also not have happened (the subsequent
enable_bridge done by the e1000e driver would have done the right
thing). I've tested "fixing" that instead of moving the set_master call
and it fixes my problem as well.

 - In get_port_device_capability(), all capabilities are gated by a
combination of the bit in cap_mask and a corresponding HW check of
the presence of the relevant PCIe capability or similar... except
for the VC one, which is solely read from the HW capability. That means
that the platform pcie_port_platform_notify() has no ability to prevent
the VC capability (so if I have a broken bridge that advertises it but
my platform wants to block it, it can't).

 - I am quite nervous with the PCIe port driver disabling bridges. I
understand the intent but what if that bridge has some system device
behind it ? Something you don't even know about (used by ACPI, behind an
ISA bridge for example ?).

I think disabling bridges is a VERY risky proposition at all times
(including during PM) and I don't think the port driver should do it.

Maybe a more robust approach would be to detect one way or another that
the bridge was already enabled and only disable it if it wasn't or
something along those lines (ie ,restore it in the state it was)...

This is not my problem right now of course (in my case the bridge was
disabled to begin with) but I have a long experience with system stuff
hiding behind bridges and the code as it is written makes me a bit
nervous.

Cheers,
Ben.

