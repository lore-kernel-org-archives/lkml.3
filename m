Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab3DYWYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:24:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab3DYWYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:24:09 -0400
Subject: [PATCH 0/2] Protect against iommu driver disconnect
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com
Date: Thu, 25 Apr 2013 16:24:08 -0600
Message-ID: <20130425221546.14023.37372.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tsirkin pointed out that file operations on /dev/vfio/vfio
dereference iommu_driver and iommu_data without a lock.  If releasing
a group or unsetting the container occurs concurrently, we could race.
We currently use a mutex when setting this association, so we can
convert to a rwsem keeping the existing mutex critical sections as
down_writes and add down_reads where these are used.  Thanks,

Alex

---

Alex Williamson (2):
      vfio: Convert container->group_lock to rwsem
      vfio: Use down_reads to protect iommu disconnects


 drivers/vfio/vfio.c |   83 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 26 deletions(-)
