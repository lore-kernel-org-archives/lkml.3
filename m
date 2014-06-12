Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaFLUkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:40:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbaFLUjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:39:09 -0400
From: Bandan Das <bsd@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Add extra test for extended capabilities
References: <20140612164349.9739.53824.stgit@bling.home>
	<jpgwqclx4yw.fsf@nelium.bos.redhat.com>
	<1402604942.3707.17.camel@ul30vt.home>
Date: Thu, 12 Jun 2014 16:39:08 -0400
In-Reply-To: <1402604942.3707.17.camel@ul30vt.home> (Alex Williamson's message
	of "Thu, 12 Jun 2014 14:29:02 -0600")
Message-ID: <jpgy4x1vp5f.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Williamson <alex.williamson@redhat.com> writes:

> On Thu, 2014-06-12 at 16:12 -0400, Bandan Das wrote:
>> Alex Williamson <alex.williamson@redhat.com> writes:
>> 
>> > If the PCI core set cfg_size isn't large enough for extended
>> > capabilities, then they're not there.  Extended config space may be
>> > inaccessible due to a PCI bridge, in which case cfg_size may be cut
>> > short.
>> 
>> Just curious, is this part of the spec or just a convention ? I mean
>> could there be devices with quirks ?
>
> The PCIe bridge spec indicates that PCIe-to-PCI bridges should handle
> extended config accesses as an unsupported request.  But as in 78916b00,
> we've seen that's not always the case.  This just makes us trust
> PCI-core before the capabilities we find on the device.  The current
> quirk in the referenced commit is for a relatively uncommon topology,
> but never rule out that we couldn't have a device quirked to avoid
> touching extended config space too.  Thanks,

Ok, Understood, Thanks!

> Alex 
>
>> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>> > ---
>> >  drivers/vfio/pci/vfio_pci_config.c |   13 +++++++++----
>> >  1 file changed, 9 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>> > index 83cd157..4a62a37 100644
>> > --- a/drivers/vfio/pci/vfio_pci_config.c
>> > +++ b/drivers/vfio/pci/vfio_pci_config.c
>> > @@ -1027,8 +1027,11 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
>> >  
>> >  		if (PCI_X_CMD_VERSION(word)) {
>> >  			/* Test for extended capabilities */
>> > -			pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &dword);
>> > -			vdev->extended_caps = (dword != 0);
>> > +			if (pdev->cfg_size > PCI_CFG_SPACE_SIZE) {
>> > +				pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE,
>> > +						      &dword);
>> > +				vdev->extended_caps = (dword != 0);
>> > +			}
>> >  			return PCI_CAP_PCIX_SIZEOF_V2;
>> >  		} else
>> >  			return PCI_CAP_PCIX_SIZEOF_V0;
>> > @@ -1041,8 +1044,10 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
>> >  		return byte;
>> >  	case PCI_CAP_ID_EXP:
>> >  		/* Test for extended capabilities */
>> > -		pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &dword);
>> > -		vdev->extended_caps = (dword != 0);
>> > +		if (pdev->cfg_size > PCI_CFG_SPACE_SIZE) {
>> > +			pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &dword);
>> > +			vdev->extended_caps = (dword != 0);
>> > +		}
>> >  
>> >  		/* length based on version */
>> >  		if ((pcie_caps_reg(pdev) & PCI_EXP_FLAGS_VERS) == 1)
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe kvm" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
