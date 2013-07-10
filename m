Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab3GJV4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 17:56:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:11410 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab3GJV4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 17:56:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1038,1363158000"; 
   d="scan'208";a="329548177"
Message-ID: <51DDD894.3050408@linux.intel.com>
Date: Wed, 10 Jul 2013 14:56:36 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Jiri Kosina <jkosina@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction patching
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz> <51DDD3E9.6090601@linux.intel.com> <20130710214848.GB14879@pd.tnic>
In-Reply-To: <20130710214848.GB14879@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 02:48 PM, Borislav Petkov wrote:
> On Wed, Jul 10, 2013 at 02:36:41PM -0700, H. Peter Anvin wrote:
>> I'm wondering if it would be easier/more general to just return to the
>> instruction. The "more general" bit would allow this to be used for
>> other things, like alternatives, and perhaps eventually dynamic call
>> patching.
> 
> Well, the aspect of not using stop_machine in alternatives is a don't
> care because there we do text_poke_early on the BSP anyway. However,
> there we toggle interrupts so it would probably be interesting to see
> whether a non-interrupt-disabling variant would be faster.
> 
>> Returning to the instruction will, in effect, be a busy-wait for
>> the faulted CPU until the patch is complete; more or less what
>> stop_machine would do, but only for a CPU which actually strays into
>> the affected region.
> 
> Oh, something like we patch in a two-byte jump first:
> 
> 1:
> 	jmp 1b
> 
> until we finish patching the rest? Ha, interesting :).
> 

No, the idea is that the affected CPU will simply execute int3 -> iret
ad nauseam until the first byte is repatched, at that point execution
will resume normally.

	-hpa

