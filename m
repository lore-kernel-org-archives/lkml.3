Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3LPNCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:02:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab3LPNCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:02:01 -0500
Date: Mon, 16 Dec 2013 14:01:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>, thomas@m3y3r.de, list@osuosl.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>, open@osuosl.org,
        HID CORE LAYER <linux-input@vger.kernel.org>,
        devel@linuxdriverproject.org
Subject: Re: [v3.11][Regression] HID: hyperv: convert alloc+memcpy to
 memdup
In-Reply-To: <52459942.3020600@canonical.com>
Message-ID: <alpine.LNX.2.00.1312161401100.12882@pobox.suse.cz>
References: <5237430B.5040009@canonical.com> <20130916203824.GP25896@mwanda> <52376ED9.5080208@canonical.com> <20130916210503.GQ25896@mwanda> <5237A5D5.8010006@canonical.com> <alpine.LNX.2.00.1309241129370.18703@pobox.suse.cz> <52432152.3030100@canonical.com>
 <alpine.LNX.2.00.1309271250130.18703@pobox.suse.cz> <52459942.3020600@canonical.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Sep 2013, Joseph Salisbury wrote:

> >> commit b1a1442a23776756b254b69786848a94d92445ba
> >> Author: Jiri Kosina <jkosina@suse.cz>
> >> Date: Mon Jun 3 11:27:48 2013 +0200
> >>
> >>     HID: core: fix reporting of raw events
> >>
> >> Reverting this commit in v3.12-rc2 prevents the system from locking up, 
> >> which happens when connecting a bluetooth trackpad.
> >>
> >> Jiri, do you think we should revert this patch, or is there some further 
> >> debugging/data collecting you would like to do?
> > Hi Joseph,
> >
> > in this mail:
> >
> > 	Message-ID: <5241992E.3090805@canonical.com>
> > 	Date: Tue, 24 Sep 2013 09:52:46 -0400
> >
> > you said that reverting this commit doesn't prevent the lockups, so I am 
> > rather confused ... ?
> >
> > Thanks,
> >
> The testing was invalid.  Reverting commit b1a1442 does resolve the bug
> and stop the lockups.

Okay, I finally got some sense of this, sorry for the delay.

Could you please test with the patch below, instead of reverting 
b1a1442a23? Thanks a lot.



diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 253fe23..81eacd3 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1334,7 +1334,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 		csize--;
 	}
 
-	rsize = ((report->size - 1) >> 3) + 1;
+	rsize = ((report->size - 1) >> 3) + 1 + (report->id > 0) + 7;
 
 	if (rsize > HID_MAX_BUFFER_SIZE)
 		rsize = HID_MAX_BUFFER_SIZE;

-- 
Jiri Kosina
SUSE Labs
