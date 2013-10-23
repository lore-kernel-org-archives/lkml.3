Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3JWNVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:21:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48864 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3JWNVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:21:36 -0400
MIME-Version: 1.0
In-Reply-To: <5267BAE7.2090300@redhat.com>
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>
	<1382304926-1641-2-git-send-email-prarit@redhat.com>
	<CACVXFVO_bbYsRRgZ+MfVKf5=VRNy=O3VUg0mh2fumEi7cObuiw@mail.gmail.com>
	<5265A9A4.2000100@redhat.com>
	<CACVXFVM7eKA2m+ten5-1EYNdJkc5SuZy2cimpH9j94OOdsb9Uw@mail.gmail.com>
	<526706FC.2070105@redhat.com>
	<CACVXFVMmp3gOpfEtjQ-fO62=RY+7_ZJ11UW89GXDPNKE61+keg@mail.gmail.com>
	<5267A6CA.1000505@redhat.com>
	<5267BAE7.2090300@redhat.com>
Date: Wed, 23 Oct 2013 21:21:33 +0800
Message-ID: <CACVXFVPSyNu6rUuDrqT2YZVucSgyeDN_toS-Y+WoT7Ye15iGRA@mail.gmail.com>
Subject: Re: [PATCH 1/2] firmware, fix request_firmware_nowait() freeze with
 no uevent
From: Ming Lei <ming.lei@canonical.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        tigran@aivazian.fsnet.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 8:02 PM, Prarit Bhargava <prarit@redhat.com> wrote:

>
> After all this I completely forgot the problem I'm trying to solve here.  The
> issue is that with HOTPLUG & request_microcode_nowait(), if the microcode image
> is not found (that is the file is not found on disk), then EACH cpu waits 1
> minute and it takes 2 hours for a 120 cpu box to load the microcode module.
>
> Which is terrible... so HOTPLUG doesn't work here.
>
> Let me back up Ming and see if you have a better solution for me.  I have a
> system that does not have the x86 microcode loaded on disk.  I use the microcode
> module which calls request_firmware_nowait() to load the microcode image and I
> want it done as fast as possible.  The microcode loader does not have a uevent
> so I'm not waiting on userspace for completion.
>
> How do I avoid the 60 second delay/cpu introduced in the microcode path?  I
> don't see one.  If I use HOTPLUG I'm waiting 60 seconds.  If I use NOHOTPLUG
> AFAICT the loading function never will return.  AFAICT the same issue arises
> with the dell_rbu code -- it appears to never load the dell_rbu firmware.

As I said, the 60 second delay is from udev, so that is the root cause.

There are some workarounds for your reference:

- fix udev

- disable CONFIG_FW_LOADER_USER_HELPER if you are sure
the microcode image is under the default firmware search paths, which
are defined in drivers/base/firmware_class.c

- fake a empty latest microcode image under your firmware path

- use request_firmware_nowait(HOTPLUG) to request firmware from
user space, and apply the microcode at a appropriate time after the
request is completed, and the approach is what we are discussing.


Thanks,
--
Ming Lei
