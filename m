Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab3JNPZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:25:54 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:45385 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab3JNPZw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:25:52 -0400
Message-ID: <525C0CAE.3030803@linux.vnet.ibm.com>
Date: Mon, 14 Oct 2013 17:24:30 +0200
From: Steffen Maier <maier@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
CC: Vaughan Cao <vaughan.cao@oracle.com>, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan
 in the middle
References: <525AD704.6040705@oracle.com> <525BD1EA.6000701@suse.de> <525BE8C1.5090606@linux.vnet.ibm.com> <525BEF2B.2030907@suse.de> <525BF256.6060707@suse.de>
In-Reply-To: <525BF256.6060707@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101415-8372-0000-0000-0000077587B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 03:32 PM, Hannes Reinecke wrote:
> On 10/14/2013 03:18 PM, Hannes Reinecke wrote:
>> On 10/14/2013 02:51 PM, Steffen Maier wrote:
>>> On 10/14/2013 01:13 PM, Hannes Reinecke wrote:
>>>> On 10/13/2013 07:23 PM, Vaughan Cao wrote:
>>>>> [1.] One line summary of the problem:
>>>>> special sense code asc,ascq=04h,0Ch abort scsi scan in the middle
>>>>>
>>>>> [2.] Full description of the problem/report:
>>>>> For instance, storage represents 8 iscsi LUNs, however the LUN No.7
>>>>> is not well configured or has something wrong.
>>>>> Then messages received:
>>>>> kernel: scsi 5:0:0:0: Unexpected response from lun 7 while scanning, scan aborted
>>>>> Which will make LUN No.8 unavailable.
>>>>> It's confirmed that Windows and Solaris systems will continue the
>>>>> scan and make LUN No.1,2,3,4,5,6 and 8 available.
>>>>>
>>>>> Log snippet is as below:
>>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: scsi scan: INQUIRY pass 1 length 36
>>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Send: 0xffff8801e9bd4280
>>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: CDB: Inquiry: 12 00 00 00 24 00
>>>>> Aug 24 00:32:49 vmhodtest019 kernel: buffer = 0xffff8801f71fc180, bufflen = 36, queuecommand 0xffffffffa00b99e7
>>>>> Aug 24 00:32:49 vmhodtest019 kernel: leaving scsi_dispatch_cmnd()
>>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Done: 0xffff8801e9bd4280 SUCCESS
>>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
>>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: CDB: Inquiry: 12 00 00 00 24 00
>>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Sense Key : Not Ready [current]
>>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Add. Sense: Logical unit not accessible, target port in unavailable state
>>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: scsi host busy 1 failed 0
>>>>> Aug 24 00:32:49 vmhodtest019 kernel: 0 sectors total, 36 bytes done.
>>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi scan: INQUIRY failed with code 0x8000002
>>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:0: Unexpected response from lun 7 while scanning, scan aborted
>>>>>
>>>>> According to scsi_report_lun_scan(), I found:
>>>>> Linux use an inquiry command to probe a lun according to the result
>>>>> of report_lun command.
>>>>> It assumes every probe cmd will get a legal result. Otherwise, it
>>>>> regards the whole peripheral not exist or dead.
>>>>> If the return of inquiry passes its legal checking and indicates
>>>>> 'LUN not present', it won't break but also continue with the scan
>>>>> process.
>>>>> In the log, inquiry to LUN7 return a sense - asc,ascq=04h,0Ch
>>>>> (Logical unit not accessible, target port in unavailable state).
>>>>> And this is ignored, so scsi_probe_lun() returns -EIO and the scan
>>>>> process is aborted.
>>>>>
>>>>> I have two questions:
>>>>> 1. Is it correct for hardware to return a sense 04h,0Ch to inquiry
>>>>> again, even after presenting this lun in responce to REPORT_LUN
>>>>> command?
>>>> Yes, this is correct. 'REPORT LUNS' is supported in 'Unavailable' state.
>>>>
>>>>> 2. Since windows and solaris can continue scan, is it reasonable for
>>>>> linux to do the same, even for a fault-tolerance purpose?
>>>>>
>>>> Hmm. Yes, and no.
>>>>
>>>> _Actually_ this is an issue with the target, as it looks as if it
>>>> will return the above sense code while sending an 'INQUIRY' to the
>>>> device.
>>>> SPC explicitely states that the INQUIRY command should _not_ fail
>>>> for unavailable devices.
>>>> But yeah, we probably should work around this issues.
>>>> Nevertheless, please raise this issue with your array vendor.
>>>>
>>>> Please try the attached patch.
>>>>
>>>> Cheers,
>>>>
>>>> Hannes
>>>>
>>>
>>>>  From b0e90778f012010c881f8bdc03bce63a36921b77 Mon Sep 17 00:00:00 2001
>>>> From: Hannes Reinecke <hare@suse.de>
>>>> Date: Mon, 14 Oct 2013 13:11:22 +0200
>>>> Subject: [PATCH] scsi_scan: continue report_lun_scan after error
>>>>
>>>> When scsi_probe_and_add_lun() fails in scsi_report_lun_scan() this
>>>> does _not_ indicate that the entire target is done for.
>>>> So continue scanning for the remaining devices.
>>>>
>>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>>>
>>>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>>>> index 307a811..973a121 100644
>>>> --- a/drivers/scsi/scsi_scan.c
>>>> +++ b/drivers/scsi/scsi_scan.c
>>>> @@ -1484,13 +1484,12 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
>>>>   				lun, NULL, NULL, rescan, NULL);
>>>>   			if (res == SCSI_SCAN_NO_RESPONSE) {
>>>>   				/*
>>>> -				 * Got some results, but now none, abort.
>>>> +				 * Got some results, but now none, ignore.
>>>>   				 */
>>>>   				sdev_printk(KERN_ERR, sdev,
>>>>   					"Unexpected response"
>>>> -				        " from lun %d while scanning, scan"
>>>> -				        " aborted\n", lun);
>>>> -				break;
>>>> +					" from lun %d while scanning,"
>>>> +					" ignoring device\n", lun);
>>>>   			}
>>>>   		}
>>>>   	}
>>>
>>> In LLDDs that do their own initiator based LUN masking (because the midlayer does not have this
>>> functionality to enable hardware virtualization without NPIV, or
>> to work around suboptimal LUN
>>> masking on the target), they are likely to return -ENXIO from
>> slave_alloc(), making scsi_alloc_sdev()
>>> return NULL, being converted to SCSI_SCAN_NO_RESPONSE by
>> scsi_probe_and_add_lun() and thus going
>>> through the same code path above.
>>>
>> Ah. Hmm. Yes, they would.
>>
>> However, I personally would question this approach, as SPC states that
>>
>>> The REPORT LUNS command (see table 284) requests the device
>>> server to return the peripheral device logical unit inventory
>>> accessible to the I_T nexus.
>>
>> So by plain reading this would meant that you either should modify
>> 'REPORT LUNS' to not show the masked LUNs, or set the pqual field to
>> '0x10' or '0x11' for those LUNs.

