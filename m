Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289Ab3EXJmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:42:45 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:19798 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab3EXJmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:42:42 -0400
Message-ID: <519F3592.4090207@huawei.com>
Date: Fri, 24 May 2013 17:40:34 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <megaraidlinux@lsi.com>, <JBottomley@parallels.com>
CC: <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <kashyap.desai@lsi.com>, <aradford@gmail.com>,
        Li Zefan <lizefan@huawei.com>, Santosh Y <santoshsy@gmail.com>
Subject: [PATCH RESEND] scsi: megaraid: check kzalloc
References: <519ECEF1.9060804@huawei.com>
In-Reply-To: <519ECEF1.9060804@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we should check kzalloc, avoid to hit oops

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/scsi/megaraid.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

instead of checking scmd->device, sdev is more appropriate.

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 846f475..6b623cb 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4161,6 +4161,10 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 	memset(scb, 0, sizeof(scb_t));

 	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
+	if (sdev) {
+		scsi_free_command(GFP_KERNEL, scmd);
+		return -ENOMEM;
+	}
 	scmd->device = sdev;

 	memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
-- 
1.7.1



