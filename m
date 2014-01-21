Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaAUWns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:43:48 -0500
Received: from fep22.mx.upcmail.net ([62.179.121.42]:47508 "EHLO
	fep22.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaAUWnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:43:46 -0500
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <52DEF805.6070709@odi.ch>
Date: Tue, 21 Jan 2014 23:43:17 +0100
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, christian.koenig@amd.com,
        alexander.deucher@amd.com
Subject: drm/radeon bisected 3.13 regression: GPU lockup
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am seeing a GPU lockup since v3.13:

[   55.762710] radeon 0000:01:00.0: GPU lockup CP stall for more than 10000msec
[   55.762715] radeon 0000:01:00.0: GPU lockup (waiting for 0x0000000000000004 
last fence id 0x000000000000000 on ring 5)
[   55.762717] [drm:uvd_v1_0_ib_test] *ERROR* radeon: fence wait failed (-35).
[   55.762720] [drm:radeon_ib_ring_tests] *ERROR* radeon: failed testing IB on 
ring 5 (-35).

Hardware is an iMac 11,2 with a Radeon 4670 M96XT (RV730), 256MB GDDR3.


Bisected to this commit:

commit f9eaf9ae782d6480f179850e27e6f4911ac10227
Author: Christian König <christian.koenig@amd.com>
Date:   Tue Oct 29 20:14:47 2013 +0100

     drm/radeon: rework and fix reset detection v2

     Stop fiddling with jiffies, always wait for RADEON_FENCE_JIFFIES_TIMEOUT.
     Consolidate the two wait sequence implementations into just one function.
     Activate all waiters and remember if the reset was already done instead of
     trying to reset from only one thread.

     v2: clear reset flag earlier to avoid timeout in IB test

Unfortunately this patch no longer cleanly unapplies on v3.13.
