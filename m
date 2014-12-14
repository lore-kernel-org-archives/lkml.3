Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaLNQJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 11:09:26 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:48824 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaLNQJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:09:23 -0500
Message-ID: <548DB62E.7060504@linux.vnet.ibm.com>
Date: Sun, 14 Dec 2014 11:09:18 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net,
        Will Arthur <will.c.arthur@intel.com>
Subject: Re: [PATCH v10 8/8] tpm: TPM 2.0 FIFO Interface
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1418413600-5400-9-git-send-email-jarkko.sakkinen@linux.intel.com> <548DA33A.4010300@linux.vnet.ibm.com> <20141214154003.GA13338@intel.com>
In-Reply-To: <20141214154003.GA13338@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121416-0005-0000-0000-00000722F094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2014 10:40 AM, Jarkko Sakkinen wrote:
> On Sun, Dec 14, 2014 at 09:48:26AM -0500, Stefan Berger wrote:
>> On 12/12/2014 02:46 PM, Jarkko Sakkinen wrote:
>>> Detect TPM 2.0 by sending idempotent TPM 2.x command. Ordinals for
>>> TPM 2.0 are higher than TPM 1.x commands so this should be fail-safe.
>>> Using STS3 is unreliable because some chips just report 0xff and not
>>> what the spec says.
>> TPM TIS 1.2 can report either 0xff or 0x00 for sts3 since that part of
>> register was not defined for this version but only for a later version. So,
>> unless the TIS 1.3 for TPM 2.0 is broken, it should report a bit _pattern_
>> (not plain 0x00 or 0xff) that you could apply the suggested mask to and
>> check then.
> I propose this: lets keep the bit ugly but approach for now and when
> there are TPM2 FIFOs available in the market move to your workaround.
> I think that would be the most reasonable middle road here.

You are now calling tpm2_gen_interrupt and are looking at the rc, which 
is the rc from tpm_transmit_cmd, which seems to make sure that the 
sending of the command went alright and the reception of the response. 
Is this good enough to distinguish between a TPM 2 and a TPM 1.2? If you 
send a valid TPM 2 command to a TPM 1.2 this will at least transmit the 
data ok, but the TPM will respond with a TPM 1.2 tag in the response. 
The way I understand the code, the rc does not include whether the 
response packet is a valid TPM 2 response packet and lets you conclude 
to a TPM2. I do something similar in upcoming QEMU patches where I send 
a valid TPM2 command for probing and if the tag(!) in the response is a 
TPM2 tag (0x8001 = TPM_ST_NO_SESSIONS), then it's a TPM 2, otherwise a 
TPM 1.2.

Did you test this with a TPM 1.2 ?

    Stefan

>
>>      Stefan
> /Jarkko
>

