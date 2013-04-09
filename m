Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936011Ab3DINqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:46:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:43459 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab3DINqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:46:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,439,1363158000"; 
   d="scan'208";a="315344389"
Date: Tue, 9 Apr 2013 15:46:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [char-misc-next 0/3 V6] Support NFC Device on MEI CL Bus
Message-ID: <20130409134621.GJ23447@zurbaran>
References: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com>
 <20130409000815.GA30420@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B01EFB6B8@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B01EFB6B8@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Tomas,

On Tue, Apr 09, 2013 at 01:12:48PM +0000, Winkler, Tomas wrote:
> > 
> > On Tue, Apr 09, 2013 at 02:41:32AM +0300, Tomas Winkler wrote:
> > > v5 -> v6
> > >  1. include/linux/uapi/mei/nfc.h - provides API also for pure
> > >     user space implementation as found under Android.
> > >  2. Removed INTEL_MEI_BUS_NFC Kconfig option.
> > >     The NFC info client is disconnected as soon as we
> > >     get the FW info and the regular client is connected only when
> > >     mei_cl_enable_device() is explicitly called from an nfc driver.
> > >     The mei cl bus now doesn't connect NFC  exclusively.
> > >  3. Added pn544 to the possibly detected NFC chipsets.
> > >
> > > Depends on:
> > > 	mei: bus: Add device enabling and disabling API
> > 
> > If this is a nfc device, why isn't it using the nfc_register_device() and
> > nfc_unregister_device() calls?  Shouldn't you be using the in-kernel nfc api
> > we already have?
The mei/nfc.c code adds a physical device to the MEI bus, the in kernel NFC
APIs will be called by the NFC driver (drivers/nfc/) itself, once probed. The
mei/nfc.c code is not an NFC driver, it is an MEI specific layer for properly
detecting the right NFC chipsets behind the ME and abstracting the MEI secific
commands for this chipset.

This code is needed because the only think that the ME tells us at boot
time is that there is an NFC related UUID there. It can be any NFC chipset
(Although right now the firmware will only support the microread and pn544
ones) and to know exactly which one it is we need to send a few commands to
the ME firmware. Once that's done, we add a device to the MEI bus with the
proper name ("pn544" or "microread"). The actual driver living under
drivers/nfc/ will be probed and then register itself against the NFC
subsystem (through the NFC in-kernel APIs).
By doing so we keep the ME related operations under drivers/misc/mei while
drivers/nfc/ only deals with NFC related stuff.

I hope this clears things up.  If it does, we can add a similar explanation to
the first patch of this patchset.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
