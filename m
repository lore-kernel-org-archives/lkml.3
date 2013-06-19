Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab3FSGeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 02:34:11 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:39031 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab3FSGeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 02:34:09 -0400
Message-ID: <51C150D8.2070706@linux.vnet.ibm.com>
Date: Wed, 19 Jun 2013 12:04:00 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, keescook@chromium.org,
        cbouatmailru@gmail.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, ccross@android.com, paulus@samba.org,
        anton@samba.org, mahesh@linux.vnet.ibm.com
Subject: Re: [PATCH v4 0/8] Nvram-to-pstore
References: <20130605184756.25794.43872.stgit@aruna-ThinkPad-T420> <1822.1371622503@ale.ozlabs.ibm.com>
In-Reply-To: <1822.1371622503@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061906-2000-0000-0000-00000C8D2EA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Wednesday 19 June 2013 11:45 AM, Michael Neuling wrote:
> Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com> wrote:
>> Currently the kernel provides the contents of p-series NVRAM only as a
>> simple stream of bytes via /dev/nvram, which must be interpreted in user
>> space by the nvram command in the powerpc-utils package. This patch set
>> exploits the pstore subsystem to expose each partition in NVRAM as a
>> separate file in /dev/pstore. For instance, Oops messages will be stored
>> in a file named [dmesg-nvram-2].
>>
>> Changes from v3:
>> 	- Change filename prefix for of-config and common partition
>>
>> Changes from v2:
>> 	- Fix renaming of pstore type ids in nvram.c
>>
>> Changes from v1:
>> 	- Reduce #ifdefs by and remove forward declarations of pstore callbacks
>> 	- Handle return value of nvram_write_os_partition
>> 	- Remove empty pstore callbacks and register pstore only when pstore
>> 	  is configured
> When booted on pHyp, I see /dev/nvram but not /dev/pstore, even if I
> turn on CONFIG_PSTORE.  Is there something else I need to add?

You need to mount pstore to access the files.

# mkdir /dev/pstore
# mount -t pstore - /dev/pstore

to unmount

# umount /dev/pstore

References: http://lwn.net/Articles/421297/
Documentation/ABI/testing/pstore

>
> Should we update pseries_defconfig to include CONFIG_PSTORE (which it
> doesn't include currently)?  Maybe turn on panic/oops via
> CONFIG_PSTORE_RAM too?

Yes. We should enable CONFIG_PSTORE by default in pseries_defconfig.
We need not enable CONFIG_PSTORE_RAM for our case. Its for systems with
persistent RAM.

> Other than that, the series looks clean.  It's passes my build and boot
> tests.
>
> I've not reviewed the contents of the patches.
>
> Mikey
>
>> ---
>>
>> Aruna Balakrishnaiah (8):
>>        powerpc/pseries: Remove syslog prefix in uncompressed oops text
>>        powerpc/pseries: Add version and timestamp to oops header
>>        powerpc/pseries: Introduce generic read function to read nvram-partitions
>>        powerpc/pseries: Read/Write oops nvram partition via pstore
>>        powerpc/pseries: Read rtas partition via pstore
>>        powerpc/pseries: Distinguish between a os-partition and non-os partition
>>        powerpc/pseries: Read of-config partition via pstore
>>        powerpc/pseries: Read common partition via pstore
>>
>>
>>   arch/powerpc/platforms/pseries/nvram.c |  353 +++++++++++++++++++++++++++-----
>>   fs/pstore/inode.c                      |    9 +
>>   include/linux/pstore.h                 |    4
>>   3 files changed, 313 insertions(+), 53 deletions(-)
>>
>> -- 
>>
>> _______________________________________________
>> Linuxppc-dev mailing list
>> Linuxppc-dev@lists.ozlabs.org
>> https://lists.ozlabs.org/listinfo/linuxppc-dev
>>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>

