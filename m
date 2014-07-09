Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaGIDze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:55:34 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41394 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbaGIDzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:55:33 -0400
Message-ID: <53BCBD2E.6010203@ozlabs.ru>
Date: Wed, 09 Jul 2014 13:55:26 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Junichi Nomura <j-nomura@ce.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>,
        Paul Mackerras <paulus@samba.org>
CC: Vladimir Davydov <vdavydov@parallels.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression in 3.15 on POWER8 with multipath SCSI
References: <20140630103058.GA17747@iris.ozlabs.ibm.com> <20140701193907.GA15306@redhat.com> <11AF7C027C4C02408624617A4986078401323542@BPXM12GP.gisp.nec.co.jp>
In-Reply-To: <11AF7C027C4C02408624617A4986078401323542@BPXM12GP.gisp.nec.co.jp>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 08:28 PM, Junichi Nomura wrote:
> On 07/02/14 04:39, Mike Snitzer wrote:
>> On Mon, Jun 30 2014 at  6:30am -0400,
>> Paul Mackerras <paulus@samba.org> wrote:
>>
>>> I have a machine on which 3.15 usually fails to boot, and 3.14 boots
>>> every time.  The machine is a POWER8 2-socket server with 20 cores
>>> (thus 160 CPUs), 128GB of RAM, and 7 SCSI disks connected via a
>>> hardware-RAID-capable adapter which appears as two IPR controllers
>>> which are both connected to each disk.  I am booting from a disk that
>>> has Fedora 20 installed on it.
>>>
>>> After over two weeks of bisections, I can finally point to the commits
>>> that cause the problems.  The culprits are:
>>>
>>> 3e9f1be1 dm mpath: remove process_queued_ios()
>>> e8099177 dm mpath: push back requests instead of queueing
>>> bcccff93 kobject: don't block for each kobject_uevent
>>>
>>> The interesting thing is that neither e8099177 nor bcccff93 cause
>>> failures on their own, but with both commits in there are failures
>>> where the system will fail to find /home on some occasions.
>>>
>>> With 3e9f1be1 included, the system appears to be prone to a deadlock
>>> condition which typically causes the boot process to hang with this
>>> message showing:
>>>
>>> A start job is running for Monitoring of LVM2 mirror...rogress polling
>>>
>>> (with a [***     ] thing before it where the asterisks move back and
>>> forth).
>>>
>>> If I revert 63d832c3 ("dm mpath: really fix lockdep warning") ,
>>> 4cdd2ad7 ("dm mpath: fix lock order inconsistency in
>>> multipath_ioctl"), 3e9f1be1 and bcccff93, in that order, I get a
>>> kernel that will boot every time.  The first two are later commits
>>> that fix some problems with 3e9f1be1 (though not the problems I am
>>> seeing).
>>>
>>> Can anyone see any reason why e8099177 and bcccff93 would interfere
>>> with each other?
>>
>> No, not seeing any obvious relation.
>>
>> But even though you listed e8099177 as a culprit you didn't list it as a
>> commit you reverted.  Did you leave e8099177 simply because attempting
>> to revert it fails (if you don't first revert other dm-mpath.c commits)?
>>
>> (btw, Bart Van Assche also has issues with commit e8099177 due to hangs
>> during cable pull testing of mpath devices -- Bart: curious to know if
>> your cable pull tests pass if you just revert bcccff93).
> 
> It seems Bart's issue has gone with the attached patch:
> http://www.redhat.com/archives/dm-devel/2014-July/msg00035.html
> Could you try if it makes any difference on your issue?
> 
> The problem is dm-mpath's state machine stall due to e8099177
> but ioctl to the device can kick the state machine running again.
> That might be related to why bcccff93 affects the reproducibility.
> Also, 3e9f1be1 integrates some codes into the one which is affected
> by this problem. So it makes sense why the problem becomes easier
> to occur with that.
> 
> -
> Jun'ichi Nomura, NEC Corporation
> 
> 
> pg_ready() checks the current state of the multipath and may return
> false even if a new IO is needed to change the state.
> 
> OTOH, if multipath_busy() returns busy, a new IO will not be sent
> to multipath target and the state change won't happen. That results
> in lock up.
> 
> The intent of multipath_busy() is to avoid unnecessary cycles of
> dequeue + request_fn + requeue if it is known that multipath device
> will requeue.
> 
> Such situation would be:
>   - path group is being activated
>   - there is no path and the multipath is setup to requeue if no path
> 
> This patch should fix the problem introduced as a part of this commit:
>   commit e809917735ebf1b9a56c24e877ce0d320baee2ec
>   dm mpath: push back requests instead of queueing
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index ebfa411..d58343e 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1620,8 +1620,9 @@ static int multipath_busy(struct dm_target *ti)
>  
>  	spin_lock_irqsave(&m->lock, flags);
>  
> -	/* pg_init in progress, requeue until done */
> -	if (!pg_ready(m)) {
> +	/* pg_init in progress or no paths available */
> +	if (m->pg_init_in_progress ||
> +	    (!m->nr_valid_paths && m->queue_if_no_path)) {
>  		busy = 1;
>  		goto out;
>  	}

This patch fixes IPR SCSI for my POWER8 box, e8099177 was the problem.




-- 
Alexey
