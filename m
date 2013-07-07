Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3GGV62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 17:58:28 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:50009 "EHLO Ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab3GGV61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 17:58:27 -0400
Message-ID: <51D9E47B.90606@tlinx.org>
Date: Sun, 07 Jul 2013 14:58:19 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Disabling interrupt remapping seems to cause 50% drop in ethernet speed (v3.10)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seems to be a new check :


    Comments

Neil Horman <mailto:nhorman@tuxdriver.com> - April 15, 2013, 4:28 p.m.

A few years back intel published a spec update:
http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf

For the 5520 and 5500 chipsets which contained an errata (specificially errata
53), which noted that these chipsets can't properly do interrupt remapping, and
as a result the recommend that interrupt remapping be disabled in bios.  While
many vendors have a bios update to do exactly that, not all do, and of course
not all users update their bios to a level that corrects the problem.  As a
result, occasionally interrupts can arrive at a cpu even after affinity for that
interrupt has be moved, leading to lost or spurrious interrupts (usually
characterized by the message:
kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)

There have been several incidents recently of people seeing this error, and
investigation has shown that they have system for which their BIOS level is such
that this feature was not properly turned off.  As such, it would be good to
give them a reminder that their systems are vulnurable to this problem.  For
details of those that reported the problem, please see:
https://bugzilla.redhat.com/show_bug.cgi?id=887006

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Don Zickus <dzickus@redhat.com>
CC: Don Dutile <ddutile@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Asit Mallick <asit.k.mallick@intel.com>
CC: David Woodhouse <dwmw2@infradead.org>
CC: linux-pci@vger.kernel.org
CC: Joerg Roedel <joro@8bytes.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
====================

That causes a >=50% drop in receive performance on
ethernet file transfers (with the linux machine being
receiving a file)... Sending doesn't appear to be affected.

Is the above error message "No irq handler for vector" the only
error message I would see if I suffered from this bug?

I looked through message logs going back to 2012-01-27 and found 0 
of those messages.  I do have the part that that is claimed to be affected.

I've been using interrupt affinity /steering (not irqbalancing) to put
ethernet interrupts for this interface on a specific cpu, keeping
the file server for that interface on the same cpu as well as keeping
other HW interrupts off of that node.


Without the remapping, I am finding 50% or greater drop in receive speed,
yet with the remapping, I am not finding the error indicated above.

It is possible I don't see the interrupt because I don't dynamically
changed affinity after it is initialized -- dunno.  According to the
report this shouldn't be the case.  If the above error message is the
symptom, I'd think I'd see it in 2 years of logs.

Is there a way to disable this short of reverting the patch?




