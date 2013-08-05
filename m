Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab3HECQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 22:16:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42133 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3HECQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 22:16:39 -0400
Message-ID: <51FF0BC0.5020702@oracle.com>
Date: Mon, 05 Aug 2013 10:19:44 +0800
From: vaughan <vaughan.cao@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: dgilbert@interlog.com
CC: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/4] [SCSI] sg: fix race condition in sg_open
References: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com> <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com> <20130722170338.GA15824@logfs.org> <51F9EB97.7070305@interlog.com> <51FC9449.4060906@interlog.com>
In-Reply-To: <51FC9449.4060906@interlog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 01:25 PM, Douglas Gilbert wrote:
> On 13-08-01 01:01 AM, Douglas Gilbert wrote:
>> On 13-07-22 01:03 PM, Jörn Engel wrote:
>>> On Mon, 22 July 2013 12:40:29 +0800, Vaughan Cao wrote:
>>>>
>>>> There is a race when open sg with O_EXCL flag. Also a race may
>>>> happen between
>>>> sg_open and sg_remove.
>>>>
>>>> Changes from v4:
>>>>   * [3/4] use ERR_PTR series instead of adding another parameter in
>>>> sg_add_sfp
>>>>   * [4/4] fix conflict for cherry-pick from v3.
>>>>
>>>> Changes from v3:
>>>>   * release o_sem in sg_release(), not in sg_remove_sfp().
>>>>   * not set exclude with sfd_lock held.
>>>>
>>>> Vaughan Cao (4):
>>>>    [SCSI] sg: use rwsem to solve race during exclusive open
>>>>    [SCSI] sg: no need sg_open_exclusive_lock
>>>>    [SCSI] sg: checking sdp->detached isn't protected when open
>>>>    [SCSI] sg: push file descriptor list locking down to per-device
>>>>      locking
>>>>
>>>>   drivers/scsi/sg.c | 178
>>>> +++++++++++++++++++++++++-----------------------------
>>>>   1 file changed, 83 insertions(+), 95 deletions(-)
>>>
>>> Patchset looks good to me, although I didn't test it on hardware yet.
>>> Signed-off-by: Joern Engel <joern@logfs.org>
>>>
>>> James, care to pick this up?
>>
>> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
>>
>> Tested O_EXCL with multiple processes and threads; passed.
>> sg driver prior to this patch had "leaky" O_EXCL logic
>> according to the same test. Block device passed.
>>
>> James, could you clean this up:
>>    drivers/scsi/sg.c:242:6: warning: unused variable ‘res’
>> [-Wunused-variable]
>
> Further testing suggests this patch on the sg driver is
> broken, so I'll rescind my ack.
>
> The case it is broken for is when a device is opened
> without O_EXCL. Now if, while it is open, a second
> thread/process tries to open the same device O_EXCL
> then IMO the second open should fail with EBUSY.
>
> My testing shows that O_EXCL opens properly deflect
> other O_EXCL opens.
Hi  Doug,

My test don't have this issue. The routine is something as below:

I start three opens without O_EXCL, wait 30s each, and open with
O_EXCL|O_NONBLOCK, it failed with EBUSY.
And I also call myopen with/without O_EXCL many times in background at
the same time, and the test is passed. I don't know why it failed in
your test.

Usage: myopen [-e][-n][-d delay] -f file
      -e: exclude
      -n: nonblock
      -d: delay N seconds and then close.

[root@vacaowol5 16835013]# ./myopen  -f /dev/sg5 -d 30 &
[1] 3417
[root@vacaowol5 16835013]# ./myopen  -f /dev/sg5 -d 30 &
[2] 3418
[root@vacaowol5 16835013]# ./myopen  -f /dev/sg5 -d 30 &
[3] 3419
[root@vacaowol5 16835013]# cat /proc/scsi/sg/debug
max_active_device=6(origin 1)
 def_reserved_size=32768
 >>> device=sg5 scsi5 chan=0 id=1 lun=0   em=0 sg_tablesize=55 excl=0
   FD(1): timeout=60000ms bufflen=32768 (res)sgat=1 low_dma=0
   cmd_q=0 f_packid=0 k_orphan=0 closed=0
     No requests active
   FD(2): timeout=60000ms bufflen=32768 (res)sgat=1 low_dma=0
   cmd_q=0 f_packid=0 k_orphan=0 closed=0
     No requests active
   FD(3): timeout=60000ms bufflen=32768 (res)sgat=1 low_dma=0
   cmd_q=0 f_packid=0 k_orphan=0 closed=0
     No requests active

[root@vacaowol5 16835013]# ./myopen -e -n  -f /dev/sg5 -d 30 &
[4] 3422
[3422:3351] /dev/sg5:exclude: Device or resource busy

[4]+  Exit 1                  ./myopen -e -n -f /dev/sg5 -d 30

[root@vacaowol5 16835013]# cat /proc/scsi/sg/debug
max_active_device=6(origin 1)
 def_reserved_size=32768
 >>> device=sg5 scsi5 chan=0 id=1 lun=0   em=0 sg_tablesize=55 excl=0
   FD(1): timeout=60000ms bufflen=32768 (res)sgat=1 low_dma=0
   cmd_q=0 f_packid=0 k_orphan=0 closed=0
     No requests active
   FD(2): timeout=60000ms bufflen=32768 (res)sgat=1 low_dma=0
   cmd_q=0 f_packid=0 k_orphan=0 closed=0
     No requests active
   FD(3): timeout=60000ms bufflen=32768 (res)sgat=1 low_dma=0
   cmd_q=0 f_packid=0 k_orphan=0 closed=0
     No requests active
[root@vacaowol5 16835013]# cat /proc/scsi/sg/debug
[1]   Done                    ./myopen -f /dev/sg5 -d 30
[2]-  Done                    ./myopen -f /dev/sg5 -d 30
[3]+  Done                    ./myopen -f /dev/sg5 -d 30


>
> BTW the standard block driver (e.g. /dev/sdc) is broken
> in exactly the same way, according to my tests.
>
> Doug Gilbert
>
>

