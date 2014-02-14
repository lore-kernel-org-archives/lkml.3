Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaBNHnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 02:43:06 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:19923 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbaBNHnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 02:43:04 -0500
Message-ID: <52FDC8F3.50100@marvell.com>
Date: Fri, 14 Feb 2014 15:42:43 +0800
From: Jane Li <jiel@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "joe@perches.com" <joe@perches.com>, "tj@kernel.org" <tj@kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] printk: fix one circular lockdep warning about console_lock
References: <1392101400-14550-1-git-send-email-jiel@marvell.com> <20140211131927.f180ac29dede51b2733b92a6@linux-foundation.org>
In-Reply-To: <20140211131927.f180ac29dede51b2733b92a6@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-14_02:2014-02-13,2014-02-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402130246
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 05:19 AM, Andrew Morton wrote:

>> There are three locks involved in two sequence:
>> a) pm suspend:
>> 	console_lock (@suspend_console())
>> 	cpu_add_remove_lock (@disable_nonboot_cpus())
>> 	cpu_hotplug.lock (@_cpu_down())
> But but but.  suspend_console() releases console_sem again.

Console_lock does not refer to console_sem but console_lock_dep_map. Its name is console_lock. Suspend_console() does not release console_lock_dep_map.

> So the
> sequence is actually
>
>   	down(&console_sem) (@suspend_console())

	   acquire(&console_lock_dep_map) (&suspend_console())

>   	up(&console_sem) (@suspend_console())
>   	cpu_add_remove_lock (@disable_nonboot_cpus())
>   	cpu_hotplug.lock (@_cpu_down())
>
> So console_sem *doesn't* nest outside cpu_add_remove_lock and
> cpu_hotplug.lock.

Add console_lock in the sequence.

>
>> b) Plug-out CPUx:
>> 	cpu_add_remove_lock (@(cpu_down())
>> 	cpu_hotplug.lock (@_cpu_down())
>> 	console_lock (@console_cpu_notify()) => Lockdeps prints warning log.
>>
>> There should be not real deadlock, as flag of console_suspended can
>> protect this.
> console_lock() does down(&console_sem) *before* testing
> console_suspended, so I don't understand this sentence - a more
> detailed description would help.

After suspend_console(), console_sem is unlocked, but console_lock_dep_map has been acquired.


Best Regards,
Jane

