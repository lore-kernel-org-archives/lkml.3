Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832Ab3KMSeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:34:31 -0500
Received: from mout.gmx.net ([212.227.15.19]:55559 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759627Ab3KMSeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:34:23 -0500
Date: Wed, 13 Nov 2013 19:34:19 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Black screen with GMA500 driver on Atom E680 (invalid VBT signature)
Message-ID: <20131113183418.GA1593@thinkpad.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:08S1+E/bzJTusGie3qZeJ6zoeiHAPTG56sHW5Wzm6zODeuOvoJu
 xr5KAXcgshAjeD1czTW8HKvrqnXGyoJtYyy2VQ+F00XrBCLsSb6VUJk4sgV9U/TFDG1F5Zz
 KlUcskSzwsnwS1OGHu7rz9PG+CXmhnlFOafq2LOQH5Oo5ohOwl5uvo0+rBpq7y3u/nAmqbu
 jtxg3gHhG42JDhwB3PfNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I´ve a question about the GMA 500 driver (gma500_gfx) with an Intel Atom E680.

Since the gma500 driver is in the Kernel, i get a black screen after loading
the driver.

The last message i can see are "Invalid VBT signature".
I have check the driver file "intel_bios.c" and there the driver map
the bios rom and search for the string "$VBT", but the driver cannot
find the string and return with "Invalid VBT signature".

Above the function with the relevant code.

int psb_intel_init_bios(struct drm_device *dev)
{
        struct drm_psb_private *dev_priv = dev->dev_private;
        struct pci_dev *pdev = dev->pdev;
        struct vbt_header *vbt = NULL;
        struct bdb_header *bdb = NULL;
        u8 __iomem *bios = NULL;
        size_t size;
        int i;


        dev_priv->panel_type = 0xff;

        /* XXX Should this validation be moved to intel_opregion.c? */
        if (dev_priv->opregion.vbt) {
                struct vbt_header *vbt = dev_priv->opregion.vbt;
                if (memcmp(vbt->signature, "$VBT", 4) == 0) {
                        DRM_DEBUG_KMS("Using VBT from OpRegion: %20s\n",
                                         vbt->signature);
                        bdb = (struct bdb_header *)((char *)vbt + vbt->bdb_offset);
                } else
                        dev_priv->opregion.vbt = NULL;
        }

        if (bdb == NULL) {
                bios = pci_map_rom(pdev, &size);
                if (!bios)
                        return -1;
             /* Scour memory looking for the VBT signature */
                for (i = 0; i + 4 < size; i++) {
                        if (!memcmp(bios + i, "$VBT", 4)) {
                                vbt = (struct vbt_header *)(bios + i);
                                break;
                        }
                }

                if (!vbt) {
                        dev_err(dev->dev, "VBT signature missing\n");
                        pci_unmap_rom(pdev, bios);
                        return -1;
                }
                bdb = (struct bdb_header *)(bios + i + vbt->bdb_offset);
        }

        /* Grab useful general dxefinitions */
        parse_general_features(dev_priv, bdb);
        parse_driver_features(dev_priv, bdb);
        parse_lfp_panel_data(dev_priv, bdb);
        parse_sdvo_panel_data(dev_priv, bdb);
        parse_sdvo_device_mapping(dev_priv, bdb);
        parse_device_mapping(dev_priv, bdb);
        parse_backlight_data(dev_priv, bdb);
        parse_edp(dev_priv, bdb);

        if (bios)
                pci_unmap_rom(pdev, bios);

        return 0;
}


My question now is, is it a bug in the driver or in the VGA Bios?

I´ve checked the VGA bios and did a hex dump but there is really no "$VBT" string.
On an Atom Gen1 CPU with intel GMA500 Graphic there is the string in the VGA BIOS.
But if i create the VGA BIOS for intel Atom E680 which has a GMA600 Graphic
there is no string.

Does anybody of you running the GMA500 driver with and Atom E680 without having this
problem? Or does anybody know how to get this string into the VGA BIOS?


Regards 
Andy


