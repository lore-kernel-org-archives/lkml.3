Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab3G2ORE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:17:04 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:39131 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab3G2ORB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:17:01 -0400
Message-ID: <51F67959.2060803@fastmail.fm>
Date: Mon, 29 Jul 2013 16:16:57 +0200
From: Bernd Schubert <bernd.schubert@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        nick.cheng@areca.com.tw
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup
 / early userspace transition
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm> <87mwp5frdl.fsf@spindle.srvr.nix>
In-Reply-To: <87mwp5frdl.fsf@spindle.srvr.nix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: UTF-8
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 03:05 PM, Nix wrote:
> On 29 Jul 2013, Bernd Schubert said:
>
>> Hi Nick,
>>
>> On 07/29/2013 12:10 PM, Nick Alcock wrote:
>>> arcmsr0: abort device command of scsi id = 0 lun = 1
>>> arcmsr0: abort device command of scsi id = 0 lun = 0
>>> arcmsr: executing bus reset eh.....num_resets=0, num_[...]
>>>
>>> arcmsr0: wait 'abort all outstanding command' timeout
>>> arcmsr0: executing hw bus reset ....
>>> arcmsr0: waiting for hw bus reset return, retry=0
>>> arcmsr0: waiting for hw bus reset return, retry=1
>>> Areca RAID Controller0: F/W V1.46 2009-01-06 & Model ARC-1210
>>> arcmsr: scsi  bus reset eh returns with success
>>> [and back to the top of the error messages again, apparently forever,
>>>    not that the machine would be much use without its RAID array even
>>>    if this loop terminated at some point, so I only gave it a couple
>>>    of minutes]
>>>
>>> The failure happens precisely at the moment we transition to early
>>> userspace, so presumably userspace I/O is failing (or something related
>>> to raw device access, perhaps, since the first thing it does is a
>>> vgscan).
>>>
>>> I haven't bisected yet (sorry, I have work to do which means this
>>> machine must be running right now), but nothing has changed in the
>>> arcmsr controller, nor in SCSI-land excepting
>>>
>>> commit 98dcc2946adbe4349ef1ef9b99873b912831edd4
>>> Author: Martin K. Petersen <martin.petersen@oracle.com>
>>> Date:   Thu Jun 6 22:15:55 2013 -0400
> [...]
>>> Obviously, at this point, this machine has no modules loaded (it has
>>> almost none loaded even when fully operational)
>>
>> I tested this patch with ARC-1260 and F/W V1.49, no issues. Also, this
>> patch is only in 3.10.3, but not yet in 3.10.1.
>
> ... and I see this problem with 3.10.3 but not 3.10.1. (Haven't tried
> 3.10.2.)

Hmm, indeed that points to this commit. I just don't see what could fail 
there.

Could you try to run these commands with 3.10.1?

# # check if reporting opcodes works
# sg_opcodes -v  -n /dev/sdX

# check ata information page
# sg_vpd --page=0x89 /dev/sdX

>
>>                                                  And I don't think this
>> commit can cause your issue at all, a failing heuristics would enable
>> WRITE SAME and would cause issues with linux-md, but there shouldn't
>> happen anything directly in the scsi-layer. Which was your last
>> working kernel version?
>
> 3.10.1. :)

Whoops, sorry, I missed that in your first sentence.

>
> No changes to arcmsr between those versions... I suspect I'll have to
> bisect, which will be a complete pig because every failure means a hard
> powerdown of this box. Always-on servers rarely appreciate hard
> powerdowns :(
>

Maybe just revert this commit? Helpful would be some scsi logging to see 
which command actually fails. I guess you don't have a serial console?


Thanks,
Bernd
