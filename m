Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaFEATI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:19:08 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:37963 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204AbaFEATF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 20:19:05 -0400
Message-ID: <538FB775.8070405@amacapital.net>
Date: Wed, 04 Jun 2014 17:19:01 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org,
        ricardo.neri-calderon@linux.intel.com, tglx@linutronix.de,
        matt.fleming@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state
 in irq ctxt
References: <tip-baa916f39b50ad91661534652110df40396acda0@git.kernel.org> <538F9AFA.5050806@zytor.com> <20140604224920.GB4126@pd.tnic>
In-Reply-To: <20140604224920.GB4126@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 03:49 PM, Borislav Petkov wrote:
> On Wed, Jun 04, 2014 at 03:17:30PM -0700, H. Peter Anvin wrote:
>> I seem to have lost track of this... does this actually solve
>> anything, or does it just mean we'll explode hard?
> 
> Not that hard - it'll warn once only.
> 
> AFAIR, the discussion stalled but we were going in the direction of not
> calling into efi from pstore in irq context.

The kernel_fpu_begin thing has annoyed me in the past.  How bad would it
be to allocate some percpu space and just do a full save/restore when
kernel_fpu_begin happens in a context where it currently doesn't work?

I don't know how large the state is these days, but there must be some
limit to how deeply interrupts and exceptions can nest.  For each IST
entry, there is a hard limit to how deeply they can nest (once for all
but debug and four times for debug IIRC), plus one NMI (nested ones
don't touch FPU).  The most non-IST entries we can have must be bounded,
too.

Let's say there are at most 16 levels of nesting.  16 * state size *
cpus isn't that much.

Of course, code in interrupts that nests kernel_fpu_begin itself could
have a problem.  But this can be solved with a little bit of trickery in
the entry code or something.


If we did this, then I think the x86 crypto code could get rid of all of
its ridiculous async code.

--Andy
