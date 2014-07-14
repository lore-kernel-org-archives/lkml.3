Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbaGNNBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:01:13 -0400
Received: from canardo.mork.no ([148.122.252.1]:47488 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbaGNNBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:01:04 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [BISECTED 3.16-rc REGREGRESSION] backlight control stopped working
Organization: m
Date: Mon, 14 Jul 2014 14:59:44 +0200
Message-ID: <87pph8kse7.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I actually bisected this just to get

886129a8eebebec260165741fe31421482371006 is the first bad commit
commit 886129a8eebebec260165741fe31421482371006
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Tue May 6 14:46:23 2014 +0200

    ACPI / video: change acpi-video brightness_switch_enabled default to 0
    
    acpi-video is unique in that it not only generates brightness up/down
    keypresses, but also (sometimes) actively changes the brightness itself.
    
    This presents an inconsistent kernel interface to userspace, basically there
    are 2 different scenarios, depending on the laptop model:
    
     1) On some laptops a brightness up/down keypress means: show a brightness osd
     with the current brightness, iow it is a brightness has changed notification.
    
     2) Where as on (a lot of) other laptops it means a brightness up/down key was
     pressed, deal with it.
    
    Most of the desktop environments interpret any press as in scenario 2, and
    change the brightness up / down as a response to the key events, causing it
    to be changed twice, once by acpi-video and once by the DE.
    
    With the new default for video.use_native_backlight we will be moving even
    more laptops over to behaving as in scenario 2. Making the remaining laptops
    even more of a weird exception. Also note that it is hard to detect scenario
    1 properly in userspace, and AFAIK none of the DE-s deals with it.
    
    Therefor this commit changes the default of brightness_switch_enabled to 0
    making its behavior consistent with all the other backlight drivers.
    
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Reviewed-by: Aaron Lu <aaron.lu@intel.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

:040000 040000 5bbac8c4f3e9fd5421daf84289004c32c3217f2a 82c99a358bda6360f845b6063182d3e707ff90f0 M      Documentation
:040000 040000 81ed56a41130bbbea980620114ff11e3bb23ee63 a9870ba1d046bde69796060304c78dfbb1d00a1f M      drivers



The fact that this seems to be an *intentional* breakage does not help a
lot.  Yes, I understand that you believe the choice of default was
incorrect for some reason.  You might even be right about that.  But
that is still not a valid reason to break existing configurations for
end users!  Please do not do that.

Note that NO USER cares about "some laptops" or "other laptops".  They
care about their own systems, which either
 a) depend on the old default and therefore breaks with your change, or
 b) have a user modified setting and therefore are unaffected by your
    change

The above commit should be reverted.  It causes breakage for end users.

If you think the default was wrong, then please go back in time and fix
it when it was introduced. Thanks.


Bjørn
