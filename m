Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3JCTDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:03:54 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44974 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab3JCTDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:03:53 -0400
Date: Thu, 3 Oct 2013 12:03:25 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/9][v5] powerpc: implement is_instr_load_store().
Message-ID: <20131003190325.GB21561@us.ibm.com>
References: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1380672911-12812-6-git-send-email-sukadev@linux.vnet.ibm.com>
 <20131003053519.GC17237@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003053519.GC17237@concordia>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100319-0320-0000-0000-0000013B0ED1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman [michael@ellerman.id.au] wrote:
| On Tue, Oct 01, 2013 at 05:15:06PM -0700, Sukadev Bhattiprolu wrote:
| > Implement is_instr_load_store() to detect whether a given instruction
| > is one of the fixed-point or floating-point load/store instructions.
| > This function will be used in a follow-on patch to save memory hierarchy
| > information of the load/store.
| 
| The search over the array is a bit of a pity, especially as the worst
| case penalises you when you haven't hit a load/store.

Agree. Will try this out.  This is certainly more efficient.

| 
| I think we can do better. If you look at the opcode maps, and in
| particular the extended table for opcode 31, you'll see there's a
| reasonable amount of structure.
| 
| The following is only valid for arch 2.06, ie. it will classify reserved
| opcodes as being load/store, but I think that's fine for the moment. If
| we need to use it somewhere in future we can update it. But we should
| add a big comment saying it's only valid in that case.
| 
| Anyway, I think the following logic is all we need for opcode 31:
| 
| bool is_load_store(int ext_opcode)

how about I call this is_load_store_2_06() and add a comment. Horrible
but minimizes chance of misuse.

| {
|         upper = ext_opcode >> 5;
|         lower = ext_opcode & 0x1f;
| 
|         /* Short circuit as many misses as we can */
|         if (lower < 3 || lower > 23)
|             return false;
| 
|         if (lower == 3)
|             if (upper >= 16)
|                 return true;
| 
|             return false;
| 
|         if (lower == 6)
|             if (upper <= 1)
|                 return true;
|             return false;
| 
|         if (lower == 7 || lower == 12)
|             return true;
| 
|         if (lower >= 20) /* && lower <= 23 (implicit) */
|             return true;
| 
|         return false;
| }
| 
| 
| Which is not pretty, but I think it's preferable to the full search over the
| array.
| 
| cheers

