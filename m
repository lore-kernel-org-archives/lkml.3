Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3C0PD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:03:28 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58615 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab3C0PD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:03:26 -0400
MIME-Version: 1.0
In-Reply-To: <1363642353-30749-5-git-send-email-matthew.garrett@nebula.com>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
	<1363642353-30749-5-git-send-email-matthew.garrett@nebula.com>
Date: Wed, 27 Mar 2013 11:03:26 -0400
Message-ID: <CA+5PVA4VFgExGNrt5Yh+F4f48amAXKYAbdNFDy7VTFTguh6qTA@mail.gmail.com>
Subject: Re: [PATCH 05/12] PCI: Require CAP_COMPROMISE_KERNEL for PCI BAR access
From: Josh Boyer <jwboyer@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, kexec@lists.infradead.org,
        linux-pci@vger.kernel.org, kmcmartin@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 5:32 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> Any hardware that can potentially generate DMA has to be locked down from
> userspace in order to avoid it being possible for an attacker to cause
> arbitrary kernel behaviour. Default to paranoid - in future we can
> potentially relax this for sufficiently IOMMU-isolated devices.
>
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

As noted here:

https://bugzilla.redhat.com/show_bug.cgi?id=908888

this breaks pci passthru with QEMU.  The suggestion in the bug is to move
the check from read/write to open, but sysfs makes that somewhat
difficult.  The open code is part of the core sysfs functionality shared
with the majority of sysfs files, so adding a check there would restrict
things that clearly don't need to be restricted.

Kyle had the idea to add a cap field to the attribute structure, and do
a capable check if that is set.  That would allow for a more generic
usage of capabilities in sysfs code, at the cost of slightly increasing
the structure size and open path.  That seems somewhat promising if we
stick with capabilities.

I would love to just squarely blame capabilities for causing this, but we
can't just replace it with an efi_enabled(EFI_SECURE_BOOT) check because
of the sysfs open case.  I'm not sure there are great answers here.

josh
