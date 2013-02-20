Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935081Ab3BTLYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:24:41 -0500
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64387 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934662Ab3BTLYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:24:38 -0500
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="24275521"
From: "Bu, Yitian" <ybu@qti.qualcomm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: RE: [PATCH] Fix rq->lock vs logbuf_lock unlock race
Thread-Topic: [PATCH] Fix rq->lock vs logbuf_lock unlock race
Thread-Index: AQHOD0aoTqiQYklW0USvuaYJaBrXc5iCd8nwgACXPYD//4TjYA==
Date: Wed, 20 Feb 2013 11:24:36 +0000
Message-ID: <E807E903FE6CBE4D95E420FBFCC273B827526E@nasanexd01h.na.qualcomm.com>
References: <E807E903FE6CBE4D95E420FBFCC273B827413C@nasanexd01h.na.qualcomm.com>
	 <1361349910.10155.0.camel@laptop>
	 <E807E903FE6CBE4D95E420FBFCC273B827522A@nasanexd01h.na.qualcomm.com>
 <1361355555.10155.14.camel@laptop>
In-Reply-To: <1361355555.10155.14.camel@laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.106.115.132]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1KBOihH003262

> Unfortunately that's not quite possible, rq->lock is really out of bounds. At
> one point I tried 'fixing' this but there's a whole bunch of nasty that's not
> going to go away.
> 
> I've since forgotten most of the details, but aside from logbuf problems
> there's a whole host of issues with the console drivers themselves as well.
> 
> If you really want to do this, use early_printk.

Hi Peter:

The patch  0b5e1c5255e("printk: Release console_sem after logbuf_lock" )
is as below:

			console_locked = 0;
-			up(&console_sem);
+			wake = 1;
 			retval = 0;
 		}
 	}
 	printk_cpu = UINT_MAX;
 	spin_unlock(&logbuf_lock);
+	if (wake)
+		up(&console_sem);
 	return retval;

the patch 07354eb1a74d1("locking, printk: Annotate logbuf_lock as raw ")
is as below:

	printk_cpu = UINT_MAX;
-	spin_unlock(&logbuf_lock);
 	if (wake)
 		up(&console_sem);
+	raw_spin_unlock(&logbuf_lock);
 	return retval;
 }

Note that the purpose of patch 07354eb1a74d1 is to use raw_spin_unlock
instead of spin_unlock, it is not supposed to change any lock sequences.

What I do is to revert this change to 0b5e1c5255e, and it is nothing to do with
how people use printk. It is just to recover a merge mistake.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
