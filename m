Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab3GZBaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 21:30:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:56691 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab3GZBaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 21:30:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,746,1367996400"; 
   d="scan'208";a="351872425"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "minyard@acm.org" <minyard@acm.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: RE: [PATCH 03/13] ACPI/IPMI: Fix race caused by the unprotected
 ACPI IPMI transfers
Thread-Topic: [PATCH 03/13] ACPI/IPMI: Fix race caused by the unprotected
 ACPI IPMI transfers
Thread-Index: AQHOh3wQ2mCt+ewJ/06ynzhP2RS7T5lz+KeAgAC35UCAABk4AIAAZj4AgADqUHD//4QtgIAAkOsQ
Date: Fri, 26 Jul 2013 01:30:05 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802435B2C@SHSMSX101.ccr.corp.intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com>
 <1520893.BbRK6T3F73@vostro.rjw.lan>
 <1AE640813FDE7649BE1B193DEA596E88024357A9@SHSMSX101.ccr.corp.intel.com>
 <76401540.gtU1MiBxPY@vostro.rjw.lan> <51F16A96.6040706@acm.org>
 <1AE640813FDE7649BE1B193DEA596E8802435A78@SHSMSX101.ccr.corp.intel.com>
 <51F1C745.60800@acm.org>
In-Reply-To: <51F1C745.60800@acm.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6Q1UYA6008384

> From: Corey Minyard [mailto:tcminyard@gmail.com]
> Sent: Friday, July 26, 2013 8:48 AM
> 
> On 07/25/2013 07:16 PM, Zheng, Lv wrote:
> >>
> >> If I understand this correctly, the problem would be if:
> >>
> >> rem_time = wait_for_completion_timeout(&tx_msg->tx_complete,
> >>                                           IPMI_TIMEOUT);
> >>
> >> returns on a timeout, then checks msg_done and races with something
> >> setting msg_done.  If that is the case, you would need the smp_rmb()
> >> before checking msg_done.
> >>
> >> However, the timeout above is unnecessary.  You are using
> >> ipmi_request_settime(), so you can set the timeout when the IPMI
> >> command fails and returns a failure message.  The driver guarantees a
> >> return message for each request.  Just remove the timeout from the
> >> completion, set the timeout and retries in the ipmi request, and the
> >> completion should handle the barrier issues.
> > It's just difficult for me to determine retry count and timeout value, maybe
> retry=0, timeout=IPMI_TIMEOUT is OK.
> > The code of the timeout completion is already there, I think the quick fix code
> should not introduce this logic.
> > I'll add a new patch to apply your comment.
> 
> Since it is a local BMC, I doubt a retry is required.  That is probably fine.  Or
> you could set retry=1 and timeout=IPMI_TIMEOUT/2 if you wanted to be more
> sure, but I doubt it would make a difference.  The only time you really need to
> worry about retries is if you are resetting the BMC or it is being overloaded.

I think for ACPI IPMI operation region, retries can be implemented in the ASL codes by the BIOS.
I'll check if retry=0 is correct.

> 
> >
> >> Plus, from a quick glance at the code, it doesn't look like it will
> >> properly handle a situation where the timeout occurs and is handled
> >> then the response comes in later.
> > PATCH 07 fixed this issue.
> > Here we just need the smp_rmb() or holding tx_msg_lock() around the
> acpi_format_ipmi_response().
> 
> If you apply the fix like I suggest, then the race goes away.  If there's no
> timeout and it just waits for the completion, things get a lot simpler.

Exactly.  I'll try to apply this in this patch, then the PATCH 07 is also need to be re-worked.

Thanks and best regards
-Lv


> >
> > Thanks for commenting.
> 
> No problem, thanks for working on this.
> 
> -corey
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
