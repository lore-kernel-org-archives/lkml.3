Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3LDJnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:43:24 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:18771 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279Ab3LDJnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:43:19 -0500
X-IronPort-AV: E=Sophos;i="4.93,823,1378857600"; 
   d="scan'208";a="78072261"
Message-ID: <529EF934.1020200@citrix.com>
Date: Wed, 4 Dec 2013 10:43:16 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>	 <529DBA07.6090108@citrix.com>	 <1386068884.13256.9.camel@kazak.uk.xensource.com>	 <529DC7BA.7080506@citrix.com>	 <1386078108.13256.30.camel@kazak.uk.xensource.com>	 <529DF4A0.50103@citrix.com>	 <1386083821.13256.42.camel@kazak.uk.xensource.com>	 <20131203201135.GA14243@phenom.dumpdata.com> <1386149319.13256.83.camel@kazak.uk.xensource.com>
In-Reply-To: <1386149319.13256.83.camel@kazak.uk.xensource.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/13 10:28, Ian Campbell wrote:
> On Tue, 2013-12-03 at 15:11 -0500, Konrad Rzeszutek Wilk wrote:
>>>> If Konrad and Boris agree that breaking the kernel's ABI in this way is
>>>> acceptable in this specific case, I'll defer to them.
>>>
>>> My opinion as Xen on ARM hypervisor maintainer is that this is the right
>>> thing to do in this case.
>>
>> Heh. If somebody can guarantee me that (by testing the right variants and
>> mentioning this in the git commit) that this does not break x86, then
>> I am fine.
>>
>> And by 'break x86' I mean that this combination works:
>>  32-bit domU on 64-bit dom0
>>  64-bit domU on 32-bit dom0
>>
>> And perhaps also the obvious:
>>  64-bit domU on 64-bit dom0
>>  32-bit domU on 32-bit dom0
> 
> One way to test this is with gdb on a vmlinux for each arch with
> CONFIG_DEBUG_INFO=y. For each MEMBER of each interesting STRUCT:
>         (gdb) print &((struct STRUCT *)0)->MEMBER
> (this is effectively an open coded offsetof)
> 
> This could probably even be semi automated by producing a script to feed
> to gdb which run through all of the options and diffing the result.
> 
> If I could have the moon on a stick I would have a tool such as this
> running against the canonical Xen headers, to catch breakage as it is
> introduced upstream and a tool which could run against an arbitrary ELF
> binary to validate it against the upstream results.
> tools/include/xen-foreign/mkchecker.py goes some way towards that but
> isn't really extensible to the extent we would need/want.
> 
> While I'm asking for unicorns a gcc __attribute__((warn_on_holes)) which
> could be applied to a struct to enforce the need for explicit padding
> would probably be incredibly useful for this of thing.

Right now I would be happy to add something like:

#if !defined(CONFIG_X86_32) && !defined(CONFIG_X86_64) &&
!defined(CONFIG_ARM...
#error This architecture is not supported by the Xen PV block ABI
#endif

To the Linux copy of blkif.h

>> Since the xen-blkback has its own version of the structs there is no
>> need to change change newer and older version of it.
> 
> Someone should check that these are producing the right interface on ARM
> though!

AFAICT blkback on ARM is not using the structures defined in
blkback/common.h, since the protocol is "native", it's using the same
structures defined in the public header (just as blkfront). There's no
translation needed and blkback just does a memcpy from the ring to the
native struct.

