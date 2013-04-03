Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763175Ab3DCTLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:11:37 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:20899 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763106Ab3DCTLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:11:36 -0400
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTyODSIkvfdw==
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket is NULL
Date: Wed, 3 Apr 2013 21:11:16 +0200
User-Agent: KMail/1.13.7 (Linux/3.8-5.slh.3-aptosid-686; KDE/4.8.4; i686; ; )
Cc: Sven Joachim <svenjoac@gmx.de>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20130402221104.163133110@linuxfoundation.org> <87a9pfzm33.fsf@turtle.gmx.de> <20130403152720.GA21643@kroah.com>
In-Reply-To: <20130403152720.GA21643@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201304032111.25888.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wednesday 03 April 2013, Greg Kroah-Hartman wrote:
> On Wed, Apr 03, 2013 at 05:10:40PM +0200, Sven Joachim wrote:
> > On 2013-04-03 16:00 +0200, Eric Dumazet wrote:
> > > On Wed, 2013-04-03 at 13:41 +0200, Sven Joachim wrote:
> > >> On 2013-04-03 00:11 +0200, Greg Kroah-Hartman wrote:
> > >> > 3.8-stable review patch.  If anyone has any objections, please let me know.
> > >> 
> > >> I'm seeing several complaints from udevd at boot in both 3.8.6-rc1 and
> > >> 3.9-rc5: "udevd[56]: sender uid=65534, message ignored".  Reverting the
> > >> patch below on top of 3.8.6-rc1 fixes that.  I'm using udev version 175
> > >> here, and 65534 is the uid of user "nobody".
[…]

I can reproduce this issue on several systems with a Debian unstable 
(udev 175, same version as in the upcoming Debian 7.0 'wheezy') 
userland. Reverting only this patch from 3.8.6-rc1 avoids the problem.

> > > It might be a wrong sender (application bug or bad identity), and udevd
> > > correctly discards the incoming message.
> > 
> > How would I find out the culprit?
> 
> Try running 'udevadm monitor' as root and see if something shows up
> there.

There are no re-occuring messages on an idle system, connecting a USB 
stick (not mounting) results in these messages.

