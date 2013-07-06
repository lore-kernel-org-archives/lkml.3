Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab3GFSVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 14:21:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab3GFSVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 14:21:30 -0400
Date: Sat, 6 Jul 2013 20:21:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alexander Holler <holler@ahsoftware.de>
Cc: rtc-linux@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH 3/9 v2] rtc: rtc-hid-sensor-time: delay
 registering as rtc into a work
In-Reply-To: <51D7DB6E.9010004@ahsoftware.de>
Message-ID: <alpine.LNX.2.00.1307062020130.26857@pobox.suse.cz>
References: <1371228732-5749-4-git-send-email-holler@ahsoftware.de> <1371724776-5572-1-git-send-email-holler@ahsoftware.de> <20130626125501.3d64408309a6f63100cc7d08@linux-foundation.org> <51CB5E6B.109@ahsoftware.de> <20130626220758.GA32461@kroah.com>
 <51CB7E88.6000704@ahsoftware.de> <51D7DB6E.9010004@ahsoftware.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jul 2013, Alexander Holler wrote:

> I've now traced down why the above patch _really_ is needed: it's because of
> how the locking is done in the hid-subsystem. So my intuition to use a work
> was ok, but my assumption that it's because the HID device driver wasn't
> registered before probe() finished was wrong.
> 
> What happens without using a work is the following (shortened a lot):
> 
> hid_device_probe() // hid subsystem locks hdev->driver_input_lock
>   hid_time_probe()
>     devm_rtc_device_register() // wants to read the clock
>       hid_rtc_read_time() // submits GET_REPORT and waits for the answer
>                           // (the timestamp from the clock)
>         hid_input_report()
> 
> And there we have something like a deadlock situation because
> hid_input_report() needs hdev->driver_input_lock to submit the report to the
> HID driver.
> 
> So in short, it's currently impossible for a HID driver to read input from a
> HID device from inside it's probe function.

Please see commit c849a6143b ("HID: Separate struct hid_device's 
driver_lock into two locks"). It's done exactly in order to allow for 
receiving input inside of the probe() function of the driver.

-- 
Jiri Kosina
SUSE Labs
