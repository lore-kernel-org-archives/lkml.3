Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaBYD2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:28:03 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:53234 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaBYD2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:28:00 -0500
Message-ID: <530C0DBD.6060502@gmail.com>
Date: Mon, 24 Feb 2014 21:27:57 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@vger.kernel.org>
Subject: Problem with hibernate partitions and encrypted volumes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A while ago I reported this Fedora bug:

https://bugzilla.redhat.com/show_bug.cgi?id=981841

and thought I would check on the kernel side about what the best way to 
handle the problem was.

Essentially the problem relates to the way in which the kernel stores 
the device that it uses to resume and hibernate to/from. During boot, 
dracut writes the device major/minor number of the swap partition to 
/sys/power/resume, which triggers the kernel to resume from disk if a 
valid resume image is present. If not, bootup continues normally, and 
the kernel has stashed away that major/minor pair as 
swsusp_resume_device. Later on, when you choose to hibernate the system 
and "disk" gets written to /sys/power/state, the kernel uses that device 
as the swap partition it will try to save the hibernate image to.

The problem comes in when the swap partition is on a LUKS encrypted 
volume - specifically, when there is more than one encrypted volume on 
the system. (In my case, the machine has separate encrypted /home and 
swap partitions.) Since the kernel stores the resume partition as a 
major/minor pair, it's sensitive to any change in the device ordering. 
It appears that at some point in the Fedora boot process, the device 
nodes for the encrypted volumes get torn down and re-created, and there 
is apparently no guarantee of the order in which this will occur. If the 
devices get recreated in the opposite order (for example if the swap 
partition was originally minor 1 and is now minor 2), the stored device 
ID will no longer refer to a swap partition, and the hibernate process 
discovers this and aborts.

It seems like all of this could be avoided if there was a way for 
userspace to set the device used to store the hibernate image before 
triggering hibernation. As far as I can see there is no way to change 
the device stored in swsusp_resume_device without writing to 
/sys/power/resume, which immediately tries to resume from it. That seems 
like quite a hack when one is trying to hibernate. It seems like the 
"set image device" and "resume" requests should be separated.

Any thoughts?
