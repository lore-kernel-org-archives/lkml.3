Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaAIRqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 12:46:54 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:17770 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaAIRqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:46:47 -0500
X-IronPort-AV: E=Sophos;i="4.95,632,1384300800"; 
   d="scan'208";a="89234514"
Message-ID: <52CEE084.5000409@citrix.com>
Date: Thu, 9 Jan 2014 17:46:44 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Wei Liu <wei.liu2@citrix.com>, <jonathan.davies@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zoltan Kiss <zoltan.kiss@citrix.com>,
        <xen-devel@lists.xenproject.org>,
        =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH net-next v3 1/9] xen-netback: Introduce TX
 grant map definitions
References: <1389139818-24458-1-git-send-email-zoltan.kiss@citrix.com> <1389139818-24458-2-git-send-email-zoltan.kiss@citrix.com> <20140109153010.GE12164@zion.uk.xensource.com> <52CEC370.10503@citrix.com> <alpine.DEB.2.02.1401091722150.21510@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1401091722150.21510@kaball.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/14 17:28, Stefano Stabellini wrote:
> On Thu, 9 Jan 2014, David Vrabel wrote:
>> On 09/01/14 15:30, Wei Liu wrote:
>>> On Wed, Jan 08, 2014 at 12:10:10AM +0000, Zoltan Kiss wrote:
>>>> This patch contains the new definitions necessary for grant mapping.
>>>>
>>>> v2:
>>>> - move unmapping to separate thread. The NAPI instance has to be scheduled
>>>>   even from thread context, which can cause huge delays
>>>> - that causes unfortunately bigger struct xenvif
>>>> - store grant handle after checking validity
>>>>
>>>> v3:
>>>> - fix comment in xenvif_tx_dealloc_action()
>>>> - call unmap hypercall directly instead of gnttab_unmap_refs(), which does
>>>>   unnecessary m2p_override. Also remove pages_to_[un]map members
>>>
>>> Is it worthy to have another function call
>>> gnttab_unmap_refs_no_m2p_override in Xen core driver, or just add a
>>> parameter to control wether we need to touch m2p_override? I *think* it
>>> will benefit block driver as well?
>>
>> add_m2p_override and remove_m2p_override calls should be moved into the
>> gntdev device as that should be the only user.
> 
> First of all the gntdev device is common code, while the m2p_override is
> an x86 concept.

m2p_add_override() and m2p_remove_override() are already called from
common code and ARM already provides inline stubs.

The m2p override mechanism is also broken by design (local PFN to
foreign MFN may be many-to-one, but the m2p override only works if local
PFN to foreign MFN is one-to-one). So I want the m2p override to be only
used where it is /currently/ necessary.  I think there should be no new
users of it nor should it be considered a fix for any other use case.

David
