Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab3GJEPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 00:15:41 -0400
Received: from mail-gg0-f169.google.com ([209.85.161.169]:35436 "EHLO
	mail-gg0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3GJEPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 00:15:40 -0400
Message-ID: <51DCDE2C.2060909@gmail.com>
Date: Tue, 09 Jul 2013 22:08:12 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>
Subject: Suspend-to-disk issue with identifying swap partition
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently ran into a problem with suspend to disk on Fedora 19, which I 
reported here:

https://bugzilla.redhat.com/show_bug.cgi?id=981841

In this case swap and /home are encrypted volumes. Essentially (from 
what I understand, correct me if I'm wrong) what happens is that when 
dracut boots up, unlocks the encrypted swap and writes the major/minor 
number of the swap partition to /sys/power/resume to try to resume from 
it, and fails as there's no hibernate image present, the kernel still 
stashes away the major/minor number of the device into 
swsusp_resume_device (see resume_store in kernel/power/hibernate.c). For 
whatever reason those dm-crypt mappings get torn down after dracut 
finishes and recreated afterwards. As it turned out, because of the 
order of the LUKS entries on the kernel command line versus the order of 
the lines in /etc/fstab, the mappings were being recreated in the 
opposite order during the main boot sequence. This resulted in that 
stored major/minor device in swsusp_resume_device now pointing at the 
/home partition instead of the swap partition. When you go to hibernate, 
it fails as obviously that device isn't a swap partition.

It seems to me that it's not a great idea to stash away major/minor 
numbers at attempted resume and try to use them later on. There's no 
guarantee that they will still point at the same device or even exist at 
all. It appears that if the resume device was never explicitly set at 
hibernate time, then the kernel will just pick a usable swap partition 
to hibernate to, but once userspace has set a resume device, there's no 
way to get the kernel to forget about that device and just auto-detect 
at hibernate time again. And if that device no longer exists or isn't a 
swap device anymore, it seems like you're pretty much screwed.

Any thoughts?
