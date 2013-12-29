Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab3L2Cqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:46:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55307 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497Ab3L2CKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:25 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Frediano Ziglio" <frediano.ziglio@citrix.com>,
        "Takashi Iwai" <tiwai@suse.de>,
        "Stefano Panella" <stefano.panella@citrix.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.696616337@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 130/185] ALSA: memalloc.h - fix wrong truncation of
 dma_addr_t
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Panella <stefano.panella@citrix.com>

commit 932e9dec380c67ec15ac3eb073bb55797d8b4801 upstream.

When running a 32bit kernel the hda_intel driver is still reporting
a 64bit dma_mask if the HW supports it.

=46romsound/pci/hda/hda_intel.c:

        /* allow 64bit DMA address if supported by H/W */
        if ((gcap & ICH6_GCAP_64OK) && !pci_set_dma_mask(pci, DMA_BIT_MASK(64)))
                pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(64));
        else {
                pci_set_dma_mask(pci, DMA_BIT_MASK(32));
                pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(32));
        }

which means when there is a call to dma_alloc_coherent from
snd_malloc_dev_pages a machine address bigger than 32bit can be returned.
This can be true in particular if running  the 32bit kernel as a pv dom0
under the Xen Hypervisor or PAE on bare metal.

The problem is that when calling setup_bdle to program the BLE the
dma_addr_t returned from the dma_alloc_coherent is wrongly truncated
from snd_sgbuf_get_addr if running a 32bit kernel:

static inline dma_addr_t snd_sgbuf_get_addr(struct snd_dma_buffer *dmab,
                                           size_t offset)
{
        struct snd_sg_buf *sgbuf = dmab->private_data;
        dma_addr_t addr = sgbuf->table[offset >> PAGE_SHIFT].addr;
        addr &= PAGE_MASK;
        return addr + offset % PAGE_SIZE;
}

where PAGE_MASK in a 32bit kernel is zeroing the upper 32bit af addr.

Without this patch the HW will fetch the 32bit truncated address,
which is not the one obtained from dma_alloc_coherent and will result
to a non working audio but can corrupt host memory at a random location.

The current patch apply to v3.13-rc3-74-g6c843f5

Signed-off-by: Stefano Panella <stefano.panella@citrix.com>
Reviewed-by: Frediano Ziglio <frediano.ziglio@citrix.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/sound/memalloc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/sound/memalloc.h
+++ b/include/sound/memalloc.h
@@ -101,7 +101,7 @@ static inline unsigned int snd_sgbuf_ali
 static inline dma_addr_t snd_sgbuf_get_addr(struct snd_sg_buf *sgbuf, size_t offset)
 {
 	dma_addr_t addr = sgbuf->table[offset >> PAGE_SHIFT].addr;
-	addr &= PAGE_MASK;
+	addr &= ~((dma_addr_t)PAGE_SIZE - 1);
 	return addr + offset % PAGE_SIZE;
 }
 

