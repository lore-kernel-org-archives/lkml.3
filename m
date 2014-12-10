Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbaLJUxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:53:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22830 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbaLJUxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:53:32 -0500
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: martin.petersen@oracle.com, jejb@kernel.org, hch@infradead.org,
        linux-scsi@vger.kernel.org, JBottomley@Parallels.com,
        Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/22] [SCSI] mpt2sas, mpt3sas: Removing uppper boundary restriction for the module parameter max_sgl_entries
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1418131643-11568-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Date: Wed, 10 Dec 2014 15:52:58 -0500
In-Reply-To: <1418131643-11568-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Tue, 9 Dec 2014 18:57:23 +0530")
Message-ID: <yq1wq5zcjmd.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

@@ -2486,9 +2486,13 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 
 	/* command line tunables  for max sgl entries */
 	if (max_sgl_entries != -1) {
-		ioc->shost->sg_tablesize = (max_sgl_entries <
-		    MPT2SAS_SG_DEPTH) ? max_sgl_entries :
-		    MPT2SAS_SG_DEPTH;
+		if (max_sgl_entries > MPT2SAS_SG_DEPTH)
+			printk(MPT2SAS_WARN_FMT
+			 "setting max_sgl_entries(%d), overriding kernel"
+			 " defined SCSI_MAX_SG_SEGMENTS(%d)\n", ioc->name,
+			  max_sgl_entries, MPT2SAS_SG_DEPTH);
+		ioc->shost->sg_tablesize =  min_t(unsigned short,
+			     max_sgl_entries, SCSI_MAX_SG_CHAIN_SEGMENTS);
 	} else {
 		ioc->shost->sg_tablesize = MPT2SAS_SG_DEPTH;
 	}

Wouldn't it be better to print the new scatterlist limit after it has
been clamped to reflect what it's actually being set to?

-- 
Martin K. Petersen	Oracle Linux Engineering
