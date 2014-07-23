Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbaGWROX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:14:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201AbaGWROW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:14:22 -0400
Date: Wed, 23 Jul 2014 13:14:16 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Alasdair G Kergon <agk@redhat.com>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        "xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org,
        snitzer@redhat.com, dm-devel@redhat.com,
        "Liu, ShuoX" <shuox.liu@intel.com>
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation in
 copy_params
In-Reply-To: <20140723125407.GG6822@agk-dp.fab.redhat.com>
Message-ID: <alpine.LRH.2.02.1407231307200.4177@file01.intranet.prod.int.rdu2.redhat.com>
References: <53B68068.2060102@intel.com> <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com> <53BCA278.5050205@linux.intel.com> <alpine.LRH.2.02.1407091032400.4545@file01.intranet.prod.int.rdu2.redhat.com> <53CDB81B.90509@linux.intel.com>
 <20140722012352.GD6822@agk-dp.fab.redhat.com> <53CF26B2.6060503@linux.intel.com> <alpine.LRH.2.02.1407230816000.29551@file01.intranet.prod.int.rdu2.redhat.com> <20140723125407.GG6822@agk-dp.fab.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Jul 2014, Alasdair G Kergon wrote:

> On Wed, Jul 23, 2014 at 08:16:58AM -0400, Mikulas Patocka wrote:
> > So, it means that you do not use device mapper at all. So, why are you 
> > trying to change memory allocation in device mapper?
>  
> So the *test* they run is asking device-mapper to briefly reserve a 64KB
> buffer when there is no data to report:  The answer is not to run that
> pointless test:)
> 
> And if a single 64KB allocation really is a big deal, then patch 'vold'
> in userspace so it doesn't ask for 64KB when it clearly doesn't need it!
> 
> + int Devmapper::dumpState(SocketClient *c) {
> +    char *buffer = (char *) malloc(1024 * 64);
> 
> The code has just
> #define DEVMAPPER_BUFFER_SIZE 4096
> for all the other dm ioctls it issues.
> 
> Only use a larger value when it is needed i.e. if DM_BUFFER_FULL_FLAG gets set.
> 
> Alasdair

Device mapper shouldn't depend on allocation on any contiguous memory - it 
will fall back to vmalloc. I still can't believe that their suggested 
patch makes any difference.

This pattern is being repeated over and over in the kernel - for example:

        if (PIDLIST_TOO_LARGE(count))
                return vmalloc(count * sizeof(pid_t));
        else
                return kmalloc(count * sizeof(pid_t), GFP_KERNEL);


        if (is_vmalloc_addr(p))
                vfree(p);
        else
                kfree(p);

- I think we should make two functions that do this operation (for example 
kvalloc and kvfree) and convert device mapper and other users to these 
functions. Then, other kernel subsystems can start to use them to fix 
memory fragmentation issues.

Mikulas
