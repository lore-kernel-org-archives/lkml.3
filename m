Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbbAHATN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:19:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26302 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbAHATL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:19:11 -0500
To: "Sam Bradshaw \(sbradshaw\)" <sbradshaw@micron.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "axboe\@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: pass correct seed to integrity metadata generation function
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <54936D1E.3020700@micron.com> <54ADBC6E.50301@micron.com>
	<yq14ms25g21.fsf@sermon.lab.mkp.net>
	<80B89753B40C5141A3E2D53FE7A2A8A994634D2A@NTXBOIMBX02.micron.com>
	<yq1r3v640pg.fsf@sermon.lab.mkp.net>
	<80B89753B40C5141A3E2D53FE7A2A8A994634DCA@NTXBOIMBX02.micron.com>
Date: Wed, 07 Jan 2015 19:19:04 -0500
In-Reply-To: <80B89753B40C5141A3E2D53FE7A2A8A994634DCA@NTXBOIMBX02.micron.com>
	(Sam Bradshaw's message of "Wed, 7 Jan 2015 23:46:13 +0000")
Message-ID: <yq1iogi3z0n.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sam" == Sam Bradshaw (sbradshaw) <sbradshaw@micron.com> writes:

Sam> Yes.

The seed is just a seed. We happen to set it to the (block layer) sector
number if nothing else is provided but it's essentially just an
incrementing counter starting at an arbitrary value chosen by the
caller.

Since an I/O may get remapped many times as block devices are stacked
(DM, MD, stripe splits, partition offset shifts, etc.) the seed is not
expected to match the LBA on the storage device. That is almost never
the case.

In SCSI we do a remapping pass before submitting a WRITE or upon
completion of a READ. You will have to do the same for NVMe.

It was done this way to avoid remapping the ref tag several times. We
adjust the seed as the I/O gets sliced and diced and only map the PI
pages once to do a single traversal at the bottom of the stack.

For next gen devices we simply pass the seed to the hardware and let it
handle the remapping. This saves us having to map the PI pages and pull
them through the cache.

-- 
Martin K. Petersen	Oracle Linux Engineering