We need to distinguish two cases:
1) suboptimal lun masking on the target
2) hardware virtualization without NPIV

Regarding 1, one could require fixing lun masking on the target. 
However, some users cannot or do not want to do it very fine granular. 
That's why s390 also does deferred device probing ("set online" in 
sysfs) or even limits bus sensing (cio_ignore).

Regarding 2, fixing lun masking on the target does not help because 
without NPIV, the target cannot distinguish the different virtual 
initators since they are all behind one shared WWPN (and N-Port_ID).
This forces zfcp to implement initiator based lun masking, because only 
the user can tell which lun to attach to which of the virtual initiators 
sharing the same physical port. Without that, Linux would attach all 
luns to all virtual initiators, i.e. share inadvertently.

>>> E.g. zfcp does return -ENXIO if the particular LUN was not made known to the unit whitelist
>>> (via zfcp sysfs attribute unit_add).
>>> If we attach LUN 0 (via unit_add) and trigger a target scan with SCAN_WILD_CARD for the scsi
>>> lun (e.g. on remote port recovery), we see exactly above error
>> message for the first LUN in
>>> the response of report lun which is not explicitly attached to zfcp.
>>> IIRC, other LLDDs such as bfa also do similar stuff [http://marc.info/?l=linux-scsi&m=134489842105383&w=2].
>>>
>>> For those cases, I think it makes sense to abort scsi_report_lun_scan().
>>> Otherwise we would force the LLDD to return -ENXIO for every
>> single LUN reported by report lun but not
>>> explicitly added to the LLDD LUN whitelist; and this would likely
>> *flood kernel messages*.
>>>
>>> Maybe Vaughan's case needs to be distinguished in a patch.
>>>
>> Well, as mentioned initially, the real issue is that the target
>> aborts an INQUIRY while being in 'Unavailable'. Which, according to
>> SPC-3 (or later), is a violation of the spec.
>>
>> So we _could_ just tell them to go away, but admittedly that's bad
>> style. Which means we'll have to implement a workaround; the above
>> was just a simple way of implementing it. If that's not working of
>> course we'll have to do something else.
>>
> What about this patch:
>
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 973a121..01a7d69 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -594,6 +594,19 @@ static int scsi_probe_lun(struct scsi_device
> *sdev, unsigne
> d char *inq_result,
>                                       (sshdr.asc == 0x29)) &&
>                                      (sshdr.ascq == 0))
>                                          continue;
> +                               /*
> +                                * Some buggy implementations return
> +                                * 'target port in unavailable state'
> +                                * even on INQUIRY.
> +                                * Set peripheral qualifier 3
> +                                * for these devices.
> +                                */
> +                               if ((sshdr.sense_key == NOT_READY) &&
> +                                   ((sshdr.asc == 0x04) &&
> +                                    (sshdr.ascq == 0x0C))) {

style question: lower case hex digits? 0x0c

Any reason why you put the conjunction of asc and ascq inside its own 
brackets instead of having all three (including sense_key) on the same 
level of one larger conjunction (as the code above does for UA asc 
0x28/0x29 ascq 0x00)? Should be semantically equivalent, isn't it? But 
then again, ascq always goes with asc, so they form a kind of pair.

> +                                   inq_result[0] = 3 << 5;
> +                                   return 0;
> +                               }
>                          }
>                  } else {
>                          /*
>
> (watchout, linebreaks mangled and all that).
> Should be working for this particular case without interrupting
> normal workflow, now should it not?

The approach of distinguishing the workaround close to the response of 
the inquiry sounds good to me. I suppose it won't break zfcp which is 
good. Unfortunately, I don't know what the ramifications of PQ==3 are 
(the SPC-4 description sounds good, though), nor enough details about 
this common code to tell if e.g. the early return is OK (skipping 
setting sdev->scsi_level near the end of scsi_probe_lun()). But then 
again, without inquiry reply we cannot get the level from the response. 
So I think the early return is OK after all.
I guess we want to get around "if (result) return -EIO;" but also do not 
want to execute the parts depending on result==0.

SPC-4 says that for PQ==3 the PDT should be set to 0x1f. Do we need to 
fake this here as well? (I assume the target did not fill in a PDT on 
its own when replying with sense data.)

The clarification on the T10 reflector seems to say that Linux would 
then accept LUNs with PQ 3, but the target shall not have put LUs with 
PQ 3 into the LU inventory in the first place?
Anyway, I'm not opposed to the workaround.

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

