Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab3IKUtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:49:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:28072 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab3IKUtV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:49:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,886,1371106800"; 
   d="scan'208";a="400176866"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Peng Tao <bergwolf@gmail.com>, Christoph Hellwig <hch@infradead.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and
 XTENSA
Thread-Topic: [PATCH] staging: Disable lustre file system for MIPS, SH, and
 XTENSA
Thread-Index: AQHOrklEd3VMd3m790y9aLBKGonWLpnAOb+AgAALhYCAAM+BAA==
Date: Wed, 11 Sep 2013 20:48:39 +0000
Message-ID: <CE5629DC.69E0D%andreas.dilger@intel.com>
In-Reply-To: <CA+a=Yy6GFzoBT0Bgz7z5bHZRMdEBJa+txwpCZuxA+mRTch-8mA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.109.190]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <68B8581A46E4E74F9050C5AF52E8AA21@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/09/10 8:25 PM, "Peng Tao" <bergwolf@gmail.com> wrote:

>On Wed, Sep 11, 2013 at 9:44 AM, Christoph Hellwig <hch@infradead.org>
>wrote:
>> On Wed, Sep 11, 2013 at 01:14:11AM +0800, Peng Tao wrote:
>>> The problem is access_process_vm() is not exported since certain
>>> version of kernel including the latest. According to Christoph in the
>>> other mail, access_process_vm() is also a core mm function that is not
>>> supposed to be exported. Then what kind of change shall we make in
>>> order to keep current functionality?
>>
>> You should remove the higher level functionality, kernel modules are
>> not supposed to look at userspace environment variables.
>>
>OK. I've looked at the specific case that Lustre uses
>access_process_vm() to get the jobid environment variable and package
>it into the RPC requests to server. However, it turns out that in the
>latest Lustre server code, the jobid in a request is not used
>anywhere. So it looks like we can just get rid of it.
>
>Andreas, could you please confirm this? Is the jobid an obsolete
>parameter that can be abandoned? Or is there plan to use it somehow in
>the future?

The jobid code is relatively new and in use, I'm not sure why you think
it is not in use.  It is actually a feature that a bunch of users
requested.

The jobid feature allows tracking IO request stats for parallel user
processes
running on possibly thousands of different client nodes onto the servers.
This is easy to do with a single node and a single process via PID/PPID
and blktrace or equivalent, but otherwise impossible in a parallel
processing
environment where there may be users running hundreds of different jobs.
The PID/PPID is not consistent across client nodes, and the server threads
will randomly handle requests from all users.

By all means, I'd prefer to just use access_process_vm() directly, instead
of making a copy in the Lustre code.  Not being able to access the process
environment seems a bit ridiculous - the kernel stores and manages this for
the process, and it isn't even doing anything nasty like accessing the
environment from a different process, just its own environment variables.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


