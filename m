Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935264Ab3DOIMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:12:24 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:65241 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933542Ab3DOIMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:12:23 -0400
X-IronPort-AV: E=Sophos;i="4.87,473,1363132800"; 
   d="scan'208";a="3547628"
Message-ID: <516BB673.9060308@citrix.com>
Date: Mon, 15 Apr 2013 10:12:35 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH v1 2/7] xen-blkback: use balloon pages for
 all mappings
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com> <1364382643-3711-3-git-send-email-roger.pau@citrix.com> <20130409144733.GA3158@phenom.dumpdata.com> <516BB4C6.8090101@citrix.com>
In-Reply-To: <516BB4C6.8090101@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Perhaps you could update the comment from saying 'map this grant' (which
>> implies doing it NOW as opposed to have done it already), and say:
>>
>> /*
>> .. continue using the grant non-persistently. Note that
>> we mapped it in the earlier loop and the earlier if conditional
>> sets pending_handle(pending_req, i) = map[j].handle.
>> */
>>
>>
>>
>>>                       }
>>> -                     pending_handle(pending_req, i) =
>>> -                             persistent_gnts[i]->handle;
>>> -
>>> -                     if (ret)
>>> -                             continue;
>>> -             } else {
>>> -                     pending_handle(pending_req, i) = map[j++].handle;
>>> -                     bitmap_set(pending_req->unmap_seg, i, 1);
>>> -
>>> -                     if (ret)
>>> -                             continue;
>>> +                     persistent_gnt->gnt = map[j].ref;
>>> +                     persistent_gnt->handle = map[j].handle;
>>> +                     persistent_gnt->page = pages[i];
>>
>> Oh boy, that is a confusing. i and j. Keep loosing track which one is which.
>> It lookis right.
>>
>>> +                     if (add_persistent_gnt(&blkif->persistent_gnts,
>>> +                                            persistent_gnt)) {
>>> +                             kfree(persistent_gnt);
>>
>> I would also say 'persisten_gnt = NULL' for extra measure of safety

This loop was not completely right, I failed to set the unmap_seg bit if
we tried to map the grant persistently and failed, we would just jump to
next without doing:

bitmap_set(pending_req->unmap_seg, seg_idx, 1);
