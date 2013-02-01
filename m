Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab3BAPcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 10:32:54 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:47867 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3BAPcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 10:32:51 -0500
Message-ID: <510BDFBD.7090808@linux.vnet.ibm.com>
Date: Fri, 01 Feb 2013 09:31:09 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv4 3/7] zswap: add to mm/
References: <1359495627-30285-1-git-send-email-sjenning@linux.vnet.ibm.com> <1359495627-30285-4-git-send-email-sjenning@linux.vnet.ibm.com> <20130131070716.GF23548@blaptop> <510AC0C6.4020705@linux.vnet.ibm.com> <20130201023821.GB6262@blaptop>
In-Reply-To: <20130201023821.GB6262@blaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020115-7282-0000-0000-000013AACA7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 08:38 PM, Minchan Kim wrote:
> On Thu, Jan 31, 2013 at 01:06:46PM -0600, Seth Jennings wrote:
>> On 01/31/2013 01:07 AM, Minchan Kim wrote:
>>> On Tue, Jan 29, 2013 at 03:40:23PM -0600, Seth Jennings wrote:
>>>> zswap is a thin compression backend for frontswap. It receives
>>>> pages from frontswap and attempts to store them in a compressed
>>>> memory pool, resulting in an effective partial memory reclaim and
>>>> dramatically reduced swap device I/O.
>>>>
>>>> Additionally, in most cases, pages can be retrieved from this
>>>> compressed store much more quickly than reading from tradition
>>>> swap devices resulting in faster performance for many workloads.
>>>>
>>>> This patch adds the zswap driver to mm/
>>>>
>>>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
>>>> ---
>>>>  mm/Kconfig  |  15 ++
>>>>  mm/Makefile |   1 +
>>>>  mm/zswap.c  | 656 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  3 files changed, 672 insertions(+)
>>>>  create mode 100644 mm/zswap.c
>>>>
>>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>>> index 278e3ab..14b9acb 100644
>>>> --- a/mm/Kconfig
>>>> +++ b/mm/Kconfig
>>>> @@ -446,3 +446,18 @@ config FRONTSWAP
>>>>  	  and swap data is stored as normal on the matching swap device.
>>>>  
>>>>  	  If unsure, say Y to enable frontswap.
>>>> +
>>>> +config ZSWAP
>>>> +	bool "In-kernel swap page compression"
>>>> +	depends on FRONTSWAP && CRYPTO
>>>> +	select CRYPTO_LZO
>>>> +	select ZSMALLOC
>>>
>>> Again, I'm asking why zswap should have a dependent on CRPYTO?
>>> Couldn't we support it as a option? I'd like to use zswap without CRYPTO
>>> like zram.
>>
>> The reason we need CRYPTO is that zswap uses it to support a pluggable
>> compression model.  zswap can use any compressor that has a crypto API
>> driver.  zswap has _symbol dependencies_ on CRYPTO.  If it isn't
>> selected, the build breaks.
> 
> I think we can factor out compressoin part and remove dependency
> at compile time by Kconfig. No?

I'm still not following.  How would one "factor out" the crypto API
dependency when we use it to access the compressor modules.

The only thing I can think you're saying is to hack up the code with
ifdefs to call the lzo code directly based on a Kconfig option.  I
really hope you aren't saying that though :-/

> Of course, if we disable CRYPTO in Kconfig,
> we lost pluggable model but not a problem for embedded system.

The pluggable model is _very_ necessary for us because we use it to
access our hardware compression accelerator.  We do not use lzo in
that case.  We use 842 (crypto/842.c and drivers/crypto/nx/nx-842.c).

I'm not sure why we are misunderstanding on this.  Is there a specific
objection to depending the crypto API here? I understand that you are
thinking about embedded systems.  Does the enabling CRYPTO and
CRYPTO_LZO add significant size to the kernel or something?  Just
trying to understand why this is a problem.

Thanks,
Seth

> 
> Anyway, If it's a burden for you at a moment, I'm not going to insist on it.
> Will do it for myself.



