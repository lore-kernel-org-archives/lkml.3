Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaBJTeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:34:05 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:46905 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaBJTeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:34:01 -0500
Message-ID: <52F929A6.8040209@mit.edu>
Date: Mon, 10 Feb 2014 11:33:58 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Yao <ryao@gentoo.org>
CC: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        V9FS Develooper Mailing List 
	<v9fs-developer@lists.sourceforge.net>,
        Linux Netdev Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Matthew Thode <mthode@mthode.org>
Subject: Re: [PATCH 1/2] mm/vmalloc: export is_vmalloc_or_module_addr
References: <1391886730-19667-1-git-send-email-ryao@gentoo.org>	<1391886730-19667-2-git-send-email-ryao@gentoo.org>	<CA+55aFx8TzOnW9xPFA4Ox-yFiSUo=cEqeQUmgw_JWjDNEZep8Q@mail.gmail.com>	<52F68C67.6050606@gentoo.org>	<CA+55aFw2BGS-sPYM1xkO7MfZ_-u=7nF4RYFmoCM99rkL=PxvpA@mail.gmail.com>	<52F6972C.2030307@gentoo.org> <CA+55aFzzxcrLrUaCrzFbwS_74B2iHd3OvQ=WC-DR-rqpOA0j0A@mail.gmail.com>
In-Reply-To: <CA+55aFzzxcrLrUaCrzFbwS_74B2iHd3OvQ=WC-DR-rqpOA0j0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2014 02:24 PM, Linus Torvalds wrote:
> On Sat, Feb 8, 2014 at 12:44 PM, Richard Yao <ryao@gentoo.org> wrote:
>>
>> However, is_vmalloc_addr() only applies to the vmalloc region. While all
>> architectures load kernel modules into virtual memory (to my knowledge),
>> some architectures do not load them into the vmalloc region.
> 
> So?
> 
> People shouldn't do IO to module data, so who cares if something is a
> module address or not?
> 
> The thing is, even module *loading* doesn't do IO to the magic module
> addresses - it loads the module data into regular vmalloc space, and
> then copies it into the final location separately.
> 
> And no module should ever do any IO on random static data (and
> certainly not on code).
> 
> So there is _zero_ reason for a driver or a filesystem to use
> is_vmalloc_or_module_addr(). It's just not a valid question to ask.
> 
> If somebody uses module data/code addresses, we're *better* off with a
> oops or other nasty behavior than to try to make it "work".

I agree that reading to module space is awful, but is it obviously
terrible for a module to do this:

static const char header[] = {...};
kernel_write(file, header, sizeof(header), 0);

The current nasty behavior is doing the I/O to the wrong place if the
appropriate CONFIG_DEBUG option isn't set.  That IMO sucks.

--Andy
