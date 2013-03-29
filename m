Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3C2A4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 20:56:24 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:64043 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab3C2A4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 20:56:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130328205916.GA18846@milliways>
References: <20130328010148.GB25406@milliways>
	<20130328205916.GA18846@milliways>
Date: Thu, 28 Mar 2013 17:56:21 -0700
Message-ID: <CAMHSBOVZ7w51+8B=LyNBdeqP2BEYaNMDX3_WbEzUYqjdn2FZFg@mail.gmail.com>
Subject: Re: smartd broken in 3.9.0-rc4 : bisected
From: Gwendal Grignou <gwendal@google.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My mistake.
In ata_cmd_ioctl(), we clean the results and remove CHECK_CONDITION
when necessary. I did not update that code for the new Sense Key:
                if (cmd_result & SAM_STAT_CHECK_CONDITION) {
                        struct scsi_sense_hdr sshdr;
                        scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
                                             &sshdr);
                        if (sshdr.sense_key == 0 &&
                            sshdr.asc == 0 && sshdr.ascq == 0)
                                cmd_result &= ~SAM_STAT_CHECK_CONDITION;
                }

A patch in progress.
Gwendal.

On Thu, Mar 28, 2013 at 1:59 PM, Ken Moffat <zarniwhoop@ntlworld.com> wrote:
> On Thu, Mar 28, 2013 at 01:01:48AM +0000, Ken Moffat wrote:
>
> Adding Cc:s, further details at the end.
>> Hi,
>>
>>  just tested my first 3.9 kernel today.  During boot, smartd (from
>> smartmontools-6.0) fails to start.  Works fine in 3.8.4.
>>
>>  In 3.8.4 I get messages like this :
>>
>> Mar 27 22:02:02 ac4tv smartd[3981]: smartd 6.0 2012-10-10 r3643
>> [x86_64-linux-3.8.4] (local build)
>> Mar 27 22:02:02 ac4tv smartd[3981]: Copyright (C) 2002-12, Bruce
>> Allen, Christian Franke, www.smartmontools.org
>> Mar 27 22:02:02 ac4tv smartd[3981]: Opened configuration file
>> /etc/smartd.conf
>> Mar 27 22:02:02 ac4tv smartd[3981]: Configuration file
>> /etc/smartd.conf parsed.
>> Mar 27 22:02:02 ac4tv smartd[3981]: Device: /dev/sda, opened
>> Mar 27 22:02:02 ac4tv smartd[3981]: Device: /dev/sda, WDC
>> WD5000AAKX-001CA0, S/N:WD-WMAYU6818967, WWN:5-0014ee-0ad9caed4,
>> FW:15.01H15, 500 GB
>> Mar 27 22:02:02 ac4tv smartd[3981]: Device: /dev/sda, found in
>> smartd database: Western Digital Caviar Blue Serial ATA
>> Mar 27 22:02:02 ac4tv smartd[3981]: Device: /dev/sda, enabled SMART
>> Automatic Offline Testing.
>> Mar 27 22:02:02 ac4tv smartd[3981]: Device: /dev/sda, is SMART
>> capable. Adding to "monitor" list.
>> Mar 27 22:02:02 ac4tv smartd[3981]: Monitoring 1 ATA and 0 SCSI
>> devices
>>
>>  but in 3.9.0-rc4 all I get is
>> Mar 28 00:39:32 ac4tv smartd[2487]: Copyright (C) 2002-12, Bruce
>> Allen, Christian Franke, www.smartmontools.org
>> Mar 28 00:39:32 ac4tv smartd[2487]: Opened configuration file
>> /etc/smartd.conf
>> Mar 28 00:39:32 ac4tv smartd[2487]: Configuration file
>> /etc/smartd.conf parsed.
>> Mar 28 00:39:32 ac4tv smartd[2487]: Device: /dev/sda, opened
>> Mar 28 00:39:32 ac4tv smartd[2487]: Device: /dev/sda, WDC
>> WD5000AAKX-001CA0, S/N:WD-WMAYU6818967, WWN:5-0014ee-0ad9caed4,
>> FW:15.01H15, 500 GB
>> Mar 28 00:39:32 ac4tv smartd[2487]: Device: /dev/sda, found in
>> smartd database: Western Digital Caviar Blue Serial ATA
>> Mar 28 00:39:32 ac4tv smartd[2487]: Device: /dev/sda, could not
>> enable SMART capability
>> Mar 28 00:39:32 ac4tv smartd[2487]: Unable to register ATA device
>> /dev/sda at line 1 of file /etc/smartd.conf
>> Mar 28 00:39:32 ac4tv smartd[2487]: Unable to register device
>> /dev/sda (no Directive -d removable). Exiting.
>>
>>  Using strace, in the failing version I get
>> 2643  ioctl(3, HDIO_DRIVE_CMD, 0x7fff53288a60) = -1 EIO (Input/output error)
>>
>> instead of the normal
>> 3981  ioctl(3, HDIO_DRIVE_CMD, 0x7fff04437340) = 0
>> 3981  ioctl(3, HDIO_DRIVE_TASK, 0x7fff04437350) = 0
>> 3981  ioctl(3, HDIO_DRIVE_CMD, 0x7fff04437330) = 0
>> 3981  ioctl(3, HDIO_DRIVE_CMD, 0x7fff04437330) = 0
>> 3981  ioctl(3, HDIO_DRIVE_TASK, 0x7fff04437340) = 0
>>
>>  Looks like I'll be bisecting.
>>
>> ken
>  Bisection blames :
>
> commit 84a9a8cd9d0aa93c17e5815ab8a9cc4c0a765c63
> Author: Gwendal Grignou <gwendal@google.com>
> Date:   Fri Jan 18 10:56:43 2013 -0800
>
>     [libata] Set proper SK when CK_COND is set.
>
>     When the user application sends a ATA_12 or ATA_16 PASSTHROUGH
>     scsi command, put the task file register in the sense data with the
>     proper Sense Key. Instead of NO SENSE, set RECOVERED, as
>     specified in [SAT2]12.2.5 Table 92.
>
>  That reverts cleanly from 3.9.0-rc4, and with it reverted smartd
> works again.  Obviously that does nothing to fix whatever problem
> this was supposed to fix.  I can test any follow-up patches if
> needed.
>
> ken
> --
> das eine Mal als Tragödie, das andere Mal als Farce
