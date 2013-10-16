Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760514Ab3JPJjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:39:19 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:44797 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759444Ab3JPJjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:39:16 -0400
Message-ID: <525E5E79.6010905@linux.vnet.ibm.com>
Date: Wed, 16 Oct 2013 15:08:01 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 02/10][v6] powerpc/Power7: detect load/store instructions
References: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com> <1381889202-16826-3-git-send-email-sukadev@linux.vnet.ibm.com> <AE90C24D6B3A694183C094C60CF0A2F6026B738E@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B738E@saturn3.aculab.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101609-9574-0000-0000-00000A18DCBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 01:55 PM, David Laight wrote:
>> Implement instr_is_load_store_2_06() to detect whether a given instruction
>> is one of the fixed-point or floating-point load/store instructions in the
>> POWER Instruction Set Architecture v2.06.
> ...

The op code encoding is dependent on the ISA version ? Does the basic load
and store instructions change with newer ISA versions ? BTW we have got a
newer version for the ISA "PowerISA_V2.07_PUBLIC.pdf" here at power.org

https://www.power.org/documentation/power-isa-version-2-07/

Does not sound like a good idea to analyse the instructions with functions
names which specify ISA version number. Besides, this function does not
belong to specific processor or platform. It has to be bit generic.
 
>> +int instr_is_load_store_2_06(const unsigned int *instr)
>> +{
>> +	unsigned int op, upper, lower;
>> +
>> +	op = instr_opcode(*instr);
>> +
>> +	if ((op >= 32 && op <= 58) || (op == 61 || op == 62))
>> +		return true;
>> +
>> +	if (op != 31)
>> +		return false;
>> +
>> +	upper = op >> 5;
>> +	lower = op & 0x1f;
>> +
>> +	/* Short circuit as many misses as we can */
>> +	if (lower < 3 || lower > 23)
>> +		return false;
>> +
>> +	if (lower == 3) {
>> +		if (upper >= 16)
>> +			return true;
>> +
>> +		return false;
>> +	}
>> +
>> +	if (lower == 7 || lower == 12)
>> +		return true;
>> +
>> +	if (lower >= 20) /* && lower <= 23 (implicit) */
>> +		return true;
>> +
>> +	return false;
>> +}
> 
> I can't help feeling the code could do with some comments about
> which actual instructions are selected where.

Yeah, I agree. At least which category of load-store instructions are
getting selected in each case.

