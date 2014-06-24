Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaFXJ4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 05:56:19 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15952 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaFXJ4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 05:56:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Jun 2014 02:46:30 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 0/3] drm/ttm: nouveau: memory coherency for ARM
Date: Tue, 24 Jun 2014 18:54:24 +0900
Message-ID: <1403603667-11302-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For this v2 I have fixed the patches that are non-controversial (all Lucas' :))
and am resubmitting them in the hope that they will get merged. This will
just leave the issue of Nouveau system-memory buffers mapping to be solved.

This issue is quite complex, so let me summarize the situation and the data
I have at hand. ARM caching is like a quantum world where Murphy's law
constantly applies: sometimes things that you don't expect to work happen to
work, but never the ones you would like to.

On ARM the accepted wisdom is that all CPU mappings must share the same
attributes, and that failure to do so results in undefined behavior. I have
heard voices claiming that recent ARM SoCs were not affected by this, but have
yet to see hard evidence that it is indeed the case.

Most (or all) physical memory happens to be already mapped, cached, in the
lowmem area of the virtual address space. This means that if we want to be
safe wrt. the rule mentioned above, we must perform all subsequent memory
mappings the same way.

Nouveau currently performs its memory mappings cached, since it can rely on PCI
to snoop and invalidate addresses written by the CPU - something that we don't
have on ARM shared-memory systems. I had proposed a (bad) patch in the previous
revision of this series that added a way to flush the CPU cache after each write
(http://lists.freedesktop.org/archives/dri-devel/2014-May/059893.html ) but it
did not trigger a lot of approval. Instead, it has been suggested to map such
BOs write-combined.

This would break the "one mapping type only" rule, but I gave it a try by
changing the TTM_PL_TT manager's authorized caching to WC. This immediatly
resulted in breakage of applications using the GPU. Digging a little further,
I noticed that kernel mappings could be performed WC or uncached without any
problem, but that user-space mappings *must* be cached under all circumstances.
Failure to do so results in invalid pushbuffers being sent to the GPUs, messed
up vertices, and other corruptions. Uncached mappings result in the same
breakage.

So, to summarize our options for GK20A:
1) Keeping mappings of TTM buffers cached seems to be the safest option, as it
is consistent with the lowmem mapping likely affecting the memory of our
buffers. But we will have to flush kernel CPU writes to these buffers one way
or the other.
2) Changing the kernel mappings to WC or uncached seems to be safe. However
user-space mappings must still be cached or inconsistencies happen. This
double-policy for kernel and user-space mappings is not implemented in TTM
and nothing so far suggests that it should be.

And that's the state where we are. I am not considering the other possibilities
(carving memory out of lowmem, etc.) as they have already been discussed many
times by people much smarter than me (e.g. http://lists.linaro.org/pipermail/linaro-mm-sig/2011-April/000003.html )
and it seems that the issue is still here nonetheless.

At this point suggestions towards option 1) or 2) (or where I could have
screwed up in my understanding of ARM mappings) are welcome. And in the
meantime, let's try to get the 3 guys below merged!

Changes since v1:
- Removed conditional compilation for Nouveau cache sync handler
- Refactored nouveau_gem_ioctl_cpu_prep() into a new function to keep buffer
  cache management into nouveau_bo.c

Lucas Stach (3):
  drm/ttm: recognize ARM arch in ioprot handler
  drm/ttm: introduce dma cache sync helpers
  drm/nouveau: hook up cache sync functions

 drivers/gpu/drm/nouveau/nouveau_bo.c  | 47 +++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/nouveau/nouveau_bo.h  |  1 +
 drivers/gpu/drm/nouveau/nouveau_gem.c | 10 +++-----
 drivers/gpu/drm/ttm/ttm_bo_util.c     |  2 +-
 drivers/gpu/drm/ttm/ttm_tt.c          | 25 +++++++++++++++++++
 include/drm/ttm/ttm_bo_driver.h       | 28 +++++++++++++++++++++
 6 files changed, 105 insertions(+), 8 deletions(-)

-- 
2.0.0

