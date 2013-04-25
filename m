Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab3DYUfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:35:52 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:50688 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933072Ab3DYUfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:35:50 -0400
Date: Thu, 25 Apr 2013 14:35:18 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Kay Sievers <kay@vrfy.org>, Alexander Holler <holler@ahsoftware.de>,
        LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK
 changes?
Message-ID: <20130425203518.GC31863@obsidianresearch.com>
References: <517746E4.908@linaro.org>
 <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com>
 <51774F44.2060704@linaro.org>
 <517769A9.5060308@ahsoftware.de>
 <51780348.6090202@linaro.org>
 <5178D719.2060405@ahsoftware.de>
 <5179562C.3000903@linaro.org>
 <20130425183301.GA31863@obsidianresearch.com>
 <CAPXgP13PaBqtU+MQnz6fT+B18WJP3_tqSCv+OYA5W_z6F=VWdg@mail.gmail.com>
 <517989E7.3040101@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517989E7.3040101@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 12:54:15PM -0700, John Stultz wrote:

> That said, I suspect we need RTC equivalents to the xen/kvm/vrtc
> logic in the x86 persistent_clock code before we'll be able to tear
> out the persistent_clock code (I think just cmos and efi have RTC
> drivers).

Aha! Maybe this is why my Xen servers always seem to have the wrong
time in the RTC :)

I'm not sure what is going on with Xen, my Xenserver installs have a
/sys/class/rtc/rtc0 in dom0 which is rtc_cmos (bound via a PNP device),
but the Xen platform code seem to route dom0 set_wallclock to a
hypervisor call.. So, like on normal x86, not sure why userspace and
NTP auto-sync use different code.

I have a feeling the set_wallclock method doesn't actually work,
because I have had several hard crashes on Xensever boxes over the
years and the RTC was always wrong on reboot, this suggests to me the
NTP update of the RTC via set_wallclock perhaps is not working..

Xen Folks: If xen_set_wallclock is bogus, or if using the set method
via in rtc_cmos is OK, please return -ENODEV from dom0
xen_set_wallclock and rely on the new CONFIG_RTC_SYSTOHC path for NTP
synchronization.

I wonder if arch/x86/platform/mrst/vrtc.c and rtc-mrst.c are the same
thing?

Jason