broken (3.8.6-rc1, with "af_unix: dont send SCM_CREDENTIAL when dest 
socket is NULL" applied):

KERNEL[11739.713368] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1 (usb)
KERNEL[11739.713514] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0 (usb)
UDEV  [11739.713663] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1 (usb)
KERNEL[11739.713677] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7 (scsi)
KERNEL[11739.713688] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/scsi_host/host7 (scsi_host)
UDEV  [11739.713734] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0 (usb)
UDEV  [11739.713797] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7 (scsi)
UDEV  [11739.713893] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/scsi_host/host7 (scsi_host)
UDEV  [11739.718583] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1 (usb)
UDEV  [11739.720709] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0 (usb)
UDEV  [11739.720900] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7 (scsi)
UDEV  [11739.721191] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/scsi_host/host7 (scsi_host)
KERNEL[11740.747996] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0 (scsi)
KERNEL[11740.748032] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0 (scsi)
KERNEL[11740.748042] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/scsi_disk/7:0:0:0 (scsi_disk)
KERNEL[11740.748048] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/scsi_device/7:0:0:0 (scsi_device)
KERNEL[11740.748103] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/scsi_generic/sg5 (scsi_generic)
UDEV  [11740.748129] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0 (scsi)
KERNEL[11740.748146] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/bsg/7:0:0:0 (bsg)
UDEV  [11740.748251] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0 (scsi)
UDEV  [11740.748349] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0 (scsi)
UDEV  [11740.748459] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/scsi_disk/7:0:0:0 (scsi_disk)
UDEV  [11740.748533] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/scsi_device/7:0:0:0 (scsi_device)
UDEV  [11740.748910] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/scsi_generic/sg5 (scsi_generic)
UDEV  [11740.749039] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/bsg/7:0:0:0 (bsg)
UDEV  [11740.750204] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0 (scsi)
UDEV  [11740.750531] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/scsi_disk/7:0:0:0 (scsi_disk)
UDEV  [11740.750652] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/scsi_device/7:0:0:0 (scsi_device)
UDEV  [11740.751143] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/bsg/7:0:0:0 (bsg)
UDEV  [11740.751323] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/scsi_generic/sg5 (scsi_generic)
KERNEL[11740.943534] add      /devices/virtual/bdi/8:80 (bdi)
UDEV  [11740.943700] add      /devices/virtual/bdi/8:80 (bdi)
UDEV  [11740.943807] add      /devices/virtual/bdi/8:80 (bdi)
KERNEL[11740.987877] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/block/sdf (block)
KERNEL[11740.987921] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/block/sdf/sdf1 (block)
UDEV  [11740.988152] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/block/sdf (block)
UDEV  [11740.988307] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/block/sdf/sdf1 (block)
UDEV  [11741.047184] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/block/sdf (block)
UDEV  [11741.104796] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host7/target7:0:0/7:0:0:0/block/sdf/sdf1 (block)

working (3.8.6-rc1, with "af_unix: dont send SCM_CREDENTIAL when dest 
socket is NULL" reverted):

KERNEL[637.018561] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1 (usb)
KERNEL[637.018607] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0 (usb)
UDEV  [637.023544] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1 (usb)
KERNEL[637.028060] add      /module/usb_storage (module)
UDEV  [637.028268] add      /module/usb_storage (module)
KERNEL[637.028293] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6 (scsi)
KERNEL[637.028332] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/scsi_host/host6 (scsi_host)
KERNEL[637.028364] add      /bus/usb/drivers/usb-storage (drivers)
UDEV  [637.028586] add      /bus/usb/drivers/usb-storage (drivers)
UDEV  [637.028614] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0 (usb)
UDEV  [637.028910] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6 (scsi)
UDEV  [637.029294] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/scsi_host/host6 (scsi_host)
KERNEL[638.062158] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0 (scsi)
KERNEL[638.062191] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0/6:0:0:0 (scsi)
KERNEL[638.062238] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0/6:0:0:0/scsi_disk/6:0:0:0 (scsi_disk)
KERNEL[638.062280] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0/6:0:0:0/scsi_device/6:0:0:0 (scsi_device)
KERNEL[638.062347] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0/6:0:0:0/scsi_generic/sg5 (scsi_generic)
KERNEL[638.062410] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0/6:0:0:0/bsg/6:0:0:0 (bsg)
UDEV  [638.062455] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0 (scsi)
UDEV  [638.064574] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0/6:0:0:0 (scsi)
UDEV  [638.064941] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0/6:0:0:0/scsi_disk/6:0:0:0 (scsi_disk)
UDEV  [638.064974] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0/6:0:0:0/scsi_device/6:0:0:0 (scsi_device)
UDEV  [638.065568] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0/6:0:0:0/bsg/6:0:0:0 (bsg)
UDEV  [638.065766] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0/6:0:0:0/scsi_generic/sg5 (scsi_generic)
KERNEL[638.257660] add      /devices/virtual/bdi/8:80 (bdi)
UDEV  [638.258029] add      /devices/virtual/bdi/8:80 (bdi)
KERNEL[638.301820] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0/6:0:0:0/block/sdf (block)
KERNEL[638.301864] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0/6:0:0:0/block/sdf/sdf1 (block)
UDEV  [638.361377] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0/6:0:0:0/block/sdf (block)
UDEV  [638.420664] add      /devices/pci0000:00/0000:00:1a.0/usb7/7-1/7-1.1/7-1.1:1.0/host6/target6:0:0/6:0:0:0/block/sdf/sdf1 (block)


> I can't reproduce this here, running a newer version of udev (195),
> sorry, I don't have any systems with older udev releases.
> 
> Note, someone else posted this same error earlier today on the linux-usb
> mailing list, saying that USB storage devices would not automount
> anymore.  Does that work properly for you?

Yes, this patch breaks automounting or USB devices under KDE 4.8.4.

Regards
	Stefan Lippers-Hollmann
