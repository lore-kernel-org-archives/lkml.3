Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab3HNNVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:21:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58428 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab3HNNVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:21:45 -0400
Message-ID: <520B8468.7050307@arm.com>
Date: Wed, 14 Aug 2013 14:21:44 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [GIT PULL] DT/core: cpu_ofnode updates for v3.12
References: <5208E2D3.7060005@arm.com> <3356439.a21MloFP7n@vostro.rjw.lan>  <520A536C.3030600@arm.com> <520A7B00.8060405@arm.com>  <1376428024.4255.14.camel@pasglop> <520B5584.7030608@arm.com> <1376480227.4255.66.camel@pasglop>
In-Reply-To: <1376480227.4255.66.camel@pasglop>
X-OriginalArrivalTime: 14 Aug 2013 13:21:42.0025 (UTC) FILETIME=[37284790:01CE98F1]
X-MC-Unique: 113081414214309801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/08/13 12:37, Benjamin Herrenschmidt wrote:
> On Wed, 2013-08-14 at 11:01 +0100, Sudeep KarkadaNagesha wrote:
>> Yes this doesn't cover the historical "ibm,ppc-interrupt-server#s",
>> for
>> which we can have PPC specific wrapper above the generic one i.e. get
>> the cpu node and then parse for thread id under custom property.
> 
> A wrapper is wrong. I don't want to have to have all ppc callers to use
> a different function.
Ok.

On the side note the main intention of this patch series[1] is to avoid
calling of_get_cpu_node function once CPU devices are registered. It
initialises the of_node in all the cpu devices using this function when
registering the CPU device. It can be retrieved from cpu_dev->of_node.
So direct users of of_get_cpu_node can be reduced to avoid unnecessary
parsing of DT to find cpu node.

> 
> As I said, just make a generic one that returns a thread ID, ie, same
> signature as the powerpc one. Make it weak, we can override it in
> powerpc-land,
IMO, making generic definition which adhere to the ePAPR specification
as weak is not so clean.

> or we can move the ibm,ppc-interrupt-server#s handling
> into the generic one, it won't hurt, but leave the thread_id return
> there, it doesn't hurt it will come in handy in a few cases without
> causing code duplication.
> 

IMO moving of handling ibm,ppc-interrupt-server#s to generic code under
#ifdef CONFIG_PPC seems to be cleaner approach than weak definitation.

As per my understanding each thread is a different logical cpu.
Each logical cpu is mapped to unique physical id(either present in reg
field or legacy ibm,ppc-interrupt-server#s field). So given a logical
cpu id we can get the cpu node corresponding to it.
Looking @ smp_setup_cpu_maps in arch/powerpc/kernel/setup-common.c
and the comment in the same file: "This implementation only supports
power of 2 number of threads.." the thread id id is implicit in the
logical cpu id. Do we need to fetch that from DT ?

Regards,
Sudeep

[1] https://lkml.org/lkml/2013/7/22/219

