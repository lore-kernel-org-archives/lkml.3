Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaIPQYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:24:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39776 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaIPQYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:24:39 -0400
Message-ID: <54186442.8020605@gmail.com>
Date: Tue, 16 Sep 2014 19:24:34 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <boaz@plexistor.com>
CC: Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvdimm@ml01.01.org
Subject: Re: [Linux-nvdimm] [PATCH v2] pmem: Initial version of persistent
 memory driver
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>	<1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>	<540F2977.7010006@plexistor.com>	<CAPcyv4gZBdtup+DuaYL2zOhP9KcRzDAq6vLih0tbpL+abGQv-g@mail.gmail.com>	<541050E5.60502@gmail.com>	<CAPcyv4hfNX4Q75AERfF4g5MVvG82j3tXWcunWiGpBgDS2+7_1Q@mail.gmail.com>	<54108ECA.6090200@plexistor.com>	<CAPcyv4gqyiTaSJY56ZrJh05kwh9O9sXNKOz40fGu5s_=eY=U6Q@mail.gmail.com>	<54117D3A.3010305@plexistor.com>	<CAPcyv4io2P1TiXdnhQJMiWsYE5Rz+BiiAHqKZhDe5gh88PEWUA@mail.gmail.com>	<5415797A.7000700@plexistor.com> <x497g133c2x.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x497g133c2x.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 04:54 PM, Jeff Moyer wrote:
> Boaz Harrosh <boaz@plexistor.com> writes:
> 
>> On 09/11/2014 07:31 PM, Dan Williams wrote:
>> <>
>>>
>>> The point I am getting at is not requiring a priori knowledge of the
>>> physical memory map of a system.  Rather, place holder variables to
>>> enable simple dynamic discovery.
>>>
>>
>> "simple dynamic discovery" does not yet exist and when the DDR4 NvDIMM
>> will be released then we still have those DDR3 out there which will
>> not work with the new discovery, which I need to support as well.
> 
> Boaz,
> 
> Are you telling me that vendors are shipping parts that present
> themselves as E820_RAM, and that you have to manually block off the
> addresses from the kernel using the kernel command line?  If that is
> true, then that is just insane and unsupportable.  All the hardware I
> have access to:
> 1) does not present itself as normal memory and
> 2) provides some means for discovering its address and size
> 

Hi Jeff

There is one chip I have seen that is like that, yes, only the funny
thing is that we have the capacitors and all, but we don't seem to
be able to save on power loss. But it might be a bug at MB system bios
so we are investigating. But for this chip, yes we need an exclusion
at Kernel command line. I agree not very usable.

Putting that aside, Yes the two other vendors of DDR3 NvDIMM come with
their own driver that enables the chip and puts it on the buss. Then we
use a vendor supplied tool, to find the mapped physical address + size
+ unique id. We then run a script that loads pmem with this info, to
drive the chips. But with DDR3 there is no STD and each vendor has his own
discovery method. So pmem is just the generic ULD (Upper-layer-Driver) loaded
after the vendor LLD did its initial setup.

With DDR4 we will have an STD and one LLD driver will be able to discover them
from any vendor. At which time we might do a dynamic in-Kernel probe like the
SCSI core does to its ULDs when a new target is found below. But for me this
probe can just be a udev rule from user-mode and pmem can stay pure and generic.
But lets cross that bridge later. It does not change the current design, it only
adds a probe() capability to the all stack. All of the current pmem code is made
very friendly to a dynamic prob(), either from code, or via sysfs.

That said. The map= interface will always be needed because. pmem supports one
more option which is the most commonly used right now, by developers: The emulation
of pmem with RAM. In such a usage a developer puts a memmap=nn@ss at Kernel command-line
and a map=nn@ss on pmem comand-line and he can test and use code just as with real
pmem, only of-course none persistent. This mode since it has no real device is never
dynamically discovered. And we will always want to keep this ability for pmem.
So releasing with this interface is fine because there is never a reason to not keep it.
It will be there to stay. (It is also good for exporting a pmem device to a VM, with a
VM shared memory library)

My next plan is to widen the module-param interface to enable 
hotplug/hotremove/hotexpand via the same module-params. You know how a module-param
is also a hot sysfs file. At which stage the logic is as follows:

[parameters]
map=		- exists today
   On Load      - Same as "Write"
   On read	- Will display in the nn@ss,[...] format the existing devices
   On Write	- For all specified nn@ss
		  If an existing device is found at ss, if nn is bigger then
		  current, device is dynamically expanded (shrinking not aloud).
		  If no device exist at ss then one is added of nn size, provided
		  that there is no overlap with an existing device.
		  Any existing devices which are not specified are HOTREMOVED

  At this point we support everything but it is not very udev friendly so have
  two more

add= 		- New
   On Load      - Ignored
   On read	- empty
   On Write	- For all specified nn@ss 
		  If an existing device is found at ss, if nn is bigger then
                  current device it is dynamically expanded ((shrinking not aloud)
		  If no device exist at ss then one is created of nn size, provided
		  that there is no overlap with an existing device.

Remove= 	- New
   On Load      - Ignored
   On read	- empty
   On Write	- For all specified nn@ss:
		  if an existing device exactly matches nn@ss it is HOTREMOVED

  An HOTREMOVED is only allowed when device ref-count is 1, that is no open files.
  (Or mounted filesystems)

With such interface we can probe new devices from udev and keep pmem completely
generic, and vendor/ARCH agnostic. It can also be used with none DDR pcie devices.

If later we want in-kernel probe we will need an NvM-core which a pmem ULD registers
with. Then any Vendor LLD triggers core which will call all registered ULDs until
a type match is found. Same as SCSI.
But for me that registering core can just be udev in user-mode. Again we do not
have to decide now. Current pmem code is very friendly to an in kernel probe() when
such a probe will exist.

NOTE: There are 3 more possible ULDs for an NvM-core pmem is only type1
	type1 - All memory always mapped (pmem.ko)
	type2 - Reads always mapped writes are slow and need IO like flash
		(Will need an internal bcache and COW of write pages)
	type3 - Bigger internal nvm/flash with only a small window mapped at any
                given time. Will need paging and remapping-da
	type4 - pmem + flash, needs specific instructions to move data from pmem
                to flash, and free pmem for reuse. (2 tier)

> Cheers,
> Jeff
> 

Thanks
Boaz

