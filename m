Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab3EKGB7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 02:01:59 -0400
Received: from smtp1.riverbed.com ([208.70.196.45]:25560 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab3EKGB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 02:01:57 -0400
From: Ming Lei <Ming.Lei@riverbed.com>
To: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Topic: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Index: Ac5NnrX+OJKCA1vXQtyGCRlOybefOwACkHHwAAC3qcAAASol0AACAr3gAAH652AAAiA5kAAA3IFQAA/Am5A=
Date: Sat, 11 May 2013 06:01:55 +0000
Message-ID: <2CE44BD3DBCF9541909CCB42F11CA3921C703A5F@365EXCH-MBX-P1.nbttech.com>
References: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAA49@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4C92B@ORSMSX106.amr.corp.intel.com>
 <2CE44BD3DBCF9541909CCB42F11CA3921C6FAACA@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4C9B9@ORSMSX106.amr.corp.intel.com>
 <2CE44BD3DBCF9541909CCB42F11CA3921C6FAB06@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4CB19@ORSMSX106.amr.corp.intel.com>
 <2CE44BD3DBCF9541909CCB42F11CA3921C6FAB84@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4CD58@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F2DA4CD58@ORSMSX106.amr.corp.intel.com>
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

I read the section you pointed out:

15.10.4.1 Machine-Check Exception Handler for Error Recovery
When writing a machine-check exception (MCE) handler to support software recovery from Uncorrected Recover- able (UCR) errors, consider the following:
For processors on which CPUID reports DisplayFamily_DisplayModel as 06H_0EH and onward, an MCA signal is broadcast to all logical processors in the system. Due to the potentially shared machine check MSR resources among the logical processors on the same package/core, the MCE handler may be required to synchronize with the other processors that received a machine check error and serialize access to the machine check registers when analyzing, logging and clearing the information in the machine check registers.

What I understand from above in intel 64 Arch software Developer's manual are:
1) this manual is written for software developer;
2) It says that MCE handler only requires to synchronize among the logical cores in the same package/core(what I assume here is same CPU socket).

I have two CPU sockets on motherboard and total 24 logical cores(12 cores each CPU). Each CPU has its own integrated memory controller. Each memory controller controls three channels of DIMMs. I can understand that if one dimm has error, the memory controller can trigger the MCE exception to it's own CPU, but why should this memory controller sends the MCE exception to the other CPU or the rest CPUs on the motherboard? Is there any hardware standard or specification for it?

Ming

-----Original Message-----
From: Luck, Tony [mailto:tony.luck@intel.com] 
Sent: Friday, May 10, 2013 3:42 PM
To: Ming Lei; linux-kernel@vger.kernel.org
Cc: mchehab@redhat.com; bp@alien8.de
Subject: RE: x86_mce: mce_start uses number of phsical cores instead of logical cores

> So only one socket gets the machine check. So is there still a problem but the fix will be different?
> I think the error inject creates a real machine check, but since each 
> CPU has its own memory controller, the machine check may only send to the CPU the error happens.

If there is a real machine check, then it must go to all logical cpus. If it doesn't get there, then there is a h/w (or possibly f/w configuration) problem.  Interesting that few others have seen this. Perhaps because it only shows up in a fatal path and the machine is crashing anyway.  A Google search for the "Some CPUs didn't answer in synchronization" message does have a few hits that look relevant, but following a few didn't give me enough details on machine configuration to tell whether they match what you are seeing.

If there are many machines that do this - then we may need a workaround in Linux code for them.
Who is the manufacturer of the motherboard and/or system you are using?

But the current code that expects to see the machine check on all logical cpus is correct (and works as is on other machines that are following the specification).

-Tony


