Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaEVXyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:54:18 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45072 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaEVXyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:54:16 -0400
Message-ID: <537E8E1F.9020303@linux.vnet.ibm.com>
Date: Thu, 22 May 2014 16:54:07 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au, mingo@redhat.com,
        paulus@samba.org, imunsie@au1.ibm.com, acme@ghostprotocols.net,
        scottwood@freescale.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] powerpc/perf/hv-24x7: use kmem_cache instead of aligned
 stack allocations
References: <537E78AD.1040409@linux.vnet.ibm.com> <1400798673-27522-1-git-send-email-cody@linux.vnet.ibm.com> <20140523094929.15f4613c@canb.auug.org.au>
In-Reply-To: <20140523094929.15f4613c@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052223-0320-0000-0000-00000359A7B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 04:49 PM, Stephen Rothwell wrote:
> Hi Cody,
>
> On Thu, 22 May 2014 15:44:25 -0700 Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
>>
>>   	if (ret) {
>>   		if (success_expected)
>>   			pr_err_ratelimited("hcall failed: %d %#x %#x %d => 0x%lx (%ld) detail=0x%x failing ix=%x\n",
>>   					domain, offset, ix, lpar,
>>   					ret, ret,
>> -					result_buffer.buf.detailed_rc,
>> -					result_buffer.buf.failing_request_ix);
>> -		return ret;
>> +					result_buffer->buf.detailed_rc,
>> +					result_buffer->buf.failing_request_ix);
>> +		goto out_hcall;
>>   	}
>>
>> -	*res = be64_to_cpu(result_buffer.result);
>> +	*res = be64_to_cpu(result_buffer->result);
>
> not a biggie, but this last bit could be (remove the goto out_hcall and
> teh label and then)
>
> 	} else {
> 		*res = be64_to_cpu(result_buffer->result);
> 	}
>

I've got a slight preference toward keeping it as is, which lets all of 
the non-error path code stay outside of if/else blocks (and the error 
handling is kept ever so slightly more consistent).

>> +out_hcall:
>> +	kfree(result_buffer);
>> +out_resb:
>> +	kfree(request_buffer);
>> +out_reqb:
>>   	return ret;
>>   }
>>
>
> otherwise looks good to me.
>

