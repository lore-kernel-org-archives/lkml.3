Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaKCTd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:33:28 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61912 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaKCTd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:33:26 -0500
Message-ID: <5457D883.4050201@amacapital.net>
Date: Mon, 03 Nov 2014 11:33:23 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Ming Lei <ming.lei@canonical.com>,
        Sam Protsenko <semen.protsenko@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH v2 0/3] Enable user helper interface for efi capsule update
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
In-Reply-To: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2014 07:07 PM, Kweh Hock Leong wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Hi Guys,
> 
> This patchset is created on top of "efi: Capsule update support" patch:
> http://permalink.gmane.org/gmane.linux.kernel.efi/4837
> 
> It leverages the request_firmware_nowait() to expose the user helper interface for user to upload the capsule binary and calling the
> efi_capsule_update() API to pass the binary to EFI firmware.

I don't get it.  Why is the firmware interface at all reasonable for
uploading capsules?

The firmware interface makes sense for nonvolatile firmware where
hotplugging something or otherwise loading a driver needs a blob.  But
uploading an EFI capsule is an *action*, not something that should
happen transparently.  If there's an EFI firmware update available and
the user wants to install it, then the userspace tool should install it,
and it shouldn't hang around in /lib/firmware.  In fact, you shouldn't
even need /lib to be on writable media to use this.

And you most certainly don't want the EFI capsule hanging around so that
it might be accidentally installed again if the hard disk is moved.

ISTM there should be some file in sysfs to which you can write a
capsule, or perhaps a chardev and an ioctl.

--Andy

> 
> Besides build in kernel, the design also cater for build as kernel driver module. This patchset introduce a new API (request_firmware_abort()) at firmware_class so that the driver module could be unloaded by calling the API to properly stop user helper interface and release the device.
> 
> Thanks.
> 
> ---
> changelog v2:
> [PATCH 1/3]
> * use fw_lookup_buf() instead of __fw_lookup_buf() function call
> * move the fw_lookup_buf() function out of the CONFIG_PM_SLEEP block
> 
> [PATCH 2/3]
> * no change
> 
> [PATCH 3/3]
> * no change
> 
> 
> Kweh, Hock Leong (3):
>   firmware loader: Introduce new API - request_firmware_abort()
>   firmware loader: fix hung task warning dump
>   efi: Capsule update with user helper interface
> 
>  drivers/base/firmware_class.c                  |   56 ++++--
>  drivers/firmware/efi/Kconfig                   |   13 ++
>  drivers/firmware/efi/Makefile                  |    1 +
>  drivers/firmware/efi/efi-capsule-user-helper.c |  246 ++++++++++++++++++++++++
>  include/linux/firmware.h                       |    4 +
>  5 files changed, 306 insertions(+), 14 deletions(-)
>  create mode 100644 drivers/firmware/efi/efi-capsule-user-helper.c
> 

