Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaKJHgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:36:39 -0500
Received: from mail-bl2on0101.outbound.protection.outlook.com ([65.55.169.101]:63488
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751494AbaKJHgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:36:38 -0500
X-WSS-ID: 0NETBSX-08-TNZ-02
X-M-MSG: 
Message-ID: <54606AF7.8070506@amd.com>
Date: Mon, 10 Nov 2014 09:36:23 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v5 00/24] AMDKFD Kernel Driver
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
 <CAPM=9tyej9J13U0c+-DH-EYw_4JJQbiQM98QREZQLz4PPj+FmQ@mail.gmail.com>
In-Reply-To: <CAPM=9tyej9J13U0c+-DH-EYw_4JJQbiQM98QREZQLz4PPj+FmQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(377454003)(479174003)(51704005)(189002)(199003)(24454002)(65806001)(65956001)(23676002)(92566001)(92726001)(120916001)(1411001)(36756003)(64126003)(64706001)(97736003)(21056001)(20776003)(47776003)(77156002)(62966003)(50466002)(95666004)(76176999)(54356999)(101416001)(105586002)(50986999)(106466001)(65816999)(4396001)(84676001)(99396003)(31966008)(68736004)(59896002)(107046002)(46102003)(99136001)(110136001)(19580395003)(33656002)(102836001)(86362001)(83506001)(44976005)(19580405001)(80316001)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Forefront-PRVS: 039178EF4A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/10/2014 04:34 AM, Dave Airlie wrote:
> On 9 November 2014 04:37, Oded Gabbay <oded.gabbay@amd.com> wrote:
>> Hi,
>> Here is the v5 patch set of amdkfd.
>>
>> This version is released several days ahead of the release of AMD's HSA Runtime
>> library as Open Source. Coupled with the modification that Thomas Stellard
>> did for the r600 LLVM back-end, AMD will be effectively releasing a _complete_
>> userspace Open Source stack/solution for running HSA applications using
>> kernels written in OpenCL C99 on top of amdkfd.
>>
>
> Daniel pointed out too me a major problem with the approach of having
> two drivers
> touching on hw at all, they are facing similiar issues with their virt stuff,
>
> How does amdkfd interfact with runtime pm on the radeon driver? I'd expect
> some calls to the runtime get/put functions in some places.
>
> Dave.
>
Hi Dave,
Per Jerome's request from the first time he saw the driver, we removed all the 
"register bashing" code from amdkfd and moved them to the interface file between 
amdkfd and radeon, which is part of the radeon driver.
See "[PATCH v5 05/24] drm/radeon: Add radeon <--> amdkfd interface" for the 
implementation of that interface file.

amdkfd communicates with the H/W either through that file, or through packets 
submitted via the HIQ (a single kernel queue that is created/destroyed and 
exclusively used by amdkfd). By using the HIQ to submit the runlist to the GPU, 
we actually don't call to most of the interface file's functions. Those 
functions are mostly used in bring-up of new H/W with the scheduling mode of: 
"No CP scheduling"

Regarding power management, we have two hooks from the radeon driver, that call 
our driver (if it exists. if it doesn't exists, those call simply return without 
doing anything). I think this is better approach than amdkfd interface directly 
with the runtime pm, in order to prevent races between us and radeon. Do you agree ?

That code is also in Patch 5/24, at cik.c:

@@ -8471,6 +8476,10 @@ static int cik_startup(struct radeon_device *rdev)
  	if (r)
  		return r;

+	r = radeon_kfd_resume(rdev);
+	if (r)
+		return r;
+
  	return 0;
  }

@@ -8519,6 +8528,7 @@ int cik_resume(struct radeon_device *rdev)
   */
  int cik_suspend(struct radeon_device *rdev)
  {
+	radeon_kfd_suspend(rdev);
  	radeon_pm_suspend(rdev);
  	dce6_audio_fini(rdev);
  	radeon_vm_manager_fini(rdev);

- Oded

