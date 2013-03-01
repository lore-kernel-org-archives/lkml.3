Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab3CALEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:04:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:20384 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab3CALEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:04:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,761,1355126400"; 
   d="scan'208";a="269533762"
From: "Bi, Chao" <chao.bi@intel.com>
To: Jiri Slaby <jslaby@suse.cz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>,
        "Pillet, VincentX" <vincentx.pillet@intel.com>
Subject: RE: [PATCH] n_gsm: Add Mutex to avoid race when net destroy
Thread-Topic: [PATCH] n_gsm: Add Mutex to avoid race when net destroy
Thread-Index: AQHOFXI6rEqTNkU+SkWPQH++q2AeHZiOgcmAgAGBQ4CAAAUhgIAAnpUg
Date: Fri, 1 Mar 2013 11:04:03 +0000
Message-ID: <253F3AA5ECB4EC43A2CA0147545F67F2102E4FB4@SHSMSX102.ccr.corp.intel.com>
References: <1362029486.31563.5.camel@bichao>  <512F28FD.9030502@suse.cz>
 <1362127915.31563.18.camel@bichao> <51307079.2050905@suse.cz>
In-Reply-To: <51307079.2050905@suse.cz>
Accept-Language: en-US
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r21B4As2020250


-----Original Message-----
From: Jiri Slaby [mailto:jirislaby@gmail.com] On Behalf Of Jiri Slaby
Sent: Friday, March 01, 2013 5:10 PM
To: Bi, Chao
Cc: Greg Kroah-Hartman; linux-kernel@vger.kernel.org; ML netdev; Pillet, VincentX
Subject: Re: [PATCH] n_gsm: Add Mutex to avoid race when net destroy

On 03/01/2013 09:51 AM, channing wrote:
>> It should stop the queue and schedule a workqueue to lock the mutex, 
>> unregister the hetdev and reset dlci->net. (Or maybe just call 
>> muxnet_put with the lock held.)
> 
> Thanks, Jiri, you're right, I didn't notice that in validation because 
> DEBUG_ATOMIC_SLEEP is not enabled in my platform :( Now I'm trying to 
> work out the workqueue solution, when it finished I'll re-submit for 
> review. What do you mean by "call muxnet_put with lock held"? do you 
> mean to use spin lock instead of mutex?

No, I mean, in the newly added scheduled work, to lock the mutex and simply call muxnet_put. That should fix it, right?

[chao] Yes, that's to only move muxnet_put to scheduled work with mutex protected, and the rest of gsm_mux_net_start_xmit()
Is kept unchanged, and they are not in mutex lock. It could avoid race of net_free().
I'm not sure if it's safe enough, I mean if dlci->net is released before STATS(net) in gsm_mux_net_start_xmit(), will STATS(net) access unreliable data?

--
js
suse labs
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
