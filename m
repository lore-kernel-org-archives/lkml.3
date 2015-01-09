Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbbAIEGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 23:06:53 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:45240 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbbAIEGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 23:06:51 -0500
Date: Thu, 8 Jan 2015 20:06:47 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [BUG] drm/i915: backlight off after resume
Message-ID: <20150109040647.GA1355@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jani, all,

On a Lenovo X1 Carbon if the display is off when suspend is entered
it will be off when it is resumed.  A key must be pressed to restore
normal brightness.

  xset dpms force off
  sleep 1
  sudo systemctl suspend
  (resume)
  (screen off, press any key)

The behavior I am accustomed to is for it to resume with the screen on.
All of my other machines behave this way and the X1 Carbon behaved this
way in the past.

I performed a bisect and found that the following commit introduced the
problem.

  From 6dda730e55f412a6dfb181cae6784822ba463847 Mon Sep 17 00:00:00 2001
  From: Jani Nikula <jani.nikula@intel.com>
  Date: Tue, 24 Jun 2014 18:27:40 +0300
  Subject: [PATCH] drm/i915: respect the VBT minimum backlight brightness
  
  Historically we've exposed the full backlight PWM duty cycle range to
  the userspace, in the name of "mechanism, not policy". However, it turns
  out there are both panels and board designs where there is a minimum
  duty cycle that is required for proper operation. The minimum duty cycle
  is available in the VBT.
  
  The backlight class sysfs interface does not make any promises to the
  userspace about the physical meaning of the range
  0..max_brightness. Specifically there is no guarantee that 0 means off;
  indeed for acpi_backlight 0 usually is not off, but the minimum
  acceptable value.
  
  Respect the minimum backlight, and expose the range acceptable to the
  hardware as 0..max_brightness to the userspace via the backlight class
  device; 0 means the minimum acceptable enabled value. To switch off the
  backlight, the user must disable the encoder.
  
  As a side effect, make the backlight class device max brightness and
  physical PWM modulation frequency (i.e. max duty cycle)
  independent. This allows a follow-up patch to virtualize the max value
  exposed to the userspace.
  
  Signed-off-by: Jani Nikula <jani.nikula@intel.com>
  Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
  [danvet: s/BUG_ON/WARN_ON/]
  Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

-- 
- Jeremiah Mahler
