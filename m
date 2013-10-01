Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab3JAUxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:53:36 -0400
Received: from mout.gmx.net ([212.227.17.22]:64716 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab3JAUxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:53:34 -0400
Message-ID: <524B364B.3010405@gmx.de>
Date: Tue, 01 Oct 2013 22:53:31 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Libin <huawei.libin@huawei.com>, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [workqueue] check values of pwq and wq in print_worker_info()
 before use
References: <20131001203520.GA8248@p100.box> <20131001204352.GA27149@mtj.dyndns.org>
In-Reply-To: <20131001204352.GA27149@mtj.dyndns.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:fofqTY+cRsAyseVXYsniwZp0591jNOigZeyMLZR0Rtpj6wLneD4
 G+Dx9Cq70QSeDT7b1ROv6+HRb3xcH9cDDwmWvz7rxxr5LfJ9+nbotGoDpRuG4YnCtyeXijs
 ozmZmESgQVQTa2lUgD9rVUs8Q0FSd2IpB4NifdU4BAJfe3RLewjqxViprIniox0HuYp72Ta
 GiZXax8P5LADhx4h/GVGA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 10:43 PM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Oct 01, 2013 at 10:35:20PM +0200, Helge Deller wrote:
>> print_worker_info() includes no validity check on the pwq and wq
>> pointers before handing them over to the probe_kernel_read() functions.
>>
>> It seems that most architectures don't care about that, but at least on
>> the parisc architecture this leads to a kernel crash since accesses to
>> page zero are protected by the kernel for security reasons.
>>
>> Fix this problem by verifying the contents of pwq and wq before usage.
>> Even if probe_kernel_read() usually prevents such crashes by disabling
>> page faults, clean code should always include such checks. 
>>
>> Without this fix issuing "echo t > /proc/sysrq-trigger" will immediately
>> crash the Linux kernel on the parisc architecture.
> 
> Hmm... um had similar problem but the root cause here is that the arch
> isn't implementing probe_kernel_read() properly.  We really have no
> idea what the pointer value may be at the dump point and that's why we
> use probe_kernel_read().  If something like the above is necessary for
> the time being, the correct place would be the arch
> probe_kernel_read() implementation.  James, would it be difficult
> implement proper probe_kernel_read() on parisc?

No, it's not really complicated.
That was my initial way to work around that problem.

But is this really necessary? Isn't a pointer which points to mem zero most
likely wrong on any architecture?

In addition I wrote another patch to work around that problem in the parisc
page fault handler (which is needed anyway) too:
https://patchwork.kernel.org/patch/2971701/

So, in summary my patch here is not really necessary, but for the sake of
clean code I think it doesn't hurt either and as such it would be nice if
you could apply it.

Helge
