Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbaIQV4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:56:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41714 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755953AbaIQV4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:56:38 -0400
Message-ID: <541A03A1.9070908@fb.com>
Date: Wed, 17 Sep 2014 15:56:49 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Christoph Hellwig <hch@lst.de>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: blk-mq timeout handling fixes
References: <1410651613-1993-1-git-send-email-hch@lst.de> <94D0CD8314A33A4D9D801C0FE68B402958C86C8E@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C86C8E@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-17_05:2014-09-17,2014-09-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409170180
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 03:53 PM, Elliott, Robert (Server Storage) wrote:
> 
> 
>> -----Original Message-----
>> From: Christoph Hellwig [mailto:hch@lst.de]
>> Sent: Saturday, 13 September, 2014 6:40 PM
>> To: Jens Axboe
>> Cc: Elliott, Robert (Server Storage); linux-scsi@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: blk-mq timeout handling fixes
>>
>> This series fixes various issues with timeout handling that Robert
>> ran into when testing scsi-mq heavily.  He tested an earlier version,
>> and couldn't reproduce the issues anymore, although the series changed
>> quite significantly since and should probably be retested.
>>
>> In summary we not only start the blk-mq timer inside the drivers
>> ->queue_rq method after the request has been fully setup, and we
>> also tell the drivers if we're timing out a reserved (internal)
>> request or a real one.  Many drivers including will need to handle
>> those internal ones differently, e.g. for scsi-mq we don't even
>> have a scsi command structure allocated for the reserved commands.
> 
> I have rerun a variety of tests on:
> * Jens' for-next tree that went into 3.17rc5
> * plus this series
> * plus two patches for infinite recursion on flushes from 
>   Ming and then Christoph

This is pretty much what is queued up for 3.17 as well. It's bigger than
I'd like at this point, but these are real fixes.

> and have not been able to trigger the scsi_times_out req->special
> NULL pointer dereference that prompted this series.

Great!!

> Testing includes:
> * concurrent heavy workload generators:
>   * fio high iodepth direct 512 byte random reads (> 1M IOPS)
>   * programs generating large bursts of paged writes
>     * mkfs.ext4 (followed by e2fsck)
>     * mkfs.xfs (followed by xfs_check)
>     * ddpt
>   * watch -n 0 sync to generate flushes
> * scsi_logging_level MLCOMPLETE set to 0 or 1
>   * scsi_lib.c patched to put all the ACTION_FAIL messages
>     under level 1 so they can be squelched (massive error 
>     prints cause more timeouts themselves)
> * 4 hpsa and 16 mpt3sas devices (all made from SAS SSDs)
>   * lockless hpsa driver
> * injecting errors
>   * device removal
>   * device generating infinite errors
>   * device generating a brief number of errors
> 
> The filesystems don't always recover properly, but nothing in 
> the block or scsi midlayers crashed.
> 
> So, you may add this to the series:
> Tested-by: Robert Elliott <elliott@hp.com>

Thanks a lot for your (continued) testing, Robert. It's a great help.


-- 
Jens Axboe

