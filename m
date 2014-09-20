Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaITBnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 21:43:41 -0400
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:10567
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751008AbaITBnk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 21:43:40 -0400
From: Anish Bhatt <anish@chelsio.com>
To: Randy Dunlap <rdunlap@infradead.org>, Guenter Roeck <linux@roeck-us.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "mchan@broadcom.com" <mchan@broadcom.com>
Subject: RE: linux-next: Tree for Sep 19
Thread-Topic: linux-next: Tree for Sep 19
Thread-Index: AQHP1E6ozuiqDeyYUEOIJuP0CTEAAZwJfPWAgAAfvoCAAA8PgP//kqXQ
Date: Sat, 20 Sep 2014 01:43:05 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D88EF892@nice.asicdesigners.com>
References: <20140919165817.225eb8b8@canb.auug.org.au>
 <20140919211404.GA24856@roeck-us.net> <541CAC81.9040404@infradead.org>
 <541CC721.2010207@roeck-us.net>,<541CD3C3.3010905@infradead.org>
In-Reply-To: <541CD3C3.3010905@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.163.152]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original config causing issues can be seen here :
https://lkml.org/lkml/2014/9/9/500

As CNIC depends on IPV6, CNIC can be only compiled as a module when IPV6 is 
compiled as a module. This was the patch I originally commited. Previous 
behaviour was to disable all ipv6 code in such a case. However, having bnx2fc/i 
 as built-in overrides CNIC's tristate from m to built-in (as they select CNIC), 
 causing build issues. As far as I know, there is no way to control the state 
that select sets.
 -Anish
________________________________________
From: Randy Dunlap [rdunlap@infradead.org]
Sent: Friday, September 19, 2014 6:09 PM
To: Guenter Roeck; Stephen Rothwell
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Anish Bhatt; David S. Miller; James E.J. Bottomley
Subject: Re: linux-next: Tree for Sep 19

On 09/19/14 17:15, Guenter Roeck wrote:
> On 09/19/2014 03:21 PM, Randy Dunlap wrote:
>> On 09/19/14 14:14, Guenter Roeck wrote:
>>> On Fri, Sep 19, 2014 at 04:58:17PM +1000, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> Changes since 20140917:
>>>>
>>>> The fsl tree still had its build failure so I used the version from
>>>> next-20140917.
>>>>
>>>> The v4l-dvb tree lost its build failure.
>>>>
>>>> The security tree gained a conflict against the file-locks tree.
>>>>
>>>> Non-merge commits (relative to Linus' tree): 6014
>>>>   5488 files changed, 217522 insertions(+), 129375 deletions(-)
>>>>
>>>> ----------------------------------------------------------------------------
>>>>
>>> Guess this is most difficult one.
>>>
>>> mips:nlm_xlp_defconfig:
>>>
>>> warning: (SCSI_BNX2X_FCOE && LIBFCOE && TCM_QLA2XXX) selects LIBFC which has
>>> unmet direct dependencies (SCSI_LOWLEVEL && SCSI && SCSI_FC_ATTRS)
>>> warning: (SCSI_BNX2X_FCOE && LIBFCOE && TCM_QLA2XXX) selects LIBFC which has
>>> unmet direct dependencies (SCSI_LOWLEVEL && SCSI && SCSI_FC_ATTRS)
>>
>> Yes, I have a patch sitting on my hard drive that makes LIBFCOE and TCM_QLA2XXX
>> and SCSI_BNX2X_FCOE depend on SCSI_FC_ATTRS, but I'm not entirely happy about
>> having to hunt these down (even with the help of kconfig warnings).
>>
>
> One key problem is that nlm_xlp_defconfig does not configure NET anymore.
> this is after 'scsi_netlink : Make SCSI_NETLINK dependent on NET instead
> of selecting NET' was applied.
>
> In fact, there are many more affected configurations; the change from
> "select XXX" to "depends XXX" has far reaching consequences, as many
> configurations are no longer valid. For mips alone I find that this commit
> changes the following configurations.
>
> e55_defconfig
> gpr_defconfig
> ip27_defconfig
> jazz_defconfig
> loongson3_defconfig
> malta_defconfig
> malta_kvm_defconfig
> malta_kvm_guest_defconfig
> mtx1_defconfig
> nlm_xlp_defconfig
> nlm_xlr_defconfig
> rm200_defconfig
>
> e55_defconfig is almost the same as before, but only because CONFIG_NET
> was not configured for it to start with. For all others, CONFIG_NET is
> no longer set. This effectively means that out of 55 mips configurations,
> 11 or 20% are now bad. This is 3.17-rc5. vs. next-20140919.
>
> Frankly, I don't think this change was really helpful. On the contrary,
> we will be in a lot of trouble when this change makes it upstream.
> It might be be a good idea to be much more careful when making such
> changes. Cleaning up configuration dependencies is a laudable goal,
> but when it breaks configurations all over the place it does more damage
> than it is worth.

Yes, I suspect that we should just drop this effort and redo the original
problem's "fix".

Dave?

Anish, if you can remind me of the original problem and hopefully a kernel
.config file for it, I'll try to help with it.

--
~Randy
