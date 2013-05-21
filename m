Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3EUNjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:39:10 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:60201 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab3EUNjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:39:08 -0400
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <1369122596.4432.22.camel@ymzhang.sh.intel.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
 <CAErSpo7+AbHi_TwxwHTJunpFb=CMhwMdCni6+NjbhdA=35XhvA@mail.gmail.com>
 <CF6E51640088844D9CADE5541A7C2FEB33EBC11D@CMEXMB1.ad.emulex.com>
 <CAHrUA36OxKn1ucaA4-1jHU=4P+hCWOTVa2ECAwpxEoBWSRAv8A@mail.gmail.com> <1369122596.4432.22.camel@ymzhang.sh.intel.com>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Tue, 21 May 2013 08:38:47 -0500
Message-ID: <CAHrUA37hh9kZbheBi7oOuiM26wJOwNZX_R4TV8azoOv+Uo=eCA@mail.gmail.com>
Subject: Re: Subject : [ PATCH ] pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
To: yanmin_zhang <yanmin_zhang@linux.intel.com>
Cc: "Liu, Joseph" <Joseph.Liu@emulex.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Zhang, LongX" <longx.zhang@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 21 May 2013 02:49, Yanmin Zhang <yanmin_zhang@linux.intel.com> wrote:
> On Mon, 2013-05-20 at 10:37 -0500, Linas Vepstas wrote:

>>  My impression
>> is that maybe the AER driver had been doing not quite the right thing
>> for a long time.
> Pls. provide evidence/facts. The new patch is to facilitate device driver
> implementation. It doesn't mean current AER driver is incorrect. We need
> a tradeoff.
>
> Just like what Bjoin says, we shouldn't change error_state to pci_channel_io_normal
> before we really recover the hardware. The patch changes it just because
> drivers might call some functions to recover the devices, while such functions
> need (error_state==pci_channel_io_normal).

Perhaps we are talking past each other.  One needs to set error_state
== pci_channel_io_normal before calling slot_reset().  If the aer
driver wasn't doing this all along, then it seems like an old bug to
me.   The error_state flag indicates the status of the PCI channel,
and not the status of the attached device.  Once the channel has been
reset, the error state is "normal" even if the card itself hasn't yet
been brought up.

Whatever it is that the aer driver is doing, it should be doing
something similar to what the eeh driver is doing, in
arch/powerpc/platforms/pseries/eeh_driver.c  -- This is the "reference
implementation" -- Its known right, it was and continues to be heavily
tested, has found its way into sriov, etc.

The one thing that eeh does NOT do is to handle suspend/sleep states.
The basic design assumption back then was that no one would ever
suspend/sleep their server.  Since suspend/sleep messes with PCI
config space, then, yes, one would need to somehow save a second,
pristine copy of config space for device recovery.

-- Linas
