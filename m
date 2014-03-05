Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaCEIcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:32:00 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43635 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbaCEIb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:31:59 -0500
Date: Wed, 5 Mar 2014 00:31:53 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: Austin Boyle <boyle.austin@gmail.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Marek Vasut <marex@denx.de>, Angus Clark <angus.clark@st.com>
Subject: Re: [PATCH] mtd: m25p80: Flash protection support for STmicro chips
Message-ID: <20140305083153.GR13420@norris-Latitude-E6410>
References: <1357257748.31023.12.camel@pc786-ubu.GNET.GLOBAL.VPN>
 <528D15B6.2030800@keymile.com>
 <530F4CDE.7010205@keymile.com>
 <20140305081008.GP13420@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305081008.GP13420@norris-Latitude-E6410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different email for Austin?

On Wed, Mar 05, 2014 at 12:10:08AM -0800, Brian Norris wrote:
> + Marek, Angus
> 
> On Thu, Feb 27, 2014 at 03:34:06PM +0100, Gerlando Falauto wrote:
> > Hi,
> > 
> > it's me again.
> > In my opinion (and experience) this introduces a pretty serious bug
> > (not to mention the compatibility issues), yet I haven't heard a
> > single word or found a patch applied about it in three months.
> > Am I the only one having this issue? Or maybe I'm just "seeing things"?
> 
> I agree that this doesn't look quite like the best implementation. As
> you note, this feature is not available on *ALL* ST SPI flash. I think
> it should require yet another device flag in m25p_ids[]...
> 
> But I don't see why this is a concern for "certain bootloaders". If your
> bootloader doesn't support locked blocks, then don't run ioctl(MEMLOCK)
> on the device.
> 
> Leaving the following context intact for now, since it's old. But please
> trim your replies and bottom-post in the future. Thanks!
> 
> Regards,
> Brian
> 
> > Thank you,
> > Gerlando
> > 
> > P.S. FWIW, the original author of the patch seem to have disappeared.
> > 
> > On 11/20/2013 09:04 PM, Gerlando Falauto wrote:
> > >Hi,
> > >
> > >On 01/04/2013 01:02 AM, Austin Boyle wrote:
> > >>This patch adds generic support for flash protection on STmicro chips.
> > >>On chips with less than 3 protection bits, the unused bits are don't
> > >>cares
> > >>and so can be written anyway.
> > >
> > >I have two remarks:
> > >
> > >1) I believe this introduces incompatibilities with existing bootloaders
> > >which do not support this feature.
> > >Namely, u-boot is not able (to the best of my knowledge) to treat these
> > >bits properly. So as soon as you write something to your SPI nor flash
> > >from within linux, u-boot is not able to erase/rewrite those blocks
> > >anymore.
> > >
> > >Wouldn't it make more sense to selectively enable this feature, only if
> > >explicity configured to do so (e.g. through its device tree node)?
> > >Like what was used for the Spansion's PPB, see:
> > >
> > >http://lists.infradead.org/pipermail/linux-mtd/2013-January/045536.html
> > >
> > > > The lock function will only change the
> > >>protection bits if it would not unlock other areas. Similarly, the unlock
> > >>function will not lock currently unlocked areas. Tested on the m25p64.
> > > >
> > >>From: Austin Boyle <Austin.Boyle@aviatnet.com>
> > >>Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>
> > >>---
> > >>diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
> > >>index 4eeeb2d..069e34f 100644
> > >>--- a/drivers/mtd/devices/m25p80.c
> > >>+++ b/drivers/mtd/devices/m25p80.c
> > >>@@ -565,6 +565,96 @@ time_out:
> > >>      return ret;
> > >>  }
> > >>
> > >>+static int m25p80_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
> > >>+{
> > >>+    struct m25p *flash = mtd_to_m25p(mtd);
> > >>+    uint32_t offset = ofs;
> > >>+    uint8_t status_old, status_new;
> > >>+    int res = 0;
> > >>+
> > >>+    mutex_lock(&flash->lock);
> > >>+    /* Wait until finished previous command */
> > >>+    if (wait_till_ready(flash)) {
> > >>+        res = 1;
> > >>+        goto err;
> > >>+    }
> > >>+
> > >>+    status_old = read_sr(flash);
> > >>+
> > >>+    if (offset < flash->mtd.size-(flash->mtd.size/2))
> > >>+        status_new = status_old | SR_BP2 | SR_BP1 | SR_BP0;
> > >>+    else if (offset < flash->mtd.size-(flash->mtd.size/4))
> > >>+        status_new = (status_old & ~SR_BP0) | SR_BP2 | SR_BP1;
> > >>+    else if (offset < flash->mtd.size-(flash->mtd.size/8))
> > >>+        status_new = (status_old & ~SR_BP1) | SR_BP2 | SR_BP0;
> > >>+    else if (offset < flash->mtd.size-(flash->mtd.size/16))
> > >>+        status_new = (status_old & ~(SR_BP0|SR_BP1)) | SR_BP2;
> > >>+    else if (offset < flash->mtd.size-(flash->mtd.size/32))
> > >>+        status_new = (status_old & ~SR_BP2) | SR_BP1 | SR_BP0;
> > >>+    else if (offset < flash->mtd.size-(flash->mtd.size/64))
> > >>+        status_new = (status_old & ~(SR_BP2|SR_BP0)) | SR_BP1;
> > >>+    else
> > >>+        status_new = (status_old & ~(SR_BP2|SR_BP1)) | SR_BP0;
> > >
> > >2) While I believe this might work on m25p32, m25p64 and m25p128 (i.e.
> > >flashes with 64 blocks or more), it looks incorrect for smaller chips
> > >(namely our m25p80, with just 16 blocks). There, the 1/64 logic scales
> > >down to 1/16, e.g.
> > >- 000 means protect nothing
> > >- 001 means protect 1/16th (=1 blocks)    [m25p64 => 1/64th]
> > >- 010 means protect 1/8th  (=2 blocks)    [m25p64 => 1/32th]
> > >- ...
> > >- 100 means protect 1/2nd  (=8 blocks)
> > >- 101,110, 111 mean protect everything
> > >
> > >and I assume the same goes for chips with fewer sectors.
> > >
> > >Any comments?
> > >
> > >Thanks,
> > >Gerlando
> > >
> > >>+
> > >>+    /* Only modify protection if it will not unlock other areas */
> > >>+    if ((status_new&(SR_BP2|SR_BP1|SR_BP0)) >
> > >>+                    (status_old&(SR_BP2|SR_BP1|SR_BP0))) {
> > >>+        write_enable(flash);
> > >>+        if (write_sr(flash, status_new) < 0) {
> > >>+            res = 1;
> > >>+            goto err;
> > >>+        }
> > >>+    }
> > >>+
> > >>+err:    mutex_unlock(&flash->lock);
> > >>+    return res;
> > >>+}
> > >>+
> > >>+static int m25p80_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
> > >>+{
> > >>+    struct m25p *flash = mtd_to_m25p(mtd);
> > >>+    uint32_t offset = ofs;
> > >>+    uint8_t status_old, status_new;
> > >>+    int res = 0;
> > >>+
> > >>+    mutex_lock(&flash->lock);
> > >>+    /* Wait until finished previous command */
> > >>+    if (wait_till_ready(flash)) {
> > >>+        res = 1;
> > >>+        goto err;
> > >>+    }
> > >>+
> > >>+    status_old = read_sr(flash);
> > >>+
> > >>+    if (offset+len > flash->mtd.size-(flash->mtd.size/64))
> > >>+        status_new = status_old & ~(SR_BP2|SR_BP1|SR_BP0);
> > >>+    else if (offset+len > flash->mtd.size-(flash->mtd.size/32))
> > >>+        status_new = (status_old & ~(SR_BP2|SR_BP1)) | SR_BP0;
> > >>+    else if (offset+len > flash->mtd.size-(flash->mtd.size/16))
> > >>+        status_new = (status_old & ~(SR_BP2|SR_BP0)) | SR_BP1;
> > >>+    else if (offset+len > flash->mtd.size-(flash->mtd.size/8))
> > >>+        status_new = (status_old & ~SR_BP2) | SR_BP1 | SR_BP0;
> > >>+    else if (offset+len > flash->mtd.size-(flash->mtd.size/4))
> > >>+        status_new = (status_old & ~(SR_BP0|SR_BP1)) | SR_BP2;
> > >>+    else if (offset+len > flash->mtd.size-(flash->mtd.size/2))
> > >>+        status_new = (status_old & ~SR_BP1) | SR_BP2 | SR_BP0;
> > >>+    else
> > >>+        status_new = (status_old & ~SR_BP0) | SR_BP2 | SR_BP1;
> > >>+
> > >>+    /* Only modify protection if it will not lock other areas */
> > >>+    if ((status_new&(SR_BP2|SR_BP1|SR_BP0)) <
> > >>+                    (status_old&(SR_BP2|SR_BP1|SR_BP0))) {
> > >>+        write_enable(flash);
> > >>+        if (write_sr(flash, status_new) < 0) {
> > >>+            res = 1;
> > >>+            goto err;
> > >>+        }
> > >>+    }
> > >>+
> > >>+err:    mutex_unlock(&flash->lock);
> > >>+    return res;
> > >>+}
> > >>+
> > >>
> > >>/****************************************************************************/
> > >>
> > >>
> > >>  /*
> > >>@@ -899,6 +989,12 @@ static int m25p_probe(struct spi_device *spi)
> > >>      flash->mtd._erase = m25p80_erase;
> > >>      flash->mtd._read = m25p80_read;
> > >>
> > >>+    /* flash protection support for STmicro chips */
> > >>+    if (JEDEC_MFR(info->jedec_id) == CFI_MFR_ST) {
> > >>+        flash->mtd._lock = m25p80_lock;
> > >>+        flash->mtd._unlock = m25p80_unlock;
> > >>+    }
> > >>+
> > >>      /* sst flash chips use AAI word program */
> > >>      if (JEDEC_MFR(info->jedec_id) == CFI_MFR_SST)
> > >>          flash->mtd._write = sst_write;
> > >>
> > >>
