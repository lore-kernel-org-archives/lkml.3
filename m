Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaIYKGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:06:37 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:51118 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaIYKGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:06:36 -0400
X-Greylist: delayed 1129 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2014 06:06:35 EDT
Date: Thu, 25 Sep 2014 10:26:12 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: linux-kernel@vger.kernel.org
Subject: XT-PIC-XT-PIC in /proc/interrupts on x86
Message-ID: <alpine.LFD.2.11.1409251010080.6148@eddie.linux-mips.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 Is there a specific purpose we print "XT-PIC" for twice in 
/proc/interrupts these days on x86 (and maybe other) systems, e.g.:

           CPU0
  0:     860089    XT-PIC-XT-PIC    timer
  1:       7165    XT-PIC-XT-PIC    i8042
  2:          0    XT-PIC-XT-PIC    cascade
  3:          6    XT-PIC-XT-PIC    serial
  4:         10    XT-PIC-XT-PIC    serial
  6:          3    XT-PIC-XT-PIC    floppy
  8:          0    XT-PIC-XT-PIC    rtc0
 12:        178    XT-PIC-XT-PIC    eth0
 14:      37128    XT-PIC-XT-PIC    ide0
 15:          0    XT-PIC-XT-PIC    ide1
NMI:          0   Non-maskable interrupts
ERR:          0

?  This looks weird to me and is almost surely an artefact of code we have 
in `show_interrupts' in kernel/irq/proc.c:

	if (desc->irq_data.chip) {
		if (desc->irq_data.chip->irq_print_chip)
			desc->irq_data.chip->irq_print_chip(&desc->irq_data, p);
		else if (desc->irq_data.chip->name)
			seq_printf(p, " %8s", desc->irq_data.chip->name);
[...]
	if (desc->name)
		seq_printf(p, "-%-8s", desc->name);

with `desc->irq_data.chip->name' and `desc->name' both being "XT-PIC".  

 Wouldn't it make sense to set the latter to NULL if it was to be the same 
as the former?  I'll make a patch to implement it unless I hear a valid 
argument to the contrary.  It's redundant information after all, and 
confusing noise IMHO.

  Maciej
