Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaAMOvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:51:03 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47599 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaAMOu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:50:59 -0500
Message-ID: <52D3FD67.2060708@oracle.com>
Date: Mon, 13 Jan 2014 09:51:19 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: konrad.wilk@oracle.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com
Subject: Re: [PATCH] xen-blkfront: remove type check from blkfront_setup_discard
References: <1389371301-29532-1-git-send-email-olaf@aepfle.de> <52D036FC.6000308@oracle.com> <20140110213746.GA933@aepfle.de> <52D073F0.5020400@oracle.com> <20140113093032.GA13919@aepfle.de>
In-Reply-To: <20140113093032.GA13919@aepfle.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 04:30 AM, Olaf Hering wrote:
> On Fri, Jan 10, Boris Ostrovsky wrote:
>
>> I don't know discard code works but it seems to me that if you pass, for
>> example,  zero as discard_granularity (which may happen if xenbus_gather()
>> fails) then blkdev_issue_discard() in the backend will set granularity to 1
>> and continue with discard. This may not be what the the guest admin
>> requested. And he won't know about this since no error message is printed
>> anywhere.
> If I understand the code using granularity/alignment correctly, both are
> optional properties. So if the granularity is just 1 it means byte
> ranges, which is fine if the backend uses FALLOC_FL_PUNCH_HOLE. Also
> both properties are not admin controlled, for phy the blkbk drivers just
> passes on what it gets from the underlying hardware.
>
>> Similarly, if xenbug_gather("discard-secure") fails, I think the code will
>> assume that secure discard has not been requested. I don't know what
>> security implications this will have but it sounds bad to me.
> There are no security implications, if the backend does not advertise it
> then its not present.

Right. But my questions was what if the backend does advertise it and 
wants the frontent to use it but xenbus_gather() in the frontend fails. 
Do we want to silently continue without discard-secure? Is this safe?


-boris

>
> After poking around some more it seems that blkif.h is the spec, it does
> not say anything that the three properties are optional. Also the
> backend drivers in sles11sp2 and mainline create all three properties
> unconditionally. So I think a better change is to expect all three
> properties in the frontend. I will send another version of the patch.
>
>
> Olaf

