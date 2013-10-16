Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab3JPPkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:40:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53778 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760829Ab3JPPj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:39:57 -0400
Date: Wed, 16 Oct 2013 08:39:29 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 02/10][v6] powerpc/Power7: detect load/store instructions
Message-ID: <20131016153929.GC25073@us.ibm.com>
References: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1381889202-16826-3-git-send-email-sukadev@linux.vnet.ibm.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B738E@saturn3.aculab.com>
 <525E5E79.6010905@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525E5E79.6010905@linux.vnet.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101615-9332-0000-0000-000001CAFABA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anshuman Khandual [khandual@linux.vnet.ibm.com] wrote:
| On 10/16/2013 01:55 PM, David Laight wrote:
| >> Implement instr_is_load_store_2_06() to detect whether a given instruction
| >> is one of the fixed-point or floating-point load/store instructions in the
| >> POWER Instruction Set Architecture v2.06.
| > ...
| 
| The op code encoding is dependent on the ISA version ? Does the basic load
| and store instructions change with newer ISA versions ?

TBH, I don't know whether the encoding is dependent on the ISA version.

We need this for a very narrow/specific purpose on Power7 _and_ did not
want to set up expectations that it will work with all versions. Hence
the horribly named function :-)

| BTW we have got a
| newer version for the ISA "PowerISA_V2.07_PUBLIC.pdf" here at power.org
| 
| https://www.power.org/documentation/power-isa-version-2-07/

Yes, but on Power8 there is a bit in the SIER that tells us whether it
is a load or store instruction. We use that and don't need to determine
in software.

Power7 does not have such a bit and we need this only for Power7. We are
not targetting this "memory hierarchy" feature for Power6 or older processors.

| 
| Does not sound like a good idea to analyse the instructions with functions
| names which specify ISA version number. Besides, this function does not
| belong to specific processor or platform. It has to be bit generic.
| 
| >> +int instr_is_load_store_2_06(const unsigned int *instr)
| >> +{
| >> +	unsigned int op, upper, lower;
| >> +
| >> +	op = instr_opcode(*instr);
| >> +
| >> +	if ((op >= 32 && op <= 58) || (op == 61 || op == 62))
| >> +		return true;
| >> +
| >> +	if (op != 31)
| >> +		return false;
| >> +
| >> +	upper = op >> 5;
| >> +	lower = op & 0x1f;
| >> +
| >> +	/* Short circuit as many misses as we can */
| >> +	if (lower < 3 || lower > 23)
| >> +		return false;
| >> +
| >> +	if (lower == 3) {
| >> +		if (upper >= 16)
| >> +			return true;
| >> +
| >> +		return false;
| >> +	}
| >> +
| >> +	if (lower == 7 || lower == 12)
| >> +		return true;
| >> +
| >> +	if (lower >= 20) /* && lower <= 23 (implicit) */
| >> +		return true;
| >> +
| >> +	return false;
| >> +}
| > 
| > I can't help feeling the code could do with some comments about
| > which actual instructions are selected where.
| 
| Yeah, I agree. At least which category of load-store instructions are
| getting selected in each case.

Like I mentioned in the other message, how about adding a couple
of lines in the function header ?

