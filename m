Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154Ab3BXTiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 14:38:46 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:37227 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab3BXTip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 14:38:45 -0500
Message-ID: <512A6C42.8080508@lwfinger.net>
Date: Sun, 24 Feb 2013 13:38:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        =?UTF-8?B?TWljaGE=?= =?UTF-8?B?ZWwgQsO8c2No?= <m@bues.ch>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep splat when unloading b43
References: <512A4E83.5090901@lwfinger.net>  (sfid-20130224_183218_530192_A4B69F12) <1361729697.8129.19.camel@jlt4.sipsolutions.net>
In-Reply-To: <1361729697.8129.19.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2013 12:14 PM, Johannes Berg wrote:
> On Sun, 2013-02-24 at 11:31 -0600, Larry Finger wrote:

Thanks for the detailed analysis. It was very helpful.

> Here request_firmware calls wiphy_register which locks the RTNL, and
> it's running from the work struct. This was newly introduced by commit
> ecb4433550f0620f3d1471ae7099037ede30a91e
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Fri Aug 12 14:00:59 2011 +0200
>
>      mac80211: fix suspend/resume races with unregister hw

That commit may bear some responsibility, but commit 
6b6fa5868eec26bdc6a83543cebb8cf832a2645a
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Thu Mar 8 22:27:46 2012 -0600

     b43: Load firmware from a work queue and not from the probe routine

is also at fault.

> Anyway, the solution probably is to move the cancel_work_sync into
> something like the ssb deregister.

This fix was also suggested by Michael - it works.

The change to load the firmware from a work queue failed when b43 was built into 
the kernel, which required commit 5e20a4b53094651d80f856ff55a916b999dbb57a
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Thu Dec 20 15:55:01 2012 -0600

     b43: Fix firmware loading when driver is built into the kernel

I probably should do a rewrite of firmware loading, but that is unlikely to 
happen. Fortunately, moving the cancel work call is a small enough change that 
it can be backported to stable.

Thanks,

Larry

