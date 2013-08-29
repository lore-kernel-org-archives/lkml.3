Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab3H2SGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:06:34 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:61550 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab3H2SGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:06:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130829171852.GB5538@xanatos>
References: <20130821184042.GC3577@xanatos>
	<CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
	<20130822004514.GB19747@xanatos>
	<CAODwPW99gLBtNQD=UyPq9DqY0TtNubR_7e+FymkfO5u2+et++Q@mail.gmail.com>
	<A2CA0424C0A6F04399FB9E1CD98E030458DEC6BC@US01WEMBX2.internal.synopsys.com>
	<20130826191411.GG5112@xanatos>
	<A2CA0424C0A6F04399FB9E1CD98E030458DED818@US01WEMBX2.internal.synopsys.com>
	<20130828215142.GJ26483@xanatos>
	<A2CA0424C0A6F04399FB9E1CD98E030458DEE7A3@US01WEMBX2.internal.synopsys.com>
	<CAODwPW_nPvS3Y9J2J9nU49uuDSB0kVirnKTF7HejfcYJEhgsUw@mail.gmail.com>
	<20130829171852.GB5538@xanatos>
Date: Thu, 29 Aug 2013 11:06:30 -0700
X-Google-Sender-Auth: tfp-mmn-NfS24E0-mgMYGqrw-G4
Message-ID: <CAODwPW9inceudHq9L7JB60q+g91UFxqtdpiS7T6PWvwS7RwA4g@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>,
        Josh Triplett <josh.triplett@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you take a look at Table
> 13: BESL/HIRD Encoding from the xHCI spec version including errata to
> 08/14/2012

Could you please provide a link to that errata? I still cannot find
it... but from your explanation, that design decision sounds pretty
horrible. Why didn't they just choose not to set old HLC flag in BESL
controllers? Seems like the only purpose it provides there is to make
old drivers break.

Anyway, looks like we are stuck with it now, and need to deal with
those mislabeled DWC3 versions. I agree with you that we should
blacklist instead of whitelist, but I don't think the device tree is
the best place to put that... we would have to figure out the exact
DWC3 version for every processor/SoC dtsi file to determine if they
are affected, and remember to keep that up to date as we added more.

I would instead propose to check for the revision register directly in
the DWC3 stack. I think I could add a little check to dwc3_host_init()
and hack the quirk bit into the newly created XHCI controller instance
if required. However, I only have an old (unaffected) 1.85 controller
for testing, so I would need Synopsys to provide me with the exact
revision numbers affected (as read from the register) and to test the
change for us.

Also, do we want to make it an XHCI_DISABLE_USB2_LPM or a
XHCI_FORCE_USB2_BESL quirk? Assuming their BESL implementation is
otherwise correct except for omitting that bit, the latter one should
make those controllers work better.
