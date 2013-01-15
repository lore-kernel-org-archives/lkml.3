Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab3AOAAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:00:47 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:62940 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab3AOAAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:00:46 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1301142108070.1351@xoschi>
References: <alpine.LNX.2.00.1301061336180.1397@xoschi>
	<CADnq5_O1GDuigxwR8eXu7f1Fsb8iqrggVwYBaiOJKOR-ighYag@mail.gmail.com>
	<alpine.LNX.2.00.1301072206530.1617@xoschi>
	<CADnq5_NEQ2cCEPEGwBhX1KP0bDn7b+Q2M=Logw1fVC67ct-gEA@mail.gmail.com>
	<alpine.LNX.2.00.1301132143310.1772@xoschi>
	<CADnq5_N+pHZ5ugCDp7EfdW7yZ-ABS3M-vk_xtUFmnqDzz9sBvg@mail.gmail.com>
	<alpine.LNX.2.00.1301142108070.1351@xoschi>
Date: Mon, 14 Jan 2013 19:00:44 -0500
Message-ID: <CADnq5_NG6-j8sA4tnu8QaUriu-9w0EJFfP-=FwbN7YiJyGYUOQ@mail.gmail.com>
Subject: Re: Regression: drm/radeon: brightness control hard system lockup
From: Alex Deucher <alexdeucher@gmail.com>
To: Eldad Zack <eldad@fogrefinery.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 3:27 PM, Eldad Zack <eldad@fogrefinery.com> wrote:
>
> On Mon, 14 Jan 2013, Alex Deucher wrote:
>> On Sun, Jan 13, 2013 at 4:00 PM, Eldad Zack <eldad@fogrefinery.com> wrote:
>> >
>> > On Mon, 7 Jan 2013, Alex Deucher wrote:
>> >> On Mon, Jan 7, 2013 at 4:33 PM, Eldad Zack <eldad@fogrefinery.com> wrote:
>> >> >
>> >> > On Mon, 7 Jan 2013, Alex Deucher wrote:
>> >> >> On Sun, Jan 6, 2013 at 7:59 AM, Eldad Zack <eldad@fogrefinery.com> wrote:
>> >> >> >
>> >> >> > Hi Alex,
>> >> >> >
>> >> >> > Commit 0ecebb9e0d14e9948e0b1529883a776758117d6f "drm/radeon: switch to a
>> >> >> > finer grained reset for evergreen" introduced a hard system lockup to my
>> >> >> > setup. I found it after bisecting, and confirmed it by reverting it on
>> >> >> > the latest mainline ( 5f243b9 ).
>> >> >> >
>> >> >> > This:
>> >> >> >
>> >> >> >    echo 7 > /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/backlight/acpi_video0/brightness
>> >> >> >
>> >> >> > Causes a hard lock-up hard, i.e. immediate freeze, without any logs.
>> >> >> >
>> >> >> > See lspci output and kernel .config below.
>> >> >> > If there's any more info I can provide, please let me know.
>> >> >>
>> >> >> Do you normally see GPU resets when changing the backlight?  Please
>> >> >> attach your dmesg output when changing the backlight with the patch
>> >> >> reverted.
>> >> >
>> >> > I see nothing. Just to make sure, I cleared the buffer, cycled through
>> >> > 0-7 a couple of hunderd times (until the flicker annoyed), but I see no
>> >> > messages at all.
>> >> > Is there any debug config I should turn on?
>> >>
>> >> Can you try adding a printk() in evergreen_asic_reset() and see if it
>> >> is somehow getting called when you change the brightness?  When you
>> >> use the apci backlight control, the radeon driver is not involved at
>> >> all.  They only way the driver would get involved is if the acpi
>> >> backlight control somehow caused the GPU to hang and then the driver
>> >> detected the hang and attempted to reset the GPU.  I don't see any
>> >> evidence of a GPU reset in your kernel log however.  Note that the
>> >> driver also registers native backlight contol.  Does that work any
>> >> better than acpi?
>> >
>> > The native backlight controls work very well. Thanks for that, I didn't
>> > even noticed that. It has finer control over brightness too.
>> >
>> > I worked out a fix for the problem, but I think it's not a proper one.
>> > What I noticed is that evergreen_gpu_soft_reset() is only ever called
>> > once on my system, at boot.
>> > Then I realized from the dmesg that neither
>> > evergreen_gpu_soft_reset_dma() nor evergreen_gpu_soft_reset_gfx() actually
>> > do anything. Both return on the first if statements there.
>> >
>> > So as far as I can tell, the difference your patch introduced is calling
>> > evergreen_mc_stop() and evergreen_mc_resume(), which somehow puts my
>> > system in some state that ACPI brightness control leads to a lock up.
>> >
>> > BTW, I don't see a GPU reset happening at all - I also tried suspend/resume
>> > and starting an OpenGL application. Do you know how I can trigger it?
>> >
>> > To fix this, I moved the GUI_ACTIVE test before evergreen_mc_stop(), but
>> > I think it just masks the issue.
>> > Patch below (against latest HEAD) just in case.
>> >
>>
>> Thanks for tracking this down.  The attached patch should fix the
>> issue properly.
>
> Thanks, I just applied it and it works as expected.
>
> Tested-by: Eldad Zack <eldad@fogrefinery.com>

Thanks!  I'll add the patch to my -fixes queue.

Alex

>
> @Paul: Thanks for the comments, will do so in the future.
>
> Cheers,
> Eldad
