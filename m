Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbaGXFyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 01:54:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:64400 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaGXFyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 01:54:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,721,1400050800"; 
   d="scan'208";a="566422853"
Message-ID: <53D09F76.80801@linux.intel.com>
Date: Thu, 24 Jul 2014 13:53:58 +0800
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
CC: "xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org,
        snitzer@redhat.com, dm-devel@redhat.com,
        "Liu, ShuoX" <shuox.liu@intel.com>
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation
 in copy_params
References: <53B68068.2060102@intel.com> <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com> <53BCA278.5050205@linux.intel.com> <alpine.LRH.2.02.1407091032400.4545@file01.intranet.prod.int.rdu2.redhat.com> <53CDB81B.90509@linux.intel.com> <20140722012352.GD6822@agk-dp.fab.redhat.com> <53CF26B2.6060503@linux.intel.com> <alpine.LRH.2.02.1407230816000.29551@file01.intranet.prod.int.rdu2.redhat.com> <20140723125407.GG6822@agk-dp.fab.redhat.com> <alpine.LRH.2.02.1407231307200.4177@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1407231307200.4177@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/24 1:14, Mikulas Patocka wrote:
>
> On Wed, 23 Jul 2014, Alasdair G Kergon wrote:
>
>> On Wed, Jul 23, 2014 at 08:16:58AM -0400, Mikulas Patocka wrote:
>>> So, it means that you do not use device mapper at all. So, why are you
>>> trying to change memory allocation in device mapper?
>>   
>> So the *test* they run is asking device-mapper to briefly reserve a 64KB
>> buffer when there is no data to report:  The answer is not to run that
>> pointless test:)
>>
>> And if a single 64KB allocation really is a big deal, then patch 'vold'
>> in userspace so it doesn't ask for 64KB when it clearly doesn't need it!
>>
>> + int Devmapper::dumpState(SocketClient *c) {
>> +    char *buffer = (char *) malloc(1024 * 64);
>>
>> The code has just
>> #define DEVMAPPER_BUFFER_SIZE 4096
>> for all the other dm ioctls it issues.
>>
>> Only use a larger value when it is needed i.e. if DM_BUFFER_FULL_FLAG gets set.
>>
>> Alasdair
> Device mapper shouldn't depend on allocation on any contiguous memory - it
> will fall back to vmalloc. I still can't believe that their suggested
> patch makes any difference.
>
> This pattern is being repeated over and over in the kernel - for example:
>
>          if (PIDLIST_TOO_LARGE(count))
>                  return vmalloc(count * sizeof(pid_t));
>          else
>                  return kmalloc(count * sizeof(pid_t), GFP_KERNEL);
>
>
>          if (is_vmalloc_addr(p))
>                  vfree(p);
>          else
>                  kfree(p);
>
> - I think we should make two functions that do this operation (for example
> kvalloc and kvfree) and convert device mapper and other users to these
> functions. Then, other kernel subsystems can start to use them to fix
> memory fragmentation issues.

Thank Mikulas and Alasdair. Before sending out the patch, we know the result. :)
It's hard to balance between performance and stability.

Anyway, we would try to change seq_read.

Yanmin

