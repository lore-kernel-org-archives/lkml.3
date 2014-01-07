Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbaAGDfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:35:52 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:53212 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaAGDfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:35:51 -0500
MIME-Version: 1.0
In-Reply-To: <20140107024050.GA8903@kroah.com>
References: <CANthSfZij7=q1azM1wrRNDWjFY972zFpe4njBKr3bzUVsm5m-Q@mail.gmail.com>
	<20140107024050.GA8903@kroah.com>
Date: Tue, 7 Jan 2014 11:35:50 +0800
Message-ID: <CANthSfb+t53BZSXGe2VUUuHRYzphuT=-3vJtCSoERF_WChUr-A@mail.gmail.com>
Subject: Re: [PATCH] usb:hub set hub->change_bits when over-current happens
From: =?UTF-8?B?5rKI5YWJ?= <shenguang10@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 10:40 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Jan 07, 2014 at 10:33:14AM +0800, 沈光 wrote:
>> set hub->change_bits when we plug in a device which causes
>> over-current condition, so that hub_events() will check it.
>
> Why?
>
> What does this solve?  Is this a bug with existing devices that needs to
> be backported to older kernels?
>
> thanks,
>
> greg k-h

This is something that we found when we are doing compliance test with xHCI.
If we enable CONFIG_USB_SUSPEND, and plug in a bad device which causes
over-current condition to the root port, the hub->change_bits will not
be set in current code in the function of hub_activate.
Then hub_events() will ignore this change, below is a code fragment of
hub_events()
                /* deal with port status changes */
                for (i = 1; i <= hub->descriptor->bNbrPorts; i++) {
                        if (test_bit(i, hub->busy_bits))
                                continue;
                        connect_change = test_bit(i, hub->change_bits);
                        wakeup_change = test_and_clear_bit(i, hub->wakeup_bits);
                        if (!test_and_clear_bit(i, hub->event_bits) &&
                                        !connect_change && !wakeup_change)
                                continue;

According to spec, software need to disable the port if there is an
over-current condition, while current code will not, since it will not
detect such condition.

but if we disable CONFIG_USB_SUSPEND, software can detect the
over-current condition. I am still checking the code to get the
reason.

-- 
Shen Guang
