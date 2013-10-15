Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab3JOFvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:51:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932877Ab3JOFva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:51:30 -0400
Message-ID: <525CD7E0.7050809@suse.de>
Date: Tue, 15 Oct 2013 07:51:28 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: vaughan <vaughan.cao@oracle.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan
 in the middle
References: <525AD704.6040705@oracle.com> <525BD1EA.6000701@suse.de> <525CB742.4010409@oracle.com>
In-Reply-To: <525CB742.4010409@oracle.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 05:32 AM, vaughan wrote:
> On 10/14/2013 07:13 PM, Hannes Reinecke wrote:
>> In the log, inquiry to LUN7 return a sense - asc,ascq=04h,0Ch
>> (Logical unit not accessible, target port in unavailable state).
>> And this is ignored, so scsi_probe_lun() returns -EIO and the scan
>> process is aborted.
>>
>> I have two questions:
>> 1. Is it correct for hardware to return a sense 04h,0Ch to inquiry
>> again, even after presenting this lun in responce to REPORT_LUN
>> command?
>> Yes, this is correct. 'REPORT LUNS' is supported in 'Unavailable' state.
>>
>>> 2. Since windows and solaris can continue scan, is it reasonable for
>>> linux to do the same, even for a fault-tolerance purpose?
>>>
>> Hmm. Yes, and no.
>>
>> _Actually_ this is an issue with the target, as it looks as if it
>> will return the above sense code while sending an 'INQUIRY' to the
>> device.
>> SPC explicitely states that the INQUIRY command should _not_ fail
>> for unavailable devices.
> Hi all,
> 
> I found this below in spc4.
>>>>
> 5.15.2.4.4 Target port group asymmetric access states - Standby state
> While in the unavailable primary target port asymmetric access state,
> the device server shall support those of
> the following commands that it supports while in the active/optimized state:
> a) INQUIRY (the peripheral qualifier (see 6.6.2) shall be set to 001b);
> ....
> For those commands that are not supported, the device server shall
> terminate the command with CHECK
> CONDITION status, with the sense key set to NOT READY, and the
> additional sense code set to LOGICAL
> UNIT NOT ACCESSIBLE, TARGET PORT IN UNAVAILABLE STATE.
> <<<
> From the above, I suppose the hardware may works very compliant with
> spc. The case could be:
> Storage is a alua supported target. Initiator sent REPORT_LUN to target,
> target return all pqual=000b to it.
> Then Initiator INQUIRY lun 7 which is in standby state where pqual=000b
> not 001b. So this INQUIRY is regarded as
> 'not supported', and get terminated with CHECK_CONDITION,  sense key=NOT
> READY, asc,ascq=04h,0ch.
> 
> Could you confirm if my understanding is right or wrong?
> 
Wrong.

The sentence states that the device server _shall_ support those
commands, where the results should be identical as if the port would
have been in active/optimized state.

So INQUIRY always has to be supported, regardless of which primary
ALUA state the port happens to be in.

(Otherwise we'd be hard-pressed to figure out whether the port is in
'unavailable' ALUA state in the first place, as without the INQUIRY
data we couldn't even _tell_ if ALUA is supported.)

So yeah, it really looks like a firmware issue here.

But that notwithstanding, did you get a chance to test my patch?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
