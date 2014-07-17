Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaGQGuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:50:54 -0400
Received: from mail-we0-f195.google.com ([74.125.82.195]:34118 "EHLO
	mail-we0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaGQGuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:50:51 -0400
MIME-Version: 1.0
Reply-To: markus@gutschke.com
In-Reply-To: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
From: Markus Gutschke <markus@gutschke.com>
Date: Wed, 16 Jul 2014 23:50:28 -0700
X-Google-Sender-Auth: bUrHwiuvNWtagGiFuEZjyu5R94M
Message-ID: <CALGCz1oYYkKp1frPF4vExiwqW=euYY8An+Yum4U-qsBc5NyjFg@mail.gmail.com>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
To: linux-kernel@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the reviewers of the faulty change list to the cc list for this
e-mail. I hope that is considered proper etiquette for the LKML.

On Tue, Jul 15, 2014 at 6:51 PM, Markus Gutschke <markus@gutschke.com> wrote:
> My Dell M4400 has been pretty well-supported by Linux a couple of
> years now, but recent 3.16-rcX cause hard crashes when resuming from
> Suspend-to-RAM.
>
> This is tricky to debug, as device drivers are not yet restored by the
> time that the crash happens. So, I can't use Page-UP to scroll the
> screen and see the full crash information. I also cannot use the
> netconsole; the ethernet device is still suspended. For similar
> reasons, crash kernels don't seem to work either.
>
> After about a day of false starts and a lengthy bi-secting session, I
> finally narrowed things down to this change list:
>
> eec15edbb0e14485998635ea7c62e30911b465f0 is the first bad commit
> commit eec15edbb0e14485998635ea7c62e30911b465f0
> Author: Zhang Rui <rui.zhang@intel.com>
> Date:   Fri May 30 04:23:01 2014 +0200
>
>     ACPI / PNP: use device ID list for PNPACPI device enumeration
>
>     ACPI can be used to enumerate PNP devices, but the code does not
>     handle this in the right way currently.  Namely, if an ACPI device
>     object
>      1. Has a _CRS method,
>      2. Has an identification of
>         "three capital characters followed by four hex digits",
>      3. Is not in the excluded IDs list,
>     it will be enumerated to PNP bus (that is, a PNP device object will
>     be create for it).  This means that, actually, the PNP bus type is
>     used as the default bus type for enumerating _HID devices in ACPI.
>
>     However, more and more _HID devices need to be enumerated to the
>     platform bus instead (that is, platform device objects need to be
>     created for them).  As a result, the device ID list in acpi_platform.c
>     is used to enforce creating platform device objects rather than PNP
>     device objects for matching devices.  That list has been continuously
>     growing recently, unfortunately, and it is pretty much guaranteed to
>     grow even more in the future.
>
>     To address that problem it is better to enumerate _HID devices
>     as platform devices by default.  To this end, change the way of
>     enumerating PNP devices by adding a PNP ACPI scan handler that
>     will use a device ID list to create PNP devices for the ACPI
>     device objects whose device IDs are present in that list.
>
>     The initial device ID list in the PNP ACPI scan handler contains
>     all of the pnp_device_id strings from all the existing PNP drivers,
>     so this change should be transparent to the PNP core and all of the
>     PNP drivers.  Still, in the future it should be possible to reduce
>     its size by converting PNP drivers that need not be PNP for any
>     technical reasons into platform drivers.
>
>     Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>     [rjw: Rewrote the changelog, modified the PNP ACPI scan handler code]
>     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>
> :040000 040000 b7c07232aa46ae7b6faf9a907fb7274a02e4680fc2e05b31a61dccd087c554adecc89a43a1ed81f7
> M drivers
> :040000 040000 4eda970292fffbeebe167f9210502527df4e8ab421e9e6fd84c780a34bf3d48b5e7618b551da3b1a
> M include
>
> I took a photo of the crash. It feels silly to do, but I couldn't
> think of a better solution. You can find it at
> https://drive.google.com/file/d/0B8SxqKDe4hyheTlTLXY2YThkMXM
>
> As I mentioned earlier, a bunch of information has already scrolled
> off the screen, but hopefully what is visible is somewhat helpful.
>
> I will have only limited internet access the next couple of weeks. But
> I wanted to make sure I at least got the result of the bisection out
> to LKML. I will make every best effort to collect additional data, if
> asked to do so; but some of it might be delayed for a little bit,
> until I can get access to reasonably powerful hardware or reasonably
> fast internet.
>
>
> Markus
>
> P.S.: Please keep me cc'd on all responses, as I am not subscribed to
> the firehose that is LKML.
