Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaJTAes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 20:34:48 -0400
Received: from ozlabs.org ([103.22.144.67]:45492 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbaJTAen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 20:34:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Barry Davis <barry_davis@stormagic.com>
Cc: Tom Gundersen <teg@jklm.no>, "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: 0003-module-remove-MODULE_GENERIC_TABLE.patch
In-Reply-To: <EF6418FA9E2C4C238A5A1FB4BE9FF408@vWin7>
References: <EF6418FA9E2C4C238A5A1FB4BE9FF408@vWin7>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 20 Oct 2014 10:58:17 +1030
Message-ID: <87y4sb8tzy.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Barry Davis <barry_davis@stormagic.com> writes:
> Hi Rusty,
>
> I’ve just been looking at a change that this patch says you introduced:
>
> https://github.com/jumpstarter-io/pkgbuilds/blob/master/linux/0003-module-remove-MODULE_GENERIC_TABLE.patch
>
> In previous kernels we had this defined:
>     chroot:# nm kernel/drivers/scsi/vmw_pvscsi.ko | grep _device_table
>     000000e0 R __mod_pci_device_table
>
> Now we have:
>     chroot:# nm kernel/drivers/scsi/vmw_pvscsi.ko | grep _device_table
>     000000e0 R __mod_pci__pvscsi_pci_tbl_device_table
>
> This results in depmod from module-init-tools not being able to find the __mod_pci_device_table.
> This leads to modules.pcimap being generated with no entries, which breaks anything that uses modules.pcimap to decide if it should insert a module or not.
>
> Was this unintentional, or is there another way to successfully generate modules.pcimap?
>
> See https://github.com/vadmium/module-init-tools/blob/master/elfops_core.c#L351 for details of depmods expectations.

Hi Barry,

        Not intentional at all!  You're the first to report this though:
are you still using the (deprecated) modules.pcimap?  The *map files are
not supported by kmod, and were only inserted as a nod to the older
modutils.

Because it's really hard to fix: we now allow multiple tables, so the
names are now unique.

commit cff26a51da5d206d3baf871e75778da44710219d is the one that broke
this, but commit 21bdd17b21b45ea48e06e23918d681afbe0622e9 relies on it:

commit 21bdd17b21b45ea48e06e23918d681afbe0622e9
Author: Tom Gundersen <teg@jklm.no>
Date:   Mon Feb 3 11:14:13 2014 +1030

    module: allow multiple calls to MODULE_DEVICE_TABLE() per module
    
    Commit 78551277e4df5: "Input: i8042 - add PNP modaliases" had a bug, where the
    second call to MODULE_DEVICE_TABLE() overrode the first resulting in not all
    the modaliases being exposed.
    
    This fixes the problem by including the name of the device_id table in the
    __mod_*_device_table alias, allowing us to export several device_id tables
    per module.
    
    Suggested-by: Kay Sievers <kay@vrfy.org>
    Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Signed-off-by: Tom Gundersen <teg@jklm.no>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
