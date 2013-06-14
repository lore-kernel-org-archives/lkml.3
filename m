Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3FNQfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:35:55 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:30895
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752330Ab3FNQfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:35:54 -0400
Message-ID: <51BB4666.9050007@caviumnetworks.com>
Date: Fri, 14 Jun 2013 09:35:50 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Daney <ddaney.cavm@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mips <linux-mips@linux-mips.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] smp.h: Use local_irq_{save,restore}() in !SMP version
 of on_each_cpu().
References: <1371172023-16004-1-git-send-email-ddaney.cavm@gmail.com> <CA+55aFziBGnSgLimDe7WBRPQ+f3RVAsrdbo212oj85c-XSz4oA@mail.gmail.com>
In-Reply-To: <CA+55aFziBGnSgLimDe7WBRPQ+f3RVAsrdbo212oj85c-XSz4oA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-Antispam-Report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:0;SRVR:CO1PR07MB222;H:BY2PRD0712HT004.namprd07.prod.outlook.com;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 10:46 PM, Linus Torvalds wrote:
> On Thu, Jun 13, 2013 at 6:07 PM, David Daney <ddaney.cavm@gmail.com> wrote:
>>
>> Suggested fix: Do what we already do in the SMP version of
>> on_each_cpu(), and use local_irq_save/local_irq_restore.
>
> I was going to apply this, but started looking a bit more.
>
> Using "flags" as a variable name inside a macro like this is a
> *really* bad idea.
>
> Lookie here:
>
>      [torvalds@pixel linux]$ git grep on_each_cpu.*flags
>      arch/s390/kernel/perf_cpum_cf.c:        on_each_cpu(setup_pmc_cpu,
> &flags, 1);
>      arch/s390/kernel/perf_cpum_cf.c:        on_each_cpu(setup_pmc_cpu,
> &flags, 1);
>
> and ask yourself what happens when the "info" argument expands to
> "&flags", and it all compiles perfectly fine, but the "&flags" takes
> the address of the new _inner_ variable called "flags" from the macro
> expansion. Not the one that the caller actually intends..
>
> Oops.
>
> Not a good idea.
>

Yeah,  I think making it a static inline function may be the best approach.

I am going to test doing that and send a new patch very soon.

David Daney


> So I would suggest trivially renaming "flags" as "__flags" or
> something, or perhaps even just making it a real function and avoiding
> the whole namespace issue.
>
> And rather than doing that blindly by editing the patch at after -rc5,
> I'm just going to ask you to re-send a tested patch. Ok?
>
>                      Linus
>

