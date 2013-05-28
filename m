Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab3E1VlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:41:22 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40802 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627Ab3E1VlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:41:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130528205842.GE32085@xanatos>
References: <20130524210503.GC15788@xanatos>
	<Pine.LNX.4.44L0.1305251005390.18146-100000@netrider.rowland.org>
	<CALaWCOOGEDtF1z29df2ST9kV-VpMa9VbvFK0Hh71WJG5f_pngA@mail.gmail.com>
	<20130528205842.GE32085@xanatos>
Date: Tue, 28 May 2013 14:41:18 -0700
X-Google-Sender-Auth: n6H4Mr2-tUSITEUzKCmDda4roEc
Message-ID: <CAODwPW8ynh3238T6gOVmneMqsbdR2m+wPnVLbS7c38mQxCpBSQ@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci: Disable runtime PM suspend for quirky controllers.
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Shawn Nematbakhsh <shawnn@google.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Julius Werner <jwerner@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The policy we want to achieve is to disable runtime PM iff there is a
device connected that doesn't have persist_enabled or a reset_resume()
handler and whose parent/root hub resets on resume, right? So couldn't
we remove the HCD-specific XHCI_RESET_ON_RESUME and set the (existing)
generic USB_QUIRK_RESET_RESUME on the root hub instead? Then we could
handle all of this in the USB core (during device initialization and
when changing persist_enabled through sysfs) by just checking for
udev->reset_resume on all parent hubs of the device in question (and
use pm_runtime_get/put() on said device to prevent its parents from
suspending as appropriate).
