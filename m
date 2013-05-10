Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3EJSma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 14:42:30 -0400
Received: from smtp.riverbed.com ([208.70.196.45]:46691 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab3EJSm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 14:42:29 -0400
From: Ming Lei <Ming.Lei@riverbed.com>
To: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Topic: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Index: Ac5NnrX+OJKCA1vXQtyGCRlOybefOwACkHHwAAC3qcA=
Date: Fri, 10 May 2013 18:42:28 +0000
Message-ID: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAACA@SFO1EXC-MBXP06.nbttech.com>
References: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAA49@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4C92B@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F2DA4C92B@ORSMSX106.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.205.254]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With hyperthread turns on, the num_online_cpus reports the number of all logical cores. What I found in testing is only half the cores receives the mce broadcast, so I assume only the physical cores get broadcast. I have two sockets 5646 onboard. num_online_cpus() returns 24 and I only get 12 cores enter do_machine_check. I used both edac error injection and hardware edac error injector as well in my testing.

cpumask_weight(cpu_core_mask(0)) / cpu_data(0).booted_cores returns the ratio between logical cores and physical cores. In my case it is two.

Here is intel spec:
Processor Number  E5645 
# of Cores  6 
# of Threads  12

Ming

-----Original Message-----
From: Luck, Tony [mailto:tony.luck@intel.com] 
Sent: Friday, May 10, 2013 11:14 AM
To: Ming Lei; linux-kernel@vger.kernel.org
Cc: mchehab@redhat.com; bp@alien8.de
Subject: RE: x86_mce: mce_start uses number of phsical cores instead of logical cores

> +#if NR_CPUS > 1
> +	cpus /= cpumask_weight(cpu_core_mask(0)) / cpu_data(0).booted_cores; 
> +#endif

Not entirely sure what you are trying to do here (apart from making "cpus"
be a smaller number).  What is the reasoning behind the right hand side of this expression?

Is this problem more related to how EDAC is injecting an error?  When I've used other methods (e.g. ACPI/EINJ) I end up with a machine check that is broadcast to all processors ... so "cpus = num_online_cpus()" is the correct[1] number of processors to wait for.

-Tony

[1] Andi may point me (again) to a fix to help deal with the case that Linux has taken some cpus offline. In that case this code is wrong as the "offline"
cpus will still show up for machine checks.  But there are troubling corner cases with the fix.
