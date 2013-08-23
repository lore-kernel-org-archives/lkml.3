Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab3HWXH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 19:07:56 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:49572
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753361Ab3HWXHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 19:07:54 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzbb2dI98dI9371I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h177df4h17326ah186068h8275eh8275bh1de097ha1495iz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h783m1155h)
X-WSS-ID: 0MS0ASD-07-GE4-02
X-M-MSG: 
Message-ID: <5217EB44.3020302@amd.com>
Date: Fri, 23 Aug 2013 18:07:48 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <dougthompson@xmission.com>, <bhelgaas@google.com>,
        <jbeulich@suse.com>, <linux-kernel@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/1] AMD64_EDAC: Fix incorrect wrap arounds due to left
 shift beyond 32 bits.
References: <1376958472-2150-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <1376958472-2150-2-git-send-email-Aravind.Gopalakrishnan@amd.com> <20130823213725.GC15521@pd.tnic>
In-Reply-To: <20130823213725.GC15521@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.181.55.254]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/2013 4:37 PM, Borislav Petkov wrote:
> On Mon, Aug 19, 2013 at 07:27:52PM -0500, Aravind Gopalakrishnan wrote:
>> Link to the bug report:
>> http://marc.info/?l=linux-edac&m=137692201732220&w=2
>>
>> dct_base and dct_limit obtain 32 bit register values when they read their
>> respective pci config space registers. A left shift beyond 32 bits will
>> cause them to wrap around. Similar case for chan_addr as can be seen from
>> the bug report. In the patch, we rectify this by casting chan_addr to u64
>> and by comparing dct_base and dct_limit against (sys_addr >> 27)
>>
>> Tested on F15h, M30h with ECC turned on and works fine.
>>
>> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
>>
>> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
>> index b86228c..eb4793e 100644
>> --- a/drivers/edac/amd64_edac.c
>> +++ b/drivers/edac/amd64_edac.c
>> @@ -1558,11 +1558,12 @@ static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
>>   	}
>>   
>>   	/* Verify sys_addr is within DCT Range. */
>> -	dct_base = (dct_sel_baseaddr(pvt) << 27);
>> -	dct_limit = (((dct_cont_limit_reg >> 11) & 0x1FFF) << 27) | 0x7FFFFFF;
>> +	dct_base = dct_sel_baseaddr(pvt);
> This can't be correct.
>
> So the original patch takes the shifted dct_base while your change
> doesn't anymore...
>
>> +	dct_limit = (dct_cont_limit_reg >> 11) & 0x1FFF;
>>   
>>   	if (!(dct_cont_base_reg & BIT(0)) &&
>> -	    !(dct_base <= sys_addr && dct_limit >= sys_addr))
>> +	    !(dct_base <= (sys_addr >> 27) &&
>> +	      dct_limit >= (sys_addr >> 27)))
> ... and while this comparison shifts sys_addr to use the proper bits,
> the code does this assignment later:
>
> 	chan_offset = dct_base;
>
> Now, chan_offset has the << 27 version of dct_base which makes the following
> calculation wrong:
>
> 	chan_addr = sys_addr - chan_offset;
Oops. my apologies.
> because sys_addr is the full 64-bit, unshifted value.
>
> The right thing to do would be to do:
>
> 	chan_offset = dct_base << 27;
>
> Or am I missing something?
>
No, you are right.

I am re-sending the patch.

Thanks,
-Aravind.


