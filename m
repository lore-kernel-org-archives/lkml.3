Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaDQGsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 02:48:37 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15313 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaDQGse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 02:48:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 16 Apr 2014 23:43:20 -0700
From: Peter Chiang <pchiang@nvidia.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tj@kernel.org" <tj@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 17 Apr 2014 14:48:29 +0800
Subject: RE: [PATCH] mm : Avoid candidate task is equal to current task
Thread-Topic: [PATCH] mm : Avoid candidate task is equal to current task
Thread-Index: Ac9Ze/eNAFm+pbzaSSCiwRzHznO62AAjI25A
Message-ID: <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com>
References: <1397617379-26895-1-git-send-email-pchiang@nvidia.com>
 <80341664FB79C2419999599F48F738410227327881@HKMAIL01.nvidia.com>
 <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com>
 <20140416135741.GA9407@redhat.com>
In-Reply-To: <20140416135741.GA9407@redhat.com>
Accept-Language: zh-TW, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You are right !!  It is not a right solution .

It is a speculation where the panic was.

[38261.652100] Call trace: 
[38261.654616] [<ffffffc000aa6fe0>] mm_update_next_owner+0x190/0x238 
[38261.660766] [<ffffffc000aa728c>] do_exit+0x204/0x924 
[38261.665790] [<ffffffc000aa7a1c>] do_group_exit+0x40/0xcc 
[38261.671169] [<ffffffc000ab59cc>] get_signal_to_deliver+0x218/0x57c 
[38261.677409] [<ffffffc000a87e6c>] do_signal+0x534/0x550 
[38261.682608] [<ffffffc000a88070>] do_notify_resume+0x20/0x58

-----Original Message-----
From: Oleg Nesterov [mailto:oleg@redhat.com] 
Sent: Wednesday, April 16, 2014 9:58 PM
To: Peter Chiang
Cc: ccross@android.com; lizefan@huawei.com; akpm@linux-foundation.org; tj@kernel.org; pavel@ucw.cz; ebiederm@xmission.com; guillaume@morinfr.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm : Avoid candidate task is equal to current task

On 04/16, Peter Chiang wrote:
>
> mm_update_next_owner() call from exit_mm() , and exit_mm()  change 
> tsk->mm to NULL If p==c , It seems to be  impossible that mm == c->mm  (tsk->mm) .
> Because mm is non-NULL and  c->mm is NULL .

Confused, please see below.

> Fix kernel panic when finding a new owner for the mm and the new owner 
> is equal to current onwer

Did you actually observe the panic ?

> diff --git a/kernel/exit.c b/kernel/exit.c index 6ed6a1d..aa98422 
> 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -399,7 +399,7 @@ retry:
>  	 * here often
>  	 */
>  	do_each_thread(g, c) {
> -		if (c->mm == mm)
> +		if ((c != p) && (c->mm == mm))
>  			goto assign_new_owner;
>  	} while_each_thread(g, c);

p == current. This is always called with p->mm == NULL and mm != NULL.

So, if c->mm == mm then at least c->mm != NULL, and this means that c == p is not possible?

And it seems that this is exactly what you meant above. So why do you think we need this change?

Oleg.

