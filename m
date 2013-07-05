Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721Ab3GEAlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 20:41:04 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:45878 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933311Ab3GEAlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 20:41:02 -0400
MIME-Version: 1.0
Date: Thu, 4 Jul 2013 20:41:00 -0400
X-Google-Sender-Auth: W0a5LY8nnPek1jgdwvJEv-G_ics
Message-ID: <CAMfhd9XWfp420M9wF-ACya9hbQGUSkneRB6sry9=nj1KtB_ygw@mail.gmail.com>
Subject: ACPI errors from TPM PPI
From: Adam Langley <agl@imperialviolet.org>
To: xiaoyan.zhang@intel.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All TPM PPI calls appear to result in ACPI errors for me:

# cat /sys/devices/pnp0/00:09/ppi/version
cat: version: Cannot allocate memory

(All the nodes in that directory have the same result for read and write.)

This appears to be coming from acpi_evaluate_object_typed in
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/char/tpm/tpm_ppi.c#n75,
so I added a printk to get the actual value of |status| when it fails
and it's 5 (aka AE_NOT_FOUND I believe).

My knowledge of ACPI is almost nil, but here's some disassembly from
the DSDT table (I don't know if that's the right one), where it
doesn't seem impossible that it could return the string "1.2".

Scope (_SB.PCI0.LPCB.TPM)
{
 OperationRegion (TSMI, SystemIO, SMIT, 0x02)
 Field (TSMI, ByteAcc, NoLock, Preserve)
 {
  INQ,    8,
  DAT,    8
 }

 Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
 {
  If (LEqual (Arg0, Buffer (0x10)
   {
       /* 0000 */   0xA6, 0xFA, 0xDD, 0x3D, 0x1B, 0x36, 0xB4, 0x4E,
       /* 0008 */   0xA4, 0x24, 0x8D, 0x10, 0x08, 0x9D, 0x16, 0x53
   }))
  {
   Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
   Store (ToInteger (Arg2), _T_0)
   If (LEqual (_T_0, Zero))
   {
    Return (Buffer (0x02)
    {
     0xFF, 0x01
    })
   }
   Else
   {
    If (LEqual (_T_0, One))
    {
     Return ("1.2")
    }
    Else
    {
     If (LEqual (_T_0, 0x02))
     {
      ToInteger (DerefOf (Index (Arg3, Zero)), TMF2)
      Store (0x12, TMF1)
      Store (TMF1, DAT)
      Store (OFST, INQ)
      If (LEqual (DAT, 0xFF))
      {
       Return (0x02)
      }
...

# tpm_version
  TPM 1.2 Version Info:
  Chip Version:        1.2.3.69
  Spec Level:          2
  Errata Revision:     3
  TPM Vendor ID:       WEC
  TPM Version:         01010000
  Manufacturer Info:   57454300

The motherboard is an Intel DQ77KB.

Any hints would be very helpful because I'm stuck at this point.

Here's how I got here:

1) I want to store 32 bytes of data in a such a way that they can be
safely erased in the future. With log-structured filesystems and SSDs,
that seems quite hard these days.

2) Using NVRAM looks like it might be fruitful and the TPM has some
designed to be written to, as opposed to the RTC NVRAM, which seems
dangerous.

3) The TPM appears to want a physical presence signal before it'll let
me create a new NVRAM area:

# tpm_nvdefine -s 32 -i 0x10000002 -p WRITEALL
Tspi_NV_DefineSpace failed: 0x0000002d - layer=tpm, code=002d (45),
Bad physical presence value

# sudo tpm_setpresence -z
Physical Presence Status:
Command Enable: true
Hardware Enable: false
Lifetime Lock: true
Physical Presence: false
Lock: true

# sudo tpm_setpresence -z -a
Tspi_TPM_SetStatus failed: 0x00002006 - layer=tcs, code=0006 (6), Not
implemented

There's nothing that I can find in the BIOS to assert presence but I'm
led to understand the the PPI interface allows one to request that the
BIOS assert physical presence:

http://www.trustedcomputinggroup.org/resources/tcg_physical_presence_interface_specification

4) So I'm trying to get the ppi driver to do something.


Cheers

AGL

--
Adam Langley agl@imperialviolet.org http://www.imperialviolet.org
