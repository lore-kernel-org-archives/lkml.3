Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab3LRWGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:06:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3LRVMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefano Panella <stefano.panella@citrix.com>,
        Frediano Ziglio <frediano.ziglio@citrix.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 04/78] ALSA: memalloc.h - fix wrong truncation of dma_addr_t
Date: Wed, 18 Dec 2013 13:10:32 -0800
Message-Id: <20131218211112.028650310@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Panella <stefano.panella@citrix.com>

commit 932e9dec380c67ec15ac3eb073bb55797d8b4801 upstream.

When running a 32bit kernel the hda_intel driver is still reporting
a 64bit dma_mask if the HW supports it.

>From sound/pci/hda/hda_intel.c:

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/sound/memalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/sound/memalloc.h
+++ b/include/sound/memalloc.h
@@ -103,7 +103,7 @@ static inline dma_addr_t snd_sgbuf_get_a
 {
 	struct snd_sg_buf *sgbuf = dmab->private_data;
 	dma_addr_t addr = sgbuf->table[offset >> PAGE_SHIFT].addr;
-	addr &= PAGE_MASK;
+	addr &= ~((dma_addr_t)PAGE_SIZE - 1);
 	return addr + offset % PAGE_SIZE;
 }
 


