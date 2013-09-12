Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3ILICV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:02:21 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:40902 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3ILICS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:02:18 -0400
MIME-Version: 1.0
In-Reply-To: <CE5629DC.69E0D%andreas.dilger@intel.com>
References: <CA+a=Yy6GFzoBT0Bgz7z5bHZRMdEBJa+txwpCZuxA+mRTch-8mA@mail.gmail.com>
 <CE5629DC.69E0D%andreas.dilger@intel.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Thu, 12 Sep 2013 16:01:57 +0800
Message-ID: <CA+a=Yy4JAp6jHoQ1a2VK=hbSnaD2augQF=jPJ9SzBE3ThxKfzw@mail.gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and XTENSA
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 4:48 AM, Dilger, Andreas
<andreas.dilger@intel.com> wrote:
> On 2013/09/10 8:25 PM, "Peng Tao" <bergwolf@gmail.com> wrote:
>
>>On Wed, Sep 11, 2013 at 9:44 AM, Christoph Hellwig <hch@infradead.org>
>>wrote:
>>> On Wed, Sep 11, 2013 at 01:14:11AM +0800, Peng Tao wrote:
>>>> The problem is access_process_vm() is not exported since certain
>>>> version of kernel including the latest. According to Christoph in the
>>>> other mail, access_process_vm() is also a core mm function that is not
>>>> supposed to be exported. Then what kind of change shall we make in
>>>> order to keep current functionality?
>>>
>>> You should remove the higher level functionality, kernel modules are
>>> not supposed to look at userspace environment variables.
>>>
>>OK. I've looked at the specific case that Lustre uses
>>access_process_vm() to get the jobid environment variable and package
>>it into the RPC requests to server. However, it turns out that in the
>>latest Lustre server code, the jobid in a request is not used
>>anywhere. So it looks like we can just get rid of it.
>>
>>Andreas, could you please confirm this? Is the jobid an obsolete
>>parameter that can be abandoned? Or is there plan to use it somehow in
>>the future?
>
> The jobid code is relatively new and in use, I'm not sure why you think
> it is not in use.  It is actually a feature that a bunch of users
> requested.
>
You are right. Sorry I misread the code yesterday. I accidentally
searched for callers of lustre_msg_get_jobid() in a kernel tree
instead of a Lustre tree. Now I see that jobid is used by server for
request tracking purpose. Thank you for pointing it out.

> The jobid feature allows tracking IO request stats for parallel user
> processes
> running on possibly thousands of different client nodes onto the servers.
> This is easy to do with a single node and a single process via PID/PPID
> and blktrace or equivalent, but otherwise impossible in a parallel
> processing
> environment where there may be users running hundreds of different jobs.
> The PID/PPID is not consistent across client nodes, and the server threads
> will randomly handle requests from all users.
>
> By all means, I'd prefer to just use access_process_vm() directly, instead
> of making a copy in the Lustre code.  Not being able to access the process
> environment seems a bit ridiculous - the kernel stores and manages this for
> the process, and it isn't even doing anything nasty like accessing the
> environment from a different process, just its own environment variables.
>
Or, can we read from /proc/self/environ? Instead of reading from
mm->env_start/env_end, we can let proc_environ_operations do the same
and avoid calling access_process_vm() directly.

Thanks,
Tao
