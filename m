Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab3H3PTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:19:05 -0400
Received: from imap.thunk.org ([74.207.234.97]:52059 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321Ab3H3PTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:19:02 -0400
Date: Fri, 30 Aug 2013 11:18:55 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@gmail.com>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 3.10.9: EXT4-fs (sdb1): delayed block allocation failed for
 inode 163315715 at logical offset 1 with max blocks 2 with error -5
Message-ID: <20130830151855.GC30385@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@gmail.com>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <521DE3C1.8030304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521DE3C1.8030304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your SATA disk had enough errors that the ATA link was completely
reset, and the device was detached and then reattached.  As far as
kernel is concerned, it's a new device.

The problem is that the ext4 mount was for the old device, not the
newly attached device.  So attempts to read from the device is
returning errors from the block device layer.

> but later on, suddenly, without any other related message in between as far as I can see:
> 
> Aug 28 11:47:39 vostro kernel: [25874.121506] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: comm memcheck-amd64-: unable to read itable block
> Aug 28 11:47:39 vostro kernel: [25874.121510] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure

This was just the first timat the system had tried accessing the file
system, and when it tried reading from the device, it got an I/O
failure from the device pretty much immediately.  

> So kernel was trying for 10 minutes before it gave up?

I'm guessing your file system is configured with errors=continued?

> Any clues what I should look at? Few days ago memtest86+ went fine through all 16GB of RAM (Dell Vostro 3550). I do not know if the PCI/ACPI change is related or not. 

The error is happening at the block device layer.  So I don't know
whether it's caused by the table getting bumped, or something getting
confused when the device tried to enter some kind of power saving
mode, etc.

					- Ted
