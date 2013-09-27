Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3I0QAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:00:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38258 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab3I0QAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:00:17 -0400
Date: Fri, 27 Sep 2013 18:59:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>, list@osuosl.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>, open@osuosl.org,
        HID CORE LAYER <linux-input@vger.kernel.org>,
        devel@linuxdriverproject.org, thomas@m3y3r.de
Subject: Re: [v3.11][Regression] HID: hyperv: convert alloc+memcpy to memdup
Message-ID: <20130927155941.GG6247@mwanda>
References: <5237430B.5040009@canonical.com>
 <20130916203824.GP25896@mwanda>
 <52376ED9.5080208@canonical.com>
 <20130916210503.GQ25896@mwanda>
 <5237A5D5.8010006@canonical.com>
 <alpine.LNX.2.00.1309241129370.18703@pobox.suse.cz>
 <52432152.3030100@canonical.com>
 <alpine.LNX.2.00.1309271250130.18703@pobox.suse.cz>
 <52459942.3020600@canonical.com>
 <20130927152412.GF6192@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927152412.GF6192@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 06:24:12PM +0300, Dan Carpenter wrote:
> 
> It looks like magicmouse_raw_event() returns 1 on success and 0 on
> failure.

Fixing the return codes is a good idea but it won't fix the oops.

What's the point of returning 1 and 0?  In the current code no one
cares and both are treated the same.

Also if we decide to fix this instead of reverting the we could do this
cleanup as well:

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index b8470b1..868ebaa 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1417,10 +1417,8 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int i
 
 	if (hdrv && hdrv->raw_event && hid_match_report(hid, report)) {
 		ret = hdrv->raw_event(hid, report, data, size);
-		if (ret < 0) {
-			ret = ret < 0 ? ret : 0;
+		if (ret < 0)
 			goto unlock;
-		}
 	}
 
 	ret = hid_report_raw_event(hid, type, data, size, interrupt);
