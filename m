Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaAQExA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 23:53:00 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58624 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaAQEw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 23:52:59 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org
References: <1389929988.7406.18.camel@pasglop>
Date: Thu, 16 Jan 2014 20:52:46 -0800
In-Reply-To: <1389929988.7406.18.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Fri, 17 Jan 2014 14:39:48 +1100")
Message-ID: <871u07fbvl.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+a65X/yW0lfsTZOJsGOAOGgk04H9MXLzk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0022]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Spam-Relay-Country: 
Subject: Re: [Q] Why does kexec use device_shutdown rather than ubind them
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> Hi Folks !
>
> Sorry for the semi-random CC list, not sure who owns kexec nowadays. So
> we are working on a new crop of power servers for which the bootloader
> is going to be using kexec.
>
> As expected, we've been chasing a number of reliability issues mostly
> due to drivers not behaving properly, such as leaving devices DMA'ing or
> in a state that upsets the new kernel etc...
>
> So far our approach has been to fix the drivers one by one, adding the
> shutdown() method when it's missing, etc...
>
> But that lead me to wonder ... why shutdown() in the first place ? The
> semantic of shutdown() is that we are going to power the machine off. In
> some cases, that method will actively participate in the shutdown,
> powering things off, spinning disk down, etc....
>
> It doesn't have the semantic of "put the device into a clean state for a
> new driver to pick up". It's also rarely implemented.
>
> On the other hand, the remove() routine is almost everywhere, and is
> already well understood as needing to leave the device in a clean state,
> as it's often used for rmmod (often by the driver developer
> him/herself), more likely to be tested in a condition that doesn't
> involve having the machine off immediately afterward but on the contrare
> in a condition where a new driver can come and try to pick the device
> up.
>
> Additionally, remove() is also what KVM does when assigning devices to
> guest, ie, the original driver is unbound from the host, and VFIO is
> bound in its place.
>
> So we have common purpose with kexec (somewhat) and possibly common (and
> better) testing coverage with remove() than with shutdown().
>
> I plan to experiment a bit in our bootloader see if that makes a
> difference, maybe doing a first pass of unbind for anything that can be
> unbound, and shutdown for the rest.
>
> (I'll probably also sneak it a PCIe hot reset at the end but that's more
> platform specific).
>
> Any opinion ?

When I was young and kexec was a new idea and the device model was just
getting methods.  An argument was made that using remove in the reboot
path was a bad idea because it does more than is necessary so we needed
shutdown.

I wanted to use remove at the time.

There is a lot of silliness now, but my inclination is to remove
shutdown entirely and replace it with remove.  I certainly would not
have heart burn with doing so just for kexec but getting the whole
reboot path at this point would make me very happy and then we could
kill a little used rarely implemented method from the kernel.

Given that we have found emperically that flipping the bus master enable
bit to off helps enormously for stability, but doing so generically
occassionally has unfortunate consequences why not.

I think we have largely survied until now because kdump is so popular
and kdump winds up having to reinitialize devices from any random state.

But like I said I am all for reducing the burden on device driver developers.

Eric
