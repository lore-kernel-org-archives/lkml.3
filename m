Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaBNVpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:45:53 -0500
Received: from senator.holtmann.net ([87.106.208.187]:51418 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaBNVpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:45:51 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH 00/24] rfcomm fixes
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
Date: Fri, 14 Feb 2014 13:45:49 -0800
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Alexander Holler <holler@ahsoftware.de>,
        Andrey Vihrov <andrey.vihrov@gmail.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <316ACAE4-B98C-4396-8121-DCFC20BEC448@holtmann.org>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
To: Peter Hurley <peter@hurleysoftware.com>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> This patch series addresses a number of previously unknown issues
> with the RFCOMM tty device implementation, in addition to
> addressing the locking regression recently reported [1].
> 
> As Gianluca suggested and I agree, this series first reverts
> 3 of the 4 patches of 3.14-rc1 for bluetooth/rfcomm/tty.c.
> 
> The reasoning is detailed in the changelog for
>  Revert "Bluetooth: Always wait for a connection on RFCOMM open()"
> but the short answer is that it re-implements a long-standing
> bug by blocking on a non-blocking open.
> 
> This patch series corrects the reported regressions from 3.13
> (to the extent that correction is required). Specifically,
> the ModemManager regression reported by Gianluca Anzolin [2]
> and the rfcomm bind with wvdial reported by Andrey Vihrov [3].
> 
> tty: Fix ref counting for port krefs
> Bluetooth: Fix racy acquire of rfcomm_dev reference
> Bluetooth: Exclude released devices from RFCOMMGETDEVLIST ioctl
> Bluetooth: Release rfcomm_dev only once
> Bluetooth: Fix unreleased rfcomm_dev reference
>   These first 5 patches after the reverts
>   fix 4 different rfcomm_dev ref count mishandling bugs.
> 
> Bluetooth: Fix RFCOMM tty teardown race and
> Bluetooth: Serialize RFCOMMCREATEDEV and RFCOMMRELEASEDEV ioctls
>   Fix races which occur due to the design of the rfcomm ioctls
>   (note that buses don't have these kinds of races).
> 
> Bluetooth: Verify dlci not in use before rfcomm_dev create
> Bluetooth: Simplify RFCOMM session state eval
> Bluetooth: Refactor deferred setup test in rfcomm_dlc_close()
> Bluetooth: Refactor dlc disconnect logic in rfcomm_dlc_close()
> Bluetooth: Directly close dlc for not yet started RFCOMM session
>   These 5 patches fix issues with reusing the dlci after
>   closing the tty (found by unit test).
> 
> Bluetooth: Fix unsafe RFCOMM device parenting
> Bluetooth: Fix RFCOMM parent device for reused dlc
>   These 2 patches fix the ModemManager regression.
> 
> Bluetooth: Refactor rfcomm_dev_add()
> Bluetooth: Cleanup RFCOMM device registration error handling
>   These 2 patches fix an unreleased module reference while
>   error handling.
> 
> Bluetooth: Rename __rfcomm_dev_get() to __rfcomm_dev_lookup()
>   This is a trivial naming patch with no functional impact.
> 
> Bluetooth: Force -EIO from tty read/write if .activate() fails
>   The tty core provides an existing mechanism for failing
>   reads/writes if device activation fails (like an error
>   allocating the dlc).
> 
> Bluetooth: Don't fail RFCOMM tty writes
>   This patch implements buffered writes even if the device
>   is not connected.
> 
> While unit testing this, I discovered a serious defect in
> the way available space is computed that under-utilizes
> rfcomm i/o and may even halt further tx on that link, which
> is fixed by:
>  Bluetooth: Refactor write_room() calculation
>  Bluetooth: Fix write_room() calculation
> 
> 
> Note that this series does not fix the naively inefficient
> method of packetizing tty output; packetizing should be
> done on the krfcommd thread to take advantage of aggregating
> multiple tty writes into 1 or more packets. Look at any
> line-by-line console output to realize how under-utilized
> the rfcomm tty packeting is.
> 
> [1] http://www.spinics.net/lists/linux-wireless/msg117818.html
> [2] http://www.spinics.net/lists/linux-bluetooth/msg42075.html
> [3] http://www.spinics.net/lists/linux-bluetooth/msg42057.html
> 
> 
> Regards,
> 
> 
> Peter Hurley (24):
>  Revert "Bluetooth: Remove rfcomm_carrier_raised()"
>  Revert "Bluetooth: Always wait for a connection on RFCOMM open()"
>  Revert "Bluetooth: Move rfcomm_get_device() before
>    rfcomm_dev_activate()”

these 3 patches are in bluetooth-next to give them extra testing. We will get them into 3.14-rc4 after an extra week of them being in linux-next.

>  tty: Fix ref counting for port krefs

I am taking this one with Greg’s ack through bluetooth-next. Unless someone objects.

>  Bluetooth: Fix racy acquire of rfcomm_dev reference
>  Bluetooth: Exclude released devices from RFCOMMGETDEVLIST ioctl
>  Bluetooth: Release rfcomm_dev only once
>  Bluetooth: Fix unreleased rfcomm_dev reference
>  Bluetooth: Fix RFCOMM tty teardown race
>  Bluetooth: Verify dlci not in use before rfcomm_dev create
>  Bluetooth: Simplify RFCOMM session state eval
>  Bluetooth: Refactor deferred setup test in rfcomm_dlc_close()
>  Bluetooth: Refactor dlc disconnect logic in rfcomm_dlc_close()
>  Bluetooth: Directly close dlc for not yet started RFCOMM session
>  Bluetooth: Fix unsafe RFCOMM device parenting
>  Bluetooth: Fix RFCOMM parent device for reused dlc
>  Bluetooth: Rename __rfcomm_dev_get() to __rfcomm_dev_lookup()
>  Bluetooth: Serialize RFCOMMCREATEDEV and RFCOMMRELEASEDEV ioctls
>  Bluetooth: Refactor rfcomm_dev_add()
>  Bluetooth: Cleanup RFCOMM device registration error handling
>  Bluetooth: Force -EIO from tty read/write if .activate() fails
>  Bluetooth: Don't fail RFCOMM tty writes
>  Bluetooth: Refactor write_room() calculation
>  Bluetooth: Fix write_room() calculation
> 
> include/linux/tty.h            |   6 +-
> include/net/bluetooth/rfcomm.h |   9 +-
> net/bluetooth/rfcomm/core.c    |  88 ++++++++++----
> net/bluetooth/rfcomm/tty.c     | 262 ++++++++++++++++++++++-------------------
> 4 files changed, 223 insertions(+), 142 deletions(-)

all patches have been applied to bluetooth-next tree.

Regards

Marcel

