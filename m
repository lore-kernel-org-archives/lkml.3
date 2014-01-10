Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaAJW1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 17:27:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49533 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaAJW1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 17:27:41 -0500
Message-ID: <52D073F0.5020400@oracle.com>
Date: Fri, 10 Jan 2014 17:28:00 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: konrad.wilk@oracle.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com
Subject: Re: [PATCH] xen-blkfront: remove type check from blkfront_setup_discard
References: <1389371301-29532-1-git-send-email-olaf@aepfle.de> <52D036FC.6000308@oracle.com> <20140110213746.GA933@aepfle.de>
In-Reply-To: <20140110213746.GA933@aepfle.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 04:37 PM, Olaf Hering wrote:
> On Fri, Jan 10, Boris Ostrovsky wrote:
>
>> If the call below fails, is it safe to continue using discard feature? At
>> the least, are discard_granularity and discard_alignment guaranteed to have
>> sane/safe values?
> Its up to the toolstack to provide sane values. In the worst case
> discard fails. In this specific case the three values are optional, so
> the calls can fail. I do not know what happens if the backend device
> actually needs the values, but the frontend can not send proper discard
> requests. Hopefully it will not damage the hardware..

I don't know discard code works but it seems to me that if you pass, for 
example,  zero as discard_granularity (which may happen if 
xenbus_gather() fails) then blkdev_issue_discard() in the backend will 
set granularity to 1 and continue with discard. This may not be what the 
the guest admin requested. And he won't know about this since no error 
message is printed anywhere.

Similarly, if xenbug_gather("discard-secure") fails, I think the code 
will assume that secure discard has not been requested. I don't know 
what security implications this will have but it sounds bad to me.

I think we should at clear feature_discard and print an error in the log 
if *either* of xenbus_gather() calls fail.


-boris
