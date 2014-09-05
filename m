Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbaIEHzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:55:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaIEHzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:55:51 -0400
Message-ID: <54096C83.2080608@suse.com>
Date: Fri, 05 Sep 2014 09:55:47 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andrew Cooper <andrew.cooper3@citrix.com>, Jan Beulich <JBeulich@suse.com>
CC: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xensource.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 3/3] xen: eliminate scalability issues from
 initial mapping setup
References: <1409834326-29287-1-git-send-email-jgross@suse.com> <1409834326-29287-4-git-send-email-jgross@suse.com> <54086244.7020601@citrix.com> <540862FE.7070108@citrix.com> <540893F00200007800030E4F@mail.emea.novell.com> <54087AA1.8010208@citrix.com>
In-Reply-To: <54087AA1.8010208@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 04:43 PM, Andrew Cooper wrote:
> On 04/09/14 15:31, Jan Beulich wrote:
>>>>> On 04.09.14 at 15:02, <andrew.cooper3@citrix.com> wrote:
>>> On 04/09/14 13:59, David Vrabel wrote:
>>>> On 04/09/14 13:38, Juergen Gross wrote:
>>>>> Direct Xen to place the initial P->M table outside of the initial
>>>>> mapping, as otherwise the 1G (implementation) / 2G (theoretical)
>>>>> restriction on the size of the initial mapping limits the amount
>>>>> of memory a domain can be handed initially.
>>>> The three level p2m limits memory to 512 GiB on x86-64 but this patch
>>>> doesn't seem to address this limit and thus seems a bit useless to me.
>>> Any increase of the p2m beyond 3 levels will need to come with
>>> substantial libxc changes first.  3 level p2ms are hard coded throughout
>>> all the PV build and migrate code.
>> No, there no such dependency - the kernel could use 4 levels at
>> any time (sacrificing being able to get migrated), making sure it
>> only exposes the 3 levels hanging off the fourth level (or not
>> exposing this information at all) to external entities making this
>> wrong assumption.
>>
>> Jan
>>
>
> That would require that the PV kernel must start with a 3 level p2m and
> fudge things afterwards.

I always thought the 3 level p2m is constructed by the kernel, not by
the tools.

It starts with the linear p2m list anchored at xen_start_info->mfn_list,
constructs the p2m tree and writes the p2m_top_mfn mfn to
HYPERVISOR_shared_info->arch.pfn_to_mfn_frame_list_list

See comment in the kernel source arch/x86/xen/p2m.c

So booting with a larger p2m list can be handled completely by the
kernel itself.

>
> At a minimum, I would expect a patch to libxc to detect a 4 level PV
> guest and fail with a meaningful error, rather than an obscure "m2p
> doesn't match p2m for mfn/pfn X".

I'd rather fix it in a clean way.

I think the best way to do it would be an indicator in the p2m array
anchor, e.g. setting 1<<61 in pfn_to_mfn_frame_list_list. This will
result in an early error with old tools:
"Couldn't map p2m_frame_list_list"


Juergen
