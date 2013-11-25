Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab3KYItq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:49:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab3KYIsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:48:50 -0500
Message-Id: <20131125084659.182036023@dhcp-16-126.nay.redhat.com>
User-Agent: quilt/0.60-1
Date: Mon, 25 Nov 2013 16:46:59 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com
Subject-Prefi: [patch @num@/@total@ v4]
Subject: kexec kernel efi runtime support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the V4 for supporting kexec kernel efi runtime.
Per pervious discussion I pass the 1st kernel efi runtime mapping
via setup_data to 2nd kernel. Besides of the runtime mapping
info I also pass the fw_vendor, runtime, config table, smbios
physical address in setup_data. EFI spec mentioned fw_vendor,
runtime, config table addresses will be converted to virt address
after entering virtual mode, but we will use it as physical address
in efi_init. For smbios EFI spec did not mention about the address
updating, but during my test on a HP workstation, the bios will
convert it to Virt addr, thus pass it in setup_data as well.

For fw_vendor, runtime, config table, I export them in /sys/firmware/
efi/, smbios is already in /sys/firmware/efi/systab.

For efi runtime mapping I add a new directory /sys/firmware/efi/
runtime-map/ like below
[dave@darkstar ~]$ tree /sys/firmware/efi/runtime-map/
/sys/firmware/efi/runtime-map/
├── 0
│   ├── attribute
│   ├── num_pages
│   ├── phys_addr
│   ├── type
│   └── virt_addr
├── 1
│   ├── attribute
│   ├── num_pages
│   ├── phys_addr
│   ├── type
│   └── virt_addr
[snip]
 
kexec-tools will assemble them as setup_data and pass to 2nd kernel.
I will send userspace patches as well.

Limitation is I only write support for x86_64, test on below machines:
Lenovo thinkpad t420
Dell inspiron 14 - 3421
HP Z420 workstation
Qemu + OVMF

Please help to review the patches.

The patches are based on matt's efi master tree

Changes from v1:
add one flag in xloadflags, so kexec-tools can safely load old kernel
without efi support.
coding style fixes
function name for map phys_addr to fixed virt_addr
Add ABI documentation for sysfs files

Changes from v2:
01/09: a new patch to remove unused variables in __map_region function
       catched by Toshi Kani
09/09: a new patch to export x86 boot_params to sysfs instead of use
       debugfs files
Matt: reuse __map_region instead do same thing in another function.
      add a wrapper function efi_map_region_fixed [02/09]
      check return value of krealloc
      sysfs dir name s/efi-runtime-map/runtime-map [06/09]
      use desc_size in efi_runtime_map
      for the xloadflags defination: +&& defined(CONFIG_KEXEC)
Greg: sysfs : one file one value for fw_vendor, runtime, tables. [05/09]
      Document them in ABI testing
HPA:  Document the new xloadflag
Also there's other function cleanup and improvement for error handling.

Changes from v3:
Greg: sysfs code move to use __ATTR_RO and attr_group
Boris: comments and code alignment

Added 3 new patches below
10-print-efi-runtime-memmap.patch
  - 10/12: print only runtime ranges in case EFI_DEBUG printing
11-reserve-setup-data-late.patch
  - fix a bug of kdump kernel, move function for reserving setup data
    ranges late after parsing memmap= cmdline params because kdump kernel
    will pass exact memmap late.
12-x86-kdebugfs-use-ioremap.patch
  - fix a bug of x86/kernel/kdebugfs.c, use ioremap instead of __va for
    low mem because __va does not work for exact memmap=

--
Thanks
Dave
