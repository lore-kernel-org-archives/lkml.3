Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaDYJUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:20:35 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:45371 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaDYJU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:20:28 -0400
Date: Fri, 25 Apr 2014 11:19:59 +0200
From: Johan Hovold <jhovold@gmail.com>
To: xiao jin <jin.xiao@intel.com>
Cc: jhovold@gmail.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, juan.zou@intel.com,
        yanmin.zhang@intel.com, david.a.cohen@linux.intel.com,
        "Zhang, Qi1" <qi1.zhang@intel.com>
Subject: Re: [PATCH] usb_wwan: some improvement on write and resume
Message-ID: <20140425091959.GC2206@localhost>
References: <1398387435-13829-1-git-send-email-jin.xiao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398387435-13829-1-git-send-email-jin.xiao@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 08:57:15AM +0800, xiao jin wrote:
> When enable usb serial for modem data, sometimes the tty is blocked
> in tty_wait_until_sent because portdata->out_busy always is set and
> have no chance to be cleared.
>
> We have found two scenarios lead to portdata->out_busy problem.
> 1. usb_wwan_write set portdata->out_busy firstly, then try autopm
> async with error. No out urb submit and no usb_wwan_outdat_callback
> to this write, portdata->out_busy can't be cleared.
> 2. usb_wwan_resume run play_delayed() and spin_unlock, but
> intfdata->suspended still is not set to zero. At this time
> usb_wwan_write is called and anchor the urb to delay list. Then resume
> keep running but the delayed urb have no chance to be commit until next
> resume. If the time of next resume is far away, tty will be blocked
> in tty_wait_until_sent during time.

First of all, good catch of both of these issues.

They are however two distinct bugs and should be fixed separately. Could
you split the fixes into two patches and resubmit?

Please also include a more descriptive subject line for each patch, for
example:

	"USB: usb_wwan: fix urb leak in write error path"
	"USB: usb_wwan: fix race between write and resume"

You should probably point out that the write-resume race could also lead
to writes being reordered in the description of that patch.

> The patch make some enhancement on write and resume.
> 1. clear portdata->out_busy if usb_wwan_write try autopm async with
> error.
> 2. put play_Delayed and intfdata->suspended together in the spinlock,
> it's to avoid the write race during resume.

As I mentioned in the cdc-acm PM thread, there are a few more issues
with autosuspend in usb-serial so I'll include your patches in a
series that I'm preparing. Some other stuff got in the way this week,
but hopefully I'll find the time to finish it this week.

Thanks,
Johan
