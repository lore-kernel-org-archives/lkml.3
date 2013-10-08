Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3JHIG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:06:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40730 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab3JHIGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:06:54 -0400
Date: Tue, 8 Oct 2013 09:06:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>, David Airlie <airlied@linux.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131008080625.GA25034@n2100.arm.linux.org.uk>
References: <20131006082340.GA24568@localhost> <CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com> <20131007021118.GA27927@localhost> <20131007051038.GA9764@localhost> <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com> <20131007083505.GA22585@localhost> <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com> <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com> <20131008020918.GA1220@localhost> <20131008021452.GA6456@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008021452.GA6456@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 10:14:52AM +0800, Fengguang Wu wrote:
> [    2.785188] kobject: 'drm' (ffff880006dae048): kobject_release, parent ffff880000189648 (delayed)
> [    2.787362] kobject: 'drm' (ffff880006dafe00): kobject_release, parent           (null) (delayed)
> [    2.789674] [drm] radeon kernel modesetting enabled.
> [    2.791798] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
> [    2.793280] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/dri.
> [    2.795591] kobject: 'controlD64' (ffff880006dc3820): kobject_release, parent           (null) (delayed)
> [    2.797988] cirrus: probe of 0000:00:02.0 failed with error -1
> [    2.799675] usbcore: registered new interface driver udl
> [    2.802167] parport_pc 00:04: reported by Plug and Play ACPI
> [    2.803818] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
> [    2.806035] kobject: 'parport_pc.956' (ffff880006dc3820): kobject_release, parent           (null) (delayed)

Look very carefully at the above addresses of the controlD64 object and
the parport_pc.956 object.  They're both the same - and the first hasn't
been run yet.  It's a double addition because the culpret is not parport_pc,
but is controlD64 instead.

And here we have it:

int drm_put_minor(struct drm_minor **minor_p)
{
...
        drm_sysfs_device_remove(minor);
...
        kfree(minor);
}

void drm_sysfs_device_remove(struct drm_minor *minor)
{
        if (minor->kdev.parent)
                device_unregister(&minor->kdev);
        minor->kdev.parent = NULL;
}

I think David Arlie also needs a quiet talking to about how to use the
device model:

int drm_sysfs_device_add(struct drm_minor *minor)
{
        minor->kdev.release = drm_sysfs_device_release;
...
        err = device_register(&minor->kdev);
}

static void drm_sysfs_device_release(struct device *dev)
{
        memset(dev, 0, sizeof(struct device));
        return;
}

Since when has that been acceptable in a release function?
