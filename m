Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbbAGE6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 23:58:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbbAGE6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 23:58:30 -0500
Message-ID: <54ACBCF2.3010807@suse.com>
Date: Wed, 07 Jan 2015 05:58:26 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alok Kataria <akataria@vmware.com>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dunn <ddunn@vmware.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "jongman.heo@samsung.com" <jongman.heo@samsung.com>
Subject: Re: [PATCH] x86: don't rely on VMWare emulating PAT MSR correctly
References: <1418723914-9736-1-git-send-email-jgross@suse.com> <1418792295.4473.70.camel@akataria-dtop.eng.vmware.com>
In-Reply-To: <1418792295.4473.70.camel@akataria-dtop.eng.vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 maintainers, could you please consider taking my patch?

There have been several reports now regarding this issue, all could be
fixed using my patch.

Juergen

On 12/17/2014 05:57 AM, Alok Kataria wrote:
> Hi,
>
> On Tue, 2014-12-16 at 10:58 +0100, Juergen Gross wrote:
>> VMWare seems not to emulate the PAT MSR correctly: reaeding
>> MSR_IA32_CR_PAT returns 0 even after writing another value to it.
>>
>> Detect this bug and don't use the read value if it is 0.
>>
>> Commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2 ("x86: Enable PAT to
>> use cache mode translation tables") triggers this VMWare bug when the
>> kernel is booted as a VMWare guest.
>
> Thanks for taking care of this, we are fine with this workaround. On
> newer version of our product, where PAT is virtualized correctly on our
> platform we will go back to using PAT, I will give it a spin sometime
> later to verify it.
>
> Acked-by: Alok N Kataria <akataria@vmware.com>
>
>> Reported-by: Jongman Heo <jongman.heo@samsung.com>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> Tested-by: Jongman Heo <jongman.heo@samsung.com>
>> ---
>>   arch/x86/mm/pat.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
>> index edf299c..7ac6869 100644
>> --- a/arch/x86/mm/pat.c
>> +++ b/arch/x86/mm/pat.c
>> @@ -234,8 +234,13 @@ void pat_init(void)
>>   	      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
>>
>>   	/* Boot CPU check */
>> -	if (!boot_pat_state)
>> +	if (!boot_pat_state) {
>>   		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
>> +		if (!boot_pat_state) {
>> +			pat_disable("PAT read returns always zero, disabled.");
>> +			return;
>> +		}
>> +	}
>>
>>   	wrmsrl(MSR_IA32_CR_PAT, pat);
>>
>
> Alok
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{����zX����ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z��w���?����&�)ߢf��^jǫy�m��@A�a���0��h��i
>

