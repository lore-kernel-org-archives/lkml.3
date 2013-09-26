Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3IZBnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:43:50 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55065 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3IZBnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:43:46 -0400
Date: Thu, 26 Sep 2013 09:44:12 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Ben Jencks <ben@bjencks.net>, Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>
Subject: Re: [PATCH v3 4/4] thinkpad-acpi: fix handle locate for video and
 query of _BCL
Message-ID: <20130926014411.GA14158@aaronlu.linux.com>
References: <1380016052-15315-1-git-send-email-aaron.lu@intel.com>
 <1380016052-15315-5-git-send-email-aaron.lu@intel.com>
 <20130925195839.GB23810@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925195839.GB23810@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 04:58:39PM -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 24 Sep 2013, Aaron Lu wrote:
> > locate handle for ACPI video by HID, the problem is, ACPI video node
> > doesn't really have HID defined(i.e. no _HID control method is defined
> 
> ACPI video is supposed to attach a virtual HID node (ACPI_VIDEO_HID) to ACPI
> video devices so as to keep the non-trivial video device detection logic in
> just one place instead of reinventing the wheel in every driver (which is
> always a recipe for disaster).
> 
> When did that break?

I checked the git log for the commit to use tpacpi_acpi_handle_locate to
locate video controller's ACPI handle, it's:

commit 122f26726b5e16174bf8a707df14be1d93c49d62
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Mon Aug 9 23:48:18 2010 -0300

    thinkpad-acpi: find ACPI video device by synthetic HID

So I checked out that commit and found that it shouldn't work either,
since it has the same problem of the current code.

The ACPI video controller device is given an id of ACPI_VIDEO_HID, but
it's only known to Linux ACPI, not ACPICA, so the function provided by
ACPICA acpi_get_devices will not work in this case, as that function will
really check the control method of _HID under the handle, which does not
exist no matter if Linux ACPI has added an id to its device structure or
not. OTOH, the function provided by Linux ACPI acpi_device_hid will see
the added id. In a word, the add of the HID will not affect the ASL
namespace layout of the device node(thus, no _HID control method will
be added to the device node).

It seems that this problem has been found previously by:

commit ff413195e830541afeae469fc866ecd0319abd7e
Author: Alex Hung <alex.hung@canonical.com>
Date:   Tue Apr 24 16:40:52 2012 +0800

    thinkpad-acpi: fix issuing duplicated key events for brightness up/down
    
    The tp_features.bright_acpimode will not be set correctly for brightness
    control because ACPI_VIDEO_HID will not be located in ACPI. As a result,
    a duplicated key event will always be sent. acpi_video_backlight_support()
    is sufficient to detect standard ACPI brightness control.
    
    Signed-off-by: Alex Hung <alex.hung@canonical.com>
    Signed-off-by: Matthew Garrett <mjg@redhat.com>


Thanks,
Aaron
