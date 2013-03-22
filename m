Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab3CVAvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:51:37 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:41424 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3CVAve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:51:34 -0400
Message-ID: <514BAB13.3000101@gmail.com>
Date: Thu, 21 Mar 2013 18:51:31 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Myron Stowe <myron.stowe@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org, yuxiangl@marvell.com,
        yxlraid@gmail.com, greg@kroah.com, alex.williamson@redhat.com,
        kay@vrfy.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] PCI: Handle device quirks when accessing sysfs resource<N>
 entries
References: <20130321043449.7229.81056.stgit@amt.stowe> <20130321043502.7229.43877.stgit@amt.stowe>
In-Reply-To: <20130321043502.7229.43877.stgit@amt.stowe>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 10:35 PM, Myron Stowe wrote:
> Sysfs includes entries to memory regions that back a PCI device's BARs.
> The pci-sysfs entries backing I/O Port BARs can be accessed by userspace,
> providing direct access to the device's registers.  File permissions
> prevent random users from accessing the device's registers through these
> files, but don't stop a privileged app that chooses to ignore the purpose
> of these files from doing so.
>
> There are devices with abnormally strict restrictions with respect to
> accessing their registers; aspects that are typically handled by the
> device's driver.  When these access restrictions are not followed - as
> when a userspace app such as "udevadm info --attribute-walk
> --path=/sys/..." parses though reading all the device's sysfs entries - it
> can cause such devices to fail.
>
> This patch introduces a quirking mechanism that can be used to detect
> accesses that do no meet the device's restrictions, letting a device
> specific method intervene and decide how to progress.
>
> Reported-by: Xiangliang Yu <yuxiangl@marvell.com>
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>

I honestly don't think there's much point in even attempting this 
strategy. This list of devices in the quirk can't possibly be complete. 
It would likely be easier to enumerate a white-list of devices that can 
deal with their IO ports being read willy-nilly than a blacklist of 
those that don't, as there's likely countless devices that fall into 
this category. Even if they don't choke as badly as these ones do, it's 
quite likely that bad behavior will result.

I think there's a few things that need to be done:

-Fix the bug in udevadm that caused it to trawl through these files 
willy-nilly,

-Fix the kernel so that access through these files complies with the 
kernel's mechanisms for claiming IO/memory regions to prevent access 
conflicts (i.e. opening these files should claim the resource region 
they refer to, and should fail with EBUSY or something if another 
process or a kernel driver is using it).

-Reconsider whether supporting read/write on the resource files for IO 
port regions like these makes any sense. Obviously mmap isn't very 
practical for IO port access on x86 but you could even do something like 
an ioctl for this purpose. Not very many pieces of software would need 
to access these files so it's likely OK if the API is a bit ugly. That 
would prevent something like grepping through sysfs from generating port 
accesses to random devices.
