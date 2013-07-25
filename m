Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab3GYKix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:38:53 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:55596 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab3GYKiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:38:51 -0400
Subject: Re: [PATCH] x86/mce: Pay no attention to 'F' bit in MCACOD when
 parsing 'UC' errors.
To: gong.chen@linux.intel.com, tony.luck@intel.com
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: bp@suse.de, linux-kernel@vger.kernel.org
Date: Thu, 25 Jul 2013 16:08:26 +0530
Message-ID: <20130725103647.5009.92648.stgit@localhost.localdomain>
In-Reply-To: <20130724061626.GA18995@gchen.bj.intel.com>
References: <20130724061626.GA18995@gchen.bj.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072510-3864-0000-0000-000009409136
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 11:46 AM, Chen Gong wrote:
> On Tue, Jul 23, 2013 at 03:51:14PM -0700, Tony Luck wrote:
>> Date: Tue, 23 Jul 2013 15:51:14 -0700
>> From: Tony Luck <tony.luck@gmail.com>
>> To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
>> Cc: Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.intel.com>,
>>   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
>> Subject: Re: [PATCH] x86/mce: Pay no attention to 'F' bit in MCACOD when
>>   parsing 'UC' errors.
>>
>> Gah ... there is another bug in that unaffected thread entry.  The check
>> for
>> MCG_STATUS should be for RIPV=1 *and* EIPV=0
>>
>
> I set "MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)" becase
> I want it to cover Non-Affected Logical Processors (1,0)
> and Affected Logical Processor/Recoverable continuable (1,1).
>
> I think both of them are continuable so they should be as
> *KEEP*.

For affected logical processors, we won't be able to continue if we were in
kernel-space. Right? So, it looks like we should panic and I think this gets
covered by "Action required: unknown MCACOD" entry later on, though a more
explicit entry might help. For user-space, the next two entries cover AR.

Does the below help or am I reading this wrong?

Thanks,
Naveen

--
We have three categories under MCA Action Required (AR):
1. Unaffected threads/cpu (RIPV=1,EIPV=0): always continuable
2. Affected threads (RIPV=EIPV=1): continuable
3. Affected threads (RIPV=0): not continuable

The consolidated entry (Tony's new patch) should only cover (1).

(2) and (3) are covered for user-space by the two entries following the entry
for (1) for data load and instruction fetch errors.

(3) is covered for kernel-space by the earlier entry for "In kernel and no
restart IP" where we panic. The below patch is to make (2) explicit for
kernel-space.


Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index e2703520..585ddbb 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -115,6 +115,12 @@ static struct severity {
 		MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)
 		),
 	MCESEV(
+		PANIC, "Action required but kernel thread is not continuable",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR, MCI_UC_SAR|MCI_ADDR),
+		MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, MCG_STATUS_RIPV|MCG_STATUS_EIPV),
+		KERNEL
+		),
+	MCESEV(
 		AR, "Action required: data load error in a user process",
 		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
 		USER

