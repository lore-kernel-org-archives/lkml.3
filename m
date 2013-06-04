Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3FDJfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:35:15 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:59435 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3FDJfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:35:11 -0400
Message-ID: <51ADB484.3060404@huawei.com>
Date: Tue, 4 Jun 2013 17:33:56 +0800
From: Libo Chen <libo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <megaraidlinux@lsi.com>, <JBottomley@parallels.com>
CC: Libo Chen <chenlibo.3@gmail.com>, <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <kashyap.desai@lsi.com>,
        <aradford@gmail.com>, Li Zefan <lizefan@huawei.com>,
        Santosh Y <santoshsy@gmail.com>, Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2] scsi: megaraid: check kzalloc
References: <519ECEF1.9060804@huawei.com> <519F3592.4090207@huawei.com>
In-Reply-To: <519F3592.4090207@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we should check kzalloc, avoid to hit oops

Change from v1:
- put kzalloc outside of mutex

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/scsi/megaraid.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 846f475..cc599cc 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4150,6 +4150,12 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 	if (!scmd)
 		return -ENOMEM;

+	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
+	if (!sdev) {
+		scsi_free_command(GFP_KERNEL, scmd);
+		return -ENOMEM;
+	}
+
 	/*
 	 * The internal commands share one command id and hence are
 	 * serialized. This is so because we want to reserve maximum number of
@@ -4160,7 +4166,6 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 	scb = &adapter->int_scb;
 	memset(scb, 0, sizeof(scb_t));

-	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
 	scmd->device = sdev;

 	memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
-- 
1.7.1


