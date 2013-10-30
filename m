Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3J3Q2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:28:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab3J3Q1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:27:33 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: linux-edac@vger.kernel.org
Cc: tony.luck@intel.com, Aristeu Rozanski <arozansk@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com> (maintainer:EDAC-SBRIDGE),
        Doug Thompson <dougthompson@xmission.com> (supporter:EDAC-CORE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 11/12] sb_edac: avoid decoding the same error multiple times
Date: Wed, 30 Oct 2013 12:27:05 -0400
Message-Id: <1383150426-24730-12-git-send-email-arozansk@redhat.com>
In-Reply-To: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever the extended error reporting is active, multiple MCEs will be
generated for the same event, which will lead to multiple repeated
errors to be reported. So check ADDRV and only decode the error if the
MCE address is valid.

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
---
 drivers/edac/sb_edac.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 2e977b9..3c2f52b 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1410,6 +1410,10 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 		}
 	}
 
+	/* Only decode errors with an valid address (ADDRV) */
+	if (!GET_BITFIELD(m->status, 58, 58))
+		return;
+
 	rc = get_memory_error_data(mci, m->addr, &socket,
 				   &channel_mask, &rank, &area_type, msg);
 	if (rc < 0)
-- 
1.7.1

