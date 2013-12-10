Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3LJI2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:28:20 -0500
Received: from collab.rosalab.ru ([195.19.76.181]:47392 "EHLO
	collab.rosalab.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3LJI2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:28:17 -0500
Message-ID: <52A6D08B.1040802@rosalab.ru>
Date: Tue, 10 Dec 2013 12:27:55 +0400
From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Organization: ROSA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: intel-gfx@lists.freedesktop.org
CC: Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>
Subject: i915: NULL pointer dereference in i915_update_dri1_breadcrumb() during
 shutdown
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have recently observed a NULL pointer dereference in i915 driver on my 
Eee PC running ROSA Linux with kernel 3.10.21.

The crash occurs during shutdown but quite rarely, not each time.

The system log is lost but here is what I extracted from the info 
displayed on the screen.

NULL pointer dereference at 0x4
EIP is at i915_update_dri1_breadcrumb+0x25/0x70
comm: systemd-journal

i915_update_dri1_breadcrumb+0x25:
	mov    0x4(%eax),%ebx // %eax contains 0, the list of register values 
confirms that.

That is the reading of 'master_priv->sarea_priv':

void i915_update_dri1_breadcrumb(struct drm_device *dev)
{
	drm_i915_private_t *dev_priv = dev->dev_private;
	struct drm_i915_master_private *master_priv;

	if (dev->primary->master) {
		master_priv = dev->primary->master->driver_priv;
		if (master_priv->sarea_priv) // <<< crashes here
			master_priv->sarea_priv->last_dispatch =
				READ_BREADCRUMB(dev_priv);
	}
}

addr2line points to the same line too.

So, i915_update_dri1_breadcrumb() was called somehow when 
dev->primary->master->driver_priv was NULL already. A race with 
i915_master_destroy() or something else?

Hardware info, from the output of lspci -vnn:
------------------------------
00:02.0 VGA compatible controller [0300]: Intel Corporation Atom 
Processor D4xx/D5xx/N4xx/N5xx Integrated Graphics Controller [8086:a011] 
(prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device [1043:83ac]
	Flags: bus master, fast devsel, latency 0, IRQ 44
	Memory at f7e00000 (32-bit, non-prefetchable) [size=512K]
	I/O ports at dc00 [size=8]
	Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Memory at f7d00000 (32-bit, non-prefetchable) [size=1M]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Power Management version 2
	Kernel driver in use: i915
------------------------------

Regards,
Eugene

-- 
Eugene Shatokhin, ROSA Laboratory.
www.rosalab.com
