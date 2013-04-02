Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab3DBPyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:54:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324Ab3DBPye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:54:34 -0400
Date: Tue, 2 Apr 2013 11:53:44 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Young <sean@mess.org>
Cc: tkil@scrye.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Stable kernel 3.8.4/3.9-rc3 breaks PNP serial port
Message-ID: <20130402155344.GA29980@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We've had a report [1] that the 3.8.4 stable kernel makes a PNP serial
port stop working.  After testing 3.8.3, the reporter narrowed it down
to stable commit eec98f82c637 (tty/8250_pnp: serial port detection
regression since v3.7) (upstream commit 77e372a3d82).  Reverting that
single commit from 3.8.5 allows the serial port to continue working.

The machine in question is using an AMI UEFI implementation as the
firmware, and on 3.8.3 the serial port has the following in
/sys/bus/pnp/devices/00:0a/resources

	state = active
	io disabled
	irq 4
	dma disabled

With 3.8.[45], the same file has:

	state = disabled
	io disabled
	irq 4
	dma disabled

In both cases, the io and dma resources are disabled, and an IRQ is
assigned.  However, the state remains active for the port on 3.8.3.

The offending commit mentions this is a BIOS bug from InsydeH2O and that
the port is bogus in that case, but we have something similar here with
an AMI UEFI implementation (Version: 0406 Release Date: 06/06/2012)
where the port isn't bogus.

I'm not sure exactly what the solution should be here.  Any thoughts?

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=928246
