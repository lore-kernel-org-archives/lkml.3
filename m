Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab3BZRYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:24:23 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:9629 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3BZRYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:24:21 -0500
Date: Tue, 26 Feb 2013 18:24:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Problem with commit "USB: EHCI: remove ASS/PSS polling timeout"
Message-ID: <20130226182409.046bdecd@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan, Greg,

Since kernel 3.7.7, my Hauppauge Nova-T 500 Dual DVB-T TV card stopped
working reliably. Half of the boots it will work, the other half it
won't, with different error messages. For example

dib0700: firmware download failed at 7 with -110

or

usb 2-1: device not accepting address 2, error -110
usb 2-1: new high-speed USB device number 3 using ehci_hcd
usb 2-1: device descriptor read/64, error -110
usb 2-1: device descriptor read/64, error -110
usb 2-1: new high-speed USB device number 4 using ehci_hcd
usb 2-1: device not accepting address 4, error -110
usb 2-1: new high-speed USB device number 5 using ehci_hcd
usb 2-1: device not accepting address 5, error -110
hub 2-0:1.0: unable to enumerate USB device on port 1

I bisected it and found:

269ef9f3805a5ec17ddf3dd5f13d5e09598c155b is the first bad commit
commit 269ef9f3805a5ec17ddf3dd5f13d5e09598c155b
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Fri Jan 25 16:52:45 2013 -0500

    USB: EHCI: remove ASS/PSS polling timeout
    
    commit 55bcdce8a8228223ec4d17d8ded8134ed265d2c5 upstream.
    
    This patch (as1647) attempts to work around a problem that seems to
    affect some nVidia EHCI controllers.  They sometimes take a very long
    time to turn off their async or periodic schedules.  I don't know if
    this is a result of other problems, but in any case it seems wise not
    to depend on schedule enables or disables taking effect in any
    specific length of time.
    
    The patch removes the existing 20-ms timeout for enabling and
    disabling the schedules.  The driver will now continue to poll the
    schedule state at 1-ms intervals until the controller finally decides
    to obey the most recent command issued by the driver.  Just in case
    this hides a problem, a debugging message will be logged if the
    controller takes longer than 20 polls.
    
    I don't know if this will actually fix anything, but it can't hurt.
    
    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
    Tested-by: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I am apparently not the only one complaining about this commit, for
example the following bug resulted in this commit being reverted from
all affected openSUSE kernels one week ago:
  https://bugzilla.novell.com/show_bug.cgi?id=804367

Reverting this patch on top of kernel 3.7.9 make my TV card work again.

So please revert this commit upstream as well as in 3.8 and 3.7 stable
kernel series.

As a side note, I am very curious how a commit with comment "I don't
know if this will actually fix anything" ever made it into a stable
kernel tree. I thought there were stable kernel tree rules and one of
them was "it must fix a real bug that bothers people"?

Thanks,
-- 
Jean Delvare
