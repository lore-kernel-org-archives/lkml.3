Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaL2Uet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 15:34:49 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:58046 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaL2Uer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 15:34:47 -0500
Message-ID: <54A1BAEE.6000101@landley.net>
Date: Mon, 29 Dec 2014 14:34:54 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Christophe Fillot <cf@utc.fr>
CC: linux-ima-user@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-ima-user] Initramfs and IMA Appraisal
References: <5463ABC8.10308@utc.fr>	 <1415827252.18773.33.camel@dhcp-9-2-203-236.watson.ibm.com>	 <547617AF.6000604@utc.fr>	 <1417039941.26016.46.camel@dhcp-9-2-203-236.watson.ibm.com>	 <5476EBAC.8090103@utc.fr> <1419860736.14143.13.camel@dhcp-9-2-203-236.watson.ibm.com>
In-Reply-To: <1419860736.14143.13.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2014 07:45 AM, Mimi Zohar wrote:
> On Thu, 2014-11-27 at 10:15 +0100, Christophe Fillot wrote:
>>>
>>> Are you using an initrd not an initramfs?  According to
>>> Documentation/filesystems/ramfs-rootfs-initramfs.txt, "If
>> CONFIG_TMPFS
>>> is enabled, rootfs will use tmpfs instead of ramfs by default".
>>>
>> Yes, that what I thought too, but it seems that it is not really the 
>> case because of this test:
>>
>>      if (IS_ENABLED(CONFIG_TMPFS) && !saved_root_name[0] &&
>>          (!root_fs_names || strstr(root_fs_names, "tmpfs"))) {
>>          err = shmem_init();
>>          is_tmpfs = true;
>>      } else {
>>          err = init_ramfs_fs();
>>      }
> 
> [CC'ing Rob Landley, lsm, lkml]
> 
> Thanks!  "saved_root_name" is set to the boot command line "root="
> option, which in my case is the UUID.  I'm not sure why real root should
> impact the initramfs tmpfs/ramfs decision.
> 
> Unless there is a good explanation, did you want to post a patch to
> remove the test?

I added support last year, here's the start of the patch series:

  https://lkml.org/lkml/2013/6/29/101

The logic is that if you specify a fallback root via root=, then you're
not staying on rootfs (that's what root= _means_, "here is the root
filesystem the kernel is to mount over rootfs"), and thus the extra
infrastructure for tmpfs instead of ramfs is unnecessary.

I keep encountering people who set root=/dev/ram0 because they think
that means initrd (it doesn't), and then they feed in a cpio archive
(that's a third state even before you get to the ramfs/tmpfs
distinction), and they always want to change the code to make what they
asked it to do not be crazy...

Possibly the documentation needs to elaborate, but I expect what we
really need is a CONFIG_VERBOSE_ROOT_SETUP that sticks in a bunch of
printfs so the /dev/console output explains what it's doing. ("could not
exec /init out of initramfs (errno %d, file %s), falling back to
root=\nAdd blather=1 to kernel cmdline to see cpio
filenames/permissions.", and so on. Where "actual exec" shows where your
dynamic linker is when that's what wasn't there.)

Rob
