Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaB0Ptx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:49:53 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:28465 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbaB0Ptu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:49:50 -0500
X-IronPort-AV: E=Sophos;i="4.97,555,1389744000"; 
   d="scan'208";a="104685632"
Message-ID: <530F5E9B.5020404@citrix.com>
Date: Thu, 27 Feb 2014 15:49:47 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v5 4/9] xen-netback: Change RX path for mapped
 SKB fragments
References: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com> <1390253069-25507-5-git-send-email-zoltan.kiss@citrix.com> <1392745532.23084.65.camel@kazak.uk.xensource.com> <53093051.9040907@citrix.com> <530B4E05.4020900@schaman.hu> <530B606F.2070902@citrix.com> <20140227124327.GD16241@zion.uk.xensource.com>
In-Reply-To: <20140227124327.GD16241@zion.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/14 12:43, Wei Liu wrote:
> On Mon, Feb 24, 2014 at 03:08:31PM +0000, Zoltan Kiss wrote:
>> On 24/02/14 13:49, Zoltan Kiss wrote:
>>> On 22/02/14 23:18, Zoltan Kiss wrote:
>>>> On 18/02/14 17:45, Ian Campbell wrote:
>>>>> On Mon, 2014-01-20 at 21:24 +0000, Zoltan Kiss wrote:
>>>>>
>>>>> Re the Subject: change how? Perhaps "handle foreign mapped pages on the
>>>>> guest RX path" would be clearer.
>>>> Ok, I'll do that.
>>>>
>>>>>
>>>>>> RX path need to know if the SKB fragments are stored on
>>>>>> pages from another
>>>>>> domain.
>>>>> Does this not need to be done either before the mapping change
>>>>> or at the
>>>>> same time? -- otherwise you have a window of a couple of commits where
>>>>> things are broken, breaking bisectability.
>>>> I can move this to the beginning, to keep bisectability. I've
>>>> put it here originally because none of these makes sense without
>>>> the previous patches.
>>> Well, I gave it a close look: to move this to the beginning as a
>>> separate patch I would need to put move a lot of definitions from
>>> the first patch to here (ubuf_to_vif helper,
>>> xenvif_zerocopy_callback etc.). That would be the best from bisect
>>> point of view, but from patch review point of view even worse than
>>> now. So the only option I see is to merge this with the first 2
>>> patches, so it will be even bigger.
>> Actually I was stupid, we can move this patch earlier and introduce
>> stubs for those 2 functions. But for the another two patches (#6 and
>> #8) it's still true that we can't move them before, only merge them
>> into the main, as they heavily rely on the main patch. #6 is
>> necessary for Windows frontends, as they are keen to send too many
>> slots. #8 is quite a rare case, happens only if a guest wedge or
>> malicious, and sits on the packet.
>> So my question is still up: do you prefer perfect bisectability or
>> more segmented patches which are not that pain to review?
>>
>
> What's the diff stat if you merge those patches?
>

  drivers/net/xen-netback/common.h    |   33 ++-
  drivers/net/xen-netback/interface.c |   67 +++++-
  drivers/net/xen-netback/netback.c   |  424 
++++++++++++++++++++++-------------
  3 files changed, 362 insertions(+), 162 deletions(-)

