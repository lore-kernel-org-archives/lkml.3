Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab3CZRsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:48:06 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:17514 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab3CZRsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:48:03 -0400
X-IronPort-AV: E=Sophos;i="4.84,913,1355097600"; 
   d="scan'208";a="2933517"
Message-ID: <5151DF50.1060009@citrix.com>
Date: Tue, 26 Mar 2013 18:48:00 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH RFC 08/12] xen-blkback: use balloon pages for all mappings
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com> <1362047335-26402-9-git-send-email-roger.pau@citrix.com> <20130304202248.GK15386@phenom.dumpdata.com>
In-Reply-To: <20130304202248.GK15386@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/13 21:22, Konrad Rzeszutek Wilk wrote:
>> @@ -194,14 +260,15 @@ static void add_persistent_gnt(struct rb_root *root,
>>               else if (persistent_gnt->gnt > this->gnt)
>>                       new = &((*new)->rb_right);
>>               else {
>> -                     pr_alert(DRV_PFX " trying to add a gref that's already in the tree\n");
>> -                     BUG();
>> +                     pr_alert_ratelimited(DRV_PFX " trying to add a gref that's already in the tree\n");
>> +                     return -EINVAL;
> 
> That looks like a seperate bug-fix patch? Especially the pr_alert_ratelimited
> part?

Not really, the way we added granted frames before this patch, it was
never possible to add a persistent grant with the same gref twice.

With the changes introduced in this patch we first map the grants and
then we try to make them persistent by adding them to the tree. So it is
possible for a frontend to craft a malicious request that has the same
gref in all segments, and when we try to add them to the tree of
persistent grants we would hit the BUG, that's why we need to ratelimit
the alert (to prevent flooding), and return EINVAL instead of crashing.
