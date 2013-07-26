Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab3GZR5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:57:14 -0400
Received: from www.sr71.net ([198.145.64.142]:45222 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab3GZR5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:57:10 -0400
Message-ID: <51F2B876.8050104@sr71.net>
Date: Fri, 26 Jul 2013 10:57:10 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Shane Huang <shane.huang@amd.com>
Subject: Re: SATA hotplug not detecting new disks
References: <51F1B179.4070309@sr71.net> <51F1D63A.2010403@intel.com>
In-Reply-To: <51F1D63A.2010403@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 06:51 PM, Aaron Lu wrote:
> On 07/26/2013 07:15 AM, Dave Hansen wrote:
>> I've got a relatively new system that doesn't seem to be able to hotplug
>> SATA disks.  I see the same behavior on 3.10, 3.11-rc2, and Ubuntu's
>> 3.8.0-25-generic.  The disks are detected right away on reboots, but
>> even after poking the /sys/class/scsi_host/host*/scan files, new disks
>> are never detected.  I've disabled link power management.
>>
>> Am I doing something stupid here?  I thought this "just worked" on my
>> previous hardware.
> 
> My vague memory reminds me that not all SATA ports are hot pluggable -
> you can check the port's "External SATA port" bit and "Hot Plug Capable"
> bit of the PxCMD register like this:
> 
> $ grep ahci /proc/iomem 
>     e1a40000-e1a407ff : ahci
> # dd if=/dev/mem of=ahcidump bs=4096 count=1 skip=0xe1a40
> You will need to change 0xe1a40 to decimal format.
> 
> Then the PxCMD is at offset 0x118 for port 0, check bit 21 for E-SATA or
> bit 18 for hot pluggable bits. If any of them set to 1, this port
> should be hot pluggable; otherwise, it doesn't have this capability.

That whole I/O area looks to be 0'd to me, at least for the port if I
boot with it unplugged.  I even tried toggling the PORT_CMD_ALPE bit
with powertop since it is in the same port.  Nothing seems to happen for
port0 (the one unplugged at boot), although I _can_ see the writes show
up for the other ports.

I also tried booting with a disk plugged in to a port, then put that
disk to sleep and unplugged it.  I replugged a _different_ disk in its
place, and it was detected just fine.

Is it possible that the 'ata_dummy_port_ops' are getting left in place
at boot accidentally, that we're mistaking an unplugged port for a
disabled one?
