Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbaE2NKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:10:44 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:47673 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbaE2NKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:10:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140529125910.GE14570@redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
	<20140527030058.GB2372@darkstar.nay.redhat.com>
	<CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
	<20140528020935.GB2820@darkstar.nay.redhat.com>
	<20140528145140.GN14863@redhat.com>
	<CAL01qpsb5_Gh31uqm7yB6HP2rKQkhFWWTu+U4JAR54XR5bfbZw@mail.gmail.com>
	<20140529125910.GE14570@redhat.com>
Date: Thu, 29 May 2014 14:10:41 +0100
Message-ID: <CAL01qpuNS0u89gaR9pCKUoCVRkADhPO4mZueEyK8nP84=OfDaA@mail.gmail.com>
Subject: Re: [PATCH] export efi.flags to sysfs
From: "Fleming, Matt" <matt.fleming@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2014 13:59, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Only second kernel boots with "noefi" and this parameter is appened by
> kexec-tools to second kernel command line. So first kernel will still
> boot *without noefi* and kexec-tools wil think that this system support
> booting second kernel with UEFI enabled.
>
> I don't know if we export /sys/firmware/efi/runtime-map/ in case of
> non 1:1 mapping or not. Dave and Boris will know better.

Looking at the code the answer is: yes. I think that's the bug right there.

By exporting entries in /sys/firmware/efi/runtime-map we're saying
"These mappings persist across kexec, you can trust that they won't
change", for SGI UV (which currently uses the quirk) or if you boot
with efi=old_map on the command line, that's simply not true.

So, it would seem to me that we're missing a "if
(efi_enabled(OLD_MAP))" in drivers/firmware/efi/runtime-map.c.
Borislav, Dave? What do you guys think?

This is all assuming that the root of the regression is that
kexec-tools sees entries in /sys/firmware/efi/runtime-map/ and says
"Yay! EFI boot!".
