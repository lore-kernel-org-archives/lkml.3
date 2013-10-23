Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3JWBhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:37:23 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2388 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119Ab3JWBhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:37:21 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Ray Jui" <rjui@broadcom.com>
To: "Seungwon Jeon" <tgih.jun@samsung.com>, "'Chris Ball'" <cjb@laptop.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: MMC request with REQ_DISCARD option may not release host
 when it should
Thread-Topic: MMC request with REQ_DISCARD option may not release host
 when it should
Thread-Index: Ac7PbYu0mJta9GE3SVOQcBWDELh/QAAGeKBQAAIxWiA=
Date: Wed, 23 Oct 2013 01:37:09 +0000
Message-ID: <1C995FCD38EDD646A035D3E5892E8C7C04C16A13@SJEXCHMB13.corp.ad.broadcom.com>
References: <1C995FCD38EDD646A035D3E5892E8C7C04C1674F@SJEXCHMB13.corp.ad.broadcom.com>
 <000a01cecf8b$ab6c0530$02440f90$%jun@samsung.com>
In-Reply-To: <000a01cecf8b$ab6c0530$02440f90$%jun@samsung.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E79F7C8150438506-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seungwon,

Thanks for your reply. I'll try my best to find time and submit my patch within the next couple days.

Thanks,

Ray

-----Original Message-----
From: Seungwon Jeon [mailto:tgih.jun@samsung.com] 
Sent: Tuesday, October 22, 2013 6:03 PM
To: Ray Jui; 'Chris Ball'
Cc: linux-kernel@vger.kernel.org
Subject: RE: MMC request with REQ_DISCARD option may not release host when it should

Hi Ray,

Thank you for information. Your analysis is right.
I also noticed same problem.
If you'd like to submit patch, not to report, please send it with regular form.
Or I could send similar patch I have.

Thanks,
Seungwon Jeon

On Wed, Oct 23, 2013, Ray Jui wrote:
Hi Seungwon/Chris,

We recently came across an eMMC issue that causes mmc_suspend to stuck waiting to claim the host. This issue only happens when one
of the MMC partitions is mounted with the discard option. By tracing the issue down in the kernel MMC stack, in the function
mmc_blk_issue_rq under drivers/mmc/card/block.c, we noticed the host will be released when req is valid and when req->cmd_flags is
set to one of the masks: MMC_REQ_SPECIAL_MASK. Based on the code comment, I believe the intention is to always release the host in
the case of special request (which include both REQ_DISCARD and REQ_FLUSH).

Note in function call mmc_blk_issue_discard_rq, the memory where req points to can be freed. This means at the bottom of the
mmc_blk_issue_rq, req->cmd_flags may contain garbage value and I believe this is what's causing the issue that we are seeing in
mmc_suspend after the discard operation: In mmc_suspend, it blocks waiting to claim the host but the host was never released after
the discard operation.

Please help to review the attached patch that fixes the issue.

Thanks,

Ray Jui



