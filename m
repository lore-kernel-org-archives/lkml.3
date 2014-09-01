Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaIABvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 21:51:15 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36882 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000AbaIABvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 21:51:12 -0400
Message-ID: <5403D019.8030801@marvell.com>
Date: Mon, 1 Sep 2014 09:47:05 +0800
From: Leo Yan <leoy@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v1] arm64: fix bug for reloading FPSIMD state after cpu
 power off
References: <1409463591-661-1-git-send-email-leoy@marvell.com> <CC25C839-1C64-4BD0-818B-4DA0CD7EC28B@arm.com>
In-Reply-To: <CC25C839-1C64-4BD0-818B-4DA0CD7EC28B@arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-09-01_01:2014-08-29,2014-08-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1409010024
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 06:11 AM, Catalin Marinas wrote:
> On 31 Aug 2014, at 06:39, Leo Yan <leoy@marvell.com> wrote:
>> Now arm64 defers reloading FPSIMD state, but this optimization also
>> introduces the bug after cpu resume back from low power mode.
>
> You are right, I can see a bug here.
>
>> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
>> index ad8aebb..4caef93 100644
>> --- a/arch/arm64/kernel/fpsimd.c
>> +++ b/arch/arm64/kernel/fpsimd.c
>> @@ -268,13 +268,9 @@ static int fpsimd_cpu_pm_notifier(struct notifier_block *self,
>> {
>> 	switch (cmd) {
>> 	case CPU_PM_ENTER:
>> -		if (current->mm && !test_thread_flag(TIF_FOREIGN_FPSTATE))
>> -			fpsimd_save_state(&current->thread.fpsimd_state);
>
> That’s needed if we enter a low power state directly from a task with
> a valid mm (user). I’m not sure that’s possible, but just in case.

u are right, in some special cases (such like IKS, etc) a normal thread 
also may call cpu_suspend() function so that it will run here; i will 
commit another patch to reserve this part.

>> +		this_cpu_write(fpsimd_last_state, NULL);
>
> That’s correct. In most cases, we enter low power state from the idle
> thread which does not have an mm, so the CPU_PM_EXIT case wouldn’t set
> a TIF_FOREIGN_FPSTATE, so thread switching would not detect the change.
>
>> 		break;
>> 	case CPU_PM_EXIT:
>> -		if (current->mm)
>> -			set_thread_flag(TIF_FOREIGN_FPSTATE);
>
> See above for why this may still be needed (it case it returns to user
> directly without fpsimd_thread_switch() to detect fpsimd_last_state).

Will reserve this part as well.

Thanks,
Leo Yan
