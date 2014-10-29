Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbaJ2V1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:27:07 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40847 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbaJ2V1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:27:04 -0400
Date: Wed, 29 Oct 2014 14:26:20 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@au1.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 01/32] perf tools powerpc: Cache the DWARF debug info
Message-ID: <20141029212620.GC17916@us.ibm.com>
References: <1414503146-22789-1-git-send-email-acme@kernel.org>
 <1414503146-22789-2-git-send-email-acme@kernel.org>
 <87egtr751p.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87egtr751p.fsf@sejong.aot.lge.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102921-0009-0000-0000-000005F2E981
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim [namhyung@kernel.org] wrote:
| > +		if (dwfl_report_offline(dwfl, "", dso->long_name, -1) == NULL) {
| > +			pr_debug("dwfl_report_offline() failed %s\n",
| > +						dwarf_errmsg(-1));
| > +			/*
| > +			 * We normally cache the DWARF debug info and never
| > +			 * call dwfl_end(). But to prevent fd leak, free in
| > +			 * case of error.
| > +			 */
| 
| Well, it can be freed when dso__delete() called at least. :)

Agree. Jiri Olsa also pointed that out. Plan to add that as a part
of couple of other changes Jiri proposed.

| 
| 
| > +			dwfl_end(dwfl);
| > +			goto out;
| > +		}
| > +		dso->dwfl = dwfl;
| >  	}
| >  
| >  	mod = dwfl_addrmodule(dwfl, pc);
| 
| I don't know how dwfl_report_offline() can make it to find out a mod
| from pc as it's an (loaded) virtual address.  Maybe I miss something or
| is your dso's are prelinked?

Scratching my head on this and a related issue.

The code seems to work consistently on Fedora20 and we recently noticed
that it does not work on RHEL7. Maybe related to the issue you point out.

On Fedora20 objdump -D /usr/lib64/libc-2.18.so shows something like this:

00000080a7be3bf0 <.__random>:
  80a7be3bf0:   7c 08 02 a6     mflr    r0
  80a7be3bf4:   fb e1 ff f8     std     r31,-8(r1)
  80a7be3bf8:   60 00 00 00     nop
  80a7be3bfc:   39 00 00 01     li      r8,1
  80a7be3c00:   3b e2 9a f0     addi    r31,r2,-25872
  80a7be3c04:   39 40 00 00     li      r10,0
  80a7be3c08:   f8 01 00 10     std     r0,16(r1)
  80a7be3c0c:   f8 21 ff 71     stdu    r1,-144(r1)
  80a7be3c10:   7d 20 f8 29     lwarx   r9,0,r31,1
  80a7be3c14:   7c 09 50 00     cmpw    r9,r10
  80a7be3c18:   40 82 00 0c     bne     80a7be3c24 <.__random+0x34>

and my small test program (and perf) can use the addresses to correctly
say if LR is relevant or not.

But on RHEL7, objdump shows addresses differently:

0000000000063870 <.__random>:
   63870:       7c 08 02 a6     mflr    r0
   63874:       fb e1 ff f8     std     r31,-8(r1)
   63878:       60 00 00 00     nop
   6387c:       3b e2 9a e0     addi    r31,r2,-25888
   63880:       39 00 00 01     li      r8,1
   63884:       39 40 00 00     li      r10,0
   63888:       f8 01 00 10     std     r0,16(r1)
   6388c:       f8 21 ff 71     stdu    r1,-144(r1)
   63890:       7d 20 f8 29     lwarx   r9,0,r31,1

and perf and my test program fail. Not sure if this is something related
to the way it is built.

Sukadev

