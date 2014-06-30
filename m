Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaF3Lfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:35:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaF3Lfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:35:54 -0400
Message-ID: <53B14B78.4010500@suse.de>
Date: Mon, 30 Jun 2014 13:35:20 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Vladimir Davydov <vdavydov@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Regression in 3.15 on POWER8 with multipath SCSI
References: <20140630103058.GA17747@iris.ozlabs.ibm.com> <53B1416D.8020305@suse.de> <20140630110202.GB17747@iris.ozlabs.ibm.com>
In-Reply-To: <20140630110202.GB17747@iris.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 01:02 PM, Paul Mackerras wrote:
> On Mon, Jun 30, 2014 at 12:52:29PM +0200, Hannes Reinecke wrote:
>> On 06/30/2014 12:30 PM, Paul Mackerras wrote:
>>> I have a machine on which 3.15 usually fails to boot, and 3.14 boots
>>> every time.  The machine is a POWER8 2-socket server with 20 cores
>>> (thus 160 CPUs), 128GB of RAM, and 7 SCSI disks connected via a
>>> hardware-RAID-capable adapter which appears as two IPR controllers
>>> which are both connected to each disk.  I am booting from a disk that
>>> has Fedora 20 installed on it.
>>>
>>> After over two weeks of bisections, I can finally point to the commits
>>> that cause the problems.  The culprits are:
>>>
>>> 3e9f1be1 dm mpath: remove process_queued_ios()
>>> e8099177 dm mpath: push back requests instead of queueing
>>> bcccff93 kobject: don't block for each kobject_uevent
>>>
>>> The interesting thing is that neither e8099177 nor bcccff93 cause
>>> failures on their own, but with both commits in there are failures
>>> where the system will fail to find /home on some occasions.
>>>
>>> With 3e9f1be1 included, the system appears to be prone to a deadlock
>>> condition which typically causes the boot process to hang with this
>>> message showing:
>>>
>>> A start job is running for Monitoring of LVM2 mirror...rogress polling
>>>
>>> (with a [***     ] thing before it where the asterisks move back and
>>> forth).
>>>
>>> If I revert 63d832c3 ("dm mpath: really fix lockdep warning") ,
>>> 4cdd2ad7 ("dm mpath: fix lock order inconsistency in
>>> multipath_ioctl"), 3e9f1be1 and bcccff93, in that order, I get a
>>> kernel that will boot every time.  The first two are later commits
>>> that fix some problems with 3e9f1be1 (though not the problems I am
>>> seeing).
>>>
>>> Can anyone see any reason why e8099177 and bcccff93 would interfere
>>> with each other?
>>>
>> It might be running afoul with the 'cookie' mechanism.
>> Device-mapper is using inserting a 'cookie' with the ioctl, and listens to
>> any event containing the cookie to ensure udev has finished processing that
>> device and hence the device node is accessible. Added to this is the problem
>> that we don't have any good means of detecting any changes to device-mapper
>> devices.
>>
>> EG look at this sequence of events:
>>
>> add dm-1
>> remove dm-1
>> add dm-1
>>
>> Originally udev would pick up the event, read the details from sysfs, and
>> return control to the kernel.
>> With bcccff93 udev will _not_have a chance to read the details
>> from sysfs for 'dm-1', as anything read from sysfs relating to 'dm-1' might
>> infact refer to the _second_ 'add' event, which might be a totally different
>> device.
>> As far as I know udev doesn't have any mechanism to drop events,
>> so it'll always process all events. Assuming that the sysfs attributes it
>> reads _do_ relate to that event. If they don't things become interesting ...
>>
>> (Actually, this issue was always present, especially with multipathing.
>> multipath occasionally can become sluggish when processing events, so the
>> same might happen with it. We've tried to work around this, but never found
>> a fool-proof way of doing so).
>>
>> Adding Kay as he might have some more insight here.
>>
>> Another thing:
>> Do you run LVM on top of multipathing?
>> If so, could you setup your system with _not_ using LVM and disabling the
>> LVM service?
>
> No, I'm not using LVM, and in fact I deleted all the physical volumes
> that were on any of the disks (they were installations of other
> distros), so there are no physical or logical volumes anywhere on any
> disk.  I haven't tried disabling the LVM service completely, though.
> What would it mean if disabling the LVM service made a difference?
>
Yes. LVM integration with systemd is a science unto itself.
I'm reasonably confident with multipath, but not LVM.
Plus the fact the the LVM service apparently is waiting for 
something sort of points into that direction.

So please do disable the lvm service.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
