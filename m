Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaAQDkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 22:40:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:36135 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaAQDkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 22:40:41 -0500
Message-ID: <1389929988.7406.18.camel@pasglop>
Subject: [Q] Why does kexec use device_shutdown rather than ubind them
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org
Date: Fri, 17 Jan 2014 14:39:48 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks !

Sorry for the semi-random CC list, not sure who owns kexec nowadays. So
we are working on a new crop of power servers for which the bootloader
is going to be using kexec.

As expected, we've been chasing a number of reliability issues mostly
due to drivers not behaving properly, such as leaving devices DMA'ing or
in a state that upsets the new kernel etc...

So far our approach has been to fix the drivers one by one, adding the
shutdown() method when it's missing, etc...

But that lead me to wonder ... why shutdown() in the first place ? The
semantic of shutdown() is that we are going to power the machine off. In
some cases, that method will actively participate in the shutdown,
powering things off, spinning disk down, etc....

It doesn't have the semantic of "put the device into a clean state for a
new driver to pick up". It's also rarely implemented.

On the other hand, the remove() routine is almost everywhere, and is
already well understood as needing to leave the device in a clean state,
as it's often used for rmmod (often by the driver developer
him/herself), more likely to be tested in a condition that doesn't
involve having the machine off immediately afterward but on the contrare
in a condition where a new driver can come and try to pick the device
up.

Additionally, remove() is also what KVM does when assigning devices to
guest, ie, the original driver is unbound from the host, and VFIO is
bound in its place.

So we have common purpose with kexec (somewhat) and possibly common (and
better) testing coverage with remove() than with shutdown().

I plan to experiment a bit in our bootloader see if that makes a
difference, maybe doing a first pass of unbind for anything that can be
unbound, and shutdown for the rest.

(I'll probably also sneak it a PCIe hot reset at the end but that's more
platform specific).

Any opinion ?

Cheers,
Ben.
 

